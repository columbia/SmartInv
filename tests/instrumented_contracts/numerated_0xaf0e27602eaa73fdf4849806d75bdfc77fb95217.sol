1 pragma solidity ^0.4.19;
2 
3 /**
4  * CoinCrowd Exchange Rates. More info www.coincrowd.it 
5  */
6 
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15   
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() internal {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 }
44 
45 /**
46  * @title Authorizable
47  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
48  * functions, this simplifies the implementation of "multiple user permissions".
49  */
50 contract Authorizable is Ownable {
51   mapping(address => bool) public authorized;
52   
53   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
54 
55   /**
56    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
57    * account.
58    */ 
59   function Authorizable() public {
60 	authorized[msg.sender] = true;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the authorized.
65    */
66   modifier onlyAuthorized() {
67     require(authorized[msg.sender]);
68     _;
69   }
70 
71  /**
72    * @dev Allows the current owner to set an authorization.
73    * @param addressAuthorized The address to change authorization.
74    */
75   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
76     AuthorizationSet(addressAuthorized, authorization);
77     authorized[addressAuthorized] = authorization;
78   }
79   
80 }
81 
82 contract CoinCrowdExchangeRates is Ownable, Authorizable {
83     uint256 public constant decimals = 18;
84     mapping (string  => uint256) rate;
85     
86     function readRate(string _currency) public view returns (uint256 oneEtherValue) {
87         return rate[_currency];
88     }
89     
90     function writeRate(string _currency, uint256 oneEtherValue) onlyAuthorized public returns (bool result) {
91         rate[_currency] = oneEtherValue;
92         return true;
93     }
94 }