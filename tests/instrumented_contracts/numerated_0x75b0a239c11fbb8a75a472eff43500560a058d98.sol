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
14 contract IOTAETOKEN {//is inherently ERC20
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
27     string constant public name = "IOTA ETH";
28     string constant public symbol = "IOTAE";
29     uint8 constant public decimals = 8;
30     uint256 constant public totalSupply = 10000000e8;
31     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowed;
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38     function IOTAETOKEN() public {balanceOf[msg.sender] = totalSupply;}
39 
40     /**
41     * @notice send `_value` token to `_to` from `msg.sender`
42     *
43     * @param _to The address of the recipient
44     * @param _value The amount of token to be transferred
45     * @return Whether the transfer was successful or not
46     */
47     function transfer(address _to, uint256 _value) public returns (bool success) {
48         /* Ensures that tokens are not sent to address "0x0" */
49         require(_to != address(0));
50         /* Prevents sending tokens directly to contracts. */
51         require(isNotContract(_to));
52 
53         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
54         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
55         balanceOf[_to] = balanceOf[_to].add(_value);
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     /**
61     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     *
63     * @param _from The address of the sender
64     * @param _to The address of the recipient
65     * @param _value The amount of token to be transferred
66     * @return Whether the transfer was successful or not
67     */
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         /* Ensures that tokens are not sent to address "0x0" */
70         require(_to != address(0));
71         /* Ensures tokens are not sent to this contract */
72         require(_to != address(this));
73         
74         uint256 allowance = allowed[_from][msg.sender];
75         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
76         require(_value <= allowance || _from == msg.sender);
77 
78         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
79         balanceOf[_to] = balanceOf[_to].add(_value);
80         balanceOf[_from] = balanceOf[_from].sub(_value);
81 
82         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
83         /* Balance holder does not need allowance to send from self. */
84         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
85             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86         }
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /**
92     * @dev Transfer the specified amounts of tokens to the specified addresses.
93     * @dev Be aware that there is no check for duplicate recipients.
94     *
95     * @param _toAddresses Receiver addresses.
96     * @param _amounts Amounts of tokens that will be transferred.
97     */
98     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
99         /* Ensures _toAddresses array is less than or equal to 255 */
100         require(_toAddresses.length <= 255);
101         /* Ensures _toAddress and _amounts have the same number of entries. */
102         require(_toAddresses.length == _amounts.length);
103 
104         for (uint8 i = 0; i < _toAddresses.length; i++) {
105             transfer(_toAddresses[i], _amounts[i]);
106         }
107     }
108 
109     /**
110     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
111     * @dev Be aware that there is no check for duplicate recipients.
112     *
113     * @param _from The address of the sender
114     * @param _toAddresses The addresses of the recipients (MAX 255)
115     * @param _amounts The amounts of tokens to be transferred
116     */
117     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
118         /* Ensures _toAddresses array is less than or equal to 255 */
119         require(_toAddresses.length <= 255);
120         /* Ensures _toAddress and _amounts have the same number of entries. */
121         require(_toAddresses.length == _amounts.length);
122 
123         for (uint8 i = 0; i < _toAddresses.length; i++) {
124             transferFrom(_from, _toAddresses[i], _amounts[i]);
125         }
126     }
127 
128     /**
129     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
130     *
131     * @param _spender The address of the account able to transfer the tokens
132     * @param _value The amount of tokens to be approved for transfer
133     * @return Whether the approval was successful or not
134     */
135     function approve(address _spender, uint256 _value) public returns (bool success) {
136         /* Ensures address "0x0" is not assigned allowance. */
137         require(_spender != address(0));
138 
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145     * @param _owner The address of the account owning tokens
146     * @param _spender The address of the account able to transfer the tokens
147     * @return Amount of remaining tokens allowed to spent
148     */
149     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
150         remaining = allowed[_owner][_spender];
151     }
152 
153     function isNotContract(address _addr) private view returns (bool) {
154         uint length;
155         assembly {
156         /* retrieve the size of the code on target address, this needs assembly */
157         length := extcodesize(_addr)
158         }
159         return (length == 0);
160     }
161 
162     // revert on eth transfers to this contract
163     function() public payable {revert();}
164 }