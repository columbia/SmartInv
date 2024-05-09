1 pragma solidity >=0.4.0 <0.6.0;
2 
3 contract Token {
4 
5     function totalSupply() public  view returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) public view returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value)public returns (bool success) {}
14 
15     function allowance(address _owner, address _spender)public  returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21 }
22 
23 contract StandardToken is Token {
24   uint256 public _totalSupply;  
25   string public name;  
26   string public symbol;  
27   uint32 public decimals;  
28   address public owner;
29   uint256 public oneTokenPrice;
30   uint256 public  no_of_tokens;
31   
32   mapping (address => uint256) balances;
33   mapping (address => mapping (address => uint256)) allowed;
34   
35    constructor() public {  
36         symbol = "MAS";  
37         name = "MAS";  
38         decimals = 18;  
39         _totalSupply = 2000000000* 10**uint(decimals);  
40         owner = msg.sender;  
41         balances[msg.sender] = _totalSupply; 
42         oneTokenPrice = 0.01 ether;
43     }
44     
45     function totalSupply() public view returns (uint256) {
46         return _totalSupply;
47     }
48  
49 
50    function transfer(address _to, uint256 _value) public returns (bool success) {
51 
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             emit Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             emit Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) public view  returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) public returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) public  returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     function tokenForEther() public payable returns(uint256)
85     {
86         address payable _owner = address(uint160((owner))) ;
87         no_of_tokens = msg.value/oneTokenPrice;
88         _owner.transfer(msg.value);
89         transferFrom(_owner,msg.sender,no_of_tokens);
90         return no_of_tokens;
91     }
92 
93 }