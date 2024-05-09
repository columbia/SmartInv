1 pragma solidity >=0.4.22 <0.7.0;
2 
3 contract OwnedToken {
4     // `TokenCreator` is a contract type that is defined below.
5     // It is fine to reference it as long as it is not used
6     // to create a new contract.
7     TokenCreator creator;
8     address owner;
9     bytes32 name;
10 
11     // This is the constructor which registers the
12     // creator and the assigned name.
13     constructor(bytes32 _name) public {
14         // State variables are accessed via their name
15         // and not via e.g. `this.owner`. Functions can
16         // be accessed directly or through `this.f`,
17         // but the latter provides an external view
18         // to the function. Especially in the constructor,
19         // you should not access functions externally,
20         // because the function does not exist yet.
21         // See the next section for details.
22         owner = msg.sender;
23 
24         // We do an explicit type conversion from `address`
25         // to `TokenCreator` and assume that the type of
26         // the calling contract is `TokenCreator`, there is
27         // no real way to check that.
28         creator = TokenCreator(msg.sender);
29         name = _name;
30     }
31 
32     function changeName(bytes32 newName) public {
33         // Only the creator can alter the name --
34         // the comparison is possible since contracts
35         // are explicitly convertible to addresses.
36         if (msg.sender == address(creator))
37             name = newName;
38     }
39 
40     function transfer(address newOwner) public {
41         // Only the current owner can transfer the token.
42         if (msg.sender != owner) return;
43 
44         // We ask the creator contract if the transfer
45         // should proceed by using a function of the
46         // `TokenCreator` contract defined below. If
47         // the call fails (e.g. due to out-of-gas),
48         // the execution also fails here.
49         if (creator.isTokenTransferOK(owner, newOwner))
50             owner = newOwner;
51     }
52 }
53 
54 contract TokenCreator {
55     function createToken(bytes32 name)
56        public
57        returns (OwnedToken tokenAddress)
58     {
59         // Create a new `Token` contract and return its address.
60         // From the JavaScript side, the return type is
61         // `address`, as this is the closest type available in
62         // the ABI.
63         return new OwnedToken(name);
64     }
65 
66     function changeName(OwnedToken tokenAddress, bytes32 name) public {
67         // Again, the external type of `tokenAddress` is
68         // simply `address`.
69         tokenAddress.changeName(name);
70     }
71 
72     // Perform checks to determine if transferring a token to the
73     // `OwnedToken` contract should proceed
74     function isTokenTransferOK(address currentOwner, address newOwner)
75         public
76         pure
77         returns (bool ok)
78     {
79         // Check an arbitrary condition to see if transfer should proceed
80         return keccak256(abi.encodePacked(currentOwner, newOwner))[0] == 0x7f;
81     }
82 }