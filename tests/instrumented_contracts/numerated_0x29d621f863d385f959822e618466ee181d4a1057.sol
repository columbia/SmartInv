1 pragma solidity ^0.4.11;
2 
3 /*
4   Copyright 2017, Anton Egorov (Mothership Foundation)
5   Copyright 2017, Klaus Hott (BlockchainLabs.nz)
6   Copyright 2017, Jordi Baylina (Giveth)
7 
8 
9   This program is free software: you can redistribute it and/or modify
10   it under the terms of the GNU General Public License as published by
11   the Free Software Foundation, either version 3 of the License, or
12   (at your option) any later version.
13 
14   This program is distributed in the hope that it will be useful,
15   but WITHOUT ANY WARRANTY; without even the implied warranty of
16   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17   GNU General Public License for more details.
18 
19   You should have received a copy of the GNU General Public License
20   along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22 */
23 
24 contract ERC20Token {
25   /* This is a slight change to the ERC20 base standard.
26      function totalSupply() constant returns (uint256 supply);
27      is replaced with:
28      uint256 public totalSupply;
29      This automatically creates a getter function for the totalSupply.
30      This is moved to the base contract since public getter functions are not
31      currently recognised as an implementation of the matching abstract
32      function by the compiler.
33   */
34   /// total amount of tokens
35   function totalSupply() constant returns (uint256 balance);
36 
37   /// @param _owner The address from which the balance will be retrieved
38   /// @return The balance
39   function balanceOf(address _owner) constant returns (uint256 balance);
40 
41   /// @notice send `_value` token to `_to` from `msg.sender`
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transfer(address _to, uint256 _value) returns (bool success);
46 
47   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48   /// @param _from The address of the sender
49   /// @param _to The address of the recipient
50   /// @param _value The amount of token to be transferred
51   /// @return Whether the transfer was successful or not
52   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
53 
54   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
55   /// @param _spender The address of the account able to transfer the tokens
56   /// @param _value The amount of tokens to be approved for transfer
57   /// @return Whether the approval was successful or not
58   function approve(address _spender, uint256 _value) returns (bool success);
59 
60   /// @param _owner The address of the account owning tokens
61   /// @param _spender The address of the account able to transfer the tokens
62   /// @return Amount of remaining tokens allowed to spent
63   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
64 
65   event Transfer(address indexed _from, address indexed _to, uint256 _value);
66   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 contract Controlled {
70   /// @notice The address of the controller is the only address that can call
71   ///  a function with this modifier
72   modifier onlyController { if (msg.sender != controller) throw; _; }
73 
74   address public controller;
75 
76   function Controlled() { controller = msg.sender;}
77 
78   /// @notice Changes the controller of the contract
79   /// @param _newController The new controller of the contract
80   function changeController(address _newController) onlyController {
81     controller = _newController;
82   }
83 }
84 
85 contract Burnable is Controlled {
86   /// @notice The address of the controller is the only address that can call
87   ///  a function with this modifier, also the burner can call but also the
88   /// target of the function must be the burner
89   modifier onlyControllerOrBurner(address target) {
90     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
91     _;
92   }
93 
94   modifier onlyBurner {
95     assert(msg.sender == burner);
96     _;
97   }
98   address public burner;
99 
100   function Burnable() { burner = msg.sender;}
101 
102   /// @notice Changes the burner of the contract
103   /// @param _newBurner The new burner of the contract
104   function changeBurner(address _newBurner) onlyBurner {
105     burner = _newBurner;
106   }
107 }
108 
109 contract MiniMeTokenI is ERC20Token, Burnable {
110 
111       string public name;                //The Token's name: e.g. DigixDAO Tokens
112       uint8 public decimals;             //Number of decimals of the smallest unit
113       string public symbol;              //An identifier: e.g. REP
114       string public version = 'MMT_0.1'; //An arbitrary versioning scheme
115 
116 ///////////////////
117 // ERC20 Methods
118 ///////////////////
119 
120 
121     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
122     ///  its behalf, and then a function is triggered in the contract that is
123     ///  being approved, `_spender`. This allows users to use their tokens to
124     ///  interact with contracts in one function call instead of two
125     /// @param _spender The address of the contract able to transfer the tokens
126     /// @param _amount The amount of tokens to be approved for transfer
127     /// @return True if the function call was successful
128     function approveAndCall(
129         address _spender,
130         uint256 _amount,
131         bytes _extraData
132     ) returns (bool success);
133 
134 ////////////////
135 // Query balance and totalSupply in History
136 ////////////////
137 
138     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
139     /// @param _owner The address from which the balance will be retrieved
140     /// @param _blockNumber The block number when the balance is queried
141     /// @return The balance at `_blockNumber`
142     function balanceOfAt(
143         address _owner,
144         uint _blockNumber
145     ) constant returns (uint);
146 
147     /// @notice Total amount of tokens at a specific `_blockNumber`.
148     /// @param _blockNumber The block number when the totalSupply is queried
149     /// @return The total amount of tokens at `_blockNumber`
150     function totalSupplyAt(uint _blockNumber) constant returns(uint);
151 
152 ////////////////
153 // Clone Token Method
154 ////////////////
155 
156     /// @notice Creates a new clone token with the initial distribution being
157     ///  this token at `_snapshotBlock`
158     /// @param _cloneTokenName Name of the clone token
159     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
160     /// @param _cloneTokenSymbol Symbol of the clone token
161     /// @param _snapshotBlock Block when the distribution of the parent token is
162     ///  copied to set the initial distribution of the new clone token;
163     ///  if the block is zero than the actual block, the current block is used
164     /// @param _transfersEnabled True if transfers are allowed in the clone
165     /// @return The address of the new MiniMeToken Contract
166     function createCloneToken(
167         string _cloneTokenName,
168         uint8 _cloneDecimalUnits,
169         string _cloneTokenSymbol,
170         uint _snapshotBlock,
171         bool _transfersEnabled
172     ) returns(address);
173 
174 ////////////////
175 // Generate and destroy tokens
176 ////////////////
177 
178     /// @notice Generates `_amount` tokens that are assigned to `_owner`
179     /// @param _owner The address that will be assigned the new tokens
180     /// @param _amount The quantity of tokens generated
181     /// @return True if the tokens are generated correctly
182     function generateTokens(address _owner, uint _amount) returns (bool);
183 
184 
185     /// @notice Burns `_amount` tokens from `_owner`
186     /// @param _owner The address that will lose the tokens
187     /// @param _amount The quantity of tokens to burn
188     /// @return True if the tokens are burned correctly
189     function destroyTokens(address _owner, uint _amount) returns (bool);
190 
191 ////////////////
192 // Enable tokens transfers
193 ////////////////
194 
195     /// @notice Enables token holders to transfer their tokens freely if true
196     /// @param _transfersEnabled True if transfers are allowed in the clone
197     function enableTransfers(bool _transfersEnabled);
198 
199 //////////
200 // Safety Methods
201 //////////
202 
203     /// @notice This method can be used by the controller to extract mistakenly
204     ///  sent tokens to this contract.
205     /// @param _token The address of the token contract that you want to recover
206     ///  set to 0 in case you want to extract ether.
207     function claimTokens(address _token);
208 
209 ////////////////
210 // Events
211 ////////////////
212 
213     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
214     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
215 }
216 
217 contract ReferalsTokenHolder is Controlled {
218   MiniMeTokenI public msp;
219   mapping (address => bool) been_spread;
220 
221   function ReferalsTokenHolder(address _msp) {
222     msp = MiniMeTokenI(_msp);
223   }
224 
225   function spread(address[] _addresses, uint256[] _amounts) public onlyController {
226     require(_addresses.length == _amounts.length);
227 
228     for (uint256 i = 0; i < _addresses.length; i++) {
229       address addr = _addresses[i];
230       if (!been_spread[addr]) {
231         uint256 amount = _amounts[i];
232         assert(msp.transfer(addr, amount));
233         been_spread[addr] = true;
234       }
235     }
236   }
237 
238 //////////
239 // Safety Methods
240 //////////
241 
242   /// @notice This method can be used by the controller to extract mistakenly
243   ///  sent tokens to this contract.
244   /// @param _token The address of the token contract that you want to recover
245   ///  set to 0 in case you want to extract ether.
246   function claimTokens(address _token) onlyController {
247     if (_token == 0x0) {
248       controller.transfer(this.balance);
249       return;
250     }
251 
252     ERC20Token token = ERC20Token(_token);
253     uint balance = token.balanceOf(this);
254     token.transfer(controller, balance);
255     ClaimedTokens(_token, controller, balance);
256   }
257 
258   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
259 }