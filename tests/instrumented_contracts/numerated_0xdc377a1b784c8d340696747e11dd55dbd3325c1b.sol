1 contract FlipTest {
2     bool paused;
3 
4     function setPaused(bool _state) external {
5         paused = _state;
6     }
7 
8     function testMint(uint32 bot_type) external{
9       require(!paused);
10     }
11 }