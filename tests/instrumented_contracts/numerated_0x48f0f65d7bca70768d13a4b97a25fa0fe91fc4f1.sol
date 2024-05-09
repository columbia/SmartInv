1 pragma solidity ^0.4.18;
2 
3 interface ERC223
4 {
5 	function transfer(address _to, uint _value, bytes _data) public returns(bool);
6     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed data);
7 }
8 
9 interface ERC20
10 {
11 	function transferFrom(address _from, address _to, uint _value) public returns(bool);
12 	function approve(address _spender, uint _value) public returns (bool);
13 	function allowance(address _owner, address _spender) public constant returns(uint);
14 	event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 contract ERC223ReceivingContract
17 {
18 	function tokenFallBack(address _from, uint _value, bytes _data)public;	 
19 }
20 
21 contract Token
22 {
23 	string internal _symbol;
24 	string internal _name;
25 	uint8 internal _decimals;	
26     uint internal _totalSupply;
27    	mapping(address =>uint) internal _balanceOf;
28 	mapping(address => mapping(address => uint)) internal _allowances;
29 
30     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public{
31 	    _symbol = symbol;
32 		_name = name;
33 		_decimals = decimals;
34 		_totalSupply = totalSupply;
35     }
36 
37 	function name() public constant returns (string){
38         	return _name;    
39 	}
40 
41 	function symbol() public constant returns (string){
42         	return _symbol;    
43 	}
44 
45 	function decimals() public constant returns (uint8){
46 		return _decimals;
47 	}
48 
49 	function totalSupply() public constant returns (uint){
50         	return _totalSupply;
51 	}
52             	
53 	event Transfer(address indexed _from, address indexed _to, uint _value);	
54 }
55 
56 
57 contract Multiownable {
58     uint256 public howManyOwnersDecide;
59     address[] public owners;
60     bytes32[] public allOperations;
61     address insideOnlyManyOwners;
62     
63     // Reverse lookup tables for owners and allOperations
64     mapping(address => uint) ownersIndices; // Starts from 1
65     mapping(bytes32 => uint) allOperationsIndicies;
66     
67     // Owners voting mask per operations
68     mapping(bytes32 => uint256) public votesMaskByOperation;
69     mapping(bytes32 => uint256) public votesCountByOperation;
70     event OwnershipTransferred(address[] previousOwners, address[] newOwners);
71     function isOwner(address wallet) public constant returns(bool) {
72         return ownersIndices[wallet] > 0;
73     }
74 
75     function ownersCount() public constant returns(uint) {
76         return owners.length;
77     }
78 
79     function allOperationsCount() public constant returns(uint) {
80         return allOperations.length;
81     }
82 
83     // MODIFIERS
84 
85     /**
86     * @dev Allows to perform method by any of the owners
87     */
88     modifier onlyAnyOwner {
89         require(isOwner(msg.sender));
90         _;
91     }
92 
93     /**
94     * @dev Allows to perform method only after all owners call it with the same arguments
95     */
96     modifier onlyManyOwners {
97         if (insideOnlyManyOwners == msg.sender) {
98             _;
99             return;
100         }
101         require(isOwner(msg.sender));
102 
103         uint ownerIndex = ownersIndices[msg.sender] - 1;
104         bytes32 operation = keccak256(msg.data);
105         
106         if (votesMaskByOperation[operation] == 0) {
107             allOperationsIndicies[operation] = allOperations.length;
108             allOperations.push(operation);
109         }
110         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0);
111         votesMaskByOperation[operation] |= (2 ** ownerIndex);
112         votesCountByOperation[operation] += 1;
113 
114         // If all owners confirm same operation
115         if (votesCountByOperation[operation] == howManyOwnersDecide) {
116             deleteOperation(operation);
117             insideOnlyManyOwners = msg.sender;
118             _;
119             insideOnlyManyOwners = address(0);
120         }
121     }
122 
123     // CONSTRUCTOR
124 
125     function Multiownable() public {
126         owners.push(msg.sender);
127         ownersIndices[msg.sender] = 1;
128         howManyOwnersDecide = 1;
129     }
130 
131     // INTERNAL METHODS
132 
133     /**
134     * @dev Used to delete cancelled or performed operation
135     * @param operation defines which operation to delete
136     */
137     function deleteOperation(bytes32 operation) internal {
138         uint index = allOperationsIndicies[operation];
139         if (allOperations.length > 1) {
140             allOperations[index] = allOperations[allOperations.length - 1];
141             allOperationsIndicies[allOperations[index]] = index;
142         }
143         allOperations.length--;
144         
145         delete votesMaskByOperation[operation];
146         delete votesCountByOperation[operation];
147         delete allOperationsIndicies[operation];
148     }
149 
150     // PUBLIC METHODS
151 
152     /**
153     * @dev Allows owners to change ownership
154     * @param newOwners defines array of addresses of new owners
155     */
156     function transferOwnership(address[] newOwners) public {
157         transferOwnershipWithHowMany(newOwners, newOwners.length);
158     }
159 
160     /**
161     * @dev Allows owners to change ownership
162     * @param newOwners defines array of addresses of new owners
163     * @param newHowManyOwnersDecide defines how many owners can decide
164     */
165     function transferOwnershipWithHowMany(address[] newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {
166         require(newOwners.length > 0);
167         require(newOwners.length <= 256);
168         require(newHowManyOwnersDecide > 0);
169         require(newHowManyOwnersDecide <= newOwners.length);
170         for (uint i = 0; i < newOwners.length; i++) {
171             require(newOwners[i] != address(0));
172         }
173 
174         OwnershipTransferred(owners, newOwners);
175 
176         // Reset owners array and index reverse lookup table
177         for (i = 0; i < owners.length; i++) {
178             delete ownersIndices[owners[i]];
179         }
180         for (i = 0; i < newOwners.length; i++) {
181             require(ownersIndices[newOwners[i]] == 0);
182             ownersIndices[newOwners[i]] = i + 1;
183         }
184         owners = newOwners;
185         howManyOwnersDecide = newHowManyOwnersDecide;
186 
187         // Discard all pendign operations
188         for (i = 0; i < allOperations.length; i++) {
189             delete votesMaskByOperation[allOperations[i]];
190             delete votesCountByOperation[allOperations[i]];
191             delete allOperationsIndicies[allOperations[i]];
192         }
193         allOperations.length = 0;
194     }
195 }
196 
197 contract MyToken is Token("TLT","Talent Coin",8,50000000),ERC20,ERC223,Multiownable
198 {    		
199 	uint256 internal sellPrice;
200 	uint256 internal buyPrice;
201     function MyToken() public payable
202     {
203     	_balanceOf[msg.sender]=_totalSupply;       		
204     }
205 
206     function totalSupply() public constant returns (uint){
207     	return _totalSupply;  
208 	}
209 	
210     function balanceOf(address _addr)public constant returns (uint){
211       	return _balanceOf[_addr];
212 	}
213 
214 	function transfer(address _to, uint _value)public onlyManyOwners returns (bool){
215     	require(_value>0 && _value <= balanceOf(msg.sender));
216     	if(!isContract(_to))
217     	{
218     		_balanceOf[msg.sender]-= _value;
219         	_balanceOf[_to]+=_value;
220 		    Transfer(msg.sender, _to, _value); 
221  			return true;
222 	    }
223     	return false;
224 	}
225 
226 	function transfer(address _to, uint _value, bytes _data)public returns(bool)
227 	{
228 	    require(_value>0 && _value <= balanceOf(msg.sender));
229 		if(isContract(_to))
230 		{
231 			_balanceOf[msg.sender]-= _value;
232 	       	_balanceOf[_to]+=_value;
233 			ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
234 			_contract.tokenFallBack(msg.sender,_value,_data);
235 			Transfer(msg.sender, _to, _value, _data); 
236     		return true;
237 		}
238 		return false;
239 	}
240 
241 	function isContract(address _addr) internal view returns(bool){
242 		uint codeLength;
243 		assembly
244 		{
245 		    codeLength := extcodesize(_addr)
246 	    }
247 		return codeLength > 0;
248 	}	
249     
250 	function transferFrom(address _from, address _to, uint _value)public onlyManyOwners returns(bool){
251     	require(_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value && _balanceOf[_from] >= _value);
252     	{
253 			_balanceOf[_from]-=_value;
254     		_balanceOf[_to]+=_value;
255 			_allowances[_from][msg.sender] -= _value;
256 			Transfer(_from, _to, _value);            
257 			return true;
258     	}
259     	return false;
260    }
261 
262 	function approve(address _spender, uint _value) public returns (bool)
263 	{
264     	_allowances[msg.sender][_spender] = _value;
265     	Approval(msg.sender, _spender, _value);	
266     	return true;
267     }
268     
269     function allowance(address _owner, address _spender) public constant returns(uint)
270     {
271     	return _allowances[_owner][_spender];
272     }
273     
274 }