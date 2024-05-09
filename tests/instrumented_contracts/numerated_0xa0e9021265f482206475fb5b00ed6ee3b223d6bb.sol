1 pragma solidity ^0.4.23;
2 library SafeMath{
3     function add(uint a,uint b) internal pure returns(uint c){
4         c=a+b;
5         require(c>=a);
6     }
7     function sub(uint a,uint b) internal pure returns(uint c){
8         require(b<=a);
9         c=a-b;
10     }
11     function mul(uint a,uint b) internal pure returns(uint c){
12         c=a*b;
13         require(a==0||c/a==b);
14     }
15     function div(uint a,uint b) internal pure returns(uint c){
16         require(a==b*c+a%b);
17         c=a/b;
18     }
19 }
20 interface ERC20{
21   function totalSupply() external returns(uint);
22 
23   function banlanceOf(address tonkenOwner) external returns(uint balance);
24 
25   function allowance(address tokenOwner,address spender) external returns(uint remaining);
26 
27   function transfer(address to,uint tokens) external returns(bool success);
28 
29   function approve(address spender,uint tokens) external returns(bool success);
30 
31   function transferFrom(address from,address to,uint tokens) external returns(bool success);
32   
33   event Transfer(address indexed from,address indexed to,uint tokens);
34   event Approval(address indexed spender,address indexed to,uint tokens);
35 }
36 interface ApproveAndCallFallBack{
37   function receiverApproval(address from,uint tokens,address token,bytes date) public;
38 }
39 
40 interface ContractRceiver{
41     function tokenFallBack(address _from,uint _value,bytes _data) public;
42 }
43 interface ERC223{
44     function transfer(address to,uint value,bytes data) public returns(bool ok);
45     event Transfer(address indexed from,address indexed to,uint value,bytes indexed data);
46 }
47 contract Owned{
48     address public owner;
49     address public newOwner;
50     event transferownership(address indexed from,address indexed to);
51     constructor() public{
52         owner=msg.sender;
53     }
54     modifier onlyOwner{
55         require(msg.sender==owner);
56         _;
57     }
58     function ownershiptransferred(address _newOwner) public onlyOwner{
59         newOwner=_newOwner;
60     }
61     function acceptowner() public{
62         require(msg.sender==newOwner);
63         emit transferownership(owner,newOwner);
64         owner=newOwner;
65         newOwner=address(0);
66     }
67 }
68 contract BCBtokens is ERC20,ERC223,Owned{
69  using SafeMath for uint;
70  string public symbol;
71  string public name;
72  uint8 public decimals;
73  uint256 _totalSupply;
74  mapping(address=>uint) balances;
75  mapping(address=>mapping(address=>uint)) allowed;
76  constructor() public{
77      symbol = "BCB";
78      name="BCB";
79      decimals=18;
80      _totalSupply=99000000*10**18;
81      balances[owner] = _totalSupply;
82      emit Transfer(address(0),owner,_totalSupply);
83   }
84   function Iscontract(address _addr) public view returns(bool success){
85       uint length;
86       assembly{
87           length:=extcodesize(_addr)
88       }
89       return (length>0);
90   }
91    
92   function totalSupply() public view returns(uint){
93       return _totalSupply.sub(balances[address(0)]);
94   }
95   function banlanceOf(address tokenOwner) public returns(uint balance){
96       return balances[tokenOwner];
97   }
98   function transfer(address to,uint tokens) public returns(bool success){
99       balances[msg.sender] = balances[msg.sender].sub(tokens);
100       balances[to] = balances[to].add(tokens);
101       emit Transfer(msg.sender,to,tokens);
102       return true;
103   }
104   function transfer(address to ,uint value,bytes data) public returns(bool ok){
105       if(Iscontract(to)){
106           balances[msg.sender]=balances[msg.sender].sub(value);
107           balances[to] = balances[to].add(value);
108           ContractRceiver c = ContractRceiver(to);
109           c.tokenFallBack(msg.sender,value,data);
110           emit Transfer(msg.sender,to,value,data);
111           return true;
112       }
113   }
114   function approve(address spender,uint tokens) public returns(bool success){
115       allowed[msg.sender][spender]=tokens;
116       emit Approval(msg.sender,spender,tokens);
117       return true;
118   }
119   function transferFrom(address from,address to,uint tokens) public returns(bool success){
120       balances[from] = balances[from].sub(tokens);
121       allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
122       balances[to] = balances[to].add(tokens);
123       return true;
124   }
125   function allowance(address tokenOwner,address spender) public returns(uint remaining){
126       return allowed[tokenOwner][spender];
127   }
128      function approveAndCall(address spender,uint tokens,bytes data) public returns(bool success){
129     allowed[msg.sender][spender]=tokens;
130     emit Approval(msg.sender,spender,tokens);
131     ApproveAndCallFallBack(spender).receiverApproval(msg.sender,tokens,this,data);
132     return true;
133   }
134   function () public payable{
135     revert();
136   }
137 }