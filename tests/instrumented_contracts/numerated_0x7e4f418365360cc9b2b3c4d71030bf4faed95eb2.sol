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
14 contract BCT {//is inherently ERC20
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
27     string constant public name = "BlockChain Community Token";
28 
29     string constant public symbol = "BCT";
30 
31     uint8 constant public decimals = 8;
32 
33     uint256 constant public totalSupply = 100000000e8;
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
47     function BCT() public {balanceOf[msg.sender] = totalSupply;}
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
59 
60         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
61         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
62         balanceOf[_to] = balanceOf[_to].add(_value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     /**
68     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
69     *
70     * @param _from The address of the sender
71     * @param _to The address of the recipient
72     * @param _value The amount of token to be transferred
73     * @return Whether the transfer was successful or not
74     */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         /* Ensures that tokens are not sent to address "0x0" */
77         require(_to != address(0));
78         
79         uint256 allowance = allowed[_from][msg.sender];
80         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
81         require(_value <= allowance || _from == msg.sender);
82 
83         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
84         balanceOf[_to] = balanceOf[_to].add(_value);
85         balanceOf[_from] = balanceOf[_from].sub(_value);
86 
87         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
88         /* Balance holder does not need allowance to send from self. */
89         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
90             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         }
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Transfer the specified amounts of tokens to the specified addresses.
98     * @dev Be aware that there is no check for duplicate recipients.
99     *
100     * @param _toAddresses Receiver addresses.
101     * @param _amounts Amounts of tokens that will be transferred.
102     */
103     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
104         /* Ensures _toAddresses array is less than or equal to 255 */
105         require(_toAddresses.length <= 255);
106         /* Ensures _toAddress and _amounts have the same number of entries. */
107         require(_toAddresses.length == _amounts.length);
108 
109         for (uint8 i = 0; i < _toAddresses.length; i++) {
110             transfer(_toAddresses[i], _amounts[i]);
111         }
112     }
113 
114     /**
115     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
116     * @dev Be aware that there is no check for duplicate recipients.
117     *
118     * @param _from The address of the sender
119     * @param _toAddresses The addresses of the recipients (MAX 255)
120     * @param _amounts The amounts of tokens to be transferred
121     */
122     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
123         /* Ensures _toAddresses array is less than or equal to 255 */
124         require(_toAddresses.length <= 255);
125         /* Ensures _toAddress and _amounts have the same number of entries. */
126         require(_toAddresses.length == _amounts.length);
127 
128         for (uint8 i = 0; i < _toAddresses.length; i++) {
129             transferFrom(_from, _toAddresses[i], _amounts[i]);
130         }
131     }
132 
133     /**
134     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
135     *
136     * @param _spender The address of the account able to transfer the tokens
137     * @param _value The amount of tokens to be approved for transfer
138     * @return Whether the approval was successful or not
139     */
140     function approve(address _spender, uint256 _value) public returns (bool success) {
141         /* Ensures address "0x0" is not assigned allowance. */
142         require(_spender != address(0));
143 
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     /**
150     * @param _owner The address of the account owning tokens
151     * @param _spender The address of the account able to transfer the tokens
152     * @return Amount of remaining tokens allowed to spent
153     */
154     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
155         remaining = allowed[_owner][_spender];
156     }
157 
158     function isNotContract(address _addr) private view returns (bool) {
159         uint length;
160         assembly {
161         /* retrieve the size of the code on target address, this needs assembly */
162         length := extcodesize(_addr)
163         }
164         return (length == 0);
165     }
166 
167     // revert on eth transfers to this contract
168     function() public payable {revert();}
169 }