1 contract self_store {
2 
3     address owner;
4 
5     uint public contentCount = 0;
6     
7     event content(string datainfo, uint indexed version);
8     modifier onlyowner { if (msg.sender == owner) _ }
9     
10     function self_store() public { owner = msg.sender; }
11     
12     ///TODO: remove in release
13     function kill() onlyowner { suicide(owner); }
14 
15     function flush() onlyowner {
16         owner.send(this.balance);
17     }
18 
19     function add(string datainfo, uint version) onlyowner {
20         contentCount++;
21         content(datainfo, version);
22     }
23 }