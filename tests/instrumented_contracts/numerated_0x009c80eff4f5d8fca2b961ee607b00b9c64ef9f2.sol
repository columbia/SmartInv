1 pragma solidity ^ 0.5 .1;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns(uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function safeSub(uint a, uint b) public pure returns(uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function safeMul(uint a, uint b) public pure returns(uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function safeDiv(uint a, uint b) public pure returns(uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC223ReceivingContract {
26     /**
27      * @dev Standard ERC223 function that will handle incoming token transfers.
28      *
29      * @param _from  Token sender address.
30      * @param _value Amount of tokens.
31      * @param _data  Transaction metadata.
32      */
33     function tokenFallback(address _from, uint _value, bytes memory _data) public returns(bool);
34 }
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39 
40     event OwnershipTransferred(address indexed _from, address indexed _to);
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function transferOwnership(address _newOwner) public onlyOwner {
52         newOwner = _newOwner;
53     }
54 
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 contract STORH is SafeMath, Owned {
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
66     event MultiERC20Transfer(
67         address indexed _from,
68         address _to,
69         uint _amount
70     );
71 
72     mapping(address => uint) balances;
73     mapping(address => bool) public verified;
74 
75     string public name = "Storh";
76     string public symbol = "STORH";
77     uint8 public decimals = 4;
78     uint public totalSupply;
79     uint public startTime;
80 
81     modifier isVerified(address reciever) {
82         require(verified[msg.sender]);
83         require(verified[reciever]);
84         _;
85     }
86 
87     modifier hasMinBalance(uint value) {
88         if (now < (startTime + 365 days) && msg.sender == owner) {
89             require(balances[owner] >= ((totalSupply * 5) / 100) + value);
90         }
91         _;
92     }
93 
94     constructor() public {
95         balances[msg.sender] = 1200000000000;
96         totalSupply = balances[msg.sender];
97         verified[msg.sender] = true;
98         startTime = now;
99     }
100 
101     function verifyAccount(address account) public onlyOwner {
102         verified[account] = true;
103     }
104 
105     function setStartTime(uint _startTime) public {
106         startTime = _startTime;
107     }
108 
109     function multiERC20Transfer(
110         address[] memory _addresses,
111         uint[] memory _amounts
112     ) public {
113         for (uint i = 0; i < _addresses.length; i++) {
114             transfer(_addresses[i], _amounts[i]);
115             emit MultiERC20Transfer(
116                 msg.sender,
117                 _addresses[i],
118                 _amounts[i]
119             );
120         }
121     }
122 
123     function transfer(address _to, uint _value, bytes memory _data) public isVerified(_to) hasMinBalance(_value) {
124         // backwards compatibility
125         uint codeLength;
126 
127         assembly {
128             codeLength: = extcodesize(_to)
129         }
130 
131         balances[msg.sender] = safeSub(balances[msg.sender], _value);
132         balances[_to] = safeAdd(balances[_to], _value);
133         if (codeLength > 0) {
134             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
135             if (!receiver.tokenFallback(msg.sender, _value, _data)) revert();
136         }
137         emit Transfer(msg.sender, _to, _value, _data);
138     }
139 
140     function transfer(address _to, uint _value) public isVerified(_to) hasMinBalance(_value) {
141         uint codeLength;
142         bytes memory empty;
143 
144         assembly {
145             codeLength: = extcodesize(_to)
146         }
147 
148         balances[msg.sender] = safeSub(balances[msg.sender], _value);
149         balances[_to] = safeAdd(balances[_to], _value);
150         if (codeLength > 0) {
151             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
152             if (!receiver.tokenFallback(msg.sender, _value, empty)) revert();
153         }
154         emit Transfer(msg.sender, _to, _value, empty);
155     }
156 
157 
158     function balanceOf(address _owner) view public returns(uint balance) {
159         return balances[_owner];
160     }
161 
162     function close() public onlyOwner {
163         selfdestruct(address(uint160(owner)));
164     }
165 }