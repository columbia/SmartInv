1 pragma solidity ^0.4.22;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
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
35    * @dev Allows the current owner to relinquish control of the contract.
36    */
37   function renounceOwnership() public onlyOwner {
38     emit OwnershipRenounced(owner);
39     owner = address(0);
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address _newOwner) public onlyOwner {
47     _transferOwnership(_newOwner);
48   }
49 
50   /**
51    * @dev Transfers control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address _newOwner) internal {
55     require(_newOwner != address(0));
56     emit OwnershipTransferred(owner, _newOwner);
57     owner = _newOwner;
58   }
59 }
60 
61 
62 
63 
64 // ERC20 Standard Token valuable interface
65 contract StandardToken  {
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
67     function approve(address _spender, uint256 _value) public returns (bool);
68     function allowance(address _owner, address _spender) public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71 }
72 
73 
74 
75 // Main contract
76 contract GESCrowdsale is Ownable {
77 
78     /*** STORAGE CONSTANTS ***/
79 
80     StandardToken public token;
81 
82 
83     /*** CONSTRUCTOR ***/
84 
85     /**
86       * @param _token Address of the Token
87       */
88     constructor(StandardToken _token) public {
89         require(_token != address(0));
90         token = _token;
91     }
92 
93     /**
94      * @dev set token address
95      */
96     function setTokenAddress(address _addr) public onlyOwner returns (bool) {
97         token = StandardToken(_addr);
98         return true;
99 
100     }
101 
102     /**
103      * @dev send tokens to recipients, up to 300 recipients per tx
104      */
105     function sendTokensToRecipients(address[] _recipients, uint256[] _values) onlyOwner public returns (bool) {
106         require(_recipients.length == _values.length);
107         uint256 i = 0;
108         while (i < _recipients.length) {
109             if (_values[i] > 0) {
110                 StandardToken(token).transfer(_recipients[i], _values[i]);
111             }
112             i += 1;
113         }
114         return true;
115     }
116 }