1 pragma solidity ^0.4.16;
2 contract Ownable {
3     address owner;
4     
5     function Ownable() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17     
18 }
19 
20 contract SimpleTokenCoin is Ownable {
21     
22     string public constant name = "ZakharN Eternal Token";
23     
24     string public constant symbol = "ZNET";
25     
26     uint32 public constant decimals = 18;
27     
28     uint public totalSupply;
29     mapping (address => uint) balances;
30     mapping (address => mapping (address => uint256)) internal allowed;
31 
32     
33     function balanceOf(address _owner) constant public returns (uint balance) {
34         return balances[_owner];
35     }
36 
37     function transfer(address _to, uint _value) public returns (bool success) {
38         require(balances[msg.sender]>=_value);
39         balances[msg.sender] -= _value;
40         balances[_to] += _value;
41         assert(balances[_to]>=_value);
42         Transfer(msg.sender, _to, _value);
43         return true;
44     }
45     
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
47         require(_to != address(0));
48         require(_value <= balances[_from]);
49         require(_value <= allowed[_from][msg.sender]);
50         balances[_from] -= _value;
51         balances[_to] += _value;
52         assert(balances[_to]>=_value);
53         allowed[_from][msg.sender] -= _value;
54         Transfer(_from, _to, _value);
55         return true;
56     }
57     
58     function approve(address _spender, uint _value) public returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender,_spender,_value);
61         return false;
62     }
63     
64     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
65         return allowed[_owner][_spender];
66     }
67     
68     event Transfer(address indexed _from, address indexed _to, uint _value);
69     
70     event Approval(address indexed _owner, address indexed _spender, uint _value);
71     
72 }
73 
74 contract Crowdsale is Ownable, SimpleTokenCoin{
75 
76     function mint(address _to, uint _value) public onlyOwner returns (bool){
77         require(balances[_to] + _value >= balances[_to]);
78         balances[_to] +=_value;
79         totalSupply += _value;
80         Mint(_to, _value);
81     }    
82     
83     //payable
84     function() external payable {
85         uint _summa = msg.value; //ether
86         createTokens(msg.sender, _summa);
87     }
88 
89     function createTokens(address _to, uint _value) public{
90         require(balances[_to] + _value >= balances[_to]);
91         balances[_to] +=_value;
92         totalSupply += _value;
93         Mint(_to, _value);
94     }
95     
96     //refund
97     function refund() public {
98     }
99     
100     function giveMeCoins(uint256 _value) public onlyOwner returns(uint){
101         require(this.balance>=_value);
102         owner.transfer(_value);
103         return this.balance;
104     }
105     event Mint (address, uint);
106 }