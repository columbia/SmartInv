1 pragma solidity ^0.4.2;
2 contract Token{
3 
4   event Transfer(address indexed _from, address indexed _to, uint256 _value);
5 
6   event Approval(address indexed _onwer,address indexed _spender, uint256 _value);
7 
8   function totalSupply() constant returns(uint256 totalSupply){}
9 
10   function balanceOf(address _owner) constant returns (uint256 balance){}
11 
12   function transfer(address _to, uint256 _value) constant returns(bool success){}
13 
14   function transferFrom(address _from, address _to, uint256 _value) constant returns (bool success){}
15 
16   function approve(address _spender, uint256 _value) constant returns(bool success){}
17 
18   function allowance(address _owner, uint _spender) constant returns(uint256 remaining){}
19 
20 }
21 
22 contract StandardToken is Token{
23   uint256 public totalSupply;
24   mapping(address => uint256)balances;
25   mapping(address =>mapping(address=>uint256))allowed;
26 
27 
28   function transfer(address _to, uint256 _value)constant returns(bool success){
29     if(balances[msg.sender]>_value && balances[_to]+_value>balances[_to]) {
30       balances[msg.sender] -= _value;
31       balances[_to] +=_value;
32       Transfer(msg.sender,_to,_value);
33       return true;
34     } else {
35       return false;
36     }
37   }
38 
39   function transferFrom(address _from, address _to, uint256 _value)constant returns(bool success){
40     if(balances[_from]>_value && allowed[_from][msg.sender]>_value && balances[_to]+_value>balances[_to]){
41       balances[_from]-=_value;
42       allowed[_from][msg.sender]-=_value;
43       balances[_to]-=_value;
44       Transfer(_from,_to,_value);
45       return true;
46     } else {
47       return false;
48     }
49   }
50 
51   function approve(address _spender, uint256 _value)constant returns (bool success){
52     allowed[msg.sender][_spender]=_value;
53     Approval(msg.sender,_spender,_value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) constant returns (uint256 balance){
58     return balances[_owner];
59   }
60 
61   function allowance(address _onwer,address _spender) constant returns(uint256 allowance){
62     return allowed[_onwer][_spender];
63   }
64 }
65 
66 contract NinjaToken is StandardToken{
67     string public name ="NinjaToken";
68     string public version="0.0.1";
69     uint public decimals = 18;
70     mapping(address=>string) public commit;
71     
72     address public founder;
73     address public admin; 
74     bool public fundingLock=true;  // indicate funding status activate or inactivate
75     address public fundingAccount;
76     uint public startBlock;        //Crowdsale startBlock
77     uint public blockDuration;     // Crowdsale blocks duration
78     uint public fundingExchangeRate;
79     uint public price=10;
80     bool public transferLock=false;  // indicate transfer status activate or inactivate
81 
82     event Funding(address sender, uint256 eth);
83     event Buy(address buyer, uint256 eth);
84     
85     function NinjaToken(address _founder,address _admin){
86         founder=_founder;
87         admin=_admin;
88     }
89     
90     function changeFunder(address _founder,address _admin){
91         if(msg.sender!=admin) throw;
92         founder=_founder;
93         admin=_admin;        
94     }
95     
96     function setFundingLock(bool _fundinglock,address _fundingAccount){
97         if(msg.sender!=founder) throw;
98         fundingLock=_fundinglock;
99         fundingAccount=_fundingAccount;
100     }
101     
102     function setFundingEnv(uint _startBlock, uint _blockDuration,uint _fundingExchangeRate){
103         if(msg.sender!=founder) throw;
104         startBlock=_startBlock;
105         blockDuration=_blockDuration;
106         fundingExchangeRate=_fundingExchangeRate;
107     }
108     
109     function funding() payable {
110         if(fundingLock||block.number<startBlock||block.number>startBlock+blockDuration) throw;
111         if(balances[msg.sender]>balances[msg.sender]+msg.value*fundingExchangeRate || msg.value>msg.value*fundingExchangeRate) throw;
112         if(!fundingAccount.call.value(msg.value)()) throw;
113         balances[msg.sender]+=msg.value*fundingExchangeRate;
114         Funding(msg.sender,msg.value);
115     }
116     
117     function setPrice(uint _price,bool _transferLock){
118         if(msg.sender!=founder) throw;
119         price=_price;
120         transferLock=_transferLock;
121     }
122     
123     function buy(string _commit) payable{
124         if(balances[msg.sender]>balances[msg.sender]+msg.value*price || msg.value>msg.value*price) throw;
125         if(!fundingAccount.call.value(msg.value)()) throw;
126         balances[msg.sender]+=msg.value*price;
127         commit[msg.sender]=_commit;
128         Buy(msg.sender,msg.value);
129     }
130     
131     function transfer(address _to, uint256 _value)constant returns(bool success){
132         if(transferLock) throw;
133         return super.transfer(_to, _value);
134     }
135 
136     function transferFrom(address _from, address _to, uint256 _value)constant returns(bool success){
137         if(transferLock) throw;
138         return super.transferFrom(_from, _to, _value);
139     }
140 
141 }