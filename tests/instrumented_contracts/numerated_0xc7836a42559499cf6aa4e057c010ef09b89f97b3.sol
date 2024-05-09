1 pragma solidity ^0.4.17;
2 
3 library SafeMathMod {// Partial SafeMath Library
4 
5     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         require((c = a - b) < a);
7     }
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require((c = a + b) > a);
11     }
12 }
13 
14 contract InvestmentToken {//is inherently ERC20
15     using SafeMathMod for uint256;
16 
17     /**
18     * @constant name The name of the token
19     * @constant symbol  The symbol used to display the currency
20     * @constant decimals  The number of decimals used to dispay a balance
21     * @constant totalSupply The total number of tokens times 10^ of the number of decimals
22     * @constant MAX_UINT256 Magic number for unlimited allowance
23     * @storage balanceOf Holds the balances of all token holders
24     * @storage allowed Holds the allowable balance to be transferable by another address.
25     */
26 
27     string constant public name = "Investment Token";
28 
29     string constant public symbol = "INVEST";
30 
31     uint8 constant public decimals = 8;
32 
33     uint256 constant public totalSupply = 150000000e8;
34 
35     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
36 
37     mapping (address => uint256) public balanceOf;
38 
39     mapping (address => mapping (address => uint256)) public allowed;
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42 
43     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
44 
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     function InvestmentToken() public {balanceOf[msg.sender] = totalSupply;}
48 
49     /**
50     * @notice send `_value` token to `_to` from `msg.sender`
51     *
52     * @param _to The address of the recipient
53     * @param _value The amount of token to be transferred
54     * @return Whether the transfer was successful or not
55     */
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         /* Ensures that tokens are not sent to address "0x0" */
58         require(_to != address(0));
59         /* Prevents sending tokens directly to contracts. */
60         require(isNotContract(_to));
61 
62         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
63         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
64         balanceOf[_to] = balanceOf[_to].add(_value);
65         Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     /**
70     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
71     *
72     * @param _from The address of the sender
73     * @param _to The address of the recipient
74     * @param _value The amount of token to be transferred
75     * @return Whether the transfer was successful or not
76     */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         /* Ensures that tokens are not sent to address "0x0" */
79         require(_to != address(0));
80         /* Ensures tokens are not sent to this contract */
81         require(_to != address(this));
82         
83         uint256 allowance = allowed[_from][msg.sender];
84         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
85         require(_value <= allowance || _from == msg.sender);
86 
87         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
88         balanceOf[_to] = balanceOf[_to].add(_value);
89         balanceOf[_from] = balanceOf[_from].sub(_value);
90 
91         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
92         /* Balance holder does not need allowance to send from self. */
93         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
94             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95         }
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101     * @dev Transfer the specified amounts of tokens to the specified addresses.
102     * @dev Be aware that there is no check for duplicate recipients.
103     *
104     * @param _toAddresses Receiver addresses.
105     * @param _amounts Amounts of tokens that will be transferred.
106     */
107     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
108         /* Ensures _toAddresses array is less than or equal to 255 */
109         require(_toAddresses.length <= 255);
110         /* Ensures _toAddress and _amounts have the same number of entries. */
111         require(_toAddresses.length == _amounts.length);
112 
113         for (uint8 i = 0; i < _toAddresses.length; i++) {
114             transfer(_toAddresses[i], _amounts[i]);
115         }
116     }
117 
118     /**
119     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
120     * @dev Be aware that there is no check for duplicate recipients.
121     *
122     * @param _from The address of the sender
123     * @param _toAddresses The addresses of the recipients (MAX 255)
124     * @param _amounts The amounts of tokens to be transferred
125     */
126     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
127         /* Ensures _toAddresses array is less than or equal to 255 */
128         require(_toAddresses.length <= 255);
129         /* Ensures _toAddress and _amounts have the same number of entries. */
130         require(_toAddresses.length == _amounts.length);
131 
132         for (uint8 i = 0; i < _toAddresses.length; i++) {
133             transferFrom(_from, _toAddresses[i], _amounts[i]);
134         }
135     }
136 
137     /**
138     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
139     *
140     * @param _spender The address of the account able to transfer the tokens
141     * @param _value The amount of tokens to be approved for transfer
142     * @return Whether the approval was successful or not
143     */
144     function approve(address _spender, uint256 _value) public returns (bool success) {
145         /* Ensures address "0x0" is not assigned allowance. */
146         require(_spender != address(0));
147 
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154     * @param _owner The address of the account owning tokens
155     * @param _spender The address of the account able to transfer the tokens
156     * @return Amount of remaining tokens allowed to spent
157     */
158     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
159         remaining = allowed[_owner][_spender];
160     }
161 
162     function isNotContract(address _addr) private view returns (bool) {
163         uint length;
164         assembly {
165         /* retrieve the size of the code on target address, this needs assembly */
166         length := extcodesize(_addr)
167         }
168         return (length == 0);
169     }
170 
171     // revert on eth transfers to this contract
172     function() public payable {revert();}
173 }