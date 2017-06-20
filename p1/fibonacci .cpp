#include<iostream>
using namespace std;
int num[102];
int main(){
	num[0] = 1;
	num[1] = 1;
	for(int i = 2; i < 100; i++){
		num[i]=num[i-1]+num[i-2];
	}
	for(int i = 0;i < 100; i++){
		cout<<num[i]<<" ";
		if(i % 5 == 0){
			cout<<endl;
		}
	}
	return 0;
}
