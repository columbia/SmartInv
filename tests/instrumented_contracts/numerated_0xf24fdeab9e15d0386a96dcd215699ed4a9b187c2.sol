1 pragma solidity ^0.4.25;
2 
3 /*     ONUP TOKEN AFFILIATE PROJECT, THE FIRST EDITION
4         CREATED 2018-10-31 BY DAO DRIVER ETHEREUM
5         ALL PROJECT DETAILS AT https://onup.online       */
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c=a*b;assert(c/a==b);return c;}
9     function div(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a/b;return c;}
10     function sub(uint256 a, uint256 b)internal pure returns(uint256){assert(b<=a);return a-b;}
11     function add(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a+b;assert(c>=a);return c;}
12 }
13 contract ERC20 {uint256 internal Bank=0;string public constant name="OnUp TOKEN";string public constant symbol="OnUp";
14     uint8  public constant decimals=6; uint256 public price=700000000; uint256 public totalSupply;
15     event Approval(address indexed owner,address indexed spender,uint value);
16     event Transfer(address indexed from,address indexed to,uint value);
17     mapping(address=>mapping(address=>uint256))public allowance; mapping(address=>uint256)public balanceOf;
18     function balanceOf(address who)public constant returns(uint){return balanceOf[who];}
19     function approve(address _spender,uint _value)public{allowance[msg.sender][_spender]=_value; emit Approval(msg.sender,_spender,_value);}
20     function allowance(address _owner,address _spender) public constant returns (uint remaining){return allowance[_owner][_spender];} 
21 }
22 contract ALFA is ERC20{using SafeMath for uint256;
23     modifier onlyPayloadSize(uint size){require(msg.data.length >= size + 4); _;}
24     address  ref1 = 0x0000000000000000000000000000000000000000;
25     address  ref2 = 0x0000000000000000000000000000000000000000;
26     address  ref3 = 0x0000000000000000000000000000000000000000;
27     address  ref4 = 0x0000000000000000000000000000000000000000;
28     address  ref5 = 0x0000000000000000000000000000000000000000;
29     address public owner;
30     address internal constant insdr = 0xaB85Cb1087ce716E11dC37c69EaaBc09d674575d;// FEEDER 
31     address internal constant advrt = 0x28fF20D2d413A346F123198385CCf16E15295351;// ADVERTISE
32     address internal constant spcnv = 0x516e0deBB3dB8C2c087786CcF7653fa0991784b3;// AIRDROPS
33     mapping (address => address) public referrerOf;
34     mapping (address => uint256) public prevOf;
35     mapping (address => uint256) public summOf;
36     constructor()public payable{owner=msg.sender;prevOf[advrt]=6;prevOf[owner]=6;}
37     function()payable public{
38         require(msg.value >= 10000000000000000);
39         require(msg.value <= 30000000000000000000);
40         require(isContract(msg.sender)==false); 
41         if( msg.sender!=insdr ){
42             ref1=0x0000000000000000000000000000000000000000; 
43             ref2=0x0000000000000000000000000000000000000000;
44             ref3=0x0000000000000000000000000000000000000000;
45             ref4=0x0000000000000000000000000000000000000000;
46             ref5=0x0000000000000000000000000000000000000000;
47             if(msg.sender!= advrt && msg.sender!=owner){CheckPrivilege();}else{mintTokens();}
48         }else{Bank+=(msg.value.div(100)).mul(90);price=Bank.div(totalSupply);}
49     }
50     function CheckPrivilege()internal{
51         if(msg.value>=25000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
52         if(msg.value>=20000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
53         if(msg.value>=15000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
54         if(msg.value>=10000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
55         if(msg.value>= 5000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;} 
56         if(msg.value>=  100000000000000000 && prevOf[msg.sender]<1){prevOf[msg.sender]=1;}
57         if(summOf[msg.sender]>=250000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
58 		if(summOf[msg.sender]>=200000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
59 		if(summOf[msg.sender]>=150000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
60 		if(summOf[msg.sender]>=100000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
61 		if(summOf[msg.sender]>= 50000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;}
62 		ref1=referrerOf[msg.sender];if(ref1==0x0000000000000000000000000000000000000000){
63 		ref1=bytesToAddress(msg.data);require(isContract(ref1)==false);require(balanceOf[ref1]>0);require(ref1!=spcnv);
64 		require(ref1!=insdr);referrerOf[msg.sender]=ref1;}mintTokens();
65     }
66     function mintTokens()internal{
67         uint256 tokens=msg.value.div((price*100).div(70));
68         require(tokens>0);require(balanceOf[msg.sender]+tokens>balanceOf[msg.sender]);
69         uint256 perc=msg.value.div(100);uint256 sif=perc.mul(10);
70         uint256 percair=0;uint256 bonus1=0;uint256 bonus2=0;uint256 bonus3=0;
71         uint256 bonus4=0;uint256 bonus5=0;uint256 minus=0;uint256 airdrop=0;
72         if(msg.sender!=advrt && msg.sender!=owner && msg.sender!=spcnv){
73         if(ref1!=0x0000000000000000000000000000000000000000){summOf[ref1]+=msg.value; 
74         if(prevOf[ref1]>1){sif-=perc.mul(2);bonus1=perc.mul(2);minus+=2;} 
75         else if(prevOf[ref1]>0){sif-=perc;bonus1=perc;minus+=1;}else{}
76         if(ref2!= 0x0000000000000000000000000000000000000000){ 
77         if(prevOf[ref2]>2){sif-=perc.mul(2);bonus2=perc.mul(2);minus+=2;}
78         else if(prevOf[ref2]>0){sif-=perc;bonus2=perc;minus+=1;}else{}
79         if(ref3!= 0x0000000000000000000000000000000000000000){ 
80         if(prevOf[ref3]>3){sif-=perc.mul(2);bonus3=perc.mul(2);minus+=2;}
81         else if(prevOf[ref3]>0){sif-=perc;bonus3=perc;minus+=1;}else{}
82         if(ref4!= 0x0000000000000000000000000000000000000000){ 
83         if(prevOf[ref4]>4){sif-=perc.mul(2);bonus4=perc.mul(2);minus+=2;}
84         else if(prevOf[ref4]>0){sif-=perc;bonus4=perc;minus+=1;}else{}
85         if(ref5!= 0x0000000000000000000000000000000000000000){ 
86         if(prevOf[ref5]>5){sif-=perc.mul(2);bonus5=perc.mul(2);minus+= 2;}
87         else if(prevOf[ref5]>0){sif-=perc;bonus5=perc;minus+=1;}else{}}}}}}} 
88         if(sif>0){
89             airdrop=sif.div((price*100).div(70)); 
90             require(airdrop>0); 
91             percair=sif.div(100);
92             balanceOf[spcnv]+=airdrop; 
93             emit Transfer(this,spcnv,airdrop);}
94         Bank+=(perc+percair).mul(85-minus);    
95         totalSupply+=(tokens+airdrop);
96         price=Bank.div(totalSupply);
97         balanceOf[msg.sender]+=tokens;
98         emit Transfer(this,msg.sender,tokens);
99         tokens=0;airdrop=0;
100         owner.transfer(perc.mul(5)); 
101         advrt.transfer(perc.mul(5));
102         if(bonus1>0){ref1.transfer(bonus1);} 
103         if(bonus2>0){ref2.transfer(bonus2);} 
104         if(bonus3>0){ref3.transfer(bonus3);} 
105         if(bonus4>0){ref4.transfer(bonus4);} 
106         if(bonus5>0){ref5.transfer(bonus5);}
107     }
108       function transfer(address _to,uint _value)
109       public onlyPayloadSize(2*32)returns(bool success){
110         require(balanceOf[msg.sender]>=_value);
111         if(_to!=address(this)){
112             if(msg.sender==spcnv){require(_value<10000001);}
113             require(balanceOf[_to]+_value>=balanceOf[_to]);
114             balanceOf[msg.sender] -=_value;
115             balanceOf[_to]+=_value;
116             emit Transfer(msg.sender,_to,_value);
117         }else{require(msg.sender!=spcnv);
118         balanceOf[msg.sender]-=_value;uint256 change=_value.mul(price);
119         require(address(this).balance>=change);
120         if(totalSupply>_value){
121             uint256 plus=(address(this).balance-Bank).div(totalSupply);
122             Bank-=change;totalSupply-=_value;Bank+=(plus.mul(_value));
123             price=Bank.div(totalSupply);
124             emit Transfer(msg.sender,_to,_value);}
125         if(totalSupply==_value){
126             price=address(this).balance.div(totalSupply);
127             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
128             emit Transfer(msg.sender,_to,_value);
129             owner.transfer(address(this).balance-change);}
130         msg.sender.transfer(change);}return true;
131       }
132     function transferFrom(address _from,address _to,uint _value)
133     public onlyPayloadSize(3*32)returns(bool success){
134         require(balanceOf[_from]>=_value);require(allowance[_from][msg.sender]>=_value);
135         if(_to!=address(this)){
136             if(msg.sender==spcnv){require(_value<10000001);}
137             require(balanceOf[_to]+_value>=balanceOf[_to]);
138             balanceOf[_from]-=_value;balanceOf[_to]+=_value;
139             allowance[_from][msg.sender]-=_value;
140             emit Transfer(_from,_to,_value);
141         }else{require(_from!=spcnv);
142         balanceOf[_from]-=_value;uint256 change=_value.mul(price);
143         require(address(this).balance>=change);
144         if(totalSupply>_value){
145             uint256 plus=(address(this).balance-Bank).div(totalSupply);
146             Bank-=change;
147             totalSupply-=_value;
148             Bank+=(plus.mul(_value));
149             price=Bank.div(totalSupply);
150             emit Transfer(_from,_to,_value);
151             allowance[_from][msg.sender]-=_value;} 
152         if(totalSupply==_value){
153             price=address(this).balance.div(totalSupply);
154             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
155             emit Transfer(_from,_to,_value);allowance[_from][msg.sender]-=_value;
156             owner.transfer(address(this).balance - change);}
157         _from.transfer(change);}return true;
158     }
159     function bytesToAddress(bytes source)internal pure returns(address addr){assembly{addr:=mload(add(source,0x14))}return addr;}
160     function isContract(address addr)internal view returns(bool){uint size;assembly{size:=extcodesize(addr)}return size>0;}
161 }