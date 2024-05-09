1 pragma solidity ^0.4.26;
2 contract HPB {
3     address public owner;
4     mapping (address => uint) public balances;
5     address[] public users;
6     uint256 public total=0;
7     uint256 constant private MAX_UINT256 = 2**256 - 1;
8     mapping (address => mapping (address => uint256)) public allowed;
9     uint256 public totalSupply=10000000000000000;
10     string public name="Health Preservation Treasure";
11     uint8 public decimals=8;
12     string public symbol="HPT";
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     constructor() public{
17         owner = msg.sender;
18         balances[msg.sender] = totalSupply;
19     }
20 
21     function userCount() public view returns (uint256) {
22         return users.length;
23     }
24 
25     function getTotal() public view returns (uint256) {
26         return total;
27     }
28     function balanceOf(address _owner) public view returns (uint256 balance) {
29         return balances[_owner];
30     }
31 
32     function contractBalance() public view returns (uint256) {
33         return (address)(this).balance;
34     }
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[msg.sender] >= _value);
37         balances[msg.sender] -= _value;
38         balances[_to] += _value;
39         emit Transfer(msg.sender, _to, _value);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         uint256 allowance = allowed[_from][msg.sender];
45         require(balances[_from] >= _value && allowance >= _value);
46         balances[_to] += _value;
47         balances[_from] -= _value;
48         if (allowance < MAX_UINT256) {
49             allowed[_from][msg.sender] -= _value;
50         }
51         emit Transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64 
65     function() public payable {
66         if (msg.value > 0 ) {
67             total += msg.value;
68             bool isfind=false;
69             for(uint i=0;i<users.length;i++)
70             {
71                 if(msg.sender==users[i])
72                 {
73                     isfind=true;
74                     break;
75                 }
76             }
77             if(!isfind){users.push(msg.sender);}
78         }
79     }
80 }