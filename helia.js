import { createHelia } from "helia";

const helia = await createHelia()

// create a filesystem on top of Helia, in this case it's UnixFS
const fs = unixfs(helia)

// we will use this TextEncoder to turn strings into Uint8Arrays
const encoder = new TextEncoder()

// add the bytes to your node and receive a unique content identifier
const cid = await fs.addBytes(encoder.encode('Hello World 101'), {
  onProgress: (evt) => {
    console.info('add event', evt.type, evt.detail)
  }
})