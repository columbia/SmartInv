1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 
17 contract Authorize is Ownable {
18     /* Define variable owner of the type address */
19     address public backEndOperator = msg.sender;
20 
21     mapping(address=>bool) public whitelist;
22 
23     event Authorized(address wlCandidate, uint timestamp);
24 
25     event Revoked(address wlCandidate, uint timestamp);
26 
27 
28     modifier backEnd() {
29         require(msg.sender == backEndOperator || msg.sender == owner);
30         _;
31     }
32 
33     function setBackEndAddress(address newBackEndOperator) public onlyOwner {
34         backEndOperator = newBackEndOperator;
35     }
36 
37 
38     function authorize(address wlCandidate) public backEnd  {
39         require(wlCandidate != address(0x0));
40         require(!isWhitelisted(wlCandidate));
41         whitelist[wlCandidate] = true;
42         emit Authorized(wlCandidate, now);
43     }
44 
45     function revoke(address wlCandidate) public  onlyOwner {
46         whitelist[wlCandidate] = false;
47         emit Revoked(wlCandidate, now);
48     }
49 
50     function isWhitelisted(address wlCandidate) public view returns(bool) {
51         return whitelist[wlCandidate];
52     }
53 
54 }