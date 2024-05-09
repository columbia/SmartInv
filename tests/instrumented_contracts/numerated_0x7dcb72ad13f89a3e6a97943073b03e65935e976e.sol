1 pragma solidity ^0.4.11;
2 contract WhiteList {
3     string public constant VERSION = "0.1.0";
4 
5     mapping(address=>bool) public contains;
6     uint16  public chunkNr = 0;
7     uint256 public controlSum = 0;
8     bool public isSetupMode = true;
9     address admin = msg.sender;
10 
11     //adds next address package to the internal white list.
12     //call valid only in setup mode.
13     function addPack(address[] addrs, uint16 _chunkNr)
14     setupOnly
15     adminOnly
16     external {
17         require ( chunkNr++ == _chunkNr);
18         for(uint16 i=0; i<addrs.length; ++i){
19             contains[addrs[i]] = true;
20             controlSum += uint160(addrs[i]);
21         }
22     }
23 
24     //disable setup mode
25     function start()
26     adminOnly
27     public {
28         isSetupMode = false;
29     }
30 
31     modifier setupOnly {
32         if (!isSetupMode) throw;
33         _;
34     }
35 
36     modifier adminOnly {
37         if (msg.sender != admin) throw;
38         _;
39     }
40 }