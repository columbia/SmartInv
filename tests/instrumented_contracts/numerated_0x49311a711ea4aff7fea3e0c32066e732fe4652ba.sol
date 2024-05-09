1 contract Oath {
2 	mapping (address => bytes) public sig;
3 
4 	event LogSignature(address indexed from, bytes version);
5 
6 	function Oath() {
7 		if(msg.value > 0) { throw; }
8 	}
9 
10 	function sign(bytes version) public {
11 		if(sig[msg.sender].length != 0 ) { throw; }
12 		if(msg.value > 0) { throw; }
13 
14 		sig[msg.sender] = version;
15 		LogSignature(msg.sender, version);
16 	}
17 
18 	function () { throw; }
19 }