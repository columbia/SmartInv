1 pragma solidity ^0.4.24;
2 
3 /******************************************/
4 /*       Netkiller Batch Token            */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-06-09 - Batch transfer    */
9 /******************************************/
10 
11 contract NetkillerBatchToken {
12     address public owner;
13     string public name;
14     string public symbol;
15     uint public decimals;
16     uint256 public totalSupply;
17 
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Burn(address indexed from, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24     
25     mapping (address => bool) public frozenAccount;
26     event FrozenFunds(address target, bool frozen);
27 
28     bool lock = false;
29 
30     constructor(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol,
34         uint decimalUnits
35     ) public {
36         owner = msg.sender;
37         name = tokenName;
38         symbol = tokenSymbol; 
39         decimals = decimalUnits;
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier isLock {
50         require(!lock);
51         _;
52     }
53     
54     function setLock(bool _lock) onlyOwner public{
55         lock = _lock;
56     }
57 
58     function transferOwnership(address newOwner) onlyOwner public {
59         if (newOwner != address(0)) {
60             owner = newOwner;
61         }
62     }
63  
64 
65     function _transfer(address _from, address _to, uint _value) isLock internal {
66         require (_to != 0x0);
67         require (balanceOf[_from] >= _value);
68         require (balanceOf[_to] + _value > balanceOf[_to]);
69         require(!frozenAccount[_from]);
70         require(!frozenAccount[_to]);
71         balanceOf[_from] -= _value;
72         balanceOf[_to] += _value;
73         emit Transfer(_from, _to, _value);
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         _transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(_value <= allowance[_from][msg.sender]);
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function burn(uint256 _value) onlyOwner public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);
96         balanceOf[msg.sender] -= _value;
97         totalSupply -= _value;
98         emit Burn(msg.sender, _value);
99         return true;
100     }
101 
102     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
103         require(balanceOf[_from] >= _value); 
104         require(_value <= allowance[_from][msg.sender]); 
105         balanceOf[_from] -= _value;
106         allowance[_from][msg.sender] -= _value;
107         totalSupply -= _value;
108         emit Burn(_from, _value);
109         return true;
110     }
111 
112     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
113         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
114         balanceOf[target] += _amount;
115         totalSupply += _amount;
116         emit Transfer(this, target, _amount);
117     }
118     
119     function freezeAccount(address target, bool freeze) onlyOwner public {
120         frozenAccount[target] = freeze;
121         emit FrozenFunds(target, freeze);
122     }
123 
124     function transferBatch(address[] _to, uint256 _value) public returns (bool success) {
125         for (uint i=0; i<_to.length; i++) {
126             _transfer(msg.sender, _to[i], _value);
127         }
128         return true;
129     }
130 }