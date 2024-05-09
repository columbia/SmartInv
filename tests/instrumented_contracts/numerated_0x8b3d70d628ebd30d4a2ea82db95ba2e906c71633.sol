1 /**
2  * Copyright 2017–2019, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.2;
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to relinquish control of the contract.
43    * @notice Renouncing to ownership will leave the contract without an owner.
44    * It will not be possible to call the functions with the `onlyOwner`
45    * modifier anymore.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 }
70 
71 contract BZxOwnable is Ownable {
72 
73     address public bZxContractAddress;
74 
75     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
76 
77     // modifier reverts if bZxContractAddress isn't set
78     modifier onlyBZx() {
79         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
80         _;
81     }
82 
83     /**
84     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
85     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
86     */
87     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
88         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
89         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
90         bZxContractAddress = newBZxContractAddress;
91     }
92 
93     /**
94     * @dev Allows the current owner to transfer control of the contract to a newOwner.
95     * @param newOwner The address to transfer ownership to.
96     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
97     */
98     function transferOwnership(address newOwner) public onlyOwner {
99         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102     }
103 }
104 
105 interface NonCompliantEIP20 {
106     function transfer(address _to, uint256 _value) external;
107     function transferFrom(address _from, address _to, uint256 _value) external;
108     function approve(address _spender, uint256 _value) external;
109 }
110 
111 contract EIP20Wrapper {
112 
113     function eip20Transfer(
114         address token,
115         address to,
116         uint256 value)
117         internal
118         returns (bool result) {
119 
120         NonCompliantEIP20(token).transfer(to, value);
121 
122         assembly {
123             switch returndatasize()   
124             case 0 {                        // non compliant ERC20
125                 result := not(0)            // result is true
126             }
127             case 32 {                       // compliant ERC20
128                 returndatacopy(0, 0, 32) 
129                 result := mload(0)          // result == returndata of external call
130             }
131             default {                       // not an not an ERC20 token
132                 revert(0, 0) 
133             }
134         }
135 
136         require(result, "eip20Transfer failed");
137     }
138 
139     function eip20TransferFrom(
140         address token,
141         address from,
142         address to,
143         uint256 value)
144         internal
145         returns (bool result) {
146 
147         NonCompliantEIP20(token).transferFrom(from, to, value);
148 
149         assembly {
150             switch returndatasize()   
151             case 0 {                        // non compliant ERC20
152                 result := not(0)            // result is true
153             }
154             case 32 {                       // compliant ERC20
155                 returndatacopy(0, 0, 32) 
156                 result := mload(0)          // result == returndata of external call
157             }
158             default {                       // not an not an ERC20 token
159                 revert(0, 0) 
160             }
161         }
162 
163         require(result, "eip20TransferFrom failed");
164     }
165 
166     function eip20Approve(
167         address token,
168         address spender,
169         uint256 value)
170         internal
171         returns (bool result) {
172 
173         NonCompliantEIP20(token).approve(spender, value);
174 
175         assembly {
176             switch returndatasize()   
177             case 0 {                        // non compliant ERC20
178                 result := not(0)            // result is true
179             }
180             case 32 {                       // compliant ERC20
181                 returndatacopy(0, 0, 32) 
182                 result := mload(0)          // result == returndata of external call
183             }
184             default {                       // not an not an ERC20 token
185                 revert(0, 0) 
186             }
187         }
188 
189         require(result, "eip20Approve failed");
190     }
191 }
192 
193 contract BZxVault is EIP20Wrapper, BZxOwnable {
194 
195     // Only the bZx contract can directly deposit ether
196     function() external payable onlyBZx {}
197 
198     function withdrawEther(
199         address payable to,
200         uint256 value)
201         public
202         onlyBZx
203         returns (bool)
204     {
205         uint256 amount = value;
206         if (amount > address(this).balance) {
207             amount = address(this).balance;
208         }
209 
210         return (to.send(amount));
211     }
212 
213     function depositToken(
214         address token,
215         address from,
216         uint256 tokenAmount)
217         public
218         onlyBZx
219         returns (bool)
220     {
221         if (tokenAmount == 0) {
222             return false;
223         }
224 
225         eip20TransferFrom(
226             token,
227             from,
228             address(this),
229             tokenAmount);
230 
231         return true;
232     }
233 
234     function withdrawToken(
235         address token,
236         address to,
237         uint256 tokenAmount)
238         public
239         onlyBZx
240         returns (bool)
241     {
242         if (tokenAmount == 0) {
243             return false;
244         }
245 
246         eip20Transfer(
247             token,
248             to,
249             tokenAmount);
250 
251         return true;
252     }
253 
254     function transferTokenFrom(
255         address token,
256         address from,
257         address to,
258         uint256 tokenAmount)
259         public
260         onlyBZx
261         returns (bool)
262     {
263         if (tokenAmount == 0) {
264             return false;
265         }
266 
267         eip20TransferFrom(
268             token,
269             from,
270             to,
271             tokenAmount);
272 
273         return true;
274     }
275 }