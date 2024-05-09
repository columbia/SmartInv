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
13     uint public numfails;
14     uint public numsuccesses;
15 
16     address owner;
17 
18     // needed for "naive" and "oraclized" checks
19     address constant withdrawdaoaddr = 0xbf4ed7b27f1d666546e30d74d50d173d20bca754;
20     TheDaoHardForkOracle oracle = TheDaoHardForkOracle(0xe8e506306ddb78ee38c9b0d86c257bd97c2536b3);
21 
22     event logCall(uint indexed _numcalls,
23                   uint indexed _numfails,
24                   uint indexed _numsuccesses);
25 
26     modifier onlyOwner { if (msg.sender != owner) throw; _ }
27     modifier onlyThis { if (msg.sender != address(this)) throw; _ }
28 
29     // constructor (setting `owner` allows later termination)
30     function ReversibleDemo() { owner = msg.sender; }
31 
32     /* external: increments stack height */
33     /* onlyThis: prevent actual external calling */
34     function sendIfNotForked() external onlyThis returns (bool) {
35         numcallsinternal++;
36 
37         /* naive check for "is this the classic chain" */
38         // guaranteed `true`: enough has been withdrawn already
39         //     three million ------> 3'000'000
40         if (withdrawdaoaddr.balance < 3000000 ether) {
41             /* intentionally not checking return value */
42             owner.send(42);
43         }
44 
45         /* "reverse" if it's actually the HF chain */
46         if (oracle.forked()) throw;
47 
48         // not exactly a "success": send() could have failed on classic
49         return true;
50     }
51 
52     // accepts value transfers
53     function doCall(uint _gas) onlyOwner {
54         numcalls++;
55 
56         if (!this.sendIfNotForked.gas(_gas)()) {
57             numfails++;
58         }
59         else {
60             numsuccesses++;
61         }
62         logCall(numcalls, numfails, numsuccesses);
63     }
64 
65     function selfDestruct() onlyOwner {
66         selfdestruct(owner);
67     }
68 
69     // accepts value trasfers, but does nothing
70     function() {}
71 }