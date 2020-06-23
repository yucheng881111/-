#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

/*double log2(double n)
{
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}*/


void simulate(int cache_size, int block_size)
{
	unsigned int tag, index, x;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];

    //cout << "cache line: " << line << endl;

	for(int j = 0; j < line ; j++)
		cache[j].v = false;


    {
        FILE *fp = fopen("ICACHE.txt", "r");  // read file
        int count_hit=0;
        int count_miss=0;
        while(fscanf(fp, "%x", &x) != EOF)
        {
            //cout << hex << x << " ";
            //index = (x >> offset_bit) % line;
            index = (x >> offset_bit) & (line - 1);
            tag = x >> (index_bit + offset_bit);

            if(cache[index].v && cache[index].tag == tag)
            {
                cache[index].v = true;    // hit
                count_hit++;
            }
            else
            {
                cache[index].v = true;  // miss
                cache[index].tag = tag;
                count_miss++;
            }
        }
        cout << "ICACHE: " << (double) count_miss / (double) (count_hit + count_miss) << endl;

        fclose(fp);
    }

    {
        FILE *fp = fopen("DCACHE.txt", "r");  // read file
        int count_hit=0;
        int count_miss=0;
        while(fscanf(fp, "%x", &x) != EOF)
        {
            //cout << hex << x << " ";
            //index = (x >> offset_bit) % line;
            index = (x >> offset_bit) & (line - 1);
            tag = x >> (index_bit + offset_bit);

            if(cache[index].v && cache[index].tag == tag)
            {
                cache[index].v = true;    // hit
                count_hit++;
            }
            else
            {
                cache[index].v = true;  // miss
                cache[index].tag = tag;
                count_miss++;
            }
        }
        cout << "DCACHE: " <<(double) count_miss / (double) (count_hit + count_miss) << endl;

        fclose(fp);
    }


	delete [] cache;
}

int main()
{
	simulate(32, 4);
	simulate(32, 8);
	simulate(32, 16);
	simulate(32, 32);
    cout<<endl;
	simulate(64, 4);
	simulate(64, 8);
	simulate(64, 16);
	simulate(64, 32);
	simulate(64, 64);
    cout<<endl;
	simulate(128, 4);
	simulate(128, 8);
	simulate(128, 16);
	simulate(128, 32);
	simulate(128, 64);
	cout<<endl;


}
