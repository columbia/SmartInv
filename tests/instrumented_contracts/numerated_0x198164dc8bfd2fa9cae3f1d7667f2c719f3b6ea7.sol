1 // SPDX-License-Identifier: No License (None)
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  *
9  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
10  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
11  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
12  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor () internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29      * @return the address of the owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(isOwner(),"Not Owner");
40         _;
41     }
42 
43     /**
44      * @return true if `msg.sender` is the owner of the contract.
45      */
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0),"Zero address not allowed");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface Oraclize{
70     function oracleCallback(uint256 requestId,uint256 balance) external returns(bool);
71     function oraclePriceAndBalanceCallback(uint256 requestId,uint256 priceA,uint256 priceB,uint256[] calldata balances) external returns(bool);
72 }
73 
74 contract Oracle is Ownable{
75     
76     uint256 public requestIdCounter;
77 
78     mapping(address => bool) public isAllowedAddress;
79     mapping(address => bool) public isSystemAddress;
80     mapping(uint256 => bool) public requestFullFilled;
81     mapping(uint256 => address) public requestedBy;
82 
83     
84     event BalanceRequested(uint256 indexed requestId,uint256 network,address token,address user);
85     event PriceAndBalanceRequested(uint256 indexed requestId,address tokenA,address tokenB,uint256 network,address token,address[] user);
86     event BalanceUpdated(uint256 indexed requestId,uint256 balance);
87     event PriceAndBalanceUpdated(uint256 indexed requestId,uint256 priceA,uint256 priceB,uint256[] balances);
88     event SetSystem(address system, bool isActive);
89 
90     // only system wallet can send oracle response
91     modifier onlySystem() {
92         require(isSystemAddress[msg.sender],"Not System");
93         _;
94     }
95 
96     // only system wallet can send oracle response
97     function setSystem(address system, bool isActive) external onlyOwner {
98         isSystemAddress[system] = isActive;
99         emit SetSystem(system, isActive);
100     }
101 
102     function changeAllowedAddress(address _which,bool _bool) external onlyOwner returns(bool){
103         isAllowedAddress[_which] = _bool;
104         return true;
105     }
106 
107     // parameter pass networkId like eth_mainNet = 1,ropsten = 97 etc 
108     // token parameter is which token balance you want for native currency pass address(0)
109     // user which address you want to show
110     function getBalance(uint256 network,address token,address user) external returns(uint256){
111         require(isAllowedAddress[msg.sender],"ERR_ALLOWED_ADDRESS_ONLY");
112         requestIdCounter +=1;
113         requestedBy[requestIdCounter] = msg.sender;
114         emit BalanceRequested(requestIdCounter,network,token,user);
115         return requestIdCounter;
116     }
117     
118     function getPriceAndBalance(address tokenA,address tokenB,uint256 network,address token,address[] calldata user) external returns(uint256){
119         require(isAllowedAddress[msg.sender],"ERR_ALLOWED_ADDRESS_ONLY");
120         requestIdCounter +=1;
121         requestedBy[requestIdCounter] = msg.sender;
122         emit PriceAndBalanceRequested(requestIdCounter,tokenA,tokenB,network,token,user);
123         return requestIdCounter;
124     }
125     
126     function oracleCallback(uint256 _requestId,uint256 _balance) external onlySystem returns(bool){
127         require(requestFullFilled[_requestId]==false,"ERR_REQUESTED_IS_FULFILLED");
128         address _requestedBy = requestedBy[_requestId];
129         Oraclize(_requestedBy).oracleCallback(_requestId,_balance);
130         emit BalanceUpdated(_requestId,_balance);
131         requestFullFilled[_requestId] = true;
132         return true;
133     }
134     
135     
136     function oraclePriceAndBalanceCallback(uint256 _requestId,uint256 _priceA,uint256 _priceB,uint256[] calldata _balances) external onlySystem returns(bool){
137         require(requestFullFilled[_requestId]==false,"ERR_REQUESTED_IS_FULFILLED");
138         address _requestedBy = requestedBy[_requestId];
139         Oraclize(_requestedBy).oraclePriceAndBalanceCallback(_requestId,_priceA,_priceB,_balances);
140         emit PriceAndBalanceUpdated(_requestId,_priceA,_priceB,_balances);
141         requestFullFilled[_requestId] = true;
142         return true;
143     }
144 }