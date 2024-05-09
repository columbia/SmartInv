1 pragma solidity ^0.4.13;
2  
3 contract Ownable {
4     
5     address owner;
6     
7     function Ownable() {
8         owner = msg.sender;
9     }
10  
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15  
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19     
20 }
21  
22 contract CAB_EQUITY_008 is Ownable {
23     
24     string public constant name = "CAB Equity 8";
25     
26     string public constant symbol = "CEVIII";
27     
28     uint32 public constant decimals = 8;
29     
30     uint public totalSupply = 0;
31     
32     mapping (address => uint) balances;
33     
34     mapping (address => mapping(address => uint)) allowed;
35     
36     function mint(address _to, uint _value) onlyOwner {
37         assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
38         balances[_to] += _value;
39         totalSupply += _value;
40     }
41     
42     function balanceOf(address _owner) constant returns (uint balance) {
43         return balances[_owner];
44     }
45  
46     function transfer(address _to, uint _value) returns (bool success) {
47         if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
48             balances[msg.sender] -= _value; 
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } 
53         return false;
54     }
55     
56     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
57         if( allowed[_from][msg.sender] >= _value &&
58             balances[_from] >= _value 
59             && balances[_to] + _value >= balances[_to]) {
60             allowed[_from][msg.sender] -= _value;
61             balances[_from] -= _value; 
62             balances[_to] += _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } 
66         return false;
67     }
68     
69     function approve(address _spender, uint _value) returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74     
75     function allowance(address _owner, address _spender) constant returns (uint remaining) {
76         return allowed[_owner][_spender];
77     }
78     
79     event Transfer(address indexed _from, address indexed _to, uint _value);
80     
81     event Approval(address indexed _owner, address indexed _spender, uint _value);
82 
83 /*
84 0xf58b6a71D95F8853400655c0413bbf73CE6316DD
85 transfert from
86 0x6CF821A13455cABed0adc2789C6803FA2e938cA9
87 to
88 0x360D6728fc48B568588687DaD8D0143D61448D91
89 approve_1
90 0x360D6728fc48B568588687DaD8D0143D61448D91
91 approve_2
92 0xDFA87b97CEBd03CbfB682A2F041CC9F0B0E7A3fE
93 */
94     
95 }