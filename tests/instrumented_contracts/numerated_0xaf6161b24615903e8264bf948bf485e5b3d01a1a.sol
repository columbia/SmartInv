1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender)
87     external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92     external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 value
101   );
102 
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 /**
111  * @title ERC20Detailed token
112  * @dev The decimals are only for visualization purposes.
113  * All the operations are done using the smallest and indivisible token unit,
114  * just as on Ethereum all the operations are done in wei.
115  */
116 contract ERC20Detailed is IERC20 {
117   string private _name;
118   string private _symbol;
119   uint8 private _decimals;
120 
121   constructor(string name, string symbol, uint8 decimals) public {
122     _name = name;
123     _symbol = symbol;
124     _decimals = decimals;
125   }
126 
127   /**
128    * @return the name of the token.
129    */
130   function name() public view returns(string) {
131     return _name;
132   }
133 
134   /**
135    * @return the symbol of the token.
136    */
137   function symbol() public view returns(string) {
138     return _symbol;
139   }
140 
141   /**
142    * @return the number of decimals of the token.
143    */
144   function decimals() public view returns(uint8) {
145     return _decimals;
146   }
147 }
148 
149 contract SupportEscrow is Ownable {
150     ERC20Detailed public constant bznToken = ERC20Detailed(0x1BD223e638aEb3A943b8F617335E04f3e6B6fFfa);
151     ERC20Detailed public constant gusdToken = ERC20Detailed(0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd);
152     
153     //BZN has 18 decimals, so we must append 18 decimals to this number
154     uint256 public constant bznRequirement = 13213 * (10 ** uint256(18));
155     
156     //gusd has two decimals, so the last two digits are for decimals
157     //i.e 8888801 = $88,888.01
158     //Therefore, 330330 = $3,303.30
159     uint256 public constant gusdRequirement = 330330;
160 
161     //The minimum amount the contract must hold ($303.33)
162     uint256 public constant gusdMinimum = 33033;
163     
164     //The date when assets unlock
165     uint256 public constant unlockDate = 1551330000;
166     
167     bool public redeemed = false;
168     bool public executed = false;
169     bool public redeemable = false;
170     address public thirdParty;
171     
172     modifier onlyThridParty {
173         require(msg.sender == thirdParty);
174         _;
175     }
176     
177     constructor(address tp) public {
178         thirdParty = tp;
179     }
180     
181     function validate() public view returns (bool) {
182         address self = address(this);
183         
184         uint256 bzn = bznToken.balanceOf(self);
185         uint256 gusd = gusdToken.balanceOf(self);
186         
187         return bzn >= bznRequirement && gusd >= gusdRequirement;
188     }
189     
190     function execute() public onlyOwner returns (bool) {
191         //Ensure we haven't executed yet
192         require(executed == false);
193         
194         address self = address(this);
195         uint256 bzn = bznToken.balanceOf(self);
196         
197         //Ensure everything is in place before we execute
198         require(bzn >= bznRequirement);
199         
200         //Transfer the BZN to the owner
201         bznToken.transfer(owner(), bznRequirement);
202         
203         //We are done executing
204         executed = true;
205     }
206     
207     function destroy() public onlyOwner {
208         address self = address(this);
209         
210         uint256 bzn = bznToken.balanceOf(self);
211         uint256 gusd = gusdToken.balanceOf(self);
212         
213         //First return all funds
214         if (executed == false) {
215             //If it hasn't been executed yet, give funds back to third party
216             
217             bznToken.transfer(thirdParty, bzn);
218             bznToken.transfer(thirdParty, gusd);
219         } else if (redeemable && redeemed == false) {
220             //If it hasn't been redeemed but was marked redeemable, give back to third party
221             
222             bznToken.transfer(thirdParty, bzn);
223             bznToken.transfer(thirdParty, gusd);
224         }
225         
226         selfdestruct(owner());
227     }
228     
229     function allowRedeem() public onlyThridParty returns (uint256) {
230         //Ensure this has been executed
231         require(executed);
232         //Ensure this hasn't been marked as redeemable yet
233         require(redeemed == false);
234         //Ensure this hasn't been redeemed yet
235         require(redeemable == false);
236         //Ensure the time is past the unlock date
237         require(block.timestamp >= unlockDate);
238         //Ensure everything is in place before marking it as redeemable
239         require(validate());
240         
241         redeemable = true;
242     }
243     
244     function redeem() public onlyOwner returns (uint256) {
245         //Ensure this has been executed
246         require(executed);
247         //Ensure this is redeemable
248         require(redeemable);
249         //Ensure it hasn't been redeemed
250         require(redeemed == false);
251         //Ensure the time is past the unlock date
252         require(block.timestamp >= unlockDate);
253         //Ensure it's in the correct state
254         require(validate());
255         
256         //Give back the BZN to the thrid party
257         bznToken.transfer(thirdParty, bznRequirement);
258         
259         //Transfer gusd to the owner
260         gusdToken.transfer(owner(), gusdRequirement);
261         
262         //Mark as redeemed
263         redeemed = true;
264     }
265     
266     function withdrawBZN(uint256 amount) public onlyThridParty {
267         //You can only do this before execute() is called
268         //This is a safety net to ensure you don't send more than you meant to
269         //Or to reverse this contract before execute() is called
270         require(executed == false);
271         
272         //Send back BZN to the third party
273         bznToken.transfer(thirdParty, amount);
274     }
275 }