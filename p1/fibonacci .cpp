/**
ʹ��ͨ�ʽ a[n] = a[n-1]+a[n-2]����������
������ֵ���󣬲��ô����ӷ��������� 
**/
#include <iostream>
#include <cstring>
#define digit 50    //�������λ�� 
using namespace std;
//number1 ,number2 ���鱣��������ֵĸߵ�λ��ת�� 
int number1[digit];
int number2[digit];

int main()
{
	// acc��¼���� 
    int acc = 3;
    
    //��Ǳ���flag������ʱ������a[n]���滻a[n-2]����number1��number2���������� 
	//flag == true ʱ������ĺͱ�����number2�У� 
	//���򱣴���number1�� 
    bool flag = false; 
	
	 
    memset(number1,0,sizeof(number1));
    memset(number2,0,sizeof(number2));
    
    
    //쳲��������еĵ�һ�����Ϊ1���ߵ�λ��ת������number1,number2������ 
    number1[0] = number2[0] = 1 ; 
    
    
	cout<<"��1�"<<1<<endl;
	cout<<"��2�"<<1<<endl;
	
    while(acc<=100){
    	cout<<"��"<<acc<<"��: ";
        int carry = 0; //carry��¼��λ 
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
        
        //������������ 
        if(flag == false){
            int j;
            //�����λ��ʼ���ҵ���һ����Ϊ0������ʼ��� 
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
             //�����λ��ʼ���ҵ���һ����Ϊ0������ʼ��� 
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