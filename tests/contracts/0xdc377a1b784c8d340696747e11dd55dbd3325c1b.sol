contract FlipTest {
    bool paused;

    function setPaused(bool _state) external {
        paused = _state;
    }

    function testMint(uint32 bot_type) external{
      require(!paused);
    }
}