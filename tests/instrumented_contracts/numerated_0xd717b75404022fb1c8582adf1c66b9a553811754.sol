1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Safe Math contract
5  * 
6  * @dev prevents overflow when working with uint256 addition ans substraction
7  */
8 contract SafeMath {
9     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a);
12     }
13 
14     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
15         require(b <= a);
16         c = a - b;
17     }
18 }
19 
20 /**
21  * @title ERC Token Standard #20 Interface 
22  *
23  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
24  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
25  */
26 contract ERC20Interface {
27 
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function allowance(address owner, address spender) public view returns (uint256);
31 
32     function transfer(address to, uint256 value) public returns (bool);
33     function approve(address spender, uint256 value) public returns (bool);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 /**
41  * @title Owned contract
42  *
43  * @dev Implements ownership 
44  */
45 contract Ownable {
46     address public owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     function transferOwnership(address newOwner) public {
55         require(msg.sender == owner);
56         require(newOwner != address(0));
57 
58         OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60     }
61 }
62 
63 /**
64  * @title The MILC Token Contract
65  *
66  * @dev The MILC Token is an ERC20 Token
67  * @dev https://github.com/ethereum/EIPs/issues/20
68  */
69 contract MilcToken is ERC20Interface, Ownable, SafeMath {
70 
71     /**
72     * Max Tokens: 40 Millions MILC with 18 Decimals.
73     * The smallest unit is called "Hey". 1'000'000'000'000'000'000 Hey = 1 MILC
74     */
75     uint256 constant public MAX_TOKENS = 40 * 1000 * 1000 * 10 ** uint256(18);
76 
77     string public symbol = "MILC";
78     string public name = "Micro Licensing Coin";
79     uint8 public decimals = 18;
80     uint256 public totalSupply = 0;
81 
82     mapping(address => uint256) balances;
83     mapping(address => mapping(address => uint256)) allowed;
84 
85     event Mint(address indexed to, uint256 amount);
86     
87     function MilcToken() public {
88     }
89 
90     /**
91      * @dev This contract does not accept ETH
92      */
93     function() public payable {
94         revert();
95     }
96 
97     // ---- ERC20 START ----
98     function totalSupply() public view returns (uint256) {
99         return totalSupply;
100     }
101 
102     function balanceOf(address who) public view returns (uint256) {
103         return balances[who];
104     }
105 
106     function transfer(address to, uint256 value) public returns (bool) {
107         balances[msg.sender] = safeSub(balances[msg.sender], value);
108         balances[to] = safeAdd(balances[to], value);
109         Transfer(msg.sender, to, value);
110         return true;
111     }
112 
113     /**
114     * Beware that changing an allowance with this method brings the risk that someone may use both the old
115     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     */
119     function approve(address spender, uint256 value) public returns (bool) {
120         allowed[msg.sender][spender] = value;
121         Approval(msg.sender, spender, value);
122         return true;
123     }
124 
125     function transferFrom(address from, address to, uint256 value) public returns (bool) {
126         balances[from] = safeSub(balances[from], value);
127         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
128         balances[to] = safeAdd(balances[to], value);
129         Transfer(from, to, value);
130         return true;
131     }
132 
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return allowed[owner][spender];
135     }
136     // ---- ERC20 END ----
137 
138     // ---- EXTENDED FUNCTIONALITY START ----
139     /**
140      * @dev Increase the amount of tokens that an owner allowed to a spender.
141      */
142     function increaseApproval(address spender, uint256 addedValue) public returns (bool success) {
143         allowed[msg.sender][spender] = safeAdd(allowed[msg.sender][spender], addedValue);
144         Approval(msg.sender, spender, allowed[msg.sender][spender]);
145         return true;
146     }
147 
148     /**
149      * @dev Decrease the amount of tokens that an owner allowed to a spender.
150      */
151     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool success) {
152         uint256 oldValue = allowed[msg.sender][spender];
153         if (subtractedValue > oldValue) {
154             allowed[msg.sender][spender] = 0;
155         } else {
156             allowed[msg.sender][spender] = safeSub(oldValue, subtractedValue);
157         }
158 
159         Approval(msg.sender, spender, allowed[msg.sender][spender]);
160         return true;
161     }
162     
163     /**
164      * @dev Same functionality as transfer. Accepts an array of recipients and values. Can be used to save gas.
165      * @dev both arrays requires to have the same length
166      */
167     function transferArray(address[] tos, uint256[] values) public returns (bool) {
168         for (uint8 i = 0; i < tos.length; i++) {
169             require(transfer(tos[i], values[i]));
170         }
171 
172         return true;
173     }
174     // ---- EXTENDED FUNCTIONALITY END ----
175 
176     // ---- MINT START ----
177     /**
178      * @dev Bulk mint function to save gas. 
179      * @dev both arrays requires to have the same length
180      */
181     function mint(address[] recipients, uint256[] tokens) public returns (bool) {
182         require(msg.sender == owner);
183 
184         for (uint8 i = 0; i < recipients.length; i++) {
185 
186             address recipient = recipients[i];
187             uint256 token = tokens[i];
188 
189             totalSupply = safeAdd(totalSupply, token);
190             require(totalSupply <= MAX_TOKENS);
191 
192             balances[recipient] = safeAdd(balances[recipient], token);
193 
194             Mint(recipient, token);
195             Transfer(address(0), recipient, token);
196         }
197 
198         return true;
199     }
200 
201     function isMintDone() public view returns (bool) {
202         return totalSupply == MAX_TOKENS;
203     }
204     // ---- MINT END ---- 
205 }