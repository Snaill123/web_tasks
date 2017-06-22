/**
使用通项公式 a[n] = a[n-1]+a[n-2]来计算数列
由于数值过大，采用大数加法进行运算 
**/
#include <iostream>
#include <cstring>
#define digit 50    //设置最大位数 
using namespace std;
//number1 ,number2 数组保存各项数字的高低位反转数 
int number1[digit];
int number2[digit];

int main()
{
	// acc记录项数 
    int acc = 3;
    
    //标记变量flag，计算时保正用a[n]项替换a[n-2]，即number1，number2轮流保存结果 
	//flag == true 时，计算的和保存在number2中， 
	//否则保存在number1中 
    bool flag = false; 
	
	 
    memset(number1,0,sizeof(number1));
    memset(number2,0,sizeof(number2));
    
    
    //斐波那契数列的第一二项均为1，高低位反转保存在number1,number2数组中 
    number1[0] = number2[0] = 1 ; 
    
    
	cout<<"第1项："<<1<<endl;
	cout<<"第2项："<<1<<endl;
	
    while(acc<=100){
    	cout<<"第"<<acc<<"项: ";
        int carry = 0; //carry记录进位 
        for(int i = 0; i < digit; i++){
            if(flag == false){
                int temp = number1[i] + number2[i] + carry;
                number1[i] = temp%10;
                carry = temp/10;
            }
            else{
                int temp = number1[i] + number2[i] + carry;
                number2[i] = temp%10;
               	carry = temp/10;
            }
        }
        
        //输出结果，逆序 
        if(flag == false){
            int j;
            //从最高位开始，找到第一个不为0的数开始输出 
            for(j = digit-1; j >= 0;j--){
                if(number1[j] == 0) continue;
                else{
                    break;
                }
            }
            for(; j >= 0; j--) {
                cout<<number1[j];
            } 
            cout<<endl;
            flag=true;
        }
        else {
            int j;
             //从最高位开始，找到第一个不为0的数开始输出 
            for(j = digit-1; j >= 0; j--){
                if(number2[j] == 0) continue;
                else{
                    break;
                }
            }
            for(; j >= 0; j--) {
                cout<<number2[j];
            }
            cout<<endl;
            flag = false;    
        }
        acc++;
    }
    return 0;
}
