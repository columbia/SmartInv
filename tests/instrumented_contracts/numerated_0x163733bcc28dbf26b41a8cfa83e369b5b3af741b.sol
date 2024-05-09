1 pragma solidity ^0.4.13;
2 
3 interface TokenERC20 {
4 
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 
8     function transfer(address _to, uint256 _value) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12     function balanceOf(address _owner) constant returns (uint256 balance);
13 }
14 
15 
16 interface TokenNotifier {
17 
18     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
19 }
20 
21 /**
22  * @title SafeMath (from https://github.com/OpenZeppelin/zeppelin-solidity/blob/4d91118dd964618863395dcca25a50ff137bf5b6/contracts/math/SafeMath.sol)
23  * @dev Math operations with safety checks that throw on error
24  */
25 contract SafeMath {
26     
27     function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a * b;
29         assert(a == 0 || c / a == b);
30         return c;
31     }
32 
33     function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 
46 contract Owned {
47 
48     address owner;
49     
50     function Owned() { owner = msg.sender; }
51 
52     modifier onlyOwner { require(msg.sender == owner); _; }
53 }
54 
55 
56 contract PersianToken is TokenERC20, Owned, SafeMath {
57 
58     // The actual total supply is not constant and it will be updated with the real redeemed tokens once the ICO is over
59     uint256 public totalSupply = 0;
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62 
63     uint8 public constant decimals = 18;
64     string public constant name = 'Persian';
65     string public constant symbol = 'PRS';
66     string public constant version = '1.0.0';
67 
68     function transfer(address _to, uint256 _value) returns (bool success) {
69         if (balances[msg.sender] < _value) return false;
70         balances[msg.sender] = safeSub(balances[msg.sender], _value);
71         balances[_to] = safeAdd(balances[_to], _value);
72         Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if(balances[msg.sender] < _value || allowed[_from][msg.sender] < _value) return false;
78         balances[_to] = safeAdd(balances[_to], _value);
79         balances[_from] = safeSub(balances[_from], _value);
80         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
92         if(!approve(_spender, _value)) return false;
93         TokenNotifier(_spender).receiveApproval(msg.sender, _value, this, _extraData);
94         return true;
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 }
105 
106 
107 contract TokenICO is PersianToken {
108 
109     uint256 public icoStartBlock;
110     uint256 public icoEndBlock;
111     uint256 public totalContributions;
112     mapping (address => uint256) public contributions;
113 
114     // At max 300.000 Persian (with 18 decimals) will be ever generated from this ICO
115     uint256 public constant maxTotalSupply = 300000 * 10**18;
116 
117     event Contributed(address indexed _contributor, uint256 _value, uint256 _estimatedTotalTokenBalance);
118     event Claimed(address indexed _contributor, uint256 _value);
119 
120     function contribute() onlyDuringICO payable external returns (bool success) {
121         totalContributions = safeAdd(totalContributions, msg.value);
122         contributions[msg.sender] = safeAdd(contributions[msg.sender], msg.value);
123         Contributed(msg.sender, msg.value, estimateBalanceOf(msg.sender));
124         return true;
125     }
126 
127     function claimToken() onlyAfterICO external returns (bool success) {
128         uint256 balance = estimateBalanceOf(msg.sender);
129         contributions[msg.sender] = 0;
130         balances[msg.sender] = safeAdd(balances[msg.sender], balance);
131         totalSupply = safeAdd(totalSupply, balance);
132         require(totalSupply <= maxTotalSupply);
133         Claimed(msg.sender, balance);
134         return true;
135     }
136 
137     function redeemEther() onlyAfterICO onlyOwner external  {
138         owner.transfer(this.balance);
139     }
140 
141     function estimateBalanceOf(address _owner) constant returns (uint256 estimatedTokens) {
142         return contributions[_owner] > 0 ? safeMul( maxTotalSupply / totalContributions, contributions[_owner]) : 0;
143     }
144 
145     // This check is an helper function for ÐApp to check the effect of the NEXT tx, NOT simply the current state of the contract
146     function isICOOpen() constant returns (bool _open) {
147         return block.number >= (icoStartBlock - 1) && !isICOEnded();
148     }
149 
150     // This check is an helper function for ÐApp to check the effect of the NEXT tx, NOT simply the current state of the contract
151     function isICOEnded() constant returns (bool _ended) {
152         return block.number >= icoEndBlock;
153     }
154 
155     modifier onlyDuringICO {
156         require(block.number >= icoStartBlock && block.number <= icoEndBlock); _;
157     }
158 
159     modifier onlyAfterICO {
160         require(block.number > icoEndBlock); _;
161     }
162 }
163 
164 
165 contract PersianTokenICO is TokenICO {
166 
167     function PersianTokenICO(uint256 _icoStartBlock, uint256 _icoEndBlock) {
168         icoStartBlock = _icoStartBlock;
169         icoEndBlock = _icoEndBlock;
170     }
171   
172     function () onlyDuringICO payable {
173         totalContributions = safeAdd(totalContributions, msg.value);
174         contributions[msg.sender] = safeAdd(contributions[msg.sender], msg.value);
175         Contributed(msg.sender, msg.value, estimateBalanceOf(msg.sender));
176     }
177 
178 }