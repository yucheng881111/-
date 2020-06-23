#include <bits/stdc++.h>

using namespace std;

class cache_content
{
public:
    bool reference_bit;
	bool v;
	unsigned int tag;
	cache_content(){
	    v=0;
	    tag=0;
	    reference_bit=0;
	}
    // unsigned int	data[16];
};

const int K = 1024;

/*double log2(double n)
{
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}*/

void simulate(int cache_size, int n)
{
	int block_size = 64;
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	//int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	int Set = line / n;
	int set_bit = (int)log2(Set);
	vector<vector<cache_content>> set_associative(Set,vector<cache_content>(n));

	//cache_content *cache = new cache_content[line];

    //cout << "cache line: " << line << endl;
    {
        FILE *fp = fopen("LU.txt", "r");  // read file
        int count_hit = 0;
        int count_miss = 0;
        int c = 0;
        while(fscanf(fp, "%x", &x) != EOF)
        {
            int set_index = (x >> offset_bit) % Set;
            //index = (x >> offset_bit) & (line - 1);
            tag = x >> (set_bit + offset_bit);

            if(c%100==0){
                for(int i=0;i<Set;++i){
                    for(int j=0;j<n;++j){
                        set_associative[i][j].reference_bit=0;
                    }
                }
            }

            bool success=false;
            for(int i=0;i<n;++i){
                if(set_associative[set_index][i].tag==tag&&set_associative[set_index][i].v){
                    //hit
                    count_hit++;
                    success=true;
                    set_associative[set_index][i].reference_bit=1;
                    break;
                }
                if(set_associative[set_index][i].tag==0&&set_associative[set_index][i].v==0){
                    //miss
                    count_miss++;
                    set_associative[set_index][i].tag=tag;
                    set_associative[set_index][i].v=1;
                    set_associative[set_index][i].reference_bit=1;
                    success=true;
                    break;
                }
            }

            if(!success){
                count_miss++;
                //miss and full
                //LRU
                bool ok = false;
                for(int i=0;i<n;++i){
                    if(set_associative[set_index][i].reference_bit!=1){
                        set_associative[set_index][i].tag=tag;
                        set_associative[set_index][i].v=1;
                        set_associative[set_index][i].reference_bit=1;
                        ok = true;
                        break;
                    }
                }
                if(!ok){
                    srand((unsigned)time(NULL));
                    int r = rand() % n;
                    set_associative[set_index][r].tag=tag;
                    set_associative[set_index][r].v=1;
                    set_associative[set_index][r].reference_bit=1;
                }
            }

            c++;
        }

        cout << "LU: " << (double) count_miss / (double) (count_hit + count_miss) << endl;

        fclose(fp);
    }

    {
        FILE *fp = fopen("RADIX.txt", "r");  // read file
        int count_hit = 0;
        int count_miss = 0;
        int c = 0;
        while(fscanf(fp, "%x", &x) != EOF)
        {
            int set_index = (x >> offset_bit) % Set;
            //index = (x >> offset_bit) & (line - 1);
            tag = x >> (set_bit + offset_bit);

            if(c%100==0){
                for(int i=0;i<Set;++i){
                    for(int j=0;j<n;++j){
                        set_associative[i][j].reference_bit=0;
                    }
                }
            }

            bool success=false;
            for(int i=0;i<n;++i){
                if(set_associative[set_index][i].tag==tag&&set_associative[set_index][i].v){
                    //hit
                    count_hit++;
                    success=true;
                    set_associative[set_index][i].reference_bit=1;
                    break;
                }
                if(set_associative[set_index][i].tag==0&&set_associative[set_index][i].v==0){
                    //miss
                    count_miss++;
                    set_associative[set_index][i].tag=tag;
                    set_associative[set_index][i].v=1;
                    set_associative[set_index][i].reference_bit=1;
                    success=true;
                    break;
                }
            }

            if(!success){
                count_miss++;
                //miss and full
                //LRU
                bool ok = false;
                for(int i=0;i<n;++i){
                    if(set_associative[set_index][i].reference_bit!=1){
                        set_associative[set_index][i].tag=tag;
                        set_associative[set_index][i].v=1;
                        set_associative[set_index][i].reference_bit=1;
                        ok = true;
                        break;
                    }
                }
                if(!ok){
                    srand((unsigned)time(NULL));
                    int r = rand() % n;
                    set_associative[set_index][r].tag=tag;
                    set_associative[set_index][r].v=1;
                    set_associative[set_index][r].reference_bit=1;
                }
            }

            c++;
        }

        cout << "RADIX: " << (double) count_miss / (double) (count_hit + count_miss) << endl;

        fclose(fp);
    }

}

int main()
{
	// Let us simulate 4KB cache with 16B blocks
	//simulate(1*K , 64);
	simulate(1*K , 1);simulate(2*K , 1);simulate(4*K , 1);simulate(8*K , 1);simulate(16*K , 1);simulate(32*K , 1);cout<<endl;
	simulate(1*K , 2);simulate(2*K , 2);simulate(4*K , 2);simulate(8*K , 2);simulate(16*K , 2);simulate(32*K , 2);cout<<endl;
	simulate(1*K , 4);simulate(2*K , 4);simulate(4*K , 4);simulate(8*K , 4);simulate(16*K , 4);simulate(32*K , 4);cout<<endl;
	simulate(1*K , 8);simulate(2*K , 8);simulate(4*K , 8);simulate(8*K , 8);simulate(16*K , 8);simulate(32*K , 8);cout<<endl;
}
