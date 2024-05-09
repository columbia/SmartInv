1 pragma solidity ^0.4.23;
2 
3 contract IERC223Token {
4     function name() public view returns (string);
5     function symbol() public view returns (string);
6     function decimals() public view returns (uint8);
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address _holder) public view returns (uint256);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
12     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
13     
14     event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
15 }
16 contract IERC223Receiver {
17   
18    /**
19  * @dev Standard ERC223 function that will handle incoming token transfers.
20  *
21  * @param _from  Token sender address.
22  * @param _value Amount of tokens.
23  * @param _data  Transaction metadata.
24  */
25     function tokenFallback(address _from, uint _value, bytes _data) public returns(bool);
26 }
27 contract IOwned {
28     // this function isn't abstract since the compiler emits automatically generated getter functions as external
29     function owner() public pure returns (address) {}
30 
31     event OwnerUpdate(address _prevOwner, address _newOwner);
32 
33     function transferOwnership(address _newOwner) public;
34     function acceptOwnership() public;
35 }
36 
37 contract ICalled is IOwned {
38     // this function isn't abstract since the compiler emits automatically generated getter functions as external
39     function callers(address) public pure returns (bool) { }
40 
41     function appendCaller(address _caller) public;  // ownerOnly
42     function removeCaller(address _caller) public;  // ownerOnly
43     
44     event AppendCaller(ICaller _caller);
45     event RemoveCaller(ICaller _caller);
46 }
47 
48 contract ICaller{
49 	function calledUpdate(address _oldCalled, address _newCalled) public;  // ownerOnly
50 	
51 	event CalledUpdate(address _oldCalled, address _newCalled);
52 }
53 contract IERC20Token {
54     function name() public view returns (string);
55     function symbol() public view returns (string);
56     function decimals() public view returns (uint8);
57     function totalSupply() public view returns (uint256);
58     function balanceOf(address _holder) public view returns (uint256);
59     function allowance(address _from, address _spender) public view returns (uint256);
60 
61     function transfer(address _to, uint256 _value) public returns (bool success);
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
63     function approve(address _spender, uint256 _value) public returns (bool success);
64     
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _holder, address indexed _spender, uint256 _value);
67 }
68 contract IDummyToken is IERC20Token, IERC223Token, IERC223Receiver, ICaller, IOwned{
69     // these function isn't abstract since the compiler emits automatically generated getter functions as external
70     function operator() public pure returns(ITokenOperator) {}
71     //ITokenOperator public operator;
72 }
73 contract ISmartToken{
74     function disableTransfers(bool _disable) public;
75     function issue(address _to, uint256 _amount) public;
76     function destroy(address _from, uint256 _amount) public;
77 	//function() public payable;
78 }
79 contract ITokenOperator is ISmartToken, ICalled, ICaller {
80     // this function isn't abstract since the compiler emits automatically generated getter functions as external
81     function dummy() public pure returns (IDummyToken) {}
82     
83 	function emitEventTransfer(address _from, address _to, uint256 _amount) public;
84 
85     function updateChanges(address) public;
86     function updateChangesByBrother(address, uint256, uint256) public;
87     
88     function token_name() public view returns (string);
89     function token_symbol() public view returns (string);
90     function token_decimals() public view returns (uint8);
91     
92     function token_totalSupply() public view returns (uint256);
93     function token_balanceOf(address _owner) public view returns (uint256);
94     function token_allowance(address _from, address _spender) public view returns (uint256);
95 
96     function token_transfer(address _from, address _to, uint256 _value) public returns (bool success);
97     function token_transfer(address _from, address _to, uint _value, bytes _data) public returns (bool success);
98     function token_transfer(address _from, address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
99     function token_transferFrom(address _spender, address _from, address _to, uint256 _value) public returns (bool success);
100     function token_approve(address _from, address _spender, uint256 _value) public returns (bool success);
101     
102     function fallback(address _from, bytes _data) public payable;                      		// eth input
103     function token_fallback(address _token, address _from, uint _value, bytes _data) public returns(bool);    // token input from IERC233
104 }
105 
106 contract IsContract {
107 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
108     function isContract(address _addr) internal view returns (bool is_contract) {
109         uint length;
110         assembly {
111               //retrieve the size of the code on target address, this needs assembly
112               length := extcodesize(_addr)
113         }
114         return (length>0);
115     }
116 }
117    contract Owned is IOwned {
118     address public owner;
119     address public newOwner;
120 
121     /**
122         @dev constructor
123     */
124     constructor() public {
125         owner = msg.sender;
126     }
127 
128     // allows execution by the owner only
129     modifier ownerOnly {
130         assert(msg.sender == owner);
131         _;
132     }
133 
134     /**
135         @dev allows transferring the contract ownership
136         the new owner still needs to accept the transfer
137         can only be called by the contract owner
138 
139         @param _newOwner    new contract owner
140     */
141     function transferOwnership(address _newOwner) public ownerOnly {
142         require(_newOwner != owner);
143         newOwner = _newOwner;
144     }
145 
146     /**
147         @dev used by a new owner to accept an ownership transfer
148     */
149     function acceptOwnership() public {
150         require(msg.sender == newOwner);
151         emit OwnerUpdate(owner, newOwner);
152         owner = newOwner;
153         newOwner = address(0x0);
154     }
155 }
156 contract DummyToken is IDummyToken, Owned, IsContract {
157     ITokenOperator public operator = ITokenOperator(msg.sender);
158     
159     function calledUpdate(address _oldCalled, address _newCalled) public ownerOnly {
160         if(operator == _oldCalled) {
161             operator = ITokenOperator(_newCalled);
162         	emit CalledUpdate(_oldCalled, _newCalled);
163 		}
164     }
165     
166     function name() public view returns (string){
167         return operator.token_name();
168     }
169     function symbol() public view returns (string){
170         return operator.token_symbol();
171     }
172     function decimals() public view returns (uint8){
173         return operator.token_decimals();
174     }
175     
176     function totalSupply() public view returns (uint256){
177         return operator.token_totalSupply();
178     }
179     function balanceOf(address addr)public view returns(uint256){
180         return operator.token_balanceOf(addr);
181     }
182     function allowance(address _from, address _spender) public view returns (uint256){
183         return operator.token_allowance(_from, _spender);
184     }
185     
186     function transfer(address _to, uint256 _value) public returns (bool success){
187         success = operator.token_transfer(msg.sender, _to, _value);
188         bytes memory emptyBytes;
189         internalTokenFallback(msg.sender, _to, _value, emptyBytes);
190         emit Transfer(msg.sender, _to, _value);
191     }
192     function transfer(address _to, uint _value, bytes _data) public returns (bool success){
193         success = operator.token_transfer(msg.sender, _to, _value, _data);
194         internalTokenFallback(msg.sender, _to, _value, _data);
195         emit Transfer(msg.sender, _to, _value);
196     }
197     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success){
198         success = operator.token_transfer(msg.sender, _to, _value, _data, _custom_fallback);
199         internalTokenFallback(msg.sender, _to, _value, _data);
200         emit Transfer(msg.sender, _to, _value);
201     }
202 
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
204         success = operator.token_transferFrom(msg.sender, _from, _to, _value);
205         emit Transfer(_from, _to, _value);
206         
207         bytes memory emptyBytes;
208 		if(msg.sender == address(operator) && _from == address(this))				// for issue
209 			internalTokenFallback(_from, _to, _value, emptyBytes);
210     }
211     function approve(address _spender, uint256 _value) public returns (bool success){
212         success = operator.token_approve(msg.sender, _spender, _value);
213         emit Approval(msg.sender, _spender, _value);
214     }
215     
216     function() public payable {
217         operator.fallback.value(msg.value)(msg.sender, msg.data);
218 	}
219 	
220     function tokenFallback(address _from, uint _value, bytes _data) public returns(bool){
221         return operator.token_fallback(msg.sender, _from, _value, _data);
222     }
223 
224     function internalTokenFallback(address _from, address _to, uint256 _value, bytes _data)internal{
225         if(isContract(_to)){
226            require(IERC223Receiver(_to).tokenFallback(_from, _value, _data));
227         }
228     }
229 }