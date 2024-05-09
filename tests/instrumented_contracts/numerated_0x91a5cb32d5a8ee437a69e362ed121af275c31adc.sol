1 contract SaveString{
2     constructor() public {
3     }
4     mapping (uint=>string) data;
5     function setStr(uint key, string value) public {
6         data[key] = value;
7     }
8     function getStr(uint key) public constant returns(string){
9         return data[key];
10     }
11 }