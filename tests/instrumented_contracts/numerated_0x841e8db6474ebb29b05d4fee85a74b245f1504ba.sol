1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     
5     address public owner;
6     
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         owner = newOwner;
18     }
19     
20 }
21 
22 contract DeLuftCdsTok20221205I is Ownable {
23     
24     string public constant name = "DeLuftCdsTok20221205I";
25     
26     string public constant symbol = "DELUFTII";
27     
28     uint32 public constant decimals = 8;
29     
30     uint public totalSupply = 0;
31     
32     mapping (address => uint) balances;
33     
34     mapping (address => mapping(address => uint)) allowed;
35     
36     function mint(address _to, uint _value) public onlyOwner {
37         assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
38         balances[_to] += _value;
39         totalSupply += _value;
40     }
41     
42     function balanceOf(address _owner) public constant returns (uint balance) {
43         return balances[_owner];
44     }
45 
46     function transfer(address _to, uint _value) public returns (bool success) {
47         if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
48             balances[msg.sender] -= _value; 
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } 
53         return false;
54     }
55     
56     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
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
69     function approve(address _spender, uint _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74     
75     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
76         return allowed[_owner][_spender];
77     }
78     
79     event Transfer(address indexed _from, address indexed _to, uint _value);
80     
81     event Approval(address indexed _owner, address indexed _spender, uint _value);
82     
83 }