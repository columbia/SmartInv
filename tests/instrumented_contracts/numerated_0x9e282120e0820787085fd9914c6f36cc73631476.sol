1 contract Ownable {
2   address public owner;
3 
4 
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) public onlyOwner {
29     require(newOwner != address(0));
30     OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 
34 }
35 
36 
37 contract SmsCertifier is Ownable {
38 	event Confirmed(address indexed who);
39 	event Revoked(address indexed who);
40 	modifier only_certified(address _who) { require(certs[_who].active); _; }
41 	modifier only_delegate(address _who) { require(delegate[_who].active); _; }
42 
43 	mapping (address => Certification) certs;
44 	mapping (address => Certifier) delegate;
45 
46 	struct Certification {
47 		bool active;
48 		mapping (string => bytes32) meta;
49 	}
50 
51 	struct Certifier {
52 		bool active;
53 		mapping (string => bytes32) meta;
54 	}
55 
56 	function addDelegate(address _delegate, bytes32 _who) public onlyOwner {
57 		delegate[_delegate].active = true;
58 		delegate[_delegate].meta['who'] = _who;
59 	}
60 
61 	function removeDelegate(address _delegate) public onlyOwner {
62 		delegate[_delegate].active = false;
63 	}
64 
65 	function certify(address _who) only_delegate(msg.sender) {
66 		certs[_who].active = true;
67 		emit Confirmed(_who);
68 	}
69 	function revoke(address _who) only_delegate(msg.sender) only_certified(_who) {
70 		certs[_who].active = false;
71 		emit Revoked(_who);
72 	}
73 
74 	function isDelegate(address _who) public view returns (bool) { return delegate[_who].active; }
75 	function certified(address _who) public  view returns (bool) { return certs[_who].active; }
76 	function get(address _who, string _field) public view returns (bytes32) { return certs[_who].meta[_field]; }
77 	function getAddress(address _who, string _field) public view returns (address) { return address(certs[_who].meta[_field]); }
78 	function getUint(address _who, string _field) public view returns (uint) { return uint(certs[_who].meta[_field]); }
79 
80 }