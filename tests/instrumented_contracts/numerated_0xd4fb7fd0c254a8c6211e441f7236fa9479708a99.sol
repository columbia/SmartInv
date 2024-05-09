1 // The contract that allows DTH that held DAO at a contract address to
2 // authorize an enduser-account to do the withdrawal for them
3 //
4 // License: BSD3
5 
6 contract Owned {
7     /// Prevents methods from perfoming any value transfer
8     modifier noEther() {if (msg.value > 0) throw; _}
9     /// Allows only the owner to call a function
10     modifier onlyOwner { if (msg.sender != owner) throw; _ }
11 
12     address owner;
13 
14     function Owned() { owner = msg.sender;}
15 
16 
17 
18     function changeOwner(address _newOwner) onlyOwner {
19         owner = _newOwner;
20     }
21 
22     function getOwner() noEther constant returns (address) {
23         return owner;
24     }
25 }
26 
27 contract WHAuthorizeAddress is Owned {
28 
29     bool isClosed;
30 
31     mapping (address => bool) usedAddresses;
32 
33     event Authorize(address indexed dthContract, address indexed authorizedAddress);
34 
35     function WHAuthorizeAddress () {
36         isClosed = false;
37     }
38 
39     /// @notice Authorizes a regular account to act on behalf of a contract
40     /// @param _authorizedAddress The address of the regular account that will
41     ///                           act on behalf of the msg.sender contract.
42     function authorizeAddress(address _authorizedAddress) noEther() {
43 
44         // after the contract is closed no more authorizations can happen
45         if (isClosed) {
46             throw;
47         }
48 
49         // sender must be a contract and _authorizedAddress must be a user account
50         if (getCodeSize(msg.sender) == 0 || getCodeSize(_authorizedAddress) > 0) {
51             throw;
52         }
53 
54         // An authorized address can be used to represent only a single contract.
55         if (usedAddresses[_authorizedAddress]) {
56             throw;
57         }
58         usedAddresses[_authorizedAddress] = true;
59 
60         Authorize(msg.sender, _authorizedAddress);
61     }
62 
63     function() {
64         throw;
65     }
66 
67     function getCodeSize(address _addr) constant internal returns(uint _size) {
68         assembly {
69             _size := extcodesize(_addr)
70         }
71     }
72 
73     /// @notice Close the contract. After closing no more authorizations can happen
74     function close() noEther onlyOwner {
75         isClosed = true;
76     }
77 
78     function getIsClosed() noEther constant returns (bool) {
79         return isClosed;
80     }
81 }