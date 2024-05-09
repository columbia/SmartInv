1 // `interface` would make a nice keyword ;)
2 contract TheDaoHardForkOracle {
3     // `ran()` manually verified true on both ETH and ETC chains
4     function forked() constant returns (bool);
5 }
6 
7 // demostrates calling own function in a "reversible" manner
8 /* important lines are marked by multi-line comments */
9 contract ReversibleDemo {
10     // counters (all public to simplify inspection)
11     uint public numcalls;
12     uint public numcallsinternal;
13 
14     address owner;
15 
16     // needed for "naive" and "oraclized" checks
17     address constant withdrawdaoaddr = 0xbf4ed7b27f1d666546e30d74d50d173d20bca754;
18     TheDaoHardForkOracle oracle = TheDaoHardForkOracle(0xe8e506306ddb78ee38c9b0d86c257bd97c2536b3);
19 
20     event logCall(uint indexed _numcalls, uint indexed _numcallsinternal);
21 
22     modifier onlyOwner { if (msg.sender != owner) throw; _ }
23     modifier onlyThis { if (msg.sender != address(this)) throw; _ }
24 
25     // constructor (setting `owner` allows later termination)
26     function ReversibleDemo() { owner = msg.sender; }
27 
28     /* external: increments stack height */
29     /* onlyThis: prevent actual external calling */
30     function sendIfNotForked() external onlyThis returns (bool) {
31         numcallsinternal++;
32 
33         /* naive check for "is this the classic chain" */
34         // guaranteed `true`: enough has been withdrawn already
35         //     three million ------> 3'000'000
36         if (withdrawdaoaddr.balance < 3000000 ether) {
37             /* intentionally not checking return value */
38             owner.send(42);
39         }
40 
41         /* "reverse" if it's actually the HF chain */
42         if (oracle.forked()) throw;
43 
44         // not exactly a "success": send() could have failed on classic
45         return true;
46     }
47 
48     // accepts value transfers
49     function doCall(uint _gas) onlyOwner {
50         numcalls++;
51 
52         // if it throws, there won't be any return value on the stack :/
53         this.sendIfNotForked.gas(_gas)();
54 
55         logCall(numcalls, numcallsinternal);
56     }
57 
58     function selfDestruct() onlyOwner {
59         selfdestruct(owner);
60     }
61 
62     // reject value trasfers
63     function() { throw; }
64 }