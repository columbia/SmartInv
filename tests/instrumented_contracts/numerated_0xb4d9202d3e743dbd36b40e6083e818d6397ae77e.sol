1 /*
2  * Ownable
3  *
4  * Base contract with an owner.
5  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
6  */
7 
8 contract Ownable {
9     address public owner;
10 
11     function Ownable() {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner {
21         if (newOwner != address(0)) {
22             owner = newOwner;
23         }
24     }
25 }
26 
27 
28 contract Whitelist is Ownable {
29     mapping (address => uint128) whitelist;
30 
31     event Whitelisted(address who, uint128 nonce);
32 
33     function Whitelist() Ownable() {
34       // This is here for our verification code only
35     }
36 
37     function setWhitelisting(address who, uint128 nonce) internal {
38         whitelist[who] = nonce;
39 
40         Whitelisted(who, nonce);
41     }
42 
43     function whitelistUser(address who, uint128 nonce) external onlyOwner {
44         setWhitelisting(who, nonce);
45     }
46 
47     function whitelistMe(uint128 nonce, uint8 v, bytes32 r, bytes32 s) external {
48         bytes32 hash = keccak256(msg.sender, nonce);
49         require(ecrecover(hash, v, r, s) == owner);
50         require(whitelist[msg.sender] == 0);
51 
52         setWhitelisting(msg.sender, nonce);
53     }
54 
55     function isWhitelisted(address who) external view returns(bool) {
56         return whitelist[who] > 0;
57     }
58 }