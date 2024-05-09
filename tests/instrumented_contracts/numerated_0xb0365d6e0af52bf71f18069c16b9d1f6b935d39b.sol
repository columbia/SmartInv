1 contract SaveData{
2     constructor() public {
3     }
4     mapping (string=>string) data;
5     function setStr(string key, string value) public payable {
6         data[key] = value;
7     }
8     function getStr(string key) public constant returns(string){
9         return data[key];
10     }
11 }