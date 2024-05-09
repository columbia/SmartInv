1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4     
5     address owner;
6     
7     function Ownable() public{
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner{
17     require(newOwner != address(0));      
18     owner = newOwner;
19   }
20 }
21 
22 contract CoinTour is Ownable {
23     
24     string public  name  = "Coin Tour";
25     
26     string public  symbol = "COT";
27     
28     uint32 public  decimals = 8 ;
29     
30     uint public totalSupply = 2100000000000000;
31     
32     uint public etap = 1000000000000000;
33     
34     uint public forCommand = 100000000000000;
35     
36     uint public sendCount = 200000000000;
37     
38     address public commandAddress = 0xA92AdaA9B9C4F2A4219132E6B9bd07B6a1F4e01e;
39     
40     uint startEtap1 = 1511949600;
41     uint endEtap1 = 1512028800;
42     
43     uint startEtap2 = 1512468000;
44     uint endEtap2 = 1512554400;
45 
46     mapping (address => uint) balances;
47     
48     mapping (address => mapping(address => uint)) allowed;
49     
50     function CoinTour() public {
51         balances[commandAddress] = forCommand;
52         balances[owner] = totalSupply-forCommand;
53     }
54     
55     function balanceOf(address who) public constant returns (uint balance) {
56         return balances[who];
57     }
58 
59     function transfer(address _to, uint _value) public returns (bool success) {
60             if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
61                 balances[msg.sender] -= _value; 
62                 balances[_to] += _value;
63                 Transfer(msg.sender, _to, _value);
64                 return true;
65             }
66         return false;
67     }
68     
69     function multisend(address[] temp) public onlyOwner returns (bool success){
70         if((now > startEtap1 && now < endEtap1)||(now > startEtap2 && now < endEtap2)){
71             for(uint i = 0; i < temp.length; i++) {
72                 if (now>=startEtap1 && now <=endEtap1 && balances[owner]>etap || now>=startEtap2 && now <=endEtap2 && balances[owner]>0){
73                     balances[owner] -= sendCount;
74                     balances[temp[i]] += sendCount;
75                     Transfer(owner, temp[i],sendCount);
76                 }
77             }
78             return true; 
79         }
80         return false;
81     }
82     
83     function burn() onlyOwner public {
84         require (now>=endEtap1 && now <=startEtap2 || now >= endEtap2);
85         uint _value;
86         if (now>=endEtap1 && now <=startEtap2) {
87             _value = balances[owner] - etap;
88             require(_value > 0);
89         }
90         else _value = balances[owner];
91         balances[owner] -= _value;
92         totalSupply -= _value;
93         Burn(owner, _value);
94     }
95     
96     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
97         if( allowed[_from][msg.sender] >= _value && balances[_from] >= _value && balances[_to] + _value >= balances[_to]) {
98             allowed[_from][msg.sender] -= _value;
99             balances[_from] -= _value; 
100             balances[_to] += _value;
101             Transfer(_from, _to, _value);
102             return true;
103         } 
104         return false;
105     }
106      
107     function approve(address _spender, uint _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112     
113     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
114         return allowed[_owner][_spender];
115     }
116         
117     event Burn(address indexed burner, uint indexed value);
118 
119     event Transfer(address indexed _from, address indexed _to, uint _value);
120     
121     event Approval(address indexed _owner, address indexed _spender, uint _value);   
122 }