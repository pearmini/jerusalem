Grid g;
void setup() {
  size(500, 500);
  // fullScreen();
  g = new Grid(width, height, 1);
  colorMode(HSB, 360);
  background(360);
}

void draw() {
  g.crawl();
}

void mousePressed() {
  g.putCrawler(mouseX, mouseY);
}

void keyPressed() {
  g.changeCrawlerType();
}

class Grid {
  final int BFS = 0, DFS = 1;
  float cellSize;
  ArrayList<Integer> frontier;
  int [] visited, depth;
  int col, row;
  int type;
  boolean isCrawling;
  Grid(float _width, float _height, float _cellSize) {
    cellSize = _cellSize;
    row = int(_height / cellSize);
    col = int(_width / cellSize);
    isCrawling = false;
    type = BFS;
  }

  void init() {
    visited = new int[row * col]; //初始化为零，表示都没有来过
    depth = new int[row * col];
    frontier = new ArrayList();
  }

  void changeCrawlerType() {
    type++;
    type %= 2;
  }

  void putCrawler(int x, int y) {
    background(360);
    init();
    isCrawling = true;

    int r = int(y / cellSize);
    int c = int(x / cellSize);
    int index = col * r + c;
    frontier.add(index);
    depth[index] = 0;
  }

  void crawl() {
    if (isCrawling) {
      if (type == BFS) {
        randomizedBFS();
      } else {
        randomizedDFS();
      }
    }
  }

  void randomizedDFS() {
    int k = 0;
    while (++k < 1200 && !frontier.isEmpty()) {
      int node = pop(frontier);
      if (visited[node] == 1) continue;
      int x = node % col, y = int(node / col);
      fillCell(node);

      //枚举改点的所有邻居
      int m = 0, next;
      if (y > 0 && visited[next = node - col] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (y < row - 1 && visited[next = node + col] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (x > 0 && visited[next = node - 1] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (x < col - 1 && visited[next = node + 1] == 0 ) {
        frontier.add(next);
        depth[next] = depth[node] + 1;
        m++;
      }
      visited[node] = 1;
      shuffle(frontier, frontier.size() - m, frontier.size());
    }
  }



  void randomizedBFS() {
    int k = 0;
    while (++k < 1200  && !frontier.isEmpty()) {
      int node = popRandom(frontier);
      if (visited[node] == 1) continue;
      int x = node % col, y = int(node / col);
      fillCell(node);

      //枚举该点所有的邻居
      int m = 0, next;
      if (y > 0 && visited[next = (node - col)] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (y < row - 1 && visited[next = (node + col)] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (x > 0 && visited[next = (node - 1)] == 0) {
        frontier.add(next); 
        depth[next] = depth[node] + 1;
        m++;
      }
      if (x < col - 1 && visited[next = (node + 1)] == 0 ) {
        frontier.add(next);
        depth[next] = depth[node] + 1;
        m++;
      }
      visited[node] = 1; //表示已经来过了
    }
  }


  void swap(ArrayList<Integer> array, int i, int j) {
    int tmp = array.get(i);
    array.set(i, array.get(j));
    array.set(j, tmp);
  }
  int pop(ArrayList<Integer> array) {
    int n = array.size();
    int t = array.get(n - 1);
    array.remove(n - 1);
    return t;
  }


  void shuffle(ArrayList<Integer> array, int left, int right) {
    int m = right - left;
    while (m > 0) {
      int i = int(random(1) * m --);
      swap(array, left + i, left + m);
    }
  }
  int popRandom(ArrayList<Integer> array) {
    int n = array.size(), i = int(random(n));
    int t = array.get(i);
    swap(array, n - 1, i);
    array.remove(n - 1);
    return t;
  }



  void fillCell(int i) {
    int x = i % col, y = int(i / col);
    noStroke();
    int hue = (depth[i]) % 946;
    fill(colorScale[hue]);
    rect(x * cellSize, y * cellSize, cellSize, cellSize);
  }
}

int [] colorScale = {#6d3fa9, #6e3faa, #6f3faa, #703faa, #703fab, #713fab, #723fab, #733fac, #743fac, #753fac, 
  #753fac, #763fad, #773fad, #783fad, #793ead, #7a3eae, #7a3eae, #7b3eae, #7c3eae, #7d3eaf, 
  #7e3eaf, #7f3eaf, #803eaf, #803eaf, #813eb0, #823eb0, #833eb0, #843eb0, #853eb0, #863eb0, 
  #863db1, #873db1, #883db1, #893db1, #8a3db1, #8b3db1, #8c3db1, #8d3db2, #8d3db2, #8e3db2, 
  #8f3db2, #903db2, #913db2, #923db2, #933db2, #933db2, #943db2, #953db2, #963db2, #973db2, 
  #983cb3, #993cb3, #9a3cb3, #9b3cb3, #9b3cb3, #9c3cb3, #9d3cb3, #9e3cb3, #9f3cb3, #a03cb3, 
  #a13cb3, #a23cb3, #a23cb3, #a33cb2, #a43cb2, #a53cb2, #a63cb2, #a73cb2, #a83cb2, #a93cb2, 
  #a93cb2, #aa3cb2, #ab3cb2, #ac3cb2, #ad3cb2, #ae3cb2, #af3cb1, #b03cb1, #b03cb1, #b13cb1, 
  #b23cb1, #b33cb1, #b43cb1, #b53cb0, #b63cb0, #b63cb0, #b73cb0, #b83cb0, #b93caf, #ba3caf, 
  #bb3caf, #bc3caf, #bc3caf, #bd3cae, #be3cae, #bf3cae, #c03cae, #c13cae, #c13cad, #c23cad, 
  #c33cad, #c43cac, #c53cac, #c63cac, #c63cac, #c73cab, #c83cab, #c93cab, #ca3daa, #ca3daa, 
  #cb3daa, #cc3da9, #cd3da9, #ce3da9, #ce3da8, #cf3da8, #d03da8, #d13da7, #d23da7, #d23da7, 
  #d33da6, #d43ea6, #d53ea6, #d53ea5, #d63ea5, #d73ea4, #d83ea4, #d83ea4, #d93ea3, #da3ea3, 
  #db3ea2, #db3fa2, #dc3fa1, #dd3fa1, #de3fa1, #de3fa0, #df3fa0, #e03f9f, #e03f9f, #e1409e, 
  #e2409e, #e2409d, #e3409d, #e4409c, #e4409c, #e5419b, #e6419b, #e6419a, #e7419a, #e84199, 
  #e84199, #e94298, #ea4298, #ea4297, #eb4297, #ec4296, #ec4396, #ed4395, #ed4395, #ee4394, 
  #ef4394, #ef4493, #f04492, #f04492, #f14491, #f24491, #f24590, #f34590, #f3458f, #f4458e, 
  #f4468e, #f5468d, #f5468d, #f6468c, #f7478b, #f7478b, #f8478a, #f8478a, #f94889, #f94888, 
  #fa4888, #fa4887, #fb4987, #fb4986, #fb4985, #fc4a85, #fc4a84, #fd4a83, #fd4b83, #fe4b82, 
  #fe4b82, #ff4b81, #ff4c80, #ff4c80, #ff4c7f, #ff4d7e, #ff4d7e, #ff4d7d, #ff4e7c, #ff4e7c, 
  #ff4e7b, #ff4f7a, #ff4f7a, #ff5079, #ff5078, #ff5078, #ff5177, #ff5176, #ff5176, #ff5275, 
  #ff5274, #ff5274, #ff5373, #ff5372, #ff5472, #ff5471, #ff5470, #ff5570, #ff556f, #ff566e, 
  #ff566e, #ff576d, #ff576c, #ff576c, #ff586b, #ff586a, #ff596a, #ff5969, #ff5a68, #ff5a68, 
  #ff5a67, #ff5b66, #ff5b66, #ff5c65, #ff5c64, #ff5d64, #ff5d63, #ff5e62, #ff5e62, #ff5f61, 
  #ff5f61, #ff6060, #ff605f, #ff615f, #ff615e, #ff625d, #ff625d, #ff635c, #ff635b, #ff645b, 
  #ff645a, #ff6559, #ff6559, #ff6658, #ff6658, #ff6757, #ff6756, #ff6856, #ff6855, #ff6954, 
  #ff6954, #ff6a53, #ff6a53, #ff6b52, #ff6c51, #ff6c51, #ff6d50, #ff6d50, #ff6e4f, #ff6e4e, 
  #ff6f4e, #ff704d, #ff704d, #ff714c, #ff714b, #ff724b, #ff724a, #ff734a, #ff7449, #ff7449, 
  #ff7548, #ff7548, #ff7647, #ff7746, #ff7746, #ff7845, #ff7845, #ff7944, #ff7a44, #ff7a43, 
  #ff7b43, #ff7c42, #ff7c42, #ff7d41, #ff7d41, #ff7e40, #ff7f40, #ff7f3f, #ff803f, #ff813e, 
  #ff813e, #ff823e, #ff823d, #ff833d, #ff843c, #ff843c, #ff853b, #ff863b, #ff863b, #ff873a, 
  #ff883a, #ff8839, #ff8939, #ff8a39, #ff8a38, #ff8b38, #ff8c37, #ff8c37, #ff8d37, #ff8e36, 
  #ff8e36, #fe8f36, #fe9035, #fe9035, #fd9135, #fd9234, #fc9234, #fc9334, #fc9433, #fb9433, 
  #fb9533, #fa9633, #fa9732, #f99732, #f99832, #f89932, #f89931, #f89a31, #f79b31, #f79b31, 
  #f69c30, #f69d30, #f59d30, #f59e30, #f49f30, #f4a030, #f3a02f, #f3a12f, #f2a22f, #f2a22f, 
  #f1a32f, #f1a42f, #f0a42f, #f0a52e, #efa62e, #efa62e, #eea72e, #eda82e, #eda92e, #eca92e, 
  #ecaa2e, #ebab2e, #ebab2e, #eaac2e, #eaad2e, #e9ad2e, #e9ae2e, #e8af2e, #e7b02e, #e7b02e, 
  #e6b12e, #e6b22e, #e5b22e, #e5b32e, #e4b42e, #e3b42e, #e3b52e, #e2b62e, #e2b62e, #e1b72e, 
  #e1b82e, #e0b92e, #dfb92e, #dfba2f, #debb2f, #debb2f, #ddbc2f, #dcbd2f, #dcbd2f, #dbbe30, 
  #dbbf30, #dabf30, #dac030, #d9c130, #d8c131, #d8c231, #d7c331, #d7c331, #d6c431, #d5c532, 
  #d5c532, #d4c632, #d4c733, #d3c733, #d2c833, #d2c933, #d1c934, #d1ca34, #d0cb34, #cfcb35, 
  #cfcc35, #cecd35, #cecd36, #cdce36, #cdce36, #cccf37, #cbd037, #cbd038, #cad138, #cad238, 
  #c9d239, #c8d339, #c8d43a, #c7d43a, #c7d53b, #c6d53b, #c6d63c, #c5d73c, #c5d73d, #c4d83d, 
  #c3d83e, #c3d93e, #c2da3f, #c2da3f, #c1db40, #c1db40, #c0dc41, #c0dd41, #bfdd42, #bfde42, 
  #bede43, #bddf44, #bddf44, #bce045, #bce045, #bbe146, #bbe247, #bae247, #bae348, #b9e349, 
  #b9e449, #b8e44a, #b8e54b, #b7e54b, #b7e64c, #b6e64d, #b6e74d, #b6e74e, #b5e84f, #b5e94f, 
  #b4e950, #b4ea51, #b3ea52, #b3eb52, #b2eb53, #b2eb54, #b2ec55, #b1ec55, #b1ed56, #b0ed57, 
  #b0ee58, #b0ee58, #afef59, #afef5a, #aeef5a, #adf05a, #acf059, #abf059, #aaf059, #a9f059, 
  #a8f058, #a7f058, #a6f158, #a4f158, #a3f158, #a2f158, #a1f157, #a0f157, #9ff157, #9ef257, 
  #9df257, #9cf257, #9bf257, #9af257, #99f257, #98f257, #97f356, #96f356, #95f356, #94f356, 
  #93f356, #92f356, #91f356, #90f356, #8ff356, #8ef456, #8df456, #8cf456, #8bf456, #8af456, 
  #89f456, #88f457, #87f457, #86f457, #85f457, #84f557, #82f557, #81f557, #80f557, #7ff557, 
  #7ef557, #7df558, #7cf558, #7bf558, #7af558, #79f558, #78f558, #77f559, #76f659, #75f659, 
  #74f659, #73f659, #72f65a, #71f65a, #70f65a, #70f65a, #6ff65b, #6ef65b, #6df65b, #6cf65c, 
  #6bf65c, #6af65c, #69f65c, #68f65d, #67f65d, #66f65d, #65f65e, #64f65e, #63f65e, #62f65f, 
  #61f65f, #60f65f, #5ff660, #5ff660, #5ef661, #5df661, #5cf661, #5bf662, #5af662, #59f663, 
  #58f663, #57f663, #56f664, #56f664, #55f665, #54f665, #53f666, #52f566, #51f567, #51f567, 
  #50f567, #4ff568, #4ef568, #4df569, #4cf569, #4cf56a, #4bf56a, #4af56b, #49f46c, #48f46c, 
  #48f46d, #47f46d, #46f46e, #45f46e, #45f46f, #44f46f, #43f470, #42f370, #42f371, #41f372, 
  #40f372, #3ff373, #3ff373, #3ef274, #3df274, #3df275, #3cf276, #3bf276, #3af277, #3af178, 
  #39f178, #38f179, #38f179, #37f17a, #36f07b, #36f07b, #35f07c, #35f07d, #34f07d, #33ef7e, 
  #33ef7e, #32ef7f, #32ef80, #31ee80, #30ee81, #30ee82, #2fee82, #2fed83, #2eed84, #2eed84, 
  #2ded85, #2dec86, #2cec86, #2cec87, #2bec88, #2beb89, #2aeb89, #2aeb8a, #29ea8b, #29ea8b, 
  #28ea8c, #28ea8d, #27e98d, #27e98e, #26e98f, #26e88f, #25e890, #25e891, #25e792, #24e792, 
  #24e793, #23e694, #23e694, #23e695, #22e596, #22e596, #22e597, #21e498, #21e499, #21e399, 
  #20e39a, #20e39b, #20e29b, #1fe29c, #1fe29d, #1fe19e, #1ee19e, #1ee09f, #1ee0a0, #1ee0a0, 
  #1ddfa1, #1ddfa2, #1ddea2, #1ddea3, #1cdda4, #1cdda5, #1cdda5, #1cdca6, #1cdca7, #1bdba7, 
  #1bdba8, #1bdaa9, #1bdaa9, #1bd9aa, #1ad9ab, #1ad9ab, #1ad8ac, #1ad8ad, #1ad7ad, #1ad7ae, 
  #1ad6af, #1ad6af, #19d5b0, #19d5b1, #19d4b1, #19d4b2, #19d3b3, #19d3b3, #19d2b4, #19d2b5, 
  #19d1b5, #19d1b6, #19d0b7, #19d0b7, #19cfb8, #19cfb9, #19ceb9, #19ceba, #19cdba, #19cdbb, 
  #19ccbc, #19cbbc, #19cbbd, #19cabe, #19cabe, #19c9bf, #19c9bf, #19c8c0, #19c8c1, #19c7c1, 
  #19c7c2, #19c6c2, #19c5c3, #19c5c3, #1ac4c4, #1ac4c5, #1ac3c5, #1ac3c6, #1ac2c6, #1ac1c7, 
  #1ac1c7, #1ac0c8, #1bc0c8, #1bbfc9, #1bbfc9, #1bbeca, #1bbdca, #1bbdcb, #1cbccb, #1cbccc, 
  #1cbbcc, #1cbacd, #1cbacd, #1db9ce, #1db9ce, #1db8cf, #1db7cf, #1db7d0, #1eb6d0, #1eb5d1, 
  #1eb5d1, #1eb4d2, #1fb4d2, #1fb3d2, #1fb2d3, #1fb2d3, #20b1d4, #20b0d4, #20b0d4, #20afd5, 
  #21afd5, #21aed6, #21add6, #22add6, #22acd7, #22abd7, #23abd7, #23aad8, #23aad8, #24a9d8, 
  #24a8d9, #24a8d9, #25a7d9, #25a6da, #25a6da, #26a5da, #26a4db, #26a4db, #27a3db, #27a2db, 
  #27a2dc, #28a1dc, #28a1dc, #29a0dc, #299fdd, #299fdd, #2a9edd, #2a9ddd, #2a9dde, #2b9cde, 
  #2b9bde, #2c9bde, #2c9ade, #2c99de, #2d99df, #2d98df, #2e97df, #2e97df, #2f96df, #2f95df, 
  #2f95e0, #3094e0, #3093e0, #3193e0, #3192e0, #3292e0, #3291e0, #3290e0, #3390e0, #338fe0, 
  #348ee1, #348ee1, #358de1, #358ce1, #368ce1, #368be1, #368ae1, #378ae1, #3789e1, #3888e1, 
  #3888e1, #3987e1, #3987e1, #3a86e1, #3a85e1, #3b85e1, #3b84e1, #3c83e1, #3c83e1, #3d82e1, 
  #3d81e0, #3d81e0, #3e80e0, #3e7fe0, #3f7fe0, #3f7ee0, #407ee0, #407de0, #417ce0, #417ce0, 
  #427bdf, #427adf, #437adf, #4379df, #4479df, #4478df, #4577de, #4577de, #4676de, #4675de, 
  #4675de, #4774dd, #4774dd, #4873dd, #4872dd, #4972dd, #4971dc, #4a71dc, #4a70dc, #4b6fdc, 
  #4b6fdb, #4c6edb, #4c6edb, #4d6dda, #4d6cda, #4e6cda, #4e6bda, #4e6bd9, #4f6ad9, #4f69d9, 
  #5069d8, #5068d8, #5168d8, #5167d7, #5267d7, #5266d7, #5265d6, #5365d6, #5364d6, #5464d5, 
  #5463d5, #5563d4, #5562d4, #5661d4, #5661d3, #5660d3, #5760d2, #575fd2, #585fd1, #585ed1, 
  #595ed1, #595dd0, #595dd0, #5a5ccf, #5a5ccf, #5b5bce, #5b5ace, #5b5acd, #5c59cd, #5c59cc, 
  #5d58cc, #5d58cb, #5d57cb, #5e57ca, #5e56ca, #5f56c9, #5f55c9, #5f55c8, #6054c8, #6054c7, 
  #6053c7, #6153c6, #6152c6, #6152c5, #6251c4, #6251c4, #6250c3, #6350c3, #634fc2, #634fc2, 
  #644ec1, #644ec0, #644ec0, #654dbf, #654dbf, #654cbe, #664cbd, #664bbd, #664bbc, #674abc, 
  #674abb, #6749ba, #6849ba, #6849b9, #6848b8, #6848b8, #6947b7, #6947b6, #6946b6, #6946b5, 
  #6a46b4, #6a45b4, #6a45b3, #6a44b2, #6b44b2, #6b44b1, #6b43b0, #6b43b0, #6c42af, #6c42ae, 
  #6c42ae, #6c41ad, #6c41ac, #6d40ac, #6d40ab, #6d40aa};
