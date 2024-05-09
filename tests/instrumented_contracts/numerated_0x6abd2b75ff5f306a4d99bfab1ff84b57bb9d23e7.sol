1 contract ThisExternalAssembly {
2     uint public numcalls;
3     uint public numcallsinternal;
4     uint public numfails;
5     uint public numsuccesses;
6     
7     address owner;
8 
9     event logCall(uint indexed _numcalls, uint indexed _numcallsinternal);
10     
11     modifier onlyOwner { if (msg.sender != owner) throw; _ }
12     modifier onlyThis { if (msg.sender != address(this)) throw; _ }
13 
14     // constructor
15     function ThisExternalAssembly() {
16         owner = msg.sender;
17     }
18 
19     function failSend() external onlyThis returns (bool) {
20         // storage change + nested external call
21         numcallsinternal++;
22         owner.send(42);
23 
24         // placeholder for state checks
25         if (true) throw;
26 
27         // never happens in this case
28         return true;
29     }
30     
31     function doCall(uint _gas) onlyOwner {
32         numcalls++;
33 
34         address addr = address(this);
35         bytes4 sig = bytes4(sha3("failSend()"));
36 
37         bool ret;
38 
39         // work around `solc` safeguards for throws in external calls
40         // https://ethereum.stackexchange.com/questions/6354/
41         assembly {
42             let x := mload(0x40) // read "empty memory" pointer
43             mstore(x,sig)
44 
45             ret := call(
46                 _gas, // gas amount
47                 addr, // recipient account
48                 0,    // value (no need to pass)
49                 x,    // input start location
50                 0x4,  // input size - just the sig
51                 x,    // output start location
52                 0x1)  // output size (bool - 1 byte)
53 
54             //ret := mload(x) // no return value ever written :/
55             mstore(0x40,add(x,0x4)) // just in case, roll the tape
56         }
57 
58         if (ret) { numsuccesses++; }
59         else { numfails++; }
60 
61         // mostly helps with function identification if disassembled
62         logCall(numcalls, numcallsinternal);
63     }
64 
65     // will clean-up :)
66     function selfDestruct() onlyOwner { selfdestruct(owner); }
67     
68     function() { throw; }
69 }