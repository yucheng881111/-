//0716206 ³¯¬R¥à, 0716221 §E©¾ÌÉ

#include <bits/stdc++.h>

using namespace std;
typedef unsigned long long ull;

class cache_content
{
public:
    //bool reference_bit;
	bool v;
	unsigned int tag;
	cache_content(){
	    v=0;
	    tag=0;
	    //reference_bit=0;
	}
    // unsigned int	data[16];
};

const int K = 1024;

void simulate(int cache_size, int block_size, int n_way, string input, string output)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	//int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	int Set = line / n_way;
	int set_bit = (int)log2(Set);
	vector<vector<cache_content>> set_associative(Set,vector<cache_content>(n_way));

	//cache_content *cache = new cache_content[line];

    //file2 << "cache line: " << line << endl;

    fstream file;
    file.open(input, ios::in);  // read file
    fstream file2;
    file2.open(output, ios::out);
    unordered_map<ull,int> table;
    ull adda,addb,addc;
    file>>hex>>adda>>addb>>addc;
    int m,n,p;
    file>>dec>>m>>n>>p;

    ull a=adda;
    ull b=addb;
    ull c=addc;
    ull addr_a[m][n];
    ull addr_b[n][p];
    int data_a[m][n];
    int data_b[n][p];

    for(int i=0;i<m;++i){
        for(int j=0;j<n;++j){
            int x;
            file>>x;
            table[a]=x;
            addr_a[i][j]=a;
            data_a[i][j]=x;
            a+=4;
        }
    }

    for(int i=0;i<n;++i){
        for(int j=0;j<p;++j){
            int x;
            file>>x;
            table[b]=x;
            addr_b[i][j]=b;
            data_b[i][j]=x;
            b+=4;
        }
    }

    ull addr_c[m][p];
    int data_c[m][p];
    memset(data_c,0,sizeof(data_c));
    memset(addr_c,0,sizeof(addr_c));
    vector<ull> vec;

    for(int i=0;i<m;++i){
        for(int j=0;j<p;++j){
            for(int k=0;k<n;++k){
                data_c[i][j]+=data_a[i][k]*data_b[k][j];
                vec.push_back(c);
                vec.push_back(addr_a[i][k]);
                vec.push_back(addr_b[k][j]);
                vec.push_back(c);
            }
            table[c]=data_c[i][j];
            addr_c[i][j]=c;
            c+=4;
        }
    }

    for(int i=0;i<m;++i){
        for(int j=0;j<p;++j){
            file2<<data_c[i][j]<<" ";
        }
        file2<<endl;
    }

    ull base_cycle=((22*n+7)*p+7)*m+5;
    file2<<base_cycle<<" ";


    int count_hit = 0;
    int count_miss = 0;
    int cnt = 0;
    for(auto &x:vec)
    {
        //file2<<hex<<x<<endl;
        int set_index = (x >> offset_bit) % Set;
        //index = (x >> offset_bit) & (line - 1);
        tag = x >> (set_bit + offset_bit);

        bool success=false;
        for(int i=0;i<n_way;++i){
            if(set_associative[set_index][i].tag==tag&&set_associative[set_index][i].v){
                //hit
                count_hit++;
                success=true;
                //set_associative[set_index][i].reference_bit=1;
                while(i<n_way-1){
                        if(set_associative[set_index][i+1].tag==0){
                            break;
                        }
                        set_associative[set_index][i].tag=set_associative[set_index][i+1].tag;
                        i++;
                    }
                    set_associative[set_index][i].tag=tag;
                break;
            }
            if(set_associative[set_index][i].tag==0&&set_associative[set_index][i].v==0){
                //miss
                count_miss++;
                set_associative[set_index][i].tag=tag;
                set_associative[set_index][i].v=1;
                //set_associative[set_index][i].reference_bit=1;
                success=true;
                break;
            }
        }

        if(!success){
            count_miss++;
            //miss and full
            //LRU
            int j=0;
            while(j<n_way-1){
                set_associative[set_index][j].tag=set_associative[set_index][j+1].tag;
                j++;
            }
            set_associative[set_index][j].tag=tag;
            set_associative[set_index][j].v=1;
        }
    }

    //file2 << count_hit << " " << count_miss << endl;
    ull a_cycle=4*count_hit+836*count_miss;
    ull b_cycle=4*count_hit+108*count_miss;
    file2<<a_cycle<<" "<<b_cycle<<" ";

    vector<bool> L1_hit;
    vector<bool> L2_hit;
    //L1
    {
        unsigned int tag, index, x;
        int offset_bit = 4;
        int line = 8;
        int Set = 1;
        int set_bit = 0;
        vector<vector<cache_content>> set_associative(Set,vector<cache_content>(n_way));
        int count_hit = 0;
        int count_miss = 0;

        for(auto &x:vec)
        {

            //file2<<hex<<x<<endl;
            int set_index = (x >> offset_bit) % Set;
            //index = (x >> offset_bit) & (line - 1);
            tag = x >> (set_bit + offset_bit);

            bool success=false;
            for(int i=0;i<n_way;++i){
                if(set_associative[set_index][i].tag==tag&&set_associative[set_index][i].v){
                    //hit
                    count_hit++;
                    L1_hit.push_back(1);
                    success=true;
                    //set_associative[set_index][i].reference_bit=1;
                    while(i<n_way-1){
                        if(set_associative[set_index][i+1].tag==0){
                            break;
                        }
                        set_associative[set_index][i].tag=set_associative[set_index][i+1].tag;
                        i++;
                    }
                    set_associative[set_index][i].tag=tag;
                    break;
                }
                if(set_associative[set_index][i].tag==0&&set_associative[set_index][i].v==0){
                    //miss
                    count_miss++;
                    L1_hit.push_back(0);
                    set_associative[set_index][i].tag=tag;
                    set_associative[set_index][i].v=1;
                    //set_associative[set_index][i].reference_bit=1;
                    success=true;
                    break;
                }
            }

            if(!success){
                count_miss++;
                L1_hit.push_back(0);
                //miss and full
                //LRU
                int j=0;
                while(j<n_way-1){
                    set_associative[set_index][j].tag=set_associative[set_index][j+1].tag;
                    j++;
                }
                set_associative[set_index][j].tag=tag;
                set_associative[set_index][j].v=1;
            }

        }
    }

    //L2
    {
        unsigned int tag, index, x;
        int offset_bit = 7;
        int line = 32;
        int Set = 4;
        int set_bit = 2;
        vector<vector<cache_content>> set_associative(Set,vector<cache_content>(n_way));
        int count_hit = 0;
        int count_miss = 0;

        for(auto &x:vec)
        {

            //file2<<hex<<x<<endl;
            int set_index = (x >> offset_bit) % Set;
            //index = (x >> offset_bit) & (line - 1);
            tag = x >> (set_bit + offset_bit);

            bool success=false;
            for(int i=0;i<n_way;++i){
                if(set_associative[set_index][i].tag==tag&&set_associative[set_index][i].v){
                    //hit
                    count_hit++;
                    L2_hit.push_back(1);
                    success=true;
                    while(i<n_way-1){
                        if(set_associative[set_index][i+1].tag==0){
                            break;
                        }
                        set_associative[set_index][i].tag=set_associative[set_index][i+1].tag;
                        i++;
                    }
                    set_associative[set_index][i].tag=tag;
                    break;
                }
                if(set_associative[set_index][i].tag==0&&set_associative[set_index][i].v==0){
                    //miss
                    count_miss++;
                    L2_hit.push_back(0);
                    set_associative[set_index][i].tag=tag;
                    set_associative[set_index][i].v=1;
                    //set_associative[set_index][i].reference_bit=1;
                    success=true;
                    break;
                }
            }

            if(!success){
                count_miss++;
                L2_hit.push_back(0);
                //miss and full
                //LRU
                int j=0;
                while(j<n_way-1){
                    set_associative[set_index][j].tag=set_associative[set_index][j+1].tag;
                    j++;
                }
                set_associative[set_index][j].tag=tag;
                set_associative[set_index][j].v=1;
            }
        }
    }

    int L1hit=0;
    int L1missL2hit=0;
    int L2miss=0;
    for(int i=0;i<L1_hit.size();++i){
        if(L1_hit[i]){
            L1hit++;
        }else if(L2_hit[i]){
            L1missL2hit++;
        }else{
            L2miss++;
        }
    }
    //file2<<L1hit<<" "<<L1missL2hit<<" "<<L2miss<<endl;
    ull c_cycle=3*L1hit+55*L1missL2hit+3639*L2miss;
    file2<<c_cycle<<endl;

}

int main(int argc, char *argv[])
{
	simulate(512,32,8,argv[1],argv[2]);

}
