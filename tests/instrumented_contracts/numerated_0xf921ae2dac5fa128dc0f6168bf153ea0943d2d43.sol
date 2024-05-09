1 pragma solidity =0.6.6;
2 
3 contract FIRE {
4     string public constant name = "Fire Protocol";
5     string public constant symbol = "FIRE";
6     uint8 public constant decimals = 8;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balances;
10     mapping (address => mapping (address => uint256)) internal allowances;
11     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
12     mapping (address => uint32) public numCheckpoints;
13 
14     struct Checkpoint {
15         uint32 fromBlock;
16         uint256 balance;
17     }
18 
19     event Transfer(address indexed from, address indexed to, uint256 amount);
20     event Approval(address indexed owner, address indexed spender, uint256 amount);
21 
22     constructor () public {
23         mint(address(0xfcF0d7C6Ca6F65cC2C9f44Ce484D014ae4073404), 10000000 * 1e8);
24         mint(address(0x04A93A90CB8E96399c4492Bb8B2eAe8be5599AB6), 10000000 * 1e8);
25         mint(address(0x67c356A98c7A0Cf52f8a0E43b0538Fe2a235d8e4), 5000000 * 1e8);
26         mint(address(0xFd63912199922BDc256d3AA0b189986C7a0A9D02), 5000000 * 1e8);
27         mint(address(0xb1676e5e542e68d226AC0b9B7d4314Df528A8078), 15000000 * 1e8);
28         mint(address(0x8f5B105830055506119c1F8Bb3aA879669db7FDc), 55000000 * 1e8);
29     }
30 
31     function mint(address _account, uint256 _number) internal {
32         balances[_account] = _number;
33         totalSupply += _number;
34         emit Transfer(address(0), _account, _number);
35         _moveDelegates(address(0), _account, _number);
36     }
37 
38     function allowance(address account, address spender) external view returns (uint) {
39         return allowances[account][spender];
40     }
41 
42     function approve(address spender, uint256 rawAmount) external returns (bool) {
43         uint256 amount;
44         if (rawAmount == uint256(-1)) {
45             amount = uint256(-1);
46         } else {
47             amount = safe256(rawAmount, "FIRE::approve: amount exceeds 256 bits");
48         }
49 
50         allowances[msg.sender][spender] = amount;
51         emit Approval(msg.sender, spender, amount);
52         return true;
53     }
54 
55     function balanceOf(address account) external view returns (uint) {
56         return balances[account];
57     }
58 
59     function transfer(address dst, uint rawAmount) external returns (bool) {
60         uint256 amount = safe256(rawAmount, "FIRE::transfer: amount exceeds 256 bits");
61         _transferTokens(msg.sender, dst, amount);
62         return true;
63     }
64 
65     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
66         address spender = msg.sender;
67         uint256 spenderAllowance = allowances[src][spender];
68         uint256 amount = safe256(rawAmount, "FIRE::approve: amount exceeds 256 bits");
69 
70         if (spender != src && spenderAllowance != uint256(-1)) {
71             uint256 newAllowance = sub256(spenderAllowance, amount, "FIRE::transferFrom: transfer amount exceeds spender allowance");
72             allowances[src][spender] = newAllowance;
73             emit Approval(src, spender, newAllowance);
74         }
75 
76         _transferTokens(src, dst, amount);
77         return true;
78     }
79 
80     function _transferTokens(address src, address dst, uint256 amount) internal {
81         require(src != address(0), "FIRE::_transferTokens: cannot transfer from the zero address");
82         require(dst != address(0), "FIRE::_transferTokens: cannot transfer to the zero address");
83 
84         balances[src] = sub256(balances[src], amount, "FIRE::_transferTokens: transfer amount exceeds balance");
85         balances[dst] = add256(balances[dst], amount, "FIRE::_transferTokens: transfer amount overflows");
86 
87         emit Transfer(src, dst, amount);
88         _moveDelegates(src, dst, amount);
89     }
90 
91     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
92         if (srcRep != dstRep && amount > 0) {
93             if (srcRep != address(0)) {
94                 uint32 srcRepNum = numCheckpoints[srcRep];
95                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].balance : 0;
96                 uint256 srcRepNew = sub256(srcRepOld, amount, "FIRE::_moveDelegates: amount underflows");
97                 _writeCheckpoint(srcRep, srcRepNum, srcRepNew);
98             }
99 
100             if (dstRep != address(0)) {
101                 uint32 dstRepNum = numCheckpoints[dstRep];
102                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].balance : 0;
103                 uint256 dstRepNew = add256(dstRepOld, amount, "FIRE::_moveDelegates: amount overflows");
104                 _writeCheckpoint(dstRep, dstRepNum, dstRepNew);
105             }
106         }
107     }
108 
109     function _writeCheckpoint(address account, uint32 nCheckpoints, uint256 newBalance) internal {
110       uint32 blockNumber = safe32(block.number, "FIRE::_writeCheckpoint: block number exceeds 32 bits");
111 
112       if (nCheckpoints > 0 && checkpoints[account][nCheckpoints - 1].fromBlock == blockNumber) {
113           checkpoints[account][nCheckpoints - 1].balance = newBalance;
114       } else {
115           checkpoints[account][nCheckpoints] = Checkpoint(blockNumber, newBalance);
116           numCheckpoints[account] = nCheckpoints + 1;
117       }
118     }
119 
120     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
121         require(n < 2**32, errorMessage);
122         return uint32(n);
123     }
124 
125     function safe256(uint256 n, string memory errorMessage) internal pure returns (uint256) {
126         require(n <= uint(2**256-1), errorMessage);
127         return uint256(n);
128     }
129 
130     function add256(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, errorMessage);
133         return c;
134     }
135 
136     function sub256(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         return a - b;
139     }
140 }