1 pragma solidity ^0.5.0;
2 
3 // ERC-20 standard interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 contract ERC20Interface {
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address tokenOwner) public view returns (uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 contract KwikSilverCoin is ERC20Interface {
18     string public symbol;
19     string public  name;
20     uint8 public decimals;
21     uint256 public _totalSupply;
22     uint256 constant private MAX_UINT256 = 2**256 - 1;
23 
24     // Keeping track of inputs for every block results in gas costs that are too high
25     // We instead keep track of inputs for groups of blockGroupSize blocks
26     uint blockGroupSize = 20;
27 
28     mapping(address => uint) balances;
29     mapping(address => mapping(address => uint)) allowed;
30 
31     // For each address, this keeps track of how many tokens were received during each block group
32     mapping(address => mapping(uint => uint)) inputs;
33 
34     constructor() public {
35         symbol = "KWIK";
36         name = "KwikSilverCoin";
37         decimals = 18;
38         _totalSupply = 100000000000000000000000000;
39         balances[0x671446f120539cBBa92655082c881f18BF334001] = _totalSupply;
40         inputs[0x671446f120539cBBa92655082c881f18BF334001][block.number/blockGroupSize] = _totalSupply;
41         emit Transfer(address(0), 0x671446f120539cBBa92655082c881f18BF334001, _totalSupply);
42     }
43 
44     function totalSupply() public view returns (uint256) {
45         return _totalSupply;
46     }
47 
48     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
49         return balances[tokenOwner];
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         require(balances[msg.sender] >= _value);
54 
55         // Do some work to increase the gas cost
56         busyWork(msg.sender, _value);
57 
58         // Standard transfer
59         balances[msg.sender] -= _value;
60         balances[_to] += _value;
61         inputs[_to][block.number] += _value;
62         emit Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         uint256 allowance = allowed[_from][msg.sender];
68         require(balances[_from] >= _value && allowance >= _value);
69 
70         busyWork(msg.sender, _value);
71 
72         balances[_to] += _value;
73         balances[_from] -= _value;
74         if (allowance < MAX_UINT256) {
75             allowed[_from][msg.sender] -= _value;
76         }
77         emit Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 
91     function busyWork(address sender, uint amount) private returns (bool success) {
92         // Start from the current block and find unspent inputs until we have enough for the transaction amount
93         // The further back the last input is, the more gas is needed to spend it, since this loop will go longer
94         uint totalInput = 0;
95         uint blockGroupNum = block.number / blockGroupSize;
96         while (totalInput < amount) {
97             // Count the input amount at this block
98             totalInput += inputs[msg.sender][blockGroupNum];
99             // Remove the input, or if we have more than enough, remove the amount used
100             if (totalInput <= amount) {
101                 inputs[sender][blockGroupNum] = 0;
102             } else {
103                 inputs[sender][blockGroupNum] = totalInput - amount;
104             }
105             blockGroupNum--;
106         }
107     }
108 }