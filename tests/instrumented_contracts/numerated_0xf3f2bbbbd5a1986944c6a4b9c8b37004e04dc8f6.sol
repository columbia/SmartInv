1 contract BlocksureInfo {
2 
3     address public owner;
4     string public name;
5     
6     mapping (string => string) strings;
7 
8     function BlocksureInfo() {
9         owner = tx.origin;
10     }
11     
12     modifier onlyowner { if (tx.origin == owner) _ }
13 
14     function addString(string _key, string _value) onlyowner {
15         strings[_key] = _value;
16     }
17     
18     function setOwner(address _owner) onlyowner {
19         owner = _owner;
20     }
21     
22     function setName(string _name) onlyowner {
23         name = _name;
24     }
25     
26     function destroy() onlyowner {
27         suicide(owner);
28     }
29 }