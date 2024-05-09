1 pragma solidity ^0.4.11;
2 contract WhiteList {
3     string public constant VERSION = "0.1.1";
4 
5     mapping(address=>bool) public contains;
6     uint public chunkNr = 0;
7     uint public recordNr=0;
8     uint public controlSum = 0;
9     bool public isSetupMode = true;
10     address admin = msg.sender;
11 
12     //adds next address package to the internal white list.
13     //call valid only in setup mode.
14     function addPack(address[] addrs, uint16 _chunkNr)
15     setupOnly
16     adminOnly
17     external {
18         require ( chunkNr++ == _chunkNr);
19         for(uint16 i=0; i<addrs.length; ++i){
20             contains[addrs[i]] = true;
21             controlSum += uint160(addrs[i]);
22         }
23         recordNr += addrs.length;
24     }
25 
26     //disable setup mode
27     function start()
28     adminOnly
29     public {
30         isSetupMode = false;
31     }
32 
33     modifier setupOnly {
34         if (!isSetupMode) throw;
35         _;
36     }
37 
38     modifier adminOnly {
39         if (msg.sender != admin) throw;
40         _;
41     }
42 }