1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /// @notice RenExTokens is a registry of tokens that can be traded on RenEx.
66 contract RenExTokens is Ownable {
67     string public VERSION; // Passed in as a constructor parameter.
68 
69     struct TokenDetails {
70         address addr;
71         uint8 decimals;
72         bool registered;
73     }
74 
75     // Storage
76     mapping(uint32 => TokenDetails) public tokens;
77     mapping(uint32 => bool) private detailsSubmitted;
78 
79     // Events
80     event LogTokenRegistered(uint32 tokenCode, address tokenAddress, uint8 tokenDecimals);
81     event LogTokenDeregistered(uint32 tokenCode);
82 
83     /// @notice The contract constructor.
84     ///
85     /// @param _VERSION A string defining the contract version.
86     constructor(string _VERSION) public {
87         VERSION = _VERSION;
88     }
89 
90     /// @notice Allows the owner to register and the details for a token.
91     /// Once details have been submitted, they cannot be overwritten.
92     /// To re-register the same token with different details (e.g. if the address
93     /// has changed), a different token identifier should be used and the
94     /// previous token identifier should be deregistered.
95     /// If a token is not Ethereum-based, the address will be set to 0x0.
96     ///
97     /// @param _tokenCode A unique 32-bit token identifier.
98     /// @param _tokenAddress The address of the token.
99     /// @param _tokenDecimals The decimals to use for the token.
100     function registerToken(uint32 _tokenCode, address _tokenAddress, uint8 _tokenDecimals) public onlyOwner {
101         require(!tokens[_tokenCode].registered, "already registered");
102 
103         // If a token is being re-registered, the same details must be provided.
104         if (detailsSubmitted[_tokenCode]) {
105             require(tokens[_tokenCode].addr == _tokenAddress, "different address");
106             require(tokens[_tokenCode].decimals == _tokenDecimals, "different decimals");
107         } else {
108             detailsSubmitted[_tokenCode] = true;
109         }
110 
111         tokens[_tokenCode] = TokenDetails({
112             addr: _tokenAddress,
113             decimals: _tokenDecimals,
114             registered: true
115         });
116 
117         emit LogTokenRegistered(_tokenCode, _tokenAddress, _tokenDecimals);
118     }
119 
120     /// @notice Sets a token as being deregistered. The details are still stored
121     /// to prevent the token from being re-registered with different details.
122     ///
123     /// @param _tokenCode The unique 32-bit token identifier.
124     function deregisterToken(uint32 _tokenCode) external onlyOwner {
125         require(tokens[_tokenCode].registered, "not registered");
126 
127         tokens[_tokenCode].registered = false;
128 
129         emit LogTokenDeregistered(_tokenCode);
130     }
131 }