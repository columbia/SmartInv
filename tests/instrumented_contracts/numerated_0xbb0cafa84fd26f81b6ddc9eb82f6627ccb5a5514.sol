1 pragma solidity ^0.4.24;
2 
3 // Searcher is an interface for contracts that want to be notified of incoming data
4 //
5 contract Searcher {
6 
7     // poke is called when new data arrives
8     //
9     function poke() public;
10 
11     // this is called to ensure that only valid Searchers can be added to the Lighthouse - returns an arbitrarily chosen number
12     //
13     function identify() external pure returns(uint) {
14         return 0xda4b055; 
15     }
16 }
17 
18 // for operation of this contract see the readme file.
19 //
20 contract Lighthouse {
21     
22     address public auth = msg.sender; // ownable model. No real value in making it transferrable.
23 
24     Searcher seeker;                  // a single contract that can be notified of data changes
25 
26     uint value;                       // holds all the data bit fiddled into a single 32 byte word.
27 
28     uint maxAge;                      // if non zero, sets a limit to data validity
29 
30     // admin functions
31     
32     modifier onlyAuth {
33         require(auth == msg.sender, "Unauthorised access");
34         _;
35     }
36 
37     function changeAuth(address newAuth) public onlyAuth {
38         auth = newAuth;
39     }
40 
41     function changeSearcher(Searcher newSeeker) public onlyAuth {
42         seeker = newSeeker;
43         require(seeker.identify() == 0xda4b055,"invalid searcher");
44     }
45 
46     function setMaxAge(uint newMaxAge) public onlyAuth {
47         maxAge = newMaxAge;
48     }
49     
50     function notTooLongSinceUpdated() public view returns (bool) {
51         uint since = now - ((value >> 128) & 
52         0x000000000000000000000000000000000000000000000000ffffffffffffffff);
53         return (since < maxAge) || (maxAge == 0);
54     }
55     
56     function peekData() external view returns (uint128 v,bool b) {
57         v = uint128(value);
58         b = notTooLongSinceUpdated() && value != 0;
59         return;
60     }
61     
62     function peekUpdated()  external view returns (uint32 v,bool b) {
63         uint v2 = value >> 128;
64         v = uint32(v2);
65         b = notTooLongSinceUpdated() && value != 0;
66         return;
67     }
68     
69     function peekLastNonce() external view returns (uint32 v,bool b) {
70         uint v2 = value >> 192;
71         v = uint32(v2);
72         b = notTooLongSinceUpdated() && value != 0;
73         return;
74     }
75 
76     function peek() external view returns (bytes32 v ,bool ok) {
77         v = bytes32(value & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff);
78         ok = notTooLongSinceUpdated() && value != 0;
79         return;
80     }
81     
82     function read() external view returns (bytes32 x) {
83         require(notTooLongSinceUpdated() && value != 0, "Invalid data stored");
84         return bytes32(value & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff);
85     }
86     
87     function write(uint  DataValue, uint nonce) external onlyAuth {
88         require ((DataValue >> 128) == 0, "Value too large");
89         require ((nonce >> 32) == 0, "Nonce too large");
90         value = DataValue + (nonce << 192) + (now << 128) ;
91         if (address(seeker) != address(0)) {
92             seeker.poke();
93         }
94     }
95 }