
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 64 11 80       	mov    $0x801164f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 35 10 80       	mov    $0x801035f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 77 10 80       	push   $0x80107720
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 15 49 00 00       	call   80104970 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 77 10 80       	push   $0x80107727
80100097:	50                   	push   %eax
80100098:	e8 a3 47 00 00       	call   80104840 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 77 4a 00 00       	call   80104b60 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 99 49 00 00       	call   80104b00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 47 00 00       	call   80104880 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 26 00 00       	call   80102890 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 77 10 80       	push   $0x8010772e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 5d 47 00 00       	call   80104920 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 b7 26 00 00       	jmp    80102890 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 77 10 80       	push   $0x8010773f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 47 00 00       	call   80104920 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 46 00 00       	call   801048e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 40 49 00 00       	call   80104b60 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 92 48 00 00       	jmp    80104b00 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 46 77 10 80       	push   $0x80107746
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 a7 1b 00 00       	call   80101e40 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801002a0:	e8 bb 48 00 00       	call   80104b60 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002b5:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 ff 10 80       	push   $0x8010ff40
801002c8:	68 20 ff 10 80       	push   $0x8010ff20
801002cd:	e8 0e 43 00 00       	call   801045e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 3c 00 00       	call   80103f20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 05 48 00 00       	call   80104b00 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 5c 1a 00 00       	call   80101d60 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 ff 10 80    	mov    %edx,0x8010ff20
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 fe 10 80 	movsbl -0x7fef0160(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 ff 10 80       	push   $0x8010ff40
8010034c:	e8 af 47 00 00       	call   80104b00 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 06 1a 00 00       	call   80101d60 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 74 ff 10 80 00 	movl   $0x0,0x8010ff74
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 2a 00 00       	call   80102e90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 77 10 80       	push   $0x8010774d
801003a7:	e8 f4 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 03 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 cf 7b 10 80 	movl   $0x80107bcf,(%esp)
801003bc:	e8 df 03 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 45 00 00       	call   80104990 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 77 10 80       	push   $0x80107761
801003dd:	e8 be 03 00 00       	call   801007a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 ff 10 80 01 	movl   $0x1,0x8010ff78
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010041d:	89 da                	mov    %ebx,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042a:	c1 e6 08             	shl    $0x8,%esi
8010042d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042e:	89 da                	mov    %ebx,%edx
80100430:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100431:	0f b6 c0             	movzbl %al,%eax
80100434:	09 f0                	or     %esi,%eax
  if(c == '\n'){
80100436:	83 f9 0a             	cmp    $0xa,%ecx
80100439:	0f 84 91 00 00 00    	je     801004d0 <cgaputc+0xd0>
    else if (c == KEY_RIGHT)
8010043f:	81 f9 e5 00 00 00    	cmp    $0xe5,%ecx
80100445:	0f 84 15 01 00 00    	je     80100560 <cgaputc+0x160>
  else if (c == KEY_LEFT)
8010044b:	81 f9 e4 00 00 00    	cmp    $0xe4,%ecx
80100451:	0f 84 d9 00 00 00    	je     80100530 <cgaputc+0x130>
  else if(c == BACKSPACE){
80100457:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
8010045d:	0f 84 dd 00 00 00    	je     80100540 <cgaputc+0x140>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100463:	0f b6 c9             	movzbl %cl,%ecx
80100466:	8d 58 01             	lea    0x1(%eax),%ebx
80100469:	80 cd 07             	or     $0x7,%ch
8010046c:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100473:	80 
  if(pos < 0 || pos > 25*80)
80100474:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010047a:	0f 8f ec 00 00 00    	jg     8010056c <cgaputc+0x16c>
  if((pos/80) >= 24){  // Scroll up.
80100480:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100486:	7f 60                	jg     801004e8 <cgaputc+0xe8>
  outb(CRTPORT+1, pos>>8);
80100488:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
8010048b:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
8010048d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
80100494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100497:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049c:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a1:	89 da                	mov    %ebx,%edx
801004a3:	ee                   	out    %al,(%dx)
801004a4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004ad:	89 ca                	mov    %ecx,%edx
801004af:	ee                   	out    %al,(%dx)
801004b0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b5:	89 da                	mov    %ebx,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	89 f8                	mov    %edi,%eax
801004ba:	89 ca                	mov    %ecx,%edx
801004bc:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bd:	b8 20 07 00 00       	mov    $0x720,%eax
801004c2:	66 89 06             	mov    %ax,(%esi)
}
801004c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c8:	5b                   	pop    %ebx
801004c9:	5e                   	pop    %esi
801004ca:	5f                   	pop    %edi
801004cb:	5d                   	pop    %ebp
801004cc:	c3                   	ret
801004cd:	8d 76 00             	lea    0x0(%esi),%esi
    pos += 80 - pos%80;}
801004d0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004d5:	f7 e2                	mul    %edx
801004d7:	c1 ea 06             	shr    $0x6,%edx
801004da:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004dd:	c1 e0 04             	shl    $0x4,%eax
801004e0:	8d 58 50             	lea    0x50(%eax),%ebx
801004e3:	eb 8f                	jmp    80100474 <cgaputc+0x74>
801004e5:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004eb:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	68 60 0e 00 00       	push   $0xe60
801004fa:	68 a0 80 0b 80       	push   $0x800b80a0
801004ff:	68 00 80 0b 80       	push   $0x800b8000
80100504:	e8 e7 47 00 00       	call   80104cf0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100509:	b8 80 07 00 00       	mov    $0x780,%eax
8010050e:	83 c4 0c             	add    $0xc,%esp
80100511:	29 f8                	sub    %edi,%eax
80100513:	01 c0                	add    %eax,%eax
80100515:	50                   	push   %eax
80100516:	6a 00                	push   $0x0
80100518:	56                   	push   %esi
80100519:	e8 42 47 00 00       	call   80104c60 <memset>
  outb(CRTPORT+1, pos);
8010051e:	83 c4 10             	add    $0x10,%esp
80100521:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
80100525:	e9 6d ff ff ff       	jmp    80100497 <cgaputc+0x97>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    --pos;
80100530:	83 e8 01             	sub    $0x1,%eax
80100533:	ee                   	out    %al,(%dx)
}
80100534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100537:	5b                   	pop    %ebx
80100538:	5e                   	pop    %esi
80100539:	5f                   	pop    %edi
8010053a:	5d                   	pop    %ebp
8010053b:	c3                   	ret
8010053c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     --pos;
80100540:	8d 58 ff             	lea    -0x1(%eax),%ebx
    if(pos > 0) {
80100543:	85 c0                	test   %eax,%eax
80100545:	0f 85 29 ff ff ff    	jne    80100474 <cgaputc+0x74>
8010054b:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010054f:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100554:	31 ff                	xor    %edi,%edi
80100556:	e9 3c ff ff ff       	jmp    80100497 <cgaputc+0x97>
8010055b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    pos++;
80100560:	83 c0 01             	add    $0x1,%eax
80100563:	ee                   	out    %al,(%dx)
}
80100564:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100567:	5b                   	pop    %ebx
80100568:	5e                   	pop    %esi
80100569:	5f                   	pop    %edi
8010056a:	5d                   	pop    %ebp
8010056b:	c3                   	ret
    panic("pos under/overflow");
8010056c:	83 ec 0c             	sub    $0xc,%esp
8010056f:	68 65 77 10 80       	push   $0x80107765
80100574:	e8 07 fe ff ff       	call   80100380 <panic>
80100579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100580 <consputc>:
  if(panicked){
80100580:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100586:	85 d2                	test   %edx,%edx
80100588:	74 06                	je     80100590 <consputc+0x10>
  asm volatile("cli");
8010058a:	fa                   	cli
    for(;;)
8010058b:	eb fe                	jmp    8010058b <consputc+0xb>
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	56                   	push   %esi
80100594:	53                   	push   %ebx
80100595:	83 ec 10             	sub    $0x10,%esp
  if(c == BACKSPACE){
80100598:	3d 00 01 00 00       	cmp    $0x100,%eax
8010059d:	74 2f                	je     801005ce <consputc+0x4e>
  else if (c==KEY_LEFT){
8010059f:	3d e4 00 00 00       	cmp    $0xe4,%eax
801005a4:	0f 84 b4 00 00 00    	je     8010065e <consputc+0xde>
 else if(c==KEY_RIGHT){
801005aa:	3d e5 00 00 00       	cmp    $0xe5,%eax
801005af:	74 52                	je     80100603 <consputc+0x83>
  uartputc(c);
801005b1:	83 ec 0c             	sub    $0xc,%esp
801005b4:	50                   	push   %eax
801005b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801005b8:	e8 b3 5c 00 00       	call   80106270 <uartputc>
  cgaputc(c);
801005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c0:	83 c4 10             	add    $0x10,%esp
}
801005c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801005c6:	5b                   	pop    %ebx
801005c7:	5e                   	pop    %esi
801005c8:	5d                   	pop    %ebp
  cgaputc(c);
801005c9:	e9 32 fe ff ff       	jmp    80100400 <cgaputc>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005ce:	83 ec 0c             	sub    $0xc,%esp
801005d1:	6a 08                	push   $0x8
801005d3:	e8 98 5c 00 00       	call   80106270 <uartputc>
801005d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005df:	e8 8c 5c 00 00       	call   80106270 <uartputc>
801005e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005eb:	e8 80 5c 00 00       	call   80106270 <uartputc>
     cgaputc(c);
801005f0:	83 c4 10             	add    $0x10,%esp
}
801005f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cgaputc(c);
801005f6:	b8 00 01 00 00       	mov    $0x100,%eax
}
801005fb:	5b                   	pop    %ebx
801005fc:	5e                   	pop    %esi
801005fd:	5d                   	pop    %ebp
  cgaputc(c);
801005fe:	e9 fd fd ff ff       	jmp    80100400 <cgaputc>
   uartputc('\033'); 
80100603:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100606:	be d4 03 00 00       	mov    $0x3d4,%esi
8010060b:	6a 1b                	push   $0x1b
8010060d:	e8 5e 5c 00 00       	call   80106270 <uartputc>
  uartputc('[');
80100612:	c7 04 24 5b 00 00 00 	movl   $0x5b,(%esp)
80100619:	e8 52 5c 00 00       	call   80106270 <uartputc>
  uartputc('C');
8010061e:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80100625:	e8 46 5c 00 00       	call   80106270 <uartputc>
8010062a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010062f:	89 f2                	mov    %esi,%edx
80100631:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100632:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100637:	89 ca                	mov    %ecx,%edx
80100639:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010063a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010063d:	89 f2                	mov    %esi,%edx
8010063f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100644:	c1 e3 08             	shl    $0x8,%ebx
80100647:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010064b:	0f b6 c0             	movzbl %al,%eax
8010064e:	09 d8                	or     %ebx,%eax
    pos++;
80100650:	83 c0 01             	add    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100653:	ee                   	out    %al,(%dx)
    return;
80100654:	83 c4 10             	add    $0x10,%esp
}
80100657:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5d                   	pop    %ebp
8010065d:	c3                   	ret
       uartputc('\b');
8010065e:	83 ec 0c             	sub    $0xc,%esp
80100661:	be d4 03 00 00       	mov    $0x3d4,%esi
80100666:	6a 08                	push   $0x8
80100668:	e8 03 5c 00 00       	call   80106270 <uartputc>
8010066d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100672:	89 f2                	mov    %esi,%edx
80100674:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100675:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010067a:	89 ca                	mov    %ecx,%edx
8010067c:	ec                   	in     (%dx),%al
8010067d:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100680:	89 f2                	mov    %esi,%edx
80100682:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT+1) << 8;
80100687:	c1 e3 08             	shl    $0x8,%ebx
8010068a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010068b:	89 ca                	mov    %ecx,%edx
8010068d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010068e:	0f b6 c0             	movzbl %al,%eax
80100691:	09 d8                	or     %ebx,%eax
    --pos;
80100693:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100696:	ee                   	out    %al,(%dx)
    return;
80100697:	83 c4 10             	add    $0x10,%esp
8010069a:	eb bb                	jmp    80100657 <consputc+0xd7>
8010069c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801006a0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 18             	sub    $0x18,%esp
801006a9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801006ac:	ff 75 08             	push   0x8(%ebp)
801006af:	e8 8c 17 00 00       	call   80101e40 <iunlock>
  acquire(&cons.lock);
801006b4:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801006bb:	e8 a0 44 00 00       	call   80104b60 <acquire>
  for(i = 0; i < n; i++)
801006c0:	83 c4 10             	add    $0x10,%esp
801006c3:	85 f6                	test   %esi,%esi
801006c5:	7e 18                	jle    801006df <consolewrite+0x3f>
801006c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006ca:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006cd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801006d0:	0f b6 07             	movzbl (%edi),%eax
  for(i = 0; i < n; i++)
801006d3:	83 c7 01             	add    $0x1,%edi
    consputc(buf[i] & 0xff);
801006d6:	e8 a5 fe ff ff       	call   80100580 <consputc>
  for(i = 0; i < n; i++)
801006db:	39 df                	cmp    %ebx,%edi
801006dd:	75 f1                	jne    801006d0 <consolewrite+0x30>
  release(&cons.lock); 
801006df:	83 ec 0c             	sub    $0xc,%esp
801006e2:	68 40 ff 10 80       	push   $0x8010ff40
801006e7:	e8 14 44 00 00       	call   80104b00 <release>
  ilock(ip);
801006ec:	58                   	pop    %eax
801006ed:	ff 75 08             	push   0x8(%ebp)
801006f0:	e8 6b 16 00 00       	call   80101d60 <ilock>

  return n;
}
801006f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006f8:	89 f0                	mov    %esi,%eax
801006fa:	5b                   	pop    %ebx
801006fb:	5e                   	pop    %esi
801006fc:	5f                   	pop    %edi
801006fd:	5d                   	pop    %ebp
801006fe:	c3                   	ret
801006ff:	90                   	nop

80100700 <printint>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	89 d3                	mov    %edx,%ebx
80100708:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010070b:	85 c0                	test   %eax,%eax
8010070d:	79 05                	jns    80100714 <printint+0x14>
8010070f:	83 e1 01             	and    $0x1,%ecx
80100712:	75 6a                	jne    8010077e <printint+0x7e>
    x = xx;
80100714:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010071b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010071d:	31 f6                	xor    %esi,%esi
8010071f:	90                   	nop
    buf[i++] = digits[x % base];
80100720:	89 c8                	mov    %ecx,%eax
80100722:	31 d2                	xor    %edx,%edx
80100724:	89 f7                	mov    %esi,%edi
80100726:	f7 f3                	div    %ebx
80100728:	8d 76 01             	lea    0x1(%esi),%esi
8010072b:	0f b6 92 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%edx
80100732:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100736:	89 ca                	mov    %ecx,%edx
80100738:	89 c1                	mov    %eax,%ecx
8010073a:	39 da                	cmp    %ebx,%edx
8010073c:	73 e2                	jae    80100720 <printint+0x20>
  if(sign)
8010073e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100741:	85 d2                	test   %edx,%edx
80100743:	74 07                	je     8010074c <printint+0x4c>
    buf[i++] = '-';
80100745:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010074a:	89 f7                	mov    %esi,%edi
8010074c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010074f:	01 f7                	add    %esi,%edi
  if(panicked){
80100751:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
    consputc(buf[i]);
80100756:	0f be 1f             	movsbl (%edi),%ebx
  if(panicked){
80100759:	85 c0                	test   %eax,%eax
8010075b:	74 03                	je     80100760 <printint+0x60>
  asm volatile("cli");
8010075d:	fa                   	cli
    for(;;)
8010075e:	eb fe                	jmp    8010075e <printint+0x5e>
  uartputc(c);
80100760:	83 ec 0c             	sub    $0xc,%esp
80100763:	53                   	push   %ebx
80100764:	e8 07 5b 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100769:	89 d8                	mov    %ebx,%eax
8010076b:	e8 90 fc ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100770:	8d 47 ff             	lea    -0x1(%edi),%eax
80100773:	83 c4 10             	add    $0x10,%esp
80100776:	39 f7                	cmp    %esi,%edi
80100778:	74 11                	je     8010078b <printint+0x8b>
8010077a:	89 c7                	mov    %eax,%edi
8010077c:	eb d3                	jmp    80100751 <printint+0x51>
    x = -xx;
8010077e:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
80100780:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80100787:	89 c1                	mov    %eax,%ecx
80100789:	eb 92                	jmp    8010071d <printint+0x1d>
}
8010078b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010078e:	5b                   	pop    %ebx
8010078f:	5e                   	pop    %esi
80100790:	5f                   	pop    %edi
80100791:	5d                   	pop    %ebp
80100792:	c3                   	ret
80100793:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010079a:	00 
8010079b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801007a0 <cprintf>:
{
801007a0:	55                   	push   %ebp
801007a1:	89 e5                	mov    %esp,%ebp
801007a3:	57                   	push   %edi
801007a4:	56                   	push   %esi
801007a5:	53                   	push   %ebx
801007a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007a9:	8b 3d 74 ff 10 80    	mov    0x8010ff74,%edi
  if (fmt == 0)
801007af:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801007b2:	85 ff                	test   %edi,%edi
801007b4:	0f 85 26 01 00 00    	jne    801008e0 <cprintf+0x140>
  if (fmt == 0)
801007ba:	85 f6                	test   %esi,%esi
801007bc:	0f 84 e2 01 00 00    	je     801009a4 <cprintf+0x204>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007c2:	0f b6 06             	movzbl (%esi),%eax
801007c5:	85 c0                	test   %eax,%eax
801007c7:	74 63                	je     8010082c <cprintf+0x8c>
  argp = (uint*)(void*)(&fmt + 1);
801007c9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801007cf:	31 db                	xor    %ebx,%ebx
801007d1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801007d3:	83 f8 25             	cmp    $0x25,%eax
801007d6:	75 60                	jne    80100838 <cprintf+0x98>
    c = fmt[++i] & 0xff;
801007d8:	83 c3 01             	add    $0x1,%ebx
801007db:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801007df:	85 c9                	test   %ecx,%ecx
801007e1:	74 3e                	je     80100821 <cprintf+0x81>
    switch(c){
801007e3:	83 f9 70             	cmp    $0x70,%ecx
801007e6:	0f 84 c4 00 00 00    	je     801008b0 <cprintf+0x110>
801007ec:	7f 6a                	jg     80100858 <cprintf+0xb8>
801007ee:	83 f9 25             	cmp    $0x25,%ecx
801007f1:	0f 84 d9 00 00 00    	je     801008d0 <cprintf+0x130>
801007f7:	83 f9 64             	cmp    $0x64,%ecx
801007fa:	75 66                	jne    80100862 <cprintf+0xc2>
      printint(*argp++, 10, 1);
801007fc:	8d 47 04             	lea    0x4(%edi),%eax
801007ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80100804:	ba 0a 00 00 00       	mov    $0xa,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100809:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 10, 1);
8010080c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010080f:	8b 07                	mov    (%edi),%eax
80100811:	e8 ea fe ff ff       	call   80100700 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100816:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 10, 1);
8010081a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010081d:	85 c0                	test   %eax,%eax
8010081f:	75 b2                	jne    801007d3 <cprintf+0x33>
80100821:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100824:	85 ff                	test   %edi,%edi
80100826:	0f 85 d7 00 00 00    	jne    80100903 <cprintf+0x163>
}
8010082c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010082f:	5b                   	pop    %ebx
80100830:	5e                   	pop    %esi
80100831:	5f                   	pop    %edi
80100832:	5d                   	pop    %ebp
80100833:	c3                   	ret
80100834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc(c);
80100838:	e8 43 fd ff ff       	call   80100580 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010083d:	83 c3 01             	add    $0x1,%ebx
80100840:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100844:	85 c0                	test   %eax,%eax
80100846:	75 8b                	jne    801007d3 <cprintf+0x33>
80100848:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010084b:	85 ff                	test   %edi,%edi
8010084d:	74 dd                	je     8010082c <cprintf+0x8c>
8010084f:	e9 af 00 00 00       	jmp    80100903 <cprintf+0x163>
80100854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100858:	83 f9 73             	cmp    $0x73,%ecx
8010085b:	74 1b                	je     80100878 <cprintf+0xd8>
8010085d:	83 f9 78             	cmp    $0x78,%ecx
80100860:	74 4e                	je     801008b0 <cprintf+0x110>
  if(panicked){
80100862:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
80100867:	85 c0                	test   %eax,%eax
80100869:	0f 84 c5 00 00 00    	je     80100934 <cprintf+0x194>
8010086f:	fa                   	cli
    for(;;)
80100870:	eb fe                	jmp    80100870 <cprintf+0xd0>
80100872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if((s = (char*)*argp++) == 0)
80100878:	8b 17                	mov    (%edi),%edx
8010087a:	8d 47 04             	lea    0x4(%edi),%eax
8010087d:	85 d2                	test   %edx,%edx
8010087f:	0f 84 d6 00 00 00    	je     8010095b <cprintf+0x1bb>
      for(; *s; s++)
80100885:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100888:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
8010088a:	84 c9                	test   %cl,%cl
8010088c:	0f 84 0b 01 00 00    	je     8010099d <cprintf+0x1fd>
80100892:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100895:	89 fb                	mov    %edi,%ebx
80100897:	89 f7                	mov    %esi,%edi
80100899:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010089c:	89 c8                	mov    %ecx,%eax
  if(panicked){
8010089e:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801008a4:	85 c9                	test   %ecx,%ecx
801008a6:	0f 84 be 00 00 00    	je     8010096a <cprintf+0x1ca>
801008ac:	fa                   	cli
    for(;;)
801008ad:	eb fe                	jmp    801008ad <cprintf+0x10d>
801008af:	90                   	nop
      printint(*argp++, 16, 0);
801008b0:	8d 47 04             	lea    0x4(%edi),%eax
801008b3:	31 c9                	xor    %ecx,%ecx
801008b5:	ba 10 00 00 00       	mov    $0x10,%edx
801008ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008bd:	8b 07                	mov    (%edi),%eax
801008bf:	e8 3c fe ff ff       	call   80100700 <printint>
801008c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801008c7:	e9 71 ff ff ff       	jmp    8010083d <cprintf+0x9d>
801008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008d0:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
801008d6:	85 d2                	test   %edx,%edx
801008d8:	74 3e                	je     80100918 <cprintf+0x178>
801008da:	fa                   	cli
    for(;;)
801008db:	eb fe                	jmp    801008db <cprintf+0x13b>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801008e0:	83 ec 0c             	sub    $0xc,%esp
801008e3:	68 40 ff 10 80       	push   $0x8010ff40
801008e8:	e8 73 42 00 00       	call   80104b60 <acquire>
  if (fmt == 0)
801008ed:	83 c4 10             	add    $0x10,%esp
801008f0:	85 f6                	test   %esi,%esi
801008f2:	0f 84 ac 00 00 00    	je     801009a4 <cprintf+0x204>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008f8:	0f b6 06             	movzbl (%esi),%eax
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 85 c6 fe ff ff    	jne    801007c9 <cprintf+0x29>
    release(&cons.lock);
80100903:	83 ec 0c             	sub    $0xc,%esp
80100906:	68 40 ff 10 80       	push   $0x8010ff40
8010090b:	e8 f0 41 00 00       	call   80104b00 <release>
80100910:	83 c4 10             	add    $0x10,%esp
80100913:	e9 14 ff ff ff       	jmp    8010082c <cprintf+0x8c>
  uartputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	6a 25                	push   $0x25
8010091d:	e8 4e 59 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100922:	b8 25 00 00 00       	mov    $0x25,%eax
80100927:	e8 d4 fa ff ff       	call   80100400 <cgaputc>
}
8010092c:	83 c4 10             	add    $0x10,%esp
8010092f:	e9 09 ff ff ff       	jmp    8010083d <cprintf+0x9d>
  uartputc(c);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010093a:	6a 25                	push   $0x25
8010093c:	e8 2f 59 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100941:	b8 25 00 00 00       	mov    $0x25,%eax
80100946:	e8 b5 fa ff ff       	call   80100400 <cgaputc>
      consputc(c);
8010094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010094e:	e8 2d fc ff ff       	call   80100580 <consputc>
      break;
80100953:	83 c4 10             	add    $0x10,%esp
80100956:	e9 e2 fe ff ff       	jmp    8010083d <cprintf+0x9d>
8010095b:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100960:	bf 78 77 10 80       	mov    $0x80107778,%edi
80100965:	e9 28 ff ff ff       	jmp    80100892 <cprintf+0xf2>
  uartputc(c);
8010096a:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010096d:	0f be f0             	movsbl %al,%esi
      for(; *s; s++)
80100970:	83 c3 01             	add    $0x1,%ebx
  uartputc(c);
80100973:	56                   	push   %esi
80100974:	e8 f7 58 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100979:	89 f0                	mov    %esi,%eax
8010097b:	e8 80 fa ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
80100980:	0f b6 03             	movzbl (%ebx),%eax
80100983:	83 c4 10             	add    $0x10,%esp
80100986:	84 c0                	test   %al,%al
80100988:	0f 85 10 ff ff ff    	jne    8010089e <cprintf+0xfe>
      if((s = (char*)*argp++) == 0)
8010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100991:	89 fe                	mov    %edi,%esi
80100993:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100996:	89 c7                	mov    %eax,%edi
80100998:	e9 a0 fe ff ff       	jmp    8010083d <cprintf+0x9d>
8010099d:	89 c7                	mov    %eax,%edi
8010099f:	e9 99 fe ff ff       	jmp    8010083d <cprintf+0x9d>
    panic("null fmt");
801009a4:	83 ec 0c             	sub    $0xc,%esp
801009a7:	68 7f 77 10 80       	push   $0x8010777f
801009ac:	e8 cf f9 ff ff       	call   80100380 <panic>
801009b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801009b8:	00 
801009b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801009c0 <printbuf>:
void printbuf() {
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	56                   	push   %esi
801009c4:	53                   	push   %ebx
   for(uint i=input.e+1 ; i<input.end_pos ; i++ ){
801009c5:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801009ca:	8d 58 01             	lea    0x1(%eax),%ebx
801009cd:	3b 1d 2c ff 10 80    	cmp    0x8010ff2c,%ebx
801009d3:	73 3c                	jae    80100a11 <printbuf+0x51>
    consputc(input.buf[i%INPUT_BUF]);
801009d5:	89 d8                	mov    %ebx,%eax
  if(panicked){
801009d7:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
    consputc(input.buf[i%INPUT_BUF]);
801009dd:	83 e0 7f             	and    $0x7f,%eax
801009e0:	0f b6 80 a0 fe 10 80 	movzbl -0x7fef0160(%eax),%eax
  if(panicked){
801009e7:	85 d2                	test   %edx,%edx
801009e9:	74 05                	je     801009f0 <printbuf+0x30>
801009eb:	fa                   	cli
    for(;;)
801009ec:	eb fe                	jmp    801009ec <printbuf+0x2c>
801009ee:	66 90                	xchg   %ax,%ax
  uartputc(c);
801009f0:	83 ec 0c             	sub    $0xc,%esp
    consputc(input.buf[i%INPUT_BUF]);
801009f3:	0f be f0             	movsbl %al,%esi
   for(uint i=input.e+1 ; i<input.end_pos ; i++ ){
801009f6:	83 c3 01             	add    $0x1,%ebx
  uartputc(c);
801009f9:	56                   	push   %esi
801009fa:	e8 71 58 00 00       	call   80106270 <uartputc>
  cgaputc(c);
801009ff:	89 f0                	mov    %esi,%eax
80100a01:	e8 fa f9 ff ff       	call   80100400 <cgaputc>
   for(uint i=input.e+1 ; i<input.end_pos ; i++ ){
80100a06:	83 c4 10             	add    $0x10,%esp
80100a09:	3b 1d 2c ff 10 80    	cmp    0x8010ff2c,%ebx
80100a0f:	72 c4                	jb     801009d5 <printbuf+0x15>
}
80100a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100a14:	5b                   	pop    %ebx
80100a15:	5e                   	pop    %esi
80100a16:	5d                   	pop    %ebp
80100a17:	c3                   	ret
80100a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a1f:	00 

80100a20 <set_cursor>:
{
80100a20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a21:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a26:	89 e5                	mov    %esp,%ebp
80100a28:	56                   	push   %esi
80100a29:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a2e:	53                   	push   %ebx
80100a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100a32:	89 f2                	mov    %esi,%edx
80100a34:	ee                   	out    %al,(%dx)
80100a35:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
80100a3a:	89 c8                	mov    %ecx,%eax
80100a3c:	c1 f8 08             	sar    $0x8,%eax
80100a3f:	89 da                	mov    %ebx,%edx
80100a41:	ee                   	out    %al,(%dx)
80100a42:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a47:	89 f2                	mov    %esi,%edx
80100a49:	ee                   	out    %al,(%dx)
80100a4a:	89 c8                	mov    %ecx,%eax
80100a4c:	89 da                	mov    %ebx,%edx
80100a4e:	ee                   	out    %al,(%dx)
}
80100a4f:	5b                   	pop    %ebx
80100a50:	5e                   	pop    %esi
80100a51:	5d                   	pop    %ebp
80100a52:	c3                   	ret
80100a53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5a:	00 
80100a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100a60 <move_cursor>:
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	57                   	push   %edi
80100a64:	bf 0e 00 00 00       	mov    $0xe,%edi
80100a69:	56                   	push   %esi
80100a6a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a6f:	89 f8                	mov    %edi,%eax
80100a71:	53                   	push   %ebx
80100a72:	89 f2                	mov    %esi,%edx
80100a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a75:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100a7a:	89 da                	mov    %ebx,%edx
80100a7c:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100a7d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a80:	89 f2                	mov    %esi,%edx
80100a82:	c1 e0 08             	shl    $0x8,%eax
80100a85:	89 c1                	mov    %eax,%ecx
80100a87:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a8d:	89 da                	mov    %ebx,%edx
80100a8f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100a90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a93:	89 f2                	mov    %esi,%edx
80100a95:	09 c1                	or     %eax,%ecx
  if(pos >= 25*80) pos = 25*80 - 1;
80100a97:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100a9c:	03 4d 08             	add    0x8(%ebp),%ecx
  if(pos >= 25*80) pos = 25*80 - 1;
80100a9f:	39 c1                	cmp    %eax,%ecx
80100aa1:	0f 4f c8             	cmovg  %eax,%ecx
80100aa4:	31 c0                	xor    %eax,%eax
80100aa6:	85 c9                	test   %ecx,%ecx
80100aa8:	0f 48 c8             	cmovs  %eax,%ecx
80100aab:	89 f8                	mov    %edi,%eax
80100aad:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos >> 8);
80100aae:	89 cf                	mov    %ecx,%edi
80100ab0:	89 da                	mov    %ebx,%edx
80100ab2:	c1 ff 08             	sar    $0x8,%edi
80100ab5:	89 f8                	mov    %edi,%eax
80100ab7:	ee                   	out    %al,(%dx)
80100ab8:	b8 0f 00 00 00       	mov    $0xf,%eax
80100abd:	89 f2                	mov    %esi,%edx
80100abf:	ee                   	out    %al,(%dx)
80100ac0:	89 c8                	mov    %ecx,%eax
80100ac2:	89 da                	mov    %ebx,%edx
80100ac4:	ee                   	out    %al,(%dx)
}
80100ac5:	5b                   	pop    %ebx
80100ac6:	5e                   	pop    %esi
80100ac7:	5f                   	pop    %edi
80100ac8:	5d                   	pop    %ebp
80100ac9:	c3                   	ret
80100aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ad0 <move_chars_left>:
void move_chars_left(){
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	57                   	push   %edi
80100ad4:	56                   	push   %esi
80100ad5:	53                   	push   %ebx
80100ad6:	83 ec 0c             	sub    $0xc,%esp
for (uint i=input.e ; i<input.end_pos-1 ; i++){
80100ad9:	8b 3d 2c ff 10 80    	mov    0x8010ff2c,%edi
80100adf:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100ae4:	8d 57 ff             	lea    -0x1(%edi),%edx
80100ae7:	39 d0                	cmp    %edx,%eax
80100ae9:	73 48                	jae    80100b33 <move_chars_left+0x63>
  input.buf[i % INPUT_BUF]=input.buf[(i+1)%INPUT_BUF];
80100aeb:	8d 70 01             	lea    0x1(%eax),%esi
80100aee:	83 e0 7f             	and    $0x7f,%eax
80100af1:	89 f2                	mov    %esi,%edx
80100af3:	83 e2 7f             	and    $0x7f,%edx
80100af6:	0f be 9a a0 fe 10 80 	movsbl -0x7fef0160(%edx),%ebx
80100afd:	88 98 a0 fe 10 80    	mov    %bl,-0x7fef0160(%eax)
  if(panicked){
80100b03:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
80100b08:	85 c0                	test   %eax,%eax
80100b0a:	74 04                	je     80100b10 <move_chars_left+0x40>
  asm volatile("cli");
80100b0c:	fa                   	cli
    for(;;)
80100b0d:	eb fe                	jmp    80100b0d <move_chars_left+0x3d>
80100b0f:	90                   	nop
  uartputc(c);
80100b10:	83 ec 0c             	sub    $0xc,%esp
80100b13:	53                   	push   %ebx
80100b14:	e8 57 57 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100b19:	89 d8                	mov    %ebx,%eax
80100b1b:	e8 e0 f8 ff ff       	call   80100400 <cgaputc>
for (uint i=input.e ; i<input.end_pos-1 ; i++){
80100b20:	a1 2c ff 10 80       	mov    0x8010ff2c,%eax
80100b25:	83 c4 10             	add    $0x10,%esp
80100b28:	83 e8 01             	sub    $0x1,%eax
80100b2b:	39 c6                	cmp    %eax,%esi
80100b2d:	73 04                	jae    80100b33 <move_chars_left+0x63>
80100b2f:	89 f0                	mov    %esi,%eax
80100b31:	eb b8                	jmp    80100aeb <move_chars_left+0x1b>
uartputc(' ');
80100b33:	83 ec 0c             	sub    $0xc,%esp
80100b36:	6a 20                	push   $0x20
80100b38:	e8 33 57 00 00       	call   80106270 <uartputc>
for (uint i=input.e ; i<input.end_pos-1 ; i++){
80100b3d:	a1 2c ff 10 80       	mov    0x8010ff2c,%eax
80100b42:	8b 3d 28 ff 10 80    	mov    0x8010ff28,%edi
80100b48:	83 c4 10             	add    $0x10,%esp
80100b4b:	83 e8 01             	sub    $0x1,%eax
80100b4e:	39 c7                	cmp    %eax,%edi
80100b50:	0f 83 7f 00 00 00    	jae    80100bd5 <move_chars_left+0x105>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b56:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b60:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b65:	89 f2                	mov    %esi,%edx
80100b67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b68:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b6d:	89 da                	mov    %ebx,%edx
80100b6f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100b70:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b73:	89 f2                	mov    %esi,%edx
80100b75:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b7a:	c1 e1 08             	shl    $0x8,%ecx
80100b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b7e:	89 da                	mov    %ebx,%edx
80100b80:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100b81:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b84:	89 f2                	mov    %esi,%edx
80100b86:	09 c1                	or     %eax,%ecx
  if(pos >= 25*80) pos = 25*80 - 1;
80100b88:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100b8d:	83 e9 01             	sub    $0x1,%ecx
  if(pos >= 25*80) pos = 25*80 - 1;
80100b90:	39 c1                	cmp    %eax,%ecx
80100b92:	0f 4f c8             	cmovg  %eax,%ecx
80100b95:	31 c0                	xor    %eax,%eax
80100b97:	85 c9                	test   %ecx,%ecx
80100b99:	0f 48 c8             	cmovs  %eax,%ecx
80100b9c:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ba1:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos >> 8);
80100ba2:	89 ca                	mov    %ecx,%edx
80100ba4:	c1 fa 08             	sar    $0x8,%edx
80100ba7:	89 d0                	mov    %edx,%eax
80100ba9:	89 da                	mov    %ebx,%edx
80100bab:	ee                   	out    %al,(%dx)
80100bac:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bb1:	89 f2                	mov    %esi,%edx
80100bb3:	ee                   	out    %al,(%dx)
80100bb4:	89 c8                	mov    %ecx,%eax
80100bb6:	89 da                	mov    %ebx,%edx
80100bb8:	ee                   	out    %al,(%dx)
  uartputc('\b');
80100bb9:	83 ec 0c             	sub    $0xc,%esp
for (uint i=input.e ; i<input.end_pos-1 ; i++){
80100bbc:	83 c7 01             	add    $0x1,%edi
  uartputc('\b');
80100bbf:	6a 08                	push   $0x8
80100bc1:	e8 aa 56 00 00       	call   80106270 <uartputc>
for (uint i=input.e ; i<input.end_pos-1 ; i++){
80100bc6:	a1 2c ff 10 80       	mov    0x8010ff2c,%eax
80100bcb:	83 c4 10             	add    $0x10,%esp
80100bce:	83 e8 01             	sub    $0x1,%eax
80100bd1:	39 c7                	cmp    %eax,%edi
80100bd3:	72 8b                	jb     80100b60 <move_chars_left+0x90>
}
80100bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bd8:	5b                   	pop    %ebx
80100bd9:	5e                   	pop    %esi
80100bda:	5f                   	pop    %edi
80100bdb:	5d                   	pop    %ebp
80100bdc:	c3                   	ret
80100bdd:	8d 76 00             	lea    0x0(%esi),%esi

80100be0 <consoleintr>:
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	57                   	push   %edi
80100be4:	56                   	push   %esi
80100be5:	53                   	push   %ebx
80100be6:	83 ec 28             	sub    $0x28,%esp
80100be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100bec:	68 40 ff 10 80       	push   $0x8010ff40
80100bf1:	e8 6a 3f 00 00       	call   80104b60 <acquire>
  if(input.e > input.end_pos){
80100bf6:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	39 05 2c ff 10 80    	cmp    %eax,0x8010ff2c
80100c04:	73 05                	jae    80100c0b <consoleintr+0x2b>
    input.end_pos=input.e;
80100c06:	a3 2c ff 10 80       	mov    %eax,0x8010ff2c
    switch(c){
80100c0b:	31 ff                	xor    %edi,%edi
  while((c = getc()) >= 0){
80100c0d:	ff d3                	call   *%ebx
80100c0f:	85 c0                	test   %eax,%eax
80100c11:	0f 88 39 01 00 00    	js     80100d50 <consoleintr+0x170>
    switch(c){
80100c17:	83 f8 15             	cmp    $0x15,%eax
80100c1a:	0f 84 d8 01 00 00    	je     80100df8 <consoleintr+0x218>
80100c20:	7f 3e                	jg     80100c60 <consoleintr+0x80>
80100c22:	83 f8 08             	cmp    $0x8,%eax
80100c25:	0f 84 45 01 00 00    	je     80100d70 <consoleintr+0x190>
80100c2b:	83 f8 10             	cmp    $0x10,%eax
80100c2e:	0f 84 b4 01 00 00    	je     80100de8 <consoleintr+0x208>
80100c34:	83 f8 01             	cmp    $0x1,%eax
80100c37:	0f 85 66 02 00 00    	jne    80100ea3 <consoleintr+0x2c3>
        consputc(input.buf[input.e % INPUT_BUF]);
80100c3d:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
  if(panicked){
80100c42:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        consputc(input.buf[input.e % INPUT_BUF]);
80100c48:	83 e0 7f             	and    $0x7f,%eax
80100c4b:	0f b6 80 a0 fe 10 80 	movzbl -0x7fef0160(%eax),%eax
  if(panicked){
80100c52:	85 d2                	test   %edx,%edx
80100c54:	0f 84 2e 02 00 00    	je     80100e88 <consoleintr+0x2a8>
  asm volatile("cli");
80100c5a:	fa                   	cli
    for(;;)
80100c5b:	eb fe                	jmp    80100c5b <consoleintr+0x7b>
80100c5d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100c60:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100c65:	0f 84 55 01 00 00    	je     80100dc0 <consoleintr+0x1e0>
80100c6b:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100c70:	0f 84 aa 00 00 00    	je     80100d20 <consoleintr+0x140>
80100c76:	83 f8 7f             	cmp    $0x7f,%eax
80100c79:	0f 84 f1 00 00 00    	je     80100d70 <consoleintr+0x190>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c7f:	8b 15 28 ff 10 80    	mov    0x8010ff28,%edx
80100c85:	89 d1                	mov    %edx,%ecx
80100c87:	2b 0d 20 ff 10 80    	sub    0x8010ff20,%ecx
80100c8d:	83 f9 7f             	cmp    $0x7f,%ecx
80100c90:	0f 87 77 ff ff ff    	ja     80100c0d <consoleintr+0x2d>
         if(input.e <input.end_pos){
80100c96:	8b 35 2c ff 10 80    	mov    0x8010ff2c,%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100c9c:	89 d1                	mov    %edx,%ecx
80100c9e:	83 e1 7f             	and    $0x7f,%ecx
         if(input.e <input.end_pos){
80100ca1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100ca4:	8d 72 01             	lea    0x1(%edx),%esi
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
80100ca7:	83 f8 0a             	cmp    $0xa,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100caa:	88 81 a0 fe 10 80    	mov    %al,-0x7fef0160(%ecx)
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
80100cb0:	0f 94 c1             	sete   %cl
80100cb3:	83 f8 04             	cmp    $0x4,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100cb6:	89 35 28 ff 10 80    	mov    %esi,0x8010ff28
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
80100cbc:	89 ce                	mov    %ecx,%esi
80100cbe:	0f 94 c1             	sete   %cl
80100cc1:	09 ce                	or     %ecx,%esi
        if(input.e==input.end_pos+1){
80100cc3:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80100cc6:	0f 84 22 03 00 00    	je     80100fee <consoleintr+0x40e>
        consputc(c);
80100ccc:	e8 af f8 ff ff       	call   80100580 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
80100cd1:	89 f0                	mov    %esi,%eax
80100cd3:	84 c0                	test   %al,%al
80100cd5:	0f 85 23 02 00 00    	jne    80100efe <consoleintr+0x31e>
80100cdb:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80100ce0:	83 e8 80             	sub    $0xffffff80,%eax
80100ce3:	39 05 28 ff 10 80    	cmp    %eax,0x8010ff28
80100ce9:	0f 85 1e ff ff ff    	jne    80100c0d <consoleintr+0x2d>
          wakeup(&input.r);
80100cef:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100cf2:	a3 24 ff 10 80       	mov    %eax,0x8010ff24
          x=0;
80100cf7:	c7 05 80 fe 10 80 00 	movl   $0x0,0x8010fe80
80100cfe:	00 00 00 
          input.end_pos=input.e;
80100d01:	a3 2c ff 10 80       	mov    %eax,0x8010ff2c
          wakeup(&input.r);
80100d06:	68 20 ff 10 80       	push   $0x8010ff20
80100d0b:	e8 90 39 00 00       	call   801046a0 <wakeup>
80100d10:	83 c4 10             	add    $0x10,%esp
80100d13:	e9 f5 fe ff ff       	jmp    80100c0d <consoleintr+0x2d>
80100d18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d1f:	00 
         if(input.e <input.end_pos){
80100d20:	a1 2c ff 10 80       	mov    0x8010ff2c,%eax
80100d25:	39 05 28 ff 10 80    	cmp    %eax,0x8010ff28
80100d2b:	0f 83 dc fe ff ff    	jae    80100c0d <consoleintr+0x2d>
          consputc(KEY_RIGHT);
80100d31:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d36:	e8 45 f8 ff ff       	call   80100580 <consputc>
          input.e++;
80100d3b:	83 05 28 ff 10 80 01 	addl   $0x1,0x8010ff28
  while((c = getc()) >= 0){
80100d42:	ff d3                	call   *%ebx
80100d44:	85 c0                	test   %eax,%eax
80100d46:	0f 89 cb fe ff ff    	jns    80100c17 <consoleintr+0x37>
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	68 40 ff 10 80       	push   $0x8010ff40
80100d58:	e8 a3 3d 00 00       	call   80104b00 <release>
  if(doprocdump) {
80100d5d:	83 c4 10             	add    $0x10,%esp
80100d60:	85 ff                	test   %edi,%edi
80100d62:	0f 85 b8 01 00 00    	jne    80100f20 <consoleintr+0x340>
}
80100d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d6b:	5b                   	pop    %ebx
80100d6c:	5e                   	pop    %esi
80100d6d:	5f                   	pop    %edi
80100d6e:	5d                   	pop    %ebp
80100d6f:	c3                   	ret
      if(input.e != input.w){
80100d70:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100d75:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
80100d7b:	0f 84 8c fe ff ff    	je     80100c0d <consoleintr+0x2d>
        if(middle){
80100d81:	8b 0d 84 fe 10 80    	mov    0x8010fe84,%ecx
80100d87:	85 c9                	test   %ecx,%ecx
80100d89:	74 07                	je     80100d92 <consoleintr+0x1b2>
          x++;
80100d8b:	83 05 80 fe 10 80 01 	addl   $0x1,0x8010fe80
        input.e--;
80100d92:	8d 50 ff             	lea    -0x1(%eax),%edx
        if(input.e != input.end_pos){
80100d95:	3b 05 2c ff 10 80    	cmp    0x8010ff2c,%eax
  if(panicked){
80100d9b:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
        input.e--;
80100da1:	89 15 28 ff 10 80    	mov    %edx,0x8010ff28
        if(input.e != input.end_pos){
80100da7:	0f 84 5b 01 00 00    	je     80100f08 <consoleintr+0x328>
  if(panicked){
80100dad:	85 c9                	test   %ecx,%ecx
80100daf:	0f 84 77 01 00 00    	je     80100f2c <consoleintr+0x34c>
80100db5:	fa                   	cli
    for(;;)
80100db6:	eb fe                	jmp    80100db6 <consoleintr+0x1d6>
80100db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100dbf:	00 
        if(input.e> input.w){
80100dc0:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100dc5:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
80100dcb:	0f 83 3c fe ff ff    	jae    80100c0d <consoleintr+0x2d>
  if(panicked){
80100dd1:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
80100dd6:	85 c0                	test   %eax,%eax
80100dd8:	0f 84 8e 01 00 00    	je     80100f6c <consoleintr+0x38c>
80100dde:	fa                   	cli
    for(;;)
80100ddf:	eb fe                	jmp    80100ddf <consoleintr+0x1ff>
80100de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100de8:	bf 01 00 00 00       	mov    $0x1,%edi
80100ded:	e9 1b fe ff ff       	jmp    80100c0d <consoleintr+0x2d>
80100df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100df8:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100dfd:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
80100e03:	0f 84 04 fe ff ff    	je     80100c0d <consoleintr+0x2d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100e09:	83 e8 01             	sub    $0x1,%eax
80100e0c:	89 c2                	mov    %eax,%edx
80100e0e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100e11:	80 ba a0 fe 10 80 0a 	cmpb   $0xa,-0x7fef0160(%edx)
80100e18:	0f 84 ef fd ff ff    	je     80100c0d <consoleintr+0x2d>
  if(panicked){
80100e1e:	8b 35 78 ff 10 80    	mov    0x8010ff78,%esi
        input.end_pos--;
80100e24:	83 2d 2c ff 10 80 01 	subl   $0x1,0x8010ff2c
        input.e--;
80100e2b:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100e30:	85 f6                	test   %esi,%esi
80100e32:	74 0c                	je     80100e40 <consoleintr+0x260>
80100e34:	fa                   	cli
    for(;;)
80100e35:	eb fe                	jmp    80100e35 <consoleintr+0x255>
80100e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e3e:	00 
80100e3f:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100e40:	83 ec 0c             	sub    $0xc,%esp
80100e43:	6a 08                	push   $0x8
80100e45:	e8 26 54 00 00       	call   80106270 <uartputc>
80100e4a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100e51:	e8 1a 54 00 00       	call   80106270 <uartputc>
80100e56:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100e5d:	e8 0e 54 00 00       	call   80106270 <uartputc>
     cgaputc(c);
80100e62:	b8 00 01 00 00       	mov    $0x100,%eax
80100e67:	e8 94 f5 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100e6c:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100e71:	83 c4 10             	add    $0x10,%esp
80100e74:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
80100e7a:	75 8d                	jne    80100e09 <consoleintr+0x229>
80100e7c:	e9 8c fd ff ff       	jmp    80100c0d <consoleintr+0x2d>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uartputc(c);
80100e88:	83 ec 0c             	sub    $0xc,%esp
        consputc(input.buf[input.e % INPUT_BUF]);
80100e8b:	0f be f0             	movsbl %al,%esi
  uartputc(c);
80100e8e:	56                   	push   %esi
80100e8f:	e8 dc 53 00 00       	call   80106270 <uartputc>
  cgaputc(c);
80100e94:	89 f0                	mov    %esi,%eax
80100e96:	e8 65 f5 ff ff       	call   80100400 <cgaputc>
}
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	e9 6a fd ff ff       	jmp    80100c0d <consoleintr+0x2d>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100ea3:	85 c0                	test   %eax,%eax
80100ea5:	0f 84 62 fd ff ff    	je     80100c0d <consoleintr+0x2d>
80100eab:	8b 15 28 ff 10 80    	mov    0x8010ff28,%edx
80100eb1:	89 d1                	mov    %edx,%ecx
80100eb3:	2b 0d 20 ff 10 80    	sub    0x8010ff20,%ecx
80100eb9:	83 f9 7f             	cmp    $0x7f,%ecx
80100ebc:	0f 87 4b fd ff ff    	ja     80100c0d <consoleintr+0x2d>
         if(input.e <input.end_pos){
80100ec2:	8b 35 2c ff 10 80    	mov    0x8010ff2c,%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ec8:	89 d1                	mov    %edx,%ecx
80100eca:	83 e1 7f             	and    $0x7f,%ecx
         if(input.e <input.end_pos){
80100ecd:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100ed0:	8d 72 01             	lea    0x1(%edx),%esi
        c = (c == '\r') ? '\n' : c;
80100ed3:	83 f8 0d             	cmp    $0xd,%eax
80100ed6:	0f 85 cb fd ff ff    	jne    80100ca7 <consoleintr+0xc7>
        if(input.e==input.end_pos+1){
80100edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100edf:	89 35 28 ff 10 80    	mov    %esi,0x8010ff28
80100ee5:	c6 81 a0 fe 10 80 0a 	movb   $0xa,-0x7fef0160(%ecx)
        if(input.e==input.end_pos+1){
80100eec:	39 c2                	cmp    %eax,%edx
80100eee:	0f 84 0b 01 00 00    	je     80100fff <consoleintr+0x41f>
        consputc(c);
80100ef4:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ef9:	e8 82 f6 ff ff       	call   80100580 <consputc>
          input.w = input.e;
80100efe:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100f03:	e9 e7 fd ff ff       	jmp    80100cef <consoleintr+0x10f>
          input.end_pos--;
80100f08:	89 15 2c ff 10 80    	mov    %edx,0x8010ff2c
  if(panicked){
80100f0e:	85 c9                	test   %ecx,%ecx
80100f10:	0f 84 a4 00 00 00    	je     80100fba <consoleintr+0x3da>
80100f16:	fa                   	cli
    for(;;)
80100f17:	eb fe                	jmp    80100f17 <consoleintr+0x337>
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80100f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f23:	5b                   	pop    %ebx
80100f24:	5e                   	pop    %esi
80100f25:	5f                   	pop    %edi
80100f26:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f27:	e9 54 38 00 00       	jmp    80104780 <procdump>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100f2c:	83 ec 0c             	sub    $0xc,%esp
80100f2f:	6a 08                	push   $0x8
80100f31:	e8 3a 53 00 00       	call   80106270 <uartputc>
80100f36:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100f3d:	e8 2e 53 00 00       	call   80106270 <uartputc>
80100f42:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100f49:	e8 22 53 00 00       	call   80106270 <uartputc>
     cgaputc(c);
80100f4e:	b8 00 01 00 00       	mov    $0x100,%eax
80100f53:	e8 a8 f4 ff ff       	call   80100400 <cgaputc>
        move_chars_left();
80100f58:	e8 73 fb ff ff       	call   80100ad0 <move_chars_left>
        input.end_pos--;
80100f5d:	83 2d 2c ff 10 80 01 	subl   $0x1,0x8010ff2c
80100f64:	83 c4 10             	add    $0x10,%esp
80100f67:	e9 a1 fc ff ff       	jmp    80100c0d <consoleintr+0x2d>
       uartputc('\b');
80100f6c:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f6f:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f74:	6a 08                	push   $0x8
80100f76:	e8 f5 52 00 00       	call   80106270 <uartputc>
80100f7b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f80:	89 f2                	mov    %esi,%edx
80100f82:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f83:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100f88:	89 ca                	mov    %ecx,%edx
80100f8a:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100f8b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f8e:	89 f2                	mov    %esi,%edx
80100f90:	c1 e0 08             	shl    $0x8,%eax
80100f93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100f96:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f9c:	89 ca                	mov    %ecx,%edx
80100f9e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100f9f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100fa2:	0f b6 c0             	movzbl %al,%eax
80100fa5:	09 f0                	or     %esi,%eax
    --pos;
80100fa7:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100faa:	ee                   	out    %al,(%dx)
          input.e--;
80100fab:	83 2d 28 ff 10 80 01 	subl   $0x1,0x8010ff28
80100fb2:	83 c4 10             	add    $0x10,%esp
80100fb5:	e9 53 fc ff ff       	jmp    80100c0d <consoleintr+0x2d>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100fba:	83 ec 0c             	sub    $0xc,%esp
80100fbd:	6a 08                	push   $0x8
80100fbf:	e8 ac 52 00 00       	call   80106270 <uartputc>
80100fc4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100fcb:	e8 a0 52 00 00       	call   80106270 <uartputc>
80100fd0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100fd7:	e8 94 52 00 00       	call   80106270 <uartputc>
     cgaputc(c);
80100fdc:	b8 00 01 00 00       	mov    $0x100,%eax
80100fe1:	e8 1a f4 ff ff       	call   80100400 <cgaputc>
}
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	e9 1f fc ff ff       	jmp    80100c0d <consoleintr+0x2d>
        if(input.e==input.end_pos+1){
80100fee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100ff1:	83 c2 01             	add    $0x1,%edx
80100ff4:	89 15 2c ff 10 80    	mov    %edx,0x8010ff2c
80100ffa:	e9 cd fc ff ff       	jmp    80100ccc <consoleintr+0xec>
80100fff:	83 c0 01             	add    $0x1,%eax
80101002:	a3 2c ff 10 80       	mov    %eax,0x8010ff2c
        consputc(c);
80101007:	b8 0a 00 00 00       	mov    $0xa,%eax
8010100c:	e8 6f f5 ff ff       	call   80100580 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
80101011:	e9 e8 fe ff ff       	jmp    80100efe <consoleintr+0x31e>
80101016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101d:	00 
8010101e:	66 90                	xchg   %ax,%ax

80101020 <consoleinit>:

void
consoleinit(void)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101026:	68 88 77 10 80       	push   $0x80107788
8010102b:	68 40 ff 10 80       	push   $0x8010ff40
80101030:	e8 3b 39 00 00       	call   80104970 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101035:	58                   	pop    %eax
80101036:	5a                   	pop    %edx
80101037:	6a 00                	push   $0x0
80101039:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010103b:	c7 05 2c 09 11 80 a0 	movl   $0x801006a0,0x8011092c
80101042:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101045:	c7 05 28 09 11 80 80 	movl   $0x80100280,0x80110928
8010104c:	02 10 80 
  cons.locking = 1;
8010104f:	c7 05 74 ff 10 80 01 	movl   $0x1,0x8010ff74
80101056:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101059:	e8 c2 19 00 00       	call   80102a20 <ioapicenable>
}
8010105e:	83 c4 10             	add    $0x10,%esp
80101061:	c9                   	leave
80101062:	c3                   	ret
80101063:	66 90                	xchg   %ax,%ax
80101065:	66 90                	xchg   %ax,%ax
80101067:	66 90                	xchg   %ax,%ax
80101069:	66 90                	xchg   %ax,%ax
8010106b:	66 90                	xchg   %ax,%ax
8010106d:	66 90                	xchg   %ax,%ax
8010106f:	90                   	nop

80101070 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010107c:	e8 9f 2e 00 00       	call   80103f20 <myproc>
80101081:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101087:	e8 74 22 00 00       	call   80103300 <begin_op>

  if((ip = namei(path)) == 0){
8010108c:	83 ec 0c             	sub    $0xc,%esp
8010108f:	ff 75 08             	push   0x8(%ebp)
80101092:	e8 a9 15 00 00       	call   80102640 <namei>
80101097:	83 c4 10             	add    $0x10,%esp
8010109a:	85 c0                	test   %eax,%eax
8010109c:	0f 84 30 03 00 00    	je     801013d2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	89 c7                	mov    %eax,%edi
801010a7:	50                   	push   %eax
801010a8:	e8 b3 0c 00 00       	call   80101d60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801010ad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801010b3:	6a 34                	push   $0x34
801010b5:	6a 00                	push   $0x0
801010b7:	50                   	push   %eax
801010b8:	57                   	push   %edi
801010b9:	e8 b2 0f 00 00       	call   80102070 <readi>
801010be:	83 c4 20             	add    $0x20,%esp
801010c1:	83 f8 34             	cmp    $0x34,%eax
801010c4:	0f 85 01 01 00 00    	jne    801011cb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801010ca:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801010d1:	45 4c 46 
801010d4:	0f 85 f1 00 00 00    	jne    801011cb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801010da:	e8 01 63 00 00       	call   801073e0 <setupkvm>
801010df:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801010e5:	85 c0                	test   %eax,%eax
801010e7:	0f 84 de 00 00 00    	je     801011cb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010ed:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801010f4:	00 
801010f5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801010fb:	0f 84 a1 02 00 00    	je     801013a2 <exec+0x332>
  sz = 0;
80101101:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101108:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010110b:	31 db                	xor    %ebx,%ebx
8010110d:	e9 8c 00 00 00       	jmp    8010119e <exec+0x12e>
80101112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101118:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010111f:	75 6c                	jne    8010118d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101121:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101127:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010112d:	0f 82 87 00 00 00    	jb     801011ba <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101133:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101139:	72 7f                	jb     801011ba <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010113b:	83 ec 04             	sub    $0x4,%esp
8010113e:	50                   	push   %eax
8010113f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101145:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010114b:	e8 c0 60 00 00       	call   80107210 <allocuvm>
80101150:	83 c4 10             	add    $0x10,%esp
80101153:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101159:	85 c0                	test   %eax,%eax
8010115b:	74 5d                	je     801011ba <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010115d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101163:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101168:	75 50                	jne    801011ba <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101173:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101179:	57                   	push   %edi
8010117a:	50                   	push   %eax
8010117b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101181:	e8 ba 5f 00 00       	call   80107140 <loaduvm>
80101186:	83 c4 20             	add    $0x20,%esp
80101189:	85 c0                	test   %eax,%eax
8010118b:	78 2d                	js     801011ba <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010118d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101194:	83 c3 01             	add    $0x1,%ebx
80101197:	83 c6 20             	add    $0x20,%esi
8010119a:	39 d8                	cmp    %ebx,%eax
8010119c:	7e 52                	jle    801011f0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
8010119e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801011a4:	6a 20                	push   $0x20
801011a6:	56                   	push   %esi
801011a7:	50                   	push   %eax
801011a8:	57                   	push   %edi
801011a9:	e8 c2 0e 00 00       	call   80102070 <readi>
801011ae:	83 c4 10             	add    $0x10,%esp
801011b1:	83 f8 20             	cmp    $0x20,%eax
801011b4:	0f 84 5e ff ff ff    	je     80101118 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801011ba:	83 ec 0c             	sub    $0xc,%esp
801011bd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011c3:	e8 98 61 00 00       	call   80107360 <freevm>
  if(ip){
801011c8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801011cb:	83 ec 0c             	sub    $0xc,%esp
801011ce:	57                   	push   %edi
801011cf:	e8 1c 0e 00 00       	call   80101ff0 <iunlockput>
    end_op();
801011d4:	e8 97 21 00 00       	call   80103370 <end_op>
801011d9:	83 c4 10             	add    $0x10,%esp
    return -1;
801011dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
801011e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e4:	5b                   	pop    %ebx
801011e5:	5e                   	pop    %esi
801011e6:	5f                   	pop    %edi
801011e7:	5d                   	pop    %ebp
801011e8:	c3                   	ret
801011e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
801011f0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801011f6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
801011fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101202:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101208:	83 ec 0c             	sub    $0xc,%esp
8010120b:	57                   	push   %edi
8010120c:	e8 df 0d 00 00       	call   80101ff0 <iunlockput>
  end_op();
80101211:	e8 5a 21 00 00       	call   80103370 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101216:	83 c4 0c             	add    $0xc,%esp
80101219:	53                   	push   %ebx
8010121a:	56                   	push   %esi
8010121b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101221:	56                   	push   %esi
80101222:	e8 e9 5f 00 00       	call   80107210 <allocuvm>
80101227:	83 c4 10             	add    $0x10,%esp
8010122a:	89 c7                	mov    %eax,%edi
8010122c:	85 c0                	test   %eax,%eax
8010122e:	0f 84 86 00 00 00    	je     801012ba <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101234:	83 ec 08             	sub    $0x8,%esp
80101237:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010123d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010123f:	50                   	push   %eax
80101240:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101241:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101243:	e8 38 62 00 00       	call   80107480 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101248:	8b 45 0c             	mov    0xc(%ebp),%eax
8010124b:	83 c4 10             	add    $0x10,%esp
8010124e:	8b 10                	mov    (%eax),%edx
80101250:	85 d2                	test   %edx,%edx
80101252:	0f 84 56 01 00 00    	je     801013ae <exec+0x33e>
80101258:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010125e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101261:	eb 23                	jmp    80101286 <exec+0x216>
80101263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101268:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010126b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101272:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101278:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010127b:	85 d2                	test   %edx,%edx
8010127d:	74 51                	je     801012d0 <exec+0x260>
    if(argc >= MAXARG)
8010127f:	83 f8 20             	cmp    $0x20,%eax
80101282:	74 36                	je     801012ba <exec+0x24a>
80101284:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	52                   	push   %edx
8010128a:	e8 c1 3b 00 00       	call   80104e50 <strlen>
8010128f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101291:	58                   	pop    %eax
80101292:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101295:	83 eb 01             	sub    $0x1,%ebx
80101298:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010129b:	e8 b0 3b 00 00       	call   80104e50 <strlen>
801012a0:	83 c0 01             	add    $0x1,%eax
801012a3:	50                   	push   %eax
801012a4:	ff 34 b7             	push   (%edi,%esi,4)
801012a7:	53                   	push   %ebx
801012a8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801012ae:	e8 9d 63 00 00       	call   80107650 <copyout>
801012b3:	83 c4 20             	add    $0x20,%esp
801012b6:	85 c0                	test   %eax,%eax
801012b8:	79 ae                	jns    80101268 <exec+0x1f8>
    freevm(pgdir);
801012ba:	83 ec 0c             	sub    $0xc,%esp
801012bd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801012c3:	e8 98 60 00 00       	call   80107360 <freevm>
801012c8:	83 c4 10             	add    $0x10,%esp
801012cb:	e9 0c ff ff ff       	jmp    801011dc <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012d0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801012d7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801012dd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801012e3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
801012e6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
801012e9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
801012f0:	00 00 00 00 
  ustack[1] = argc;
801012f4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
801012fa:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101301:	ff ff ff 
  ustack[1] = argc;
80101304:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010130a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010130c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010130e:	29 d0                	sub    %edx,%eax
80101310:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101316:	56                   	push   %esi
80101317:	51                   	push   %ecx
80101318:	53                   	push   %ebx
80101319:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010131f:	e8 2c 63 00 00       	call   80107650 <copyout>
80101324:	83 c4 10             	add    $0x10,%esp
80101327:	85 c0                	test   %eax,%eax
80101329:	78 8f                	js     801012ba <exec+0x24a>
  for(last=s=path; *s; s++)
8010132b:	8b 45 08             	mov    0x8(%ebp),%eax
8010132e:	8b 55 08             	mov    0x8(%ebp),%edx
80101331:	0f b6 00             	movzbl (%eax),%eax
80101334:	84 c0                	test   %al,%al
80101336:	74 17                	je     8010134f <exec+0x2df>
80101338:	89 d1                	mov    %edx,%ecx
8010133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101340:	83 c1 01             	add    $0x1,%ecx
80101343:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101345:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101348:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010134b:	84 c0                	test   %al,%al
8010134d:	75 f1                	jne    80101340 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010134f:	83 ec 04             	sub    $0x4,%esp
80101352:	6a 10                	push   $0x10
80101354:	52                   	push   %edx
80101355:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010135b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010135e:	50                   	push   %eax
8010135f:	e8 ac 3a 00 00       	call   80104e10 <safestrcpy>
  curproc->pgdir = pgdir;
80101364:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010136a:	89 f0                	mov    %esi,%eax
8010136c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010136f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80101371:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101374:	89 c1                	mov    %eax,%ecx
80101376:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010137c:	8b 40 18             	mov    0x18(%eax),%eax
8010137f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101382:	8b 41 18             	mov    0x18(%ecx),%eax
80101385:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101388:	89 0c 24             	mov    %ecx,(%esp)
8010138b:	e8 20 5c 00 00       	call   80106fb0 <switchuvm>
  freevm(oldpgdir);
80101390:	89 34 24             	mov    %esi,(%esp)
80101393:	e8 c8 5f 00 00       	call   80107360 <freevm>
  return 0;
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	31 c0                	xor    %eax,%eax
8010139d:	e9 3f fe ff ff       	jmp    801011e1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801013a2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801013a7:	31 f6                	xor    %esi,%esi
801013a9:	e9 5a fe ff ff       	jmp    80101208 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801013ae:	be 10 00 00 00       	mov    $0x10,%esi
801013b3:	ba 04 00 00 00       	mov    $0x4,%edx
801013b8:	b8 03 00 00 00       	mov    $0x3,%eax
801013bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801013c4:	00 00 00 
801013c7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801013cd:	e9 17 ff ff ff       	jmp    801012e9 <exec+0x279>
    end_op();
801013d2:	e8 99 1f 00 00       	call   80103370 <end_op>
    cprintf("exec: fail\n");
801013d7:	83 ec 0c             	sub    $0xc,%esp
801013da:	68 90 77 10 80       	push   $0x80107790
801013df:	e8 bc f3 ff ff       	call   801007a0 <cprintf>
    return -1;
801013e4:	83 c4 10             	add    $0x10,%esp
801013e7:	e9 f0 fd ff ff       	jmp    801011dc <exec+0x16c>
801013ec:	66 90                	xchg   %ax,%ax
801013ee:	66 90                	xchg   %ax,%ax

801013f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801013f6:	68 9c 77 10 80       	push   $0x8010779c
801013fb:	68 80 ff 10 80       	push   $0x8010ff80
80101400:	e8 6b 35 00 00       	call   80104970 <initlock>
}
80101405:	83 c4 10             	add    $0x10,%esp
80101408:	c9                   	leave
80101409:	c3                   	ret
8010140a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101410 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101414:	bb b4 ff 10 80       	mov    $0x8010ffb4,%ebx
{
80101419:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010141c:	68 80 ff 10 80       	push   $0x8010ff80
80101421:	e8 3a 37 00 00       	call   80104b60 <acquire>
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	eb 10                	jmp    8010143b <filealloc+0x2b>
8010142b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101430:	83 c3 18             	add    $0x18,%ebx
80101433:	81 fb 14 09 11 80    	cmp    $0x80110914,%ebx
80101439:	74 25                	je     80101460 <filealloc+0x50>
    if(f->ref == 0){
8010143b:	8b 43 04             	mov    0x4(%ebx),%eax
8010143e:	85 c0                	test   %eax,%eax
80101440:	75 ee                	jne    80101430 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101442:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101445:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010144c:	68 80 ff 10 80       	push   $0x8010ff80
80101451:	e8 aa 36 00 00       	call   80104b00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101456:	89 d8                	mov    %ebx,%eax
      return f;
80101458:	83 c4 10             	add    $0x10,%esp
}
8010145b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010145e:	c9                   	leave
8010145f:	c3                   	ret
  release(&ftable.lock);
80101460:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101463:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101465:	68 80 ff 10 80       	push   $0x8010ff80
8010146a:	e8 91 36 00 00       	call   80104b00 <release>
}
8010146f:	89 d8                	mov    %ebx,%eax
  return 0;
80101471:	83 c4 10             	add    $0x10,%esp
}
80101474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101477:	c9                   	leave
80101478:	c3                   	ret
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101480 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	83 ec 10             	sub    $0x10,%esp
80101487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010148a:	68 80 ff 10 80       	push   $0x8010ff80
8010148f:	e8 cc 36 00 00       	call   80104b60 <acquire>
  if(f->ref < 1)
80101494:	8b 43 04             	mov    0x4(%ebx),%eax
80101497:	83 c4 10             	add    $0x10,%esp
8010149a:	85 c0                	test   %eax,%eax
8010149c:	7e 1a                	jle    801014b8 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010149e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801014a1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801014a4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801014a7:	68 80 ff 10 80       	push   $0x8010ff80
801014ac:	e8 4f 36 00 00       	call   80104b00 <release>
  return f;
}
801014b1:	89 d8                	mov    %ebx,%eax
801014b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014b6:	c9                   	leave
801014b7:	c3                   	ret
    panic("filedup");
801014b8:	83 ec 0c             	sub    $0xc,%esp
801014bb:	68 a3 77 10 80       	push   $0x801077a3
801014c0:	e8 bb ee ff ff       	call   80100380 <panic>
801014c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014cc:	00 
801014cd:	8d 76 00             	lea    0x0(%esi),%esi

801014d0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	57                   	push   %edi
801014d4:	56                   	push   %esi
801014d5:	53                   	push   %ebx
801014d6:	83 ec 28             	sub    $0x28,%esp
801014d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801014dc:	68 80 ff 10 80       	push   $0x8010ff80
801014e1:	e8 7a 36 00 00       	call   80104b60 <acquire>
  if(f->ref < 1)
801014e6:	8b 53 04             	mov    0x4(%ebx),%edx
801014e9:	83 c4 10             	add    $0x10,%esp
801014ec:	85 d2                	test   %edx,%edx
801014ee:	0f 8e a5 00 00 00    	jle    80101599 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801014f4:	83 ea 01             	sub    $0x1,%edx
801014f7:	89 53 04             	mov    %edx,0x4(%ebx)
801014fa:	75 44                	jne    80101540 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801014fc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101500:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101503:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010150b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010150e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101511:	8b 43 10             	mov    0x10(%ebx),%eax
80101514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101517:	68 80 ff 10 80       	push   $0x8010ff80
8010151c:	e8 df 35 00 00       	call   80104b00 <release>

  if(ff.type == FD_PIPE)
80101521:	83 c4 10             	add    $0x10,%esp
80101524:	83 ff 01             	cmp    $0x1,%edi
80101527:	74 57                	je     80101580 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101529:	83 ff 02             	cmp    $0x2,%edi
8010152c:	74 2a                	je     80101558 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101531:	5b                   	pop    %ebx
80101532:	5e                   	pop    %esi
80101533:	5f                   	pop    %edi
80101534:	5d                   	pop    %ebp
80101535:	c3                   	ret
80101536:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010153d:	00 
8010153e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101540:	c7 45 08 80 ff 10 80 	movl   $0x8010ff80,0x8(%ebp)
}
80101547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154a:	5b                   	pop    %ebx
8010154b:	5e                   	pop    %esi
8010154c:	5f                   	pop    %edi
8010154d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010154e:	e9 ad 35 00 00       	jmp    80104b00 <release>
80101553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101558:	e8 a3 1d 00 00       	call   80103300 <begin_op>
    iput(ff.ip);
8010155d:	83 ec 0c             	sub    $0xc,%esp
80101560:	ff 75 e0             	push   -0x20(%ebp)
80101563:	e8 28 09 00 00       	call   80101e90 <iput>
    end_op();
80101568:	83 c4 10             	add    $0x10,%esp
}
8010156b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156e:	5b                   	pop    %ebx
8010156f:	5e                   	pop    %esi
80101570:	5f                   	pop    %edi
80101571:	5d                   	pop    %ebp
    end_op();
80101572:	e9 f9 1d 00 00       	jmp    80103370 <end_op>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101580:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101584:	83 ec 08             	sub    $0x8,%esp
80101587:	53                   	push   %ebx
80101588:	56                   	push   %esi
80101589:	e8 32 25 00 00       	call   80103ac0 <pipeclose>
8010158e:	83 c4 10             	add    $0x10,%esp
}
80101591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101594:	5b                   	pop    %ebx
80101595:	5e                   	pop    %esi
80101596:	5f                   	pop    %edi
80101597:	5d                   	pop    %ebp
80101598:	c3                   	ret
    panic("fileclose");
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	68 ab 77 10 80       	push   $0x801077ab
801015a1:	e8 da ed ff ff       	call   80100380 <panic>
801015a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ad:	00 
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	83 ec 04             	sub    $0x4,%esp
801015b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801015ba:	83 3b 02             	cmpl   $0x2,(%ebx)
801015bd:	75 31                	jne    801015f0 <filestat+0x40>
    ilock(f->ip);
801015bf:	83 ec 0c             	sub    $0xc,%esp
801015c2:	ff 73 10             	push   0x10(%ebx)
801015c5:	e8 96 07 00 00       	call   80101d60 <ilock>
    stati(f->ip, st);
801015ca:	58                   	pop    %eax
801015cb:	5a                   	pop    %edx
801015cc:	ff 75 0c             	push   0xc(%ebp)
801015cf:	ff 73 10             	push   0x10(%ebx)
801015d2:	e8 69 0a 00 00       	call   80102040 <stati>
    iunlock(f->ip);
801015d7:	59                   	pop    %ecx
801015d8:	ff 73 10             	push   0x10(%ebx)
801015db:	e8 60 08 00 00       	call   80101e40 <iunlock>
    return 0;
  }
  return -1;
}
801015e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801015e3:	83 c4 10             	add    $0x10,%esp
801015e6:	31 c0                	xor    %eax,%eax
}
801015e8:	c9                   	leave
801015e9:	c3                   	ret
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801015f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801015f8:	c9                   	leave
801015f9:	c3                   	ret
801015fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101600 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 0c             	sub    $0xc,%esp
80101609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010160c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010160f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101612:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101616:	74 60                	je     80101678 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101618:	8b 03                	mov    (%ebx),%eax
8010161a:	83 f8 01             	cmp    $0x1,%eax
8010161d:	74 41                	je     80101660 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010161f:	83 f8 02             	cmp    $0x2,%eax
80101622:	75 5b                	jne    8010167f <fileread+0x7f>
    ilock(f->ip);
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	ff 73 10             	push   0x10(%ebx)
8010162a:	e8 31 07 00 00       	call   80101d60 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010162f:	57                   	push   %edi
80101630:	ff 73 14             	push   0x14(%ebx)
80101633:	56                   	push   %esi
80101634:	ff 73 10             	push   0x10(%ebx)
80101637:	e8 34 0a 00 00       	call   80102070 <readi>
8010163c:	83 c4 20             	add    $0x20,%esp
8010163f:	89 c6                	mov    %eax,%esi
80101641:	85 c0                	test   %eax,%eax
80101643:	7e 03                	jle    80101648 <fileread+0x48>
      f->off += r;
80101645:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101648:	83 ec 0c             	sub    $0xc,%esp
8010164b:	ff 73 10             	push   0x10(%ebx)
8010164e:	e8 ed 07 00 00       	call   80101e40 <iunlock>
    return r;
80101653:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101656:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101659:	89 f0                	mov    %esi,%eax
8010165b:	5b                   	pop    %ebx
8010165c:	5e                   	pop    %esi
8010165d:	5f                   	pop    %edi
8010165e:	5d                   	pop    %ebp
8010165f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101660:	8b 43 0c             	mov    0xc(%ebx),%eax
80101663:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101666:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101669:	5b                   	pop    %ebx
8010166a:	5e                   	pop    %esi
8010166b:	5f                   	pop    %edi
8010166c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010166d:	e9 0e 26 00 00       	jmp    80103c80 <piperead>
80101672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101678:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010167d:	eb d7                	jmp    80101656 <fileread+0x56>
  panic("fileread");
8010167f:	83 ec 0c             	sub    $0xc,%esp
80101682:	68 b5 77 10 80       	push   $0x801077b5
80101687:	e8 f4 ec ff ff       	call   80100380 <panic>
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	57                   	push   %edi
80101694:	56                   	push   %esi
80101695:	53                   	push   %ebx
80101696:	83 ec 1c             	sub    $0x1c,%esp
80101699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010169c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010169f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801016a5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801016a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801016ac:	0f 84 bb 00 00 00    	je     8010176d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801016b2:	8b 03                	mov    (%ebx),%eax
801016b4:	83 f8 01             	cmp    $0x1,%eax
801016b7:	0f 84 bf 00 00 00    	je     8010177c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801016bd:	83 f8 02             	cmp    $0x2,%eax
801016c0:	0f 85 c8 00 00 00    	jne    8010178e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801016c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801016c9:	31 f6                	xor    %esi,%esi
    while(i < n){
801016cb:	85 c0                	test   %eax,%eax
801016cd:	7f 30                	jg     801016ff <filewrite+0x6f>
801016cf:	e9 94 00 00 00       	jmp    80101768 <filewrite+0xd8>
801016d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801016d8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801016db:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801016de:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801016e1:	ff 73 10             	push   0x10(%ebx)
801016e4:	e8 57 07 00 00       	call   80101e40 <iunlock>
      end_op();
801016e9:	e8 82 1c 00 00       	call   80103370 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801016ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801016f1:	83 c4 10             	add    $0x10,%esp
801016f4:	39 c7                	cmp    %eax,%edi
801016f6:	75 5c                	jne    80101754 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801016f8:	01 fe                	add    %edi,%esi
    while(i < n){
801016fa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801016fd:	7e 69                	jle    80101768 <filewrite+0xd8>
      int n1 = n - i;
801016ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101702:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101707:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101709:	39 c7                	cmp    %eax,%edi
8010170b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010170e:	e8 ed 1b 00 00       	call   80103300 <begin_op>
      ilock(f->ip);
80101713:	83 ec 0c             	sub    $0xc,%esp
80101716:	ff 73 10             	push   0x10(%ebx)
80101719:	e8 42 06 00 00       	call   80101d60 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010171e:	57                   	push   %edi
8010171f:	ff 73 14             	push   0x14(%ebx)
80101722:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101725:	01 f0                	add    %esi,%eax
80101727:	50                   	push   %eax
80101728:	ff 73 10             	push   0x10(%ebx)
8010172b:	e8 40 0a 00 00       	call   80102170 <writei>
80101730:	83 c4 20             	add    $0x20,%esp
80101733:	85 c0                	test   %eax,%eax
80101735:	7f a1                	jg     801016d8 <filewrite+0x48>
80101737:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	ff 73 10             	push   0x10(%ebx)
80101740:	e8 fb 06 00 00       	call   80101e40 <iunlock>
      end_op();
80101745:	e8 26 1c 00 00       	call   80103370 <end_op>
      if(r < 0)
8010174a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010174d:	83 c4 10             	add    $0x10,%esp
80101750:	85 c0                	test   %eax,%eax
80101752:	75 14                	jne    80101768 <filewrite+0xd8>
        panic("short filewrite");
80101754:	83 ec 0c             	sub    $0xc,%esp
80101757:	68 be 77 10 80       	push   $0x801077be
8010175c:	e8 1f ec ff ff       	call   80100380 <panic>
80101761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101768:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010176b:	74 05                	je     80101772 <filewrite+0xe2>
8010176d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101772:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101775:	89 f0                	mov    %esi,%eax
80101777:	5b                   	pop    %ebx
80101778:	5e                   	pop    %esi
80101779:	5f                   	pop    %edi
8010177a:	5d                   	pop    %ebp
8010177b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010177c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010177f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101782:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101785:	5b                   	pop    %ebx
80101786:	5e                   	pop    %esi
80101787:	5f                   	pop    %edi
80101788:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101789:	e9 d2 23 00 00       	jmp    80103b60 <pipewrite>
  panic("filewrite");
8010178e:	83 ec 0c             	sub    $0xc,%esp
80101791:	68 c4 77 10 80       	push   $0x801077c4
80101796:	e8 e5 eb ff ff       	call   80100380 <panic>
8010179b:	66 90                	xchg   %ax,%ax
8010179d:	66 90                	xchg   %ax,%ax
8010179f:	90                   	nop

801017a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801017a9:	8b 0d d4 25 11 80    	mov    0x801125d4,%ecx
{
801017af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801017b2:	85 c9                	test   %ecx,%ecx
801017b4:	0f 84 8c 00 00 00    	je     80101846 <balloc+0xa6>
801017ba:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801017bc:	89 f8                	mov    %edi,%eax
801017be:	83 ec 08             	sub    $0x8,%esp
801017c1:	89 fe                	mov    %edi,%esi
801017c3:	c1 f8 0c             	sar    $0xc,%eax
801017c6:	03 05 ec 25 11 80    	add    0x801125ec,%eax
801017cc:	50                   	push   %eax
801017cd:	ff 75 dc             	push   -0x24(%ebp)
801017d0:	e8 fb e8 ff ff       	call   801000d0 <bread>
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801017db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017de:	a1 d4 25 11 80       	mov    0x801125d4,%eax
801017e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017e6:	31 c0                	xor    %eax,%eax
801017e8:	eb 32                	jmp    8010181c <balloc+0x7c>
801017ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801017f0:	89 c1                	mov    %eax,%ecx
801017f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801017fa:	83 e1 07             	and    $0x7,%ecx
801017fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017ff:	89 c1                	mov    %eax,%ecx
80101801:	c1 f9 03             	sar    $0x3,%ecx
80101804:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101809:	89 fa                	mov    %edi,%edx
8010180b:	85 df                	test   %ebx,%edi
8010180d:	74 49                	je     80101858 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010180f:	83 c0 01             	add    $0x1,%eax
80101812:	83 c6 01             	add    $0x1,%esi
80101815:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010181a:	74 07                	je     80101823 <balloc+0x83>
8010181c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010181f:	39 d6                	cmp    %edx,%esi
80101821:	72 cd                	jb     801017f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101823:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101826:	83 ec 0c             	sub    $0xc,%esp
80101829:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010182c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101832:	e8 b9 e9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101837:	83 c4 10             	add    $0x10,%esp
8010183a:	3b 3d d4 25 11 80    	cmp    0x801125d4,%edi
80101840:	0f 82 76 ff ff ff    	jb     801017bc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	68 ce 77 10 80       	push   $0x801077ce
8010184e:	e8 2d eb ff ff       	call   80100380 <panic>
80101853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101858:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010185b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010185e:	09 da                	or     %ebx,%edx
80101860:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101864:	57                   	push   %edi
80101865:	e8 76 1c 00 00       	call   801034e0 <log_write>
        brelse(bp);
8010186a:	89 3c 24             	mov    %edi,(%esp)
8010186d:	e8 7e e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101872:	58                   	pop    %eax
80101873:	5a                   	pop    %edx
80101874:	56                   	push   %esi
80101875:	ff 75 dc             	push   -0x24(%ebp)
80101878:	e8 53 e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010187d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101880:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101882:	8d 40 5c             	lea    0x5c(%eax),%eax
80101885:	68 00 02 00 00       	push   $0x200
8010188a:	6a 00                	push   $0x0
8010188c:	50                   	push   %eax
8010188d:	e8 ce 33 00 00       	call   80104c60 <memset>
  log_write(bp);
80101892:	89 1c 24             	mov    %ebx,(%esp)
80101895:	e8 46 1c 00 00       	call   801034e0 <log_write>
  brelse(bp);
8010189a:	89 1c 24             	mov    %ebx,(%esp)
8010189d:	e8 4e e9 ff ff       	call   801001f0 <brelse>
}
801018a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a5:	89 f0                	mov    %esi,%eax
801018a7:	5b                   	pop    %ebx
801018a8:	5e                   	pop    %esi
801018a9:	5f                   	pop    %edi
801018aa:	5d                   	pop    %ebp
801018ab:	c3                   	ret
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801018b4:	31 ff                	xor    %edi,%edi
{
801018b6:	56                   	push   %esi
801018b7:	89 c6                	mov    %eax,%esi
801018b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ba:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
801018bf:	83 ec 28             	sub    $0x28,%esp
801018c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801018c5:	68 80 09 11 80       	push   $0x80110980
801018ca:	e8 91 32 00 00       	call   80104b60 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	eb 1b                	jmp    801018f2 <iget+0x42>
801018d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018de:	00 
801018df:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018e0:	39 33                	cmp    %esi,(%ebx)
801018e2:	74 6c                	je     80101950 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ea:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801018f0:	74 26                	je     80101918 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018f2:	8b 43 08             	mov    0x8(%ebx),%eax
801018f5:	85 c0                	test   %eax,%eax
801018f7:	7f e7                	jg     801018e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018f9:	85 ff                	test   %edi,%edi
801018fb:	75 e7                	jne    801018e4 <iget+0x34>
801018fd:	85 c0                	test   %eax,%eax
801018ff:	75 76                	jne    80101977 <iget+0xc7>
      empty = ip;
80101901:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101903:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101909:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
8010190f:	75 e1                	jne    801018f2 <iget+0x42>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101918:	85 ff                	test   %edi,%edi
8010191a:	74 79                	je     80101995 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010191c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010191f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101921:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101924:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010192b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101932:	68 80 09 11 80       	push   $0x80110980
80101937:	e8 c4 31 00 00       	call   80104b00 <release>

  return ip;
8010193c:	83 c4 10             	add    $0x10,%esp
}
8010193f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101942:	89 f8                	mov    %edi,%eax
80101944:	5b                   	pop    %ebx
80101945:	5e                   	pop    %esi
80101946:	5f                   	pop    %edi
80101947:	5d                   	pop    %ebp
80101948:	c3                   	ret
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101950:	39 53 04             	cmp    %edx,0x4(%ebx)
80101953:	75 8f                	jne    801018e4 <iget+0x34>
      ip->ref++;
80101955:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010195b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010195d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101960:	68 80 09 11 80       	push   $0x80110980
80101965:	e8 96 31 00 00       	call   80104b00 <release>
      return ip;
8010196a:	83 c4 10             	add    $0x10,%esp
}
8010196d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101970:	89 f8                	mov    %edi,%eax
80101972:	5b                   	pop    %ebx
80101973:	5e                   	pop    %esi
80101974:	5f                   	pop    %edi
80101975:	5d                   	pop    %ebp
80101976:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101977:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010197d:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101983:	74 10                	je     80101995 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101985:	8b 43 08             	mov    0x8(%ebx),%eax
80101988:	85 c0                	test   %eax,%eax
8010198a:	0f 8f 50 ff ff ff    	jg     801018e0 <iget+0x30>
80101990:	e9 68 ff ff ff       	jmp    801018fd <iget+0x4d>
    panic("iget: no inodes");
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	68 e4 77 10 80       	push   $0x801077e4
8010199d:	e8 de e9 ff ff       	call   80100380 <panic>
801019a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019a9:	00 
801019aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019b0 <bfree>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801019b3:	89 d0                	mov    %edx,%eax
801019b5:	c1 e8 0c             	shr    $0xc,%eax
{
801019b8:	89 e5                	mov    %esp,%ebp
801019ba:	56                   	push   %esi
801019bb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801019bc:	03 05 ec 25 11 80    	add    0x801125ec,%eax
{
801019c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801019c4:	83 ec 08             	sub    $0x8,%esp
801019c7:	50                   	push   %eax
801019c8:	51                   	push   %ecx
801019c9:	e8 02 e7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801019ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801019d0:	c1 fb 03             	sar    $0x3,%ebx
801019d3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801019d6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801019d8:	83 e1 07             	and    $0x7,%ecx
801019db:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801019e0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801019e6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801019e8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801019ed:	85 c1                	test   %eax,%ecx
801019ef:	74 23                	je     80101a14 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801019f1:	f7 d0                	not    %eax
  log_write(bp);
801019f3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801019f6:	21 c8                	and    %ecx,%eax
801019f8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801019fc:	56                   	push   %esi
801019fd:	e8 de 1a 00 00       	call   801034e0 <log_write>
  brelse(bp);
80101a02:	89 34 24             	mov    %esi,(%esp)
80101a05:	e8 e6 e7 ff ff       	call   801001f0 <brelse>
}
80101a0a:	83 c4 10             	add    $0x10,%esp
80101a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a10:	5b                   	pop    %ebx
80101a11:	5e                   	pop    %esi
80101a12:	5d                   	pop    %ebp
80101a13:	c3                   	ret
    panic("freeing free block");
80101a14:	83 ec 0c             	sub    $0xc,%esp
80101a17:	68 f4 77 10 80       	push   $0x801077f4
80101a1c:	e8 5f e9 ff ff       	call   80100380 <panic>
80101a21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a28:	00 
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a30 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	89 c6                	mov    %eax,%esi
80101a37:	53                   	push   %ebx
80101a38:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101a3b:	83 fa 0b             	cmp    $0xb,%edx
80101a3e:	0f 86 8c 00 00 00    	jbe    80101ad0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101a44:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101a47:	83 fb 7f             	cmp    $0x7f,%ebx
80101a4a:	0f 87 a2 00 00 00    	ja     80101af2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101a50:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101a56:	85 c0                	test   %eax,%eax
80101a58:	74 5e                	je     80101ab8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101a5a:	83 ec 08             	sub    $0x8,%esp
80101a5d:	50                   	push   %eax
80101a5e:	ff 36                	push   (%esi)
80101a60:	e8 6b e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101a65:	83 c4 10             	add    $0x10,%esp
80101a68:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101a6c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101a6e:	8b 3b                	mov    (%ebx),%edi
80101a70:	85 ff                	test   %edi,%edi
80101a72:	74 1c                	je     80101a90 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	52                   	push   %edx
80101a78:	e8 73 e7 ff ff       	call   801001f0 <brelse>
80101a7d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a83:	89 f8                	mov    %edi,%eax
80101a85:	5b                   	pop    %ebx
80101a86:	5e                   	pop    %esi
80101a87:	5f                   	pop    %edi
80101a88:	5d                   	pop    %ebp
80101a89:	c3                   	ret
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101a93:	8b 06                	mov    (%esi),%eax
80101a95:	e8 06 fd ff ff       	call   801017a0 <balloc>
      log_write(bp);
80101a9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a9d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101aa0:	89 03                	mov    %eax,(%ebx)
80101aa2:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101aa4:	52                   	push   %edx
80101aa5:	e8 36 1a 00 00       	call   801034e0 <log_write>
80101aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101aad:	83 c4 10             	add    $0x10,%esp
80101ab0:	eb c2                	jmp    80101a74 <bmap+0x44>
80101ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ab8:	8b 06                	mov    (%esi),%eax
80101aba:	e8 e1 fc ff ff       	call   801017a0 <balloc>
80101abf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101ac5:	eb 93                	jmp    80101a5a <bmap+0x2a>
80101ac7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ace:	00 
80101acf:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101ad0:	8d 5a 14             	lea    0x14(%edx),%ebx
80101ad3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101ad7:	85 ff                	test   %edi,%edi
80101ad9:	75 a5                	jne    80101a80 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101adb:	8b 00                	mov    (%eax),%eax
80101add:	e8 be fc ff ff       	call   801017a0 <balloc>
80101ae2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101ae6:	89 c7                	mov    %eax,%edi
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	89 f8                	mov    %edi,%eax
80101aee:	5e                   	pop    %esi
80101aef:	5f                   	pop    %edi
80101af0:	5d                   	pop    %ebp
80101af1:	c3                   	ret
  panic("bmap: out of range");
80101af2:	83 ec 0c             	sub    $0xc,%esp
80101af5:	68 07 78 10 80       	push   $0x80107807
80101afa:	e8 81 e8 ff ff       	call   80100380 <panic>
80101aff:	90                   	nop

80101b00 <readsb>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101b08:	83 ec 08             	sub    $0x8,%esp
80101b0b:	6a 01                	push   $0x1
80101b0d:	ff 75 08             	push   0x8(%ebp)
80101b10:	e8 bb e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b15:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b18:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b1a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b1d:	6a 1c                	push   $0x1c
80101b1f:	50                   	push   %eax
80101b20:	56                   	push   %esi
80101b21:	e8 ca 31 00 00       	call   80104cf0 <memmove>
  brelse(bp);
80101b26:	83 c4 10             	add    $0x10,%esp
80101b29:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b2f:	5b                   	pop    %ebx
80101b30:	5e                   	pop    %esi
80101b31:	5d                   	pop    %ebp
  brelse(bp);
80101b32:	e9 b9 e6 ff ff       	jmp    801001f0 <brelse>
80101b37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b3e:	00 
80101b3f:	90                   	nop

80101b40 <iinit>:
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	53                   	push   %ebx
80101b44:	bb c0 09 11 80       	mov    $0x801109c0,%ebx
80101b49:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101b4c:	68 1a 78 10 80       	push   $0x8010781a
80101b51:	68 80 09 11 80       	push   $0x80110980
80101b56:	e8 15 2e 00 00       	call   80104970 <initlock>
  for(i = 0; i < NINODE; i++) {
80101b5b:	83 c4 10             	add    $0x10,%esp
80101b5e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101b60:	83 ec 08             	sub    $0x8,%esp
80101b63:	68 21 78 10 80       	push   $0x80107821
80101b68:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101b69:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101b6f:	e8 cc 2c 00 00       	call   80104840 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101b74:	83 c4 10             	add    $0x10,%esp
80101b77:	81 fb e0 25 11 80    	cmp    $0x801125e0,%ebx
80101b7d:	75 e1                	jne    80101b60 <iinit+0x20>
  bp = bread(dev, 1);
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	6a 01                	push   $0x1
80101b84:	ff 75 08             	push   0x8(%ebp)
80101b87:	e8 44 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b8c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b8f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b91:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b94:	6a 1c                	push   $0x1c
80101b96:	50                   	push   %eax
80101b97:	68 d4 25 11 80       	push   $0x801125d4
80101b9c:	e8 4f 31 00 00       	call   80104cf0 <memmove>
  brelse(bp);
80101ba1:	89 1c 24             	mov    %ebx,(%esp)
80101ba4:	e8 47 e6 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ba9:	ff 35 ec 25 11 80    	push   0x801125ec
80101baf:	ff 35 e8 25 11 80    	push   0x801125e8
80101bb5:	ff 35 e4 25 11 80    	push   0x801125e4
80101bbb:	ff 35 e0 25 11 80    	push   0x801125e0
80101bc1:	ff 35 dc 25 11 80    	push   0x801125dc
80101bc7:	ff 35 d8 25 11 80    	push   0x801125d8
80101bcd:	ff 35 d4 25 11 80    	push   0x801125d4
80101bd3:	68 34 7c 10 80       	push   $0x80107c34
80101bd8:	e8 c3 eb ff ff       	call   801007a0 <cprintf>
}
80101bdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101be0:	83 c4 30             	add    $0x30,%esp
80101be3:	c9                   	leave
80101be4:	c3                   	ret
80101be5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bec:	00 
80101bed:	8d 76 00             	lea    0x0(%esi),%esi

80101bf0 <ialloc>:
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101bfc:	83 3d dc 25 11 80 01 	cmpl   $0x1,0x801125dc
{
80101c03:	8b 75 08             	mov    0x8(%ebp),%esi
80101c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101c09:	0f 86 91 00 00 00    	jbe    80101ca0 <ialloc+0xb0>
80101c0f:	bf 01 00 00 00       	mov    $0x1,%edi
80101c14:	eb 21                	jmp    80101c37 <ialloc+0x47>
80101c16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c1d:	00 
80101c1e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101c20:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101c23:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101c26:	53                   	push   %ebx
80101c27:	e8 c4 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101c2c:	83 c4 10             	add    $0x10,%esp
80101c2f:	3b 3d dc 25 11 80    	cmp    0x801125dc,%edi
80101c35:	73 69                	jae    80101ca0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	83 ec 08             	sub    $0x8,%esp
80101c3c:	c1 e8 03             	shr    $0x3,%eax
80101c3f:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101c45:	50                   	push   %eax
80101c46:	56                   	push   %esi
80101c47:	e8 84 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101c4c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101c4f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101c51:	89 f8                	mov    %edi,%eax
80101c53:	83 e0 07             	and    $0x7,%eax
80101c56:	c1 e0 06             	shl    $0x6,%eax
80101c59:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101c5d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101c61:	75 bd                	jne    80101c20 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101c63:	83 ec 04             	sub    $0x4,%esp
80101c66:	6a 40                	push   $0x40
80101c68:	6a 00                	push   $0x0
80101c6a:	51                   	push   %ecx
80101c6b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c6e:	e8 ed 2f 00 00       	call   80104c60 <memset>
      dip->type = type;
80101c73:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101c77:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c7a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101c7d:	89 1c 24             	mov    %ebx,(%esp)
80101c80:	e8 5b 18 00 00       	call   801034e0 <log_write>
      brelse(bp);
80101c85:	89 1c 24             	mov    %ebx,(%esp)
80101c88:	e8 63 e5 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101c8d:	83 c4 10             	add    $0x10,%esp
}
80101c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101c93:	89 fa                	mov    %edi,%edx
}
80101c95:	5b                   	pop    %ebx
      return iget(dev, inum);
80101c96:	89 f0                	mov    %esi,%eax
}
80101c98:	5e                   	pop    %esi
80101c99:	5f                   	pop    %edi
80101c9a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101c9b:	e9 10 fc ff ff       	jmp    801018b0 <iget>
  panic("ialloc: no inodes");
80101ca0:	83 ec 0c             	sub    $0xc,%esp
80101ca3:	68 27 78 10 80       	push   $0x80107827
80101ca8:	e8 d3 e6 ff ff       	call   80100380 <panic>
80101cad:	8d 76 00             	lea    0x0(%esi),%esi

80101cb0 <iupdate>:
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
80101cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cb8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cbb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cbe:	83 ec 08             	sub    $0x8,%esp
80101cc1:	c1 e8 03             	shr    $0x3,%eax
80101cc4:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101cca:	50                   	push   %eax
80101ccb:	ff 73 a4             	push   -0x5c(%ebx)
80101cce:	e8 fd e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101cd3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cd7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cda:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cdc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101cdf:	83 e0 07             	and    $0x7,%eax
80101ce2:	c1 e0 06             	shl    $0x6,%eax
80101ce5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101ce9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101cec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cf0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101cf3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101cf7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101cfb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101cff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101d03:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101d07:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101d0a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d0d:	6a 34                	push   $0x34
80101d0f:	53                   	push   %ebx
80101d10:	50                   	push   %eax
80101d11:	e8 da 2f 00 00       	call   80104cf0 <memmove>
  log_write(bp);
80101d16:	89 34 24             	mov    %esi,(%esp)
80101d19:	e8 c2 17 00 00       	call   801034e0 <log_write>
  brelse(bp);
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d27:	5b                   	pop    %ebx
80101d28:	5e                   	pop    %esi
80101d29:	5d                   	pop    %ebp
  brelse(bp);
80101d2a:	e9 c1 e4 ff ff       	jmp    801001f0 <brelse>
80101d2f:	90                   	nop

80101d30 <idup>:
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	53                   	push   %ebx
80101d34:	83 ec 10             	sub    $0x10,%esp
80101d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101d3a:	68 80 09 11 80       	push   $0x80110980
80101d3f:	e8 1c 2e 00 00       	call   80104b60 <acquire>
  ip->ref++;
80101d44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d48:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101d4f:	e8 ac 2d 00 00       	call   80104b00 <release>
}
80101d54:	89 d8                	mov    %ebx,%eax
80101d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d59:	c9                   	leave
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101d60 <ilock>:
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	56                   	push   %esi
80101d64:	53                   	push   %ebx
80101d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101d68:	85 db                	test   %ebx,%ebx
80101d6a:	0f 84 b7 00 00 00    	je     80101e27 <ilock+0xc7>
80101d70:	8b 53 08             	mov    0x8(%ebx),%edx
80101d73:	85 d2                	test   %edx,%edx
80101d75:	0f 8e ac 00 00 00    	jle    80101e27 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101d7b:	83 ec 0c             	sub    $0xc,%esp
80101d7e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d81:	50                   	push   %eax
80101d82:	e8 f9 2a 00 00       	call   80104880 <acquiresleep>
  if(ip->valid == 0){
80101d87:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101d8a:	83 c4 10             	add    $0x10,%esp
80101d8d:	85 c0                	test   %eax,%eax
80101d8f:	74 0f                	je     80101da0 <ilock+0x40>
}
80101d91:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d94:	5b                   	pop    %ebx
80101d95:	5e                   	pop    %esi
80101d96:	5d                   	pop    %ebp
80101d97:	c3                   	ret
80101d98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d9f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101da0:	8b 43 04             	mov    0x4(%ebx),%eax
80101da3:	83 ec 08             	sub    $0x8,%esp
80101da6:	c1 e8 03             	shr    $0x3,%eax
80101da9:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101daf:	50                   	push   %eax
80101db0:	ff 33                	push   (%ebx)
80101db2:	e8 19 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101db7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101dba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101dbc:	8b 43 04             	mov    0x4(%ebx),%eax
80101dbf:	83 e0 07             	and    $0x7,%eax
80101dc2:	c1 e0 06             	shl    $0x6,%eax
80101dc5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101dc9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dcc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101dcf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101dd3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101dd7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101ddb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101ddf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101de3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101de7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101deb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101dee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101df1:	6a 34                	push   $0x34
80101df3:	50                   	push   %eax
80101df4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101df7:	50                   	push   %eax
80101df8:	e8 f3 2e 00 00       	call   80104cf0 <memmove>
    brelse(bp);
80101dfd:	89 34 24             	mov    %esi,(%esp)
80101e00:	e8 eb e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101e05:	83 c4 10             	add    $0x10,%esp
80101e08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101e0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101e14:	0f 85 77 ff ff ff    	jne    80101d91 <ilock+0x31>
      panic("ilock: no type");
80101e1a:	83 ec 0c             	sub    $0xc,%esp
80101e1d:	68 3f 78 10 80       	push   $0x8010783f
80101e22:	e8 59 e5 ff ff       	call   80100380 <panic>
    panic("ilock");
80101e27:	83 ec 0c             	sub    $0xc,%esp
80101e2a:	68 39 78 10 80       	push   $0x80107839
80101e2f:	e8 4c e5 ff ff       	call   80100380 <panic>
80101e34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e3b:	00 
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <iunlock>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	56                   	push   %esi
80101e44:	53                   	push   %ebx
80101e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e48:	85 db                	test   %ebx,%ebx
80101e4a:	74 28                	je     80101e74 <iunlock+0x34>
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101e52:	56                   	push   %esi
80101e53:	e8 c8 2a 00 00       	call   80104920 <holdingsleep>
80101e58:	83 c4 10             	add    $0x10,%esp
80101e5b:	85 c0                	test   %eax,%eax
80101e5d:	74 15                	je     80101e74 <iunlock+0x34>
80101e5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101e62:	85 c0                	test   %eax,%eax
80101e64:	7e 0e                	jle    80101e74 <iunlock+0x34>
  releasesleep(&ip->lock);
80101e66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101e69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e6c:	5b                   	pop    %ebx
80101e6d:	5e                   	pop    %esi
80101e6e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101e6f:	e9 6c 2a 00 00       	jmp    801048e0 <releasesleep>
    panic("iunlock");
80101e74:	83 ec 0c             	sub    $0xc,%esp
80101e77:	68 4e 78 10 80       	push   $0x8010784e
80101e7c:	e8 ff e4 ff ff       	call   80100380 <panic>
80101e81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e88:	00 
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e90 <iput>:
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 28             	sub    $0x28,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101e9c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e9f:	57                   	push   %edi
80101ea0:	e8 db 29 00 00       	call   80104880 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ea5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101ea8:	83 c4 10             	add    $0x10,%esp
80101eab:	85 d2                	test   %edx,%edx
80101ead:	74 07                	je     80101eb6 <iput+0x26>
80101eaf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101eb4:	74 32                	je     80101ee8 <iput+0x58>
  releasesleep(&ip->lock);
80101eb6:	83 ec 0c             	sub    $0xc,%esp
80101eb9:	57                   	push   %edi
80101eba:	e8 21 2a 00 00       	call   801048e0 <releasesleep>
  acquire(&icache.lock);
80101ebf:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101ec6:	e8 95 2c 00 00       	call   80104b60 <acquire>
  ip->ref--;
80101ecb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ecf:	83 c4 10             	add    $0x10,%esp
80101ed2:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
}
80101ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101edc:	5b                   	pop    %ebx
80101edd:	5e                   	pop    %esi
80101ede:	5f                   	pop    %edi
80101edf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ee0:	e9 1b 2c 00 00       	jmp    80104b00 <release>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 80 09 11 80       	push   $0x80110980
80101ef0:	e8 6b 2c 00 00       	call   80104b60 <acquire>
    int r = ip->ref;
80101ef5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ef8:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101eff:	e8 fc 2b 00 00       	call   80104b00 <release>
    if(r == 1){
80101f04:	83 c4 10             	add    $0x10,%esp
80101f07:	83 fe 01             	cmp    $0x1,%esi
80101f0a:	75 aa                	jne    80101eb6 <iput+0x26>
80101f0c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101f12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f15:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	89 cb                	mov    %ecx,%ebx
80101f1c:	eb 09                	jmp    80101f27 <iput+0x97>
80101f1e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f20:	83 c6 04             	add    $0x4,%esi
80101f23:	39 de                	cmp    %ebx,%esi
80101f25:	74 19                	je     80101f40 <iput+0xb0>
    if(ip->addrs[i]){
80101f27:	8b 16                	mov    (%esi),%edx
80101f29:	85 d2                	test   %edx,%edx
80101f2b:	74 f3                	je     80101f20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101f2d:	8b 07                	mov    (%edi),%eax
80101f2f:	e8 7c fa ff ff       	call   801019b0 <bfree>
      ip->addrs[i] = 0;
80101f34:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101f3a:	eb e4                	jmp    80101f20 <iput+0x90>
80101f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101f40:	89 fb                	mov    %edi,%ebx
80101f42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f45:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101f4b:	85 c0                	test   %eax,%eax
80101f4d:	75 2d                	jne    80101f7c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101f4f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101f52:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101f59:	53                   	push   %ebx
80101f5a:	e8 51 fd ff ff       	call   80101cb0 <iupdate>
      ip->type = 0;
80101f5f:	31 c0                	xor    %eax,%eax
80101f61:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101f65:	89 1c 24             	mov    %ebx,(%esp)
80101f68:	e8 43 fd ff ff       	call   80101cb0 <iupdate>
      ip->valid = 0;
80101f6d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101f74:	83 c4 10             	add    $0x10,%esp
80101f77:	e9 3a ff ff ff       	jmp    80101eb6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f7c:	83 ec 08             	sub    $0x8,%esp
80101f7f:	50                   	push   %eax
80101f80:	ff 33                	push   (%ebx)
80101f82:	e8 49 e1 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101f87:	83 c4 10             	add    $0x10,%esp
80101f8a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f8d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f93:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101f96:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f99:	89 cf                	mov    %ecx,%edi
80101f9b:	eb 0a                	jmp    80101fa7 <iput+0x117>
80101f9d:	8d 76 00             	lea    0x0(%esi),%esi
80101fa0:	83 c6 04             	add    $0x4,%esi
80101fa3:	39 fe                	cmp    %edi,%esi
80101fa5:	74 0f                	je     80101fb6 <iput+0x126>
      if(a[j])
80101fa7:	8b 16                	mov    (%esi),%edx
80101fa9:	85 d2                	test   %edx,%edx
80101fab:	74 f3                	je     80101fa0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101fad:	8b 03                	mov    (%ebx),%eax
80101faf:	e8 fc f9 ff ff       	call   801019b0 <bfree>
80101fb4:	eb ea                	jmp    80101fa0 <iput+0x110>
    brelse(bp);
80101fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fbf:	50                   	push   %eax
80101fc0:	e8 2b e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101fc5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101fcb:	8b 03                	mov    (%ebx),%eax
80101fcd:	e8 de f9 ff ff       	call   801019b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101fd2:	83 c4 10             	add    $0x10,%esp
80101fd5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101fdc:	00 00 00 
80101fdf:	e9 6b ff ff ff       	jmp    80101f4f <iput+0xbf>
80101fe4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101feb:	00 
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <iunlockput>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	56                   	push   %esi
80101ff4:	53                   	push   %ebx
80101ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ff8:	85 db                	test   %ebx,%ebx
80101ffa:	74 34                	je     80102030 <iunlockput+0x40>
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	8d 73 0c             	lea    0xc(%ebx),%esi
80102002:	56                   	push   %esi
80102003:	e8 18 29 00 00       	call   80104920 <holdingsleep>
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	85 c0                	test   %eax,%eax
8010200d:	74 21                	je     80102030 <iunlockput+0x40>
8010200f:	8b 43 08             	mov    0x8(%ebx),%eax
80102012:	85 c0                	test   %eax,%eax
80102014:	7e 1a                	jle    80102030 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102016:	83 ec 0c             	sub    $0xc,%esp
80102019:	56                   	push   %esi
8010201a:	e8 c1 28 00 00       	call   801048e0 <releasesleep>
  iput(ip);
8010201f:	83 c4 10             	add    $0x10,%esp
80102022:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102025:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102028:	5b                   	pop    %ebx
80102029:	5e                   	pop    %esi
8010202a:	5d                   	pop    %ebp
  iput(ip);
8010202b:	e9 60 fe ff ff       	jmp    80101e90 <iput>
    panic("iunlock");
80102030:	83 ec 0c             	sub    $0xc,%esp
80102033:	68 4e 78 10 80       	push   $0x8010784e
80102038:	e8 43 e3 ff ff       	call   80100380 <panic>
8010203d:	8d 76 00             	lea    0x0(%esi),%esi

80102040 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	8b 55 08             	mov    0x8(%ebp),%edx
80102046:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102049:	8b 0a                	mov    (%edx),%ecx
8010204b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010204e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102051:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102054:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102058:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010205b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010205f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102063:	8b 52 58             	mov    0x58(%edx),%edx
80102066:	89 50 10             	mov    %edx,0x10(%eax)
}
80102069:	5d                   	pop    %ebp
8010206a:	c3                   	ret
8010206b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102070 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
80102079:	8b 75 08             	mov    0x8(%ebp),%esi
8010207c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102082:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80102087:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010208a:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010208d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80102090:	0f 84 aa 00 00 00    	je     80102140 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102096:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102099:	8b 56 58             	mov    0x58(%esi),%edx
8010209c:	39 fa                	cmp    %edi,%edx
8010209e:	0f 82 bd 00 00 00    	jb     80102161 <readi+0xf1>
801020a4:	89 f9                	mov    %edi,%ecx
801020a6:	31 db                	xor    %ebx,%ebx
801020a8:	01 c1                	add    %eax,%ecx
801020aa:	0f 92 c3             	setb   %bl
801020ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801020b0:	0f 82 ab 00 00 00    	jb     80102161 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801020b6:	89 d3                	mov    %edx,%ebx
801020b8:	29 fb                	sub    %edi,%ebx
801020ba:	39 ca                	cmp    %ecx,%edx
801020bc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020bf:	85 c0                	test   %eax,%eax
801020c1:	74 73                	je     80102136 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801020c3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801020c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801020d3:	89 fa                	mov    %edi,%edx
801020d5:	c1 ea 09             	shr    $0x9,%edx
801020d8:	89 d8                	mov    %ebx,%eax
801020da:	e8 51 f9 ff ff       	call   80101a30 <bmap>
801020df:	83 ec 08             	sub    $0x8,%esp
801020e2:	50                   	push   %eax
801020e3:	ff 33                	push   (%ebx)
801020e5:	e8 e6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801020ed:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020f2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801020f4:	89 f8                	mov    %edi,%eax
801020f6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020fb:	29 f3                	sub    %esi,%ebx
801020fd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801020ff:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102103:	39 d9                	cmp    %ebx,%ecx
80102105:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102108:	83 c4 0c             	add    $0xc,%esp
8010210b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010210c:	01 de                	add    %ebx,%esi
8010210e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102110:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102113:	50                   	push   %eax
80102114:	ff 75 e0             	push   -0x20(%ebp)
80102117:	e8 d4 2b 00 00       	call   80104cf0 <memmove>
    brelse(bp);
8010211c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010211f:	89 14 24             	mov    %edx,(%esp)
80102122:	e8 c9 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102127:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010212a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010212d:	83 c4 10             	add    $0x10,%esp
80102130:	39 de                	cmp    %ebx,%esi
80102132:	72 9c                	jb     801020d0 <readi+0x60>
80102134:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102139:	5b                   	pop    %ebx
8010213a:	5e                   	pop    %esi
8010213b:	5f                   	pop    %edi
8010213c:	5d                   	pop    %ebp
8010213d:	c3                   	ret
8010213e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102140:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102144:	66 83 fa 09          	cmp    $0x9,%dx
80102148:	77 17                	ja     80102161 <readi+0xf1>
8010214a:	8b 14 d5 20 09 11 80 	mov    -0x7feef6e0(,%edx,8),%edx
80102151:	85 d2                	test   %edx,%edx
80102153:	74 0c                	je     80102161 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102155:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215b:	5b                   	pop    %ebx
8010215c:	5e                   	pop    %esi
8010215d:	5f                   	pop    %edi
8010215e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010215f:	ff e2                	jmp    *%edx
      return -1;
80102161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102166:	eb ce                	jmp    80102136 <readi+0xc6>
80102168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010216f:	00 

80102170 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	57                   	push   %edi
80102174:	56                   	push   %esi
80102175:	53                   	push   %ebx
80102176:	83 ec 1c             	sub    $0x1c,%esp
80102179:	8b 45 08             	mov    0x8(%ebp),%eax
8010217c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010217f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102182:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102187:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010218a:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010218d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80102190:	0f 84 ba 00 00 00    	je     80102250 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102196:	39 78 58             	cmp    %edi,0x58(%eax)
80102199:	0f 82 ea 00 00 00    	jb     80102289 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010219f:	8b 75 e0             	mov    -0x20(%ebp),%esi
801021a2:	89 f2                	mov    %esi,%edx
801021a4:	01 fa                	add    %edi,%edx
801021a6:	0f 82 dd 00 00 00    	jb     80102289 <writei+0x119>
801021ac:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801021b2:	0f 87 d1 00 00 00    	ja     80102289 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021b8:	85 f6                	test   %esi,%esi
801021ba:	0f 84 85 00 00 00    	je     80102245 <writei+0xd5>
801021c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801021c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021d0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801021d3:	89 fa                	mov    %edi,%edx
801021d5:	c1 ea 09             	shr    $0x9,%edx
801021d8:	89 f0                	mov    %esi,%eax
801021da:	e8 51 f8 ff ff       	call   80101a30 <bmap>
801021df:	83 ec 08             	sub    $0x8,%esp
801021e2:	50                   	push   %eax
801021e3:	ff 36                	push   (%esi)
801021e5:	e8 e6 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801021ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801021ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801021f0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021f5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801021f7:	89 f8                	mov    %edi,%eax
801021f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021fe:	29 d3                	sub    %edx,%ebx
80102200:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102202:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102206:	39 d9                	cmp    %ebx,%ecx
80102208:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010220b:	83 c4 0c             	add    $0xc,%esp
8010220e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010220f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102211:	ff 75 dc             	push   -0x24(%ebp)
80102214:	50                   	push   %eax
80102215:	e8 d6 2a 00 00       	call   80104cf0 <memmove>
    log_write(bp);
8010221a:	89 34 24             	mov    %esi,(%esp)
8010221d:	e8 be 12 00 00       	call   801034e0 <log_write>
    brelse(bp);
80102222:	89 34 24             	mov    %esi,(%esp)
80102225:	e8 c6 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010222a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010222d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102230:	83 c4 10             	add    $0x10,%esp
80102233:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102236:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102239:	39 d8                	cmp    %ebx,%eax
8010223b:	72 93                	jb     801021d0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010223d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102240:	39 78 58             	cmp    %edi,0x58(%eax)
80102243:	72 33                	jb     80102278 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102245:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224b:	5b                   	pop    %ebx
8010224c:	5e                   	pop    %esi
8010224d:	5f                   	pop    %edi
8010224e:	5d                   	pop    %ebp
8010224f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102250:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102254:	66 83 f8 09          	cmp    $0x9,%ax
80102258:	77 2f                	ja     80102289 <writei+0x119>
8010225a:	8b 04 c5 24 09 11 80 	mov    -0x7feef6dc(,%eax,8),%eax
80102261:	85 c0                	test   %eax,%eax
80102263:	74 24                	je     80102289 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102265:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226b:	5b                   	pop    %ebx
8010226c:	5e                   	pop    %esi
8010226d:	5f                   	pop    %edi
8010226e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010226f:	ff e0                	jmp    *%eax
80102271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102278:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010227b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010227e:	50                   	push   %eax
8010227f:	e8 2c fa ff ff       	call   80101cb0 <iupdate>
80102284:	83 c4 10             	add    $0x10,%esp
80102287:	eb bc                	jmp    80102245 <writei+0xd5>
      return -1;
80102289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010228e:	eb b8                	jmp    80102248 <writei+0xd8>

80102290 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102296:	6a 0e                	push   $0xe
80102298:	ff 75 0c             	push   0xc(%ebp)
8010229b:	ff 75 08             	push   0x8(%ebp)
8010229e:	e8 bd 2a 00 00       	call   80104d60 <strncmp>
}
801022a3:	c9                   	leave
801022a4:	c3                   	ret
801022a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ac:	00 
801022ad:	8d 76 00             	lea    0x0(%esi),%esi

801022b0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 1c             	sub    $0x1c,%esp
801022b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801022bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801022c1:	0f 85 85 00 00 00    	jne    8010234c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022c7:	8b 53 58             	mov    0x58(%ebx),%edx
801022ca:	31 ff                	xor    %edi,%edi
801022cc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801022cf:	85 d2                	test   %edx,%edx
801022d1:	74 3e                	je     80102311 <dirlookup+0x61>
801022d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d8:	6a 10                	push   $0x10
801022da:	57                   	push   %edi
801022db:	56                   	push   %esi
801022dc:	53                   	push   %ebx
801022dd:	e8 8e fd ff ff       	call   80102070 <readi>
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	83 f8 10             	cmp    $0x10,%eax
801022e8:	75 55                	jne    8010233f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801022ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022ef:	74 18                	je     80102309 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801022f1:	83 ec 04             	sub    $0x4,%esp
801022f4:	8d 45 da             	lea    -0x26(%ebp),%eax
801022f7:	6a 0e                	push   $0xe
801022f9:	50                   	push   %eax
801022fa:	ff 75 0c             	push   0xc(%ebp)
801022fd:	e8 5e 2a 00 00       	call   80104d60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102302:	83 c4 10             	add    $0x10,%esp
80102305:	85 c0                	test   %eax,%eax
80102307:	74 17                	je     80102320 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102309:	83 c7 10             	add    $0x10,%edi
8010230c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010230f:	72 c7                	jb     801022d8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102314:	31 c0                	xor    %eax,%eax
}
80102316:	5b                   	pop    %ebx
80102317:	5e                   	pop    %esi
80102318:	5f                   	pop    %edi
80102319:	5d                   	pop    %ebp
8010231a:	c3                   	ret
8010231b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80102320:	8b 45 10             	mov    0x10(%ebp),%eax
80102323:	85 c0                	test   %eax,%eax
80102325:	74 05                	je     8010232c <dirlookup+0x7c>
        *poff = off;
80102327:	8b 45 10             	mov    0x10(%ebp),%eax
8010232a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010232c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102330:	8b 03                	mov    (%ebx),%eax
80102332:	e8 79 f5 ff ff       	call   801018b0 <iget>
}
80102337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010233a:	5b                   	pop    %ebx
8010233b:	5e                   	pop    %esi
8010233c:	5f                   	pop    %edi
8010233d:	5d                   	pop    %ebp
8010233e:	c3                   	ret
      panic("dirlookup read");
8010233f:	83 ec 0c             	sub    $0xc,%esp
80102342:	68 68 78 10 80       	push   $0x80107868
80102347:	e8 34 e0 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010234c:	83 ec 0c             	sub    $0xc,%esp
8010234f:	68 56 78 10 80       	push   $0x80107856
80102354:	e8 27 e0 ff ff       	call   80100380 <panic>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102360 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	57                   	push   %edi
80102364:	56                   	push   %esi
80102365:	53                   	push   %ebx
80102366:	89 c3                	mov    %eax,%ebx
80102368:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010236b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010236e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102371:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102374:	0f 84 9e 01 00 00    	je     80102518 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010237a:	e8 a1 1b 00 00       	call   80103f20 <myproc>
  acquire(&icache.lock);
8010237f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102382:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102385:	68 80 09 11 80       	push   $0x80110980
8010238a:	e8 d1 27 00 00       	call   80104b60 <acquire>
  ip->ref++;
8010238f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102393:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010239a:	e8 61 27 00 00       	call   80104b00 <release>
8010239f:	83 c4 10             	add    $0x10,%esp
801023a2:	eb 07                	jmp    801023ab <namex+0x4b>
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801023a8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801023ab:	0f b6 03             	movzbl (%ebx),%eax
801023ae:	3c 2f                	cmp    $0x2f,%al
801023b0:	74 f6                	je     801023a8 <namex+0x48>
  if(*path == 0)
801023b2:	84 c0                	test   %al,%al
801023b4:	0f 84 06 01 00 00    	je     801024c0 <namex+0x160>
  while(*path != '/' && *path != 0)
801023ba:	0f b6 03             	movzbl (%ebx),%eax
801023bd:	84 c0                	test   %al,%al
801023bf:	0f 84 10 01 00 00    	je     801024d5 <namex+0x175>
801023c5:	89 df                	mov    %ebx,%edi
801023c7:	3c 2f                	cmp    $0x2f,%al
801023c9:	0f 84 06 01 00 00    	je     801024d5 <namex+0x175>
801023cf:	90                   	nop
801023d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801023d4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801023d7:	3c 2f                	cmp    $0x2f,%al
801023d9:	74 04                	je     801023df <namex+0x7f>
801023db:	84 c0                	test   %al,%al
801023dd:	75 f1                	jne    801023d0 <namex+0x70>
  len = path - s;
801023df:	89 f8                	mov    %edi,%eax
801023e1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801023e3:	83 f8 0d             	cmp    $0xd,%eax
801023e6:	0f 8e ac 00 00 00    	jle    80102498 <namex+0x138>
    memmove(name, s, DIRSIZ);
801023ec:	83 ec 04             	sub    $0x4,%esp
801023ef:	6a 0e                	push   $0xe
801023f1:	53                   	push   %ebx
801023f2:	89 fb                	mov    %edi,%ebx
801023f4:	ff 75 e4             	push   -0x1c(%ebp)
801023f7:	e8 f4 28 00 00       	call   80104cf0 <memmove>
801023fc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801023ff:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102402:	75 0c                	jne    80102410 <namex+0xb0>
80102404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102408:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010240b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010240e:	74 f8                	je     80102408 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	56                   	push   %esi
80102414:	e8 47 f9 ff ff       	call   80101d60 <ilock>
    if(ip->type != T_DIR){
80102419:	83 c4 10             	add    $0x10,%esp
8010241c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102421:	0f 85 b7 00 00 00    	jne    801024de <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102427:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010242a:	85 c0                	test   %eax,%eax
8010242c:	74 09                	je     80102437 <namex+0xd7>
8010242e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102431:	0f 84 f7 00 00 00    	je     8010252e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102437:	83 ec 04             	sub    $0x4,%esp
8010243a:	6a 00                	push   $0x0
8010243c:	ff 75 e4             	push   -0x1c(%ebp)
8010243f:	56                   	push   %esi
80102440:	e8 6b fe ff ff       	call   801022b0 <dirlookup>
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	89 c7                	mov    %eax,%edi
8010244a:	85 c0                	test   %eax,%eax
8010244c:	0f 84 8c 00 00 00    	je     801024de <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102452:	83 ec 0c             	sub    $0xc,%esp
80102455:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102458:	51                   	push   %ecx
80102459:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010245c:	e8 bf 24 00 00       	call   80104920 <holdingsleep>
80102461:	83 c4 10             	add    $0x10,%esp
80102464:	85 c0                	test   %eax,%eax
80102466:	0f 84 02 01 00 00    	je     8010256e <namex+0x20e>
8010246c:	8b 56 08             	mov    0x8(%esi),%edx
8010246f:	85 d2                	test   %edx,%edx
80102471:	0f 8e f7 00 00 00    	jle    8010256e <namex+0x20e>
  releasesleep(&ip->lock);
80102477:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010247a:	83 ec 0c             	sub    $0xc,%esp
8010247d:	51                   	push   %ecx
8010247e:	e8 5d 24 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80102483:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80102486:	89 fe                	mov    %edi,%esi
  iput(ip);
80102488:	e8 03 fa ff ff       	call   80101e90 <iput>
8010248d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80102490:	e9 16 ff ff ff       	jmp    801023ab <namex+0x4b>
80102495:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010249b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
8010249e:	83 ec 04             	sub    $0x4,%esp
801024a1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801024a4:	50                   	push   %eax
801024a5:	53                   	push   %ebx
    name[len] = 0;
801024a6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801024a8:	ff 75 e4             	push   -0x1c(%ebp)
801024ab:	e8 40 28 00 00       	call   80104cf0 <memmove>
    name[len] = 0;
801024b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801024b3:	83 c4 10             	add    $0x10,%esp
801024b6:	c6 01 00             	movb   $0x0,(%ecx)
801024b9:	e9 41 ff ff ff       	jmp    801023ff <namex+0x9f>
801024be:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801024c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801024c3:	85 c0                	test   %eax,%eax
801024c5:	0f 85 93 00 00 00    	jne    8010255e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801024cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024ce:	89 f0                	mov    %esi,%eax
801024d0:	5b                   	pop    %ebx
801024d1:	5e                   	pop    %esi
801024d2:	5f                   	pop    %edi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret
  while(*path != '/' && *path != 0)
801024d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801024d8:	89 df                	mov    %ebx,%edi
801024da:	31 c0                	xor    %eax,%eax
801024dc:	eb c0                	jmp    8010249e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801024de:	83 ec 0c             	sub    $0xc,%esp
801024e1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801024e4:	53                   	push   %ebx
801024e5:	e8 36 24 00 00       	call   80104920 <holdingsleep>
801024ea:	83 c4 10             	add    $0x10,%esp
801024ed:	85 c0                	test   %eax,%eax
801024ef:	74 7d                	je     8010256e <namex+0x20e>
801024f1:	8b 4e 08             	mov    0x8(%esi),%ecx
801024f4:	85 c9                	test   %ecx,%ecx
801024f6:	7e 76                	jle    8010256e <namex+0x20e>
  releasesleep(&ip->lock);
801024f8:	83 ec 0c             	sub    $0xc,%esp
801024fb:	53                   	push   %ebx
801024fc:	e8 df 23 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80102501:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102504:	31 f6                	xor    %esi,%esi
  iput(ip);
80102506:	e8 85 f9 ff ff       	call   80101e90 <iput>
      return 0;
8010250b:	83 c4 10             	add    $0x10,%esp
}
8010250e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102511:	89 f0                	mov    %esi,%eax
80102513:	5b                   	pop    %ebx
80102514:	5e                   	pop    %esi
80102515:	5f                   	pop    %edi
80102516:	5d                   	pop    %ebp
80102517:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102518:	ba 01 00 00 00       	mov    $0x1,%edx
8010251d:	b8 01 00 00 00       	mov    $0x1,%eax
80102522:	e8 89 f3 ff ff       	call   801018b0 <iget>
80102527:	89 c6                	mov    %eax,%esi
80102529:	e9 7d fe ff ff       	jmp    801023ab <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010252e:	83 ec 0c             	sub    $0xc,%esp
80102531:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102534:	53                   	push   %ebx
80102535:	e8 e6 23 00 00       	call   80104920 <holdingsleep>
8010253a:	83 c4 10             	add    $0x10,%esp
8010253d:	85 c0                	test   %eax,%eax
8010253f:	74 2d                	je     8010256e <namex+0x20e>
80102541:	8b 7e 08             	mov    0x8(%esi),%edi
80102544:	85 ff                	test   %edi,%edi
80102546:	7e 26                	jle    8010256e <namex+0x20e>
  releasesleep(&ip->lock);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	53                   	push   %ebx
8010254c:	e8 8f 23 00 00       	call   801048e0 <releasesleep>
}
80102551:	83 c4 10             	add    $0x10,%esp
}
80102554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102557:	89 f0                	mov    %esi,%eax
80102559:	5b                   	pop    %ebx
8010255a:	5e                   	pop    %esi
8010255b:	5f                   	pop    %edi
8010255c:	5d                   	pop    %ebp
8010255d:	c3                   	ret
    iput(ip);
8010255e:	83 ec 0c             	sub    $0xc,%esp
80102561:	56                   	push   %esi
      return 0;
80102562:	31 f6                	xor    %esi,%esi
    iput(ip);
80102564:	e8 27 f9 ff ff       	call   80101e90 <iput>
    return 0;
80102569:	83 c4 10             	add    $0x10,%esp
8010256c:	eb a0                	jmp    8010250e <namex+0x1ae>
    panic("iunlock");
8010256e:	83 ec 0c             	sub    $0xc,%esp
80102571:	68 4e 78 10 80       	push   $0x8010784e
80102576:	e8 05 de ff ff       	call   80100380 <panic>
8010257b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102580 <dirlink>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	57                   	push   %edi
80102584:	56                   	push   %esi
80102585:	53                   	push   %ebx
80102586:	83 ec 20             	sub    $0x20,%esp
80102589:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010258c:	6a 00                	push   $0x0
8010258e:	ff 75 0c             	push   0xc(%ebp)
80102591:	53                   	push   %ebx
80102592:	e8 19 fd ff ff       	call   801022b0 <dirlookup>
80102597:	83 c4 10             	add    $0x10,%esp
8010259a:	85 c0                	test   %eax,%eax
8010259c:	75 67                	jne    80102605 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010259e:	8b 7b 58             	mov    0x58(%ebx),%edi
801025a1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801025a4:	85 ff                	test   %edi,%edi
801025a6:	74 29                	je     801025d1 <dirlink+0x51>
801025a8:	31 ff                	xor    %edi,%edi
801025aa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801025ad:	eb 09                	jmp    801025b8 <dirlink+0x38>
801025af:	90                   	nop
801025b0:	83 c7 10             	add    $0x10,%edi
801025b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801025b6:	73 19                	jae    801025d1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025b8:	6a 10                	push   $0x10
801025ba:	57                   	push   %edi
801025bb:	56                   	push   %esi
801025bc:	53                   	push   %ebx
801025bd:	e8 ae fa ff ff       	call   80102070 <readi>
801025c2:	83 c4 10             	add    $0x10,%esp
801025c5:	83 f8 10             	cmp    $0x10,%eax
801025c8:	75 4e                	jne    80102618 <dirlink+0x98>
    if(de.inum == 0)
801025ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801025cf:	75 df                	jne    801025b0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801025d1:	83 ec 04             	sub    $0x4,%esp
801025d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801025d7:	6a 0e                	push   $0xe
801025d9:	ff 75 0c             	push   0xc(%ebp)
801025dc:	50                   	push   %eax
801025dd:	e8 ce 27 00 00       	call   80104db0 <strncpy>
  de.inum = inum;
801025e2:	8b 45 10             	mov    0x10(%ebp),%eax
801025e5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025e9:	6a 10                	push   $0x10
801025eb:	57                   	push   %edi
801025ec:	56                   	push   %esi
801025ed:	53                   	push   %ebx
801025ee:	e8 7d fb ff ff       	call   80102170 <writei>
801025f3:	83 c4 20             	add    $0x20,%esp
801025f6:	83 f8 10             	cmp    $0x10,%eax
801025f9:	75 2a                	jne    80102625 <dirlink+0xa5>
  return 0;
801025fb:	31 c0                	xor    %eax,%eax
}
801025fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102600:	5b                   	pop    %ebx
80102601:	5e                   	pop    %esi
80102602:	5f                   	pop    %edi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret
    iput(ip);
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	50                   	push   %eax
80102609:	e8 82 f8 ff ff       	call   80101e90 <iput>
    return -1;
8010260e:	83 c4 10             	add    $0x10,%esp
80102611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102616:	eb e5                	jmp    801025fd <dirlink+0x7d>
      panic("dirlink read");
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	68 77 78 10 80       	push   $0x80107877
80102620:	e8 5b dd ff ff       	call   80100380 <panic>
    panic("dirlink");
80102625:	83 ec 0c             	sub    $0xc,%esp
80102628:	68 d3 7a 10 80       	push   $0x80107ad3
8010262d:	e8 4e dd ff ff       	call   80100380 <panic>
80102632:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102639:	00 
8010263a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102640 <namei>:

struct inode*
namei(char *path)
{
80102640:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102641:	31 d2                	xor    %edx,%edx
{
80102643:	89 e5                	mov    %esp,%ebp
80102645:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102648:	8b 45 08             	mov    0x8(%ebp),%eax
8010264b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010264e:	e8 0d fd ff ff       	call   80102360 <namex>
}
80102653:	c9                   	leave
80102654:	c3                   	ret
80102655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265c:	00 
8010265d:	8d 76 00             	lea    0x0(%esi),%esi

80102660 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102660:	55                   	push   %ebp
  return namex(path, 1, name);
80102661:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102666:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102668:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010266b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010266e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010266f:	e9 ec fc ff ff       	jmp    80102360 <namex>
80102674:	66 90                	xchg   %ax,%ax
80102676:	66 90                	xchg   %ax,%ax
80102678:	66 90                	xchg   %ax,%ax
8010267a:	66 90                	xchg   %ax,%ax
8010267c:	66 90                	xchg   %ax,%ax
8010267e:	66 90                	xchg   %ax,%ax

80102680 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102689:	85 c0                	test   %eax,%eax
8010268b:	0f 84 b4 00 00 00    	je     80102745 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102691:	8b 70 08             	mov    0x8(%eax),%esi
80102694:	89 c3                	mov    %eax,%ebx
80102696:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010269c:	0f 87 96 00 00 00    	ja     80102738 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801026a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ae:	00 
801026af:	90                   	nop
801026b0:	89 ca                	mov    %ecx,%edx
801026b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026b3:	83 e0 c0             	and    $0xffffffc0,%eax
801026b6:	3c 40                	cmp    $0x40,%al
801026b8:	75 f6                	jne    801026b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ba:	31 ff                	xor    %edi,%edi
801026bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801026c1:	89 f8                	mov    %edi,%eax
801026c3:	ee                   	out    %al,(%dx)
801026c4:	b8 01 00 00 00       	mov    $0x1,%eax
801026c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801026ce:	ee                   	out    %al,(%dx)
801026cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026d4:	89 f0                	mov    %esi,%eax
801026d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026d7:	89 f0                	mov    %esi,%eax
801026d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026de:	c1 f8 08             	sar    $0x8,%eax
801026e1:	ee                   	out    %al,(%dx)
801026e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026e7:	89 f8                	mov    %edi,%eax
801026e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801026ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026f3:	c1 e0 04             	shl    $0x4,%eax
801026f6:	83 e0 10             	and    $0x10,%eax
801026f9:	83 c8 e0             	or     $0xffffffe0,%eax
801026fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026fd:	f6 03 04             	testb  $0x4,(%ebx)
80102700:	75 16                	jne    80102718 <idestart+0x98>
80102702:	b8 20 00 00 00       	mov    $0x20,%eax
80102707:	89 ca                	mov    %ecx,%edx
80102709:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010270a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010270d:	5b                   	pop    %ebx
8010270e:	5e                   	pop    %esi
8010270f:	5f                   	pop    %edi
80102710:	5d                   	pop    %ebp
80102711:	c3                   	ret
80102712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102718:	b8 30 00 00 00       	mov    $0x30,%eax
8010271d:	89 ca                	mov    %ecx,%edx
8010271f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102720:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102725:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102728:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010272d:	fc                   	cld
8010272e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102730:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102733:	5b                   	pop    %ebx
80102734:	5e                   	pop    %esi
80102735:	5f                   	pop    %edi
80102736:	5d                   	pop    %ebp
80102737:	c3                   	ret
    panic("incorrect blockno");
80102738:	83 ec 0c             	sub    $0xc,%esp
8010273b:	68 8d 78 10 80       	push   $0x8010788d
80102740:	e8 3b dc ff ff       	call   80100380 <panic>
    panic("idestart");
80102745:	83 ec 0c             	sub    $0xc,%esp
80102748:	68 84 78 10 80       	push   $0x80107884
8010274d:	e8 2e dc ff ff       	call   80100380 <panic>
80102752:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102759:	00 
8010275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102760 <ideinit>:
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102766:	68 9f 78 10 80       	push   $0x8010789f
8010276b:	68 20 26 11 80       	push   $0x80112620
80102770:	e8 fb 21 00 00       	call   80104970 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102775:	58                   	pop    %eax
80102776:	a1 a4 27 11 80       	mov    0x801127a4,%eax
8010277b:	5a                   	pop    %edx
8010277c:	83 e8 01             	sub    $0x1,%eax
8010277f:	50                   	push   %eax
80102780:	6a 0e                	push   $0xe
80102782:	e8 99 02 00 00       	call   80102a20 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102787:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010278a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010278f:	90                   	nop
80102790:	89 ca                	mov    %ecx,%edx
80102792:	ec                   	in     (%dx),%al
80102793:	83 e0 c0             	and    $0xffffffc0,%eax
80102796:	3c 40                	cmp    $0x40,%al
80102798:	75 f6                	jne    80102790 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010279a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010279f:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a5:	89 ca                	mov    %ecx,%edx
801027a7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801027a8:	84 c0                	test   %al,%al
801027aa:	75 1e                	jne    801027ca <ideinit+0x6a>
801027ac:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801027b1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bd:	00 
801027be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801027c0:	83 e9 01             	sub    $0x1,%ecx
801027c3:	74 0f                	je     801027d4 <ideinit+0x74>
801027c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801027c6:	84 c0                	test   %al,%al
801027c8:	74 f6                	je     801027c0 <ideinit+0x60>
      havedisk1 = 1;
801027ca:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
801027d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801027d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027de:	ee                   	out    %al,(%dx)
}
801027df:	c9                   	leave
801027e0:	c3                   	ret
801027e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027e8:	00 
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	57                   	push   %edi
801027f4:	56                   	push   %esi
801027f5:	53                   	push   %ebx
801027f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027f9:	68 20 26 11 80       	push   $0x80112620
801027fe:	e8 5d 23 00 00       	call   80104b60 <acquire>

  if((b = idequeue) == 0){
80102803:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102809:	83 c4 10             	add    $0x10,%esp
8010280c:	85 db                	test   %ebx,%ebx
8010280e:	74 63                	je     80102873 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102810:	8b 43 58             	mov    0x58(%ebx),%eax
80102813:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102818:	8b 33                	mov    (%ebx),%esi
8010281a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102820:	75 2f                	jne    80102851 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102822:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102827:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010282e:	00 
8010282f:	90                   	nop
80102830:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102831:	89 c1                	mov    %eax,%ecx
80102833:	83 e1 c0             	and    $0xffffffc0,%ecx
80102836:	80 f9 40             	cmp    $0x40,%cl
80102839:	75 f5                	jne    80102830 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010283b:	a8 21                	test   $0x21,%al
8010283d:	75 12                	jne    80102851 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010283f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102842:	b9 80 00 00 00       	mov    $0x80,%ecx
80102847:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010284c:	fc                   	cld
8010284d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010284f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102851:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102854:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102857:	83 ce 02             	or     $0x2,%esi
8010285a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010285c:	53                   	push   %ebx
8010285d:	e8 3e 1e 00 00       	call   801046a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102862:	a1 04 26 11 80       	mov    0x80112604,%eax
80102867:	83 c4 10             	add    $0x10,%esp
8010286a:	85 c0                	test   %eax,%eax
8010286c:	74 05                	je     80102873 <ideintr+0x83>
    idestart(idequeue);
8010286e:	e8 0d fe ff ff       	call   80102680 <idestart>
    release(&idelock);
80102873:	83 ec 0c             	sub    $0xc,%esp
80102876:	68 20 26 11 80       	push   $0x80112620
8010287b:	e8 80 22 00 00       	call   80104b00 <release>

  release(&idelock);
}
80102880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102883:	5b                   	pop    %ebx
80102884:	5e                   	pop    %esi
80102885:	5f                   	pop    %edi
80102886:	5d                   	pop    %ebp
80102887:	c3                   	ret
80102888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010288f:	00 

80102890 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	53                   	push   %ebx
80102894:	83 ec 10             	sub    $0x10,%esp
80102897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010289a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010289d:	50                   	push   %eax
8010289e:	e8 7d 20 00 00       	call   80104920 <holdingsleep>
801028a3:	83 c4 10             	add    $0x10,%esp
801028a6:	85 c0                	test   %eax,%eax
801028a8:	0f 84 c3 00 00 00    	je     80102971 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028ae:	8b 03                	mov    (%ebx),%eax
801028b0:	83 e0 06             	and    $0x6,%eax
801028b3:	83 f8 02             	cmp    $0x2,%eax
801028b6:	0f 84 a8 00 00 00    	je     80102964 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801028bc:	8b 53 04             	mov    0x4(%ebx),%edx
801028bf:	85 d2                	test   %edx,%edx
801028c1:	74 0d                	je     801028d0 <iderw+0x40>
801028c3:	a1 00 26 11 80       	mov    0x80112600,%eax
801028c8:	85 c0                	test   %eax,%eax
801028ca:	0f 84 87 00 00 00    	je     80102957 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 20 26 11 80       	push   $0x80112620
801028d8:	e8 83 22 00 00       	call   80104b60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028dd:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
801028e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	85 c0                	test   %eax,%eax
801028ee:	74 60                	je     80102950 <iderw+0xc0>
801028f0:	89 c2                	mov    %eax,%edx
801028f2:	8b 40 58             	mov    0x58(%eax),%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	75 f7                	jne    801028f0 <iderw+0x60>
801028f9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801028fc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801028fe:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102904:	74 3a                	je     80102940 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102906:	8b 03                	mov    (%ebx),%eax
80102908:	83 e0 06             	and    $0x6,%eax
8010290b:	83 f8 02             	cmp    $0x2,%eax
8010290e:	74 1b                	je     8010292b <iderw+0x9b>
    sleep(b, &idelock);
80102910:	83 ec 08             	sub    $0x8,%esp
80102913:	68 20 26 11 80       	push   $0x80112620
80102918:	53                   	push   %ebx
80102919:	e8 c2 1c 00 00       	call   801045e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010291e:	8b 03                	mov    (%ebx),%eax
80102920:	83 c4 10             	add    $0x10,%esp
80102923:	83 e0 06             	and    $0x6,%eax
80102926:	83 f8 02             	cmp    $0x2,%eax
80102929:	75 e5                	jne    80102910 <iderw+0x80>
  }


  release(&idelock);
8010292b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102935:	c9                   	leave
  release(&idelock);
80102936:	e9 c5 21 00 00       	jmp    80104b00 <release>
8010293b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102940:	89 d8                	mov    %ebx,%eax
80102942:	e8 39 fd ff ff       	call   80102680 <idestart>
80102947:	eb bd                	jmp    80102906 <iderw+0x76>
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102950:	ba 04 26 11 80       	mov    $0x80112604,%edx
80102955:	eb a5                	jmp    801028fc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102957:	83 ec 0c             	sub    $0xc,%esp
8010295a:	68 ce 78 10 80       	push   $0x801078ce
8010295f:	e8 1c da ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102964:	83 ec 0c             	sub    $0xc,%esp
80102967:	68 b9 78 10 80       	push   $0x801078b9
8010296c:	e8 0f da ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	68 a3 78 10 80       	push   $0x801078a3
80102979:	e8 02 da ff ff       	call   80100380 <panic>
8010297e:	66 90                	xchg   %ax,%ax

80102980 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	56                   	push   %esi
80102984:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102985:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010298c:	00 c0 fe 
  ioapic->reg = reg;
8010298f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102996:	00 00 00 
  return ioapic->data;
80102999:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010299f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801029a2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801029a8:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801029ae:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029b5:	c1 ee 10             	shr    $0x10,%esi
801029b8:	89 f0                	mov    %esi,%eax
801029ba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801029bd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801029c0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801029c3:	39 c2                	cmp    %eax,%edx
801029c5:	74 16                	je     801029dd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029c7:	83 ec 0c             	sub    $0xc,%esp
801029ca:	68 88 7c 10 80       	push   $0x80107c88
801029cf:	e8 cc dd ff ff       	call   801007a0 <cprintf>
  ioapic->reg = reg;
801029d4:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801029da:	83 c4 10             	add    $0x10,%esp
{
801029dd:	ba 10 00 00 00       	mov    $0x10,%edx
801029e2:	31 c0                	xor    %eax,%eax
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801029e8:	89 13                	mov    %edx,(%ebx)
801029ea:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801029ed:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029f3:	83 c0 01             	add    $0x1,%eax
801029f6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801029fc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801029ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102a02:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102a05:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102a07:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102a0d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102a14:	39 c6                	cmp    %eax,%esi
80102a16:	7d d0                	jge    801029e8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a18:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a1b:	5b                   	pop    %ebx
80102a1c:	5e                   	pop    %esi
80102a1d:	5d                   	pop    %ebp
80102a1e:	c3                   	ret
80102a1f:	90                   	nop

80102a20 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a20:	55                   	push   %ebp
  ioapic->reg = reg;
80102a21:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102a27:	89 e5                	mov    %esp,%ebp
80102a29:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a2c:	8d 50 20             	lea    0x20(%eax),%edx
80102a2f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a33:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a35:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a3b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a3e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a44:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a46:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a4b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a4e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a51:	5d                   	pop    %ebp
80102a52:	c3                   	ret
80102a53:	66 90                	xchg   %ax,%ax
80102a55:	66 90                	xchg   %ax,%ax
80102a57:	66 90                	xchg   %ax,%ax
80102a59:	66 90                	xchg   %ax,%ax
80102a5b:	66 90                	xchg   %ax,%ax
80102a5d:	66 90                	xchg   %ax,%ax
80102a5f:	90                   	nop

80102a60 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	53                   	push   %ebx
80102a64:	83 ec 04             	sub    $0x4,%esp
80102a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a6a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102a70:	75 76                	jne    80102ae8 <kfree+0x88>
80102a72:	81 fb f0 64 11 80    	cmp    $0x801164f0,%ebx
80102a78:	72 6e                	jb     80102ae8 <kfree+0x88>
80102a7a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a80:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a85:	77 61                	ja     80102ae8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a87:	83 ec 04             	sub    $0x4,%esp
80102a8a:	68 00 10 00 00       	push   $0x1000
80102a8f:	6a 01                	push   $0x1
80102a91:	53                   	push   %ebx
80102a92:	e8 c9 21 00 00       	call   80104c60 <memset>

  if(kmem.use_lock)
80102a97:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	85 d2                	test   %edx,%edx
80102aa2:	75 1c                	jne    80102ac0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102aa4:	a1 98 26 11 80       	mov    0x80112698,%eax
80102aa9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102aab:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102ab0:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102ab6:	85 c0                	test   %eax,%eax
80102ab8:	75 1e                	jne    80102ad8 <kfree+0x78>
    release(&kmem.lock);
}
80102aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102abd:	c9                   	leave
80102abe:	c3                   	ret
80102abf:	90                   	nop
    acquire(&kmem.lock);
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	68 60 26 11 80       	push   $0x80112660
80102ac8:	e8 93 20 00 00       	call   80104b60 <acquire>
80102acd:	83 c4 10             	add    $0x10,%esp
80102ad0:	eb d2                	jmp    80102aa4 <kfree+0x44>
80102ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102ad8:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102adf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ae2:	c9                   	leave
    release(&kmem.lock);
80102ae3:	e9 18 20 00 00       	jmp    80104b00 <release>
    panic("kfree");
80102ae8:	83 ec 0c             	sub    $0xc,%esp
80102aeb:	68 ec 78 10 80       	push   $0x801078ec
80102af0:	e8 8b d8 ff ff       	call   80100380 <panic>
80102af5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102afc:	00 
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <freerange>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	56                   	push   %esi
80102b04:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b05:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b08:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b0b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b1d:	39 de                	cmp    %ebx,%esi
80102b1f:	72 23                	jb     80102b44 <freerange+0x44>
80102b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b28:	83 ec 0c             	sub    $0xc,%esp
80102b2b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b37:	50                   	push   %eax
80102b38:	e8 23 ff ff ff       	call   80102a60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b3d:	83 c4 10             	add    $0x10,%esp
80102b40:	39 de                	cmp    %ebx,%esi
80102b42:	73 e4                	jae    80102b28 <freerange+0x28>
}
80102b44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b47:	5b                   	pop    %ebx
80102b48:	5e                   	pop    %esi
80102b49:	5d                   	pop    %ebp
80102b4a:	c3                   	ret
80102b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102b50 <kinit2>:
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b55:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b58:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b5b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b61:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b67:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b6d:	39 de                	cmp    %ebx,%esi
80102b6f:	72 23                	jb     80102b94 <kinit2+0x44>
80102b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b78:	83 ec 0c             	sub    $0xc,%esp
80102b7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b87:	50                   	push   %eax
80102b88:	e8 d3 fe ff ff       	call   80102a60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b8d:	83 c4 10             	add    $0x10,%esp
80102b90:	39 de                	cmp    %ebx,%esi
80102b92:	73 e4                	jae    80102b78 <kinit2+0x28>
  kmem.use_lock = 1;
80102b94:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102b9b:	00 00 00 
}
80102b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ba1:	5b                   	pop    %ebx
80102ba2:	5e                   	pop    %esi
80102ba3:	5d                   	pop    %ebp
80102ba4:	c3                   	ret
80102ba5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bac:	00 
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <kinit1>:
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	56                   	push   %esi
80102bb4:	53                   	push   %ebx
80102bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 f2 78 10 80       	push   $0x801078f2
80102bc0:	68 60 26 11 80       	push   $0x80112660
80102bc5:	e8 a6 1d 00 00       	call   80104970 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102bca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bcd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bd0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102bd7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102bda:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102be0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bec:	39 de                	cmp    %ebx,%esi
80102bee:	72 1c                	jb     80102c0c <kinit1+0x5c>
    kfree(p);
80102bf0:	83 ec 0c             	sub    $0xc,%esp
80102bf3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102bff:	50                   	push   %eax
80102c00:	e8 5b fe ff ff       	call   80102a60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c05:	83 c4 10             	add    $0x10,%esp
80102c08:	39 de                	cmp    %ebx,%esi
80102c0a:	73 e4                	jae    80102bf0 <kinit1+0x40>
}
80102c0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c0f:	5b                   	pop    %ebx
80102c10:	5e                   	pop    %esi
80102c11:	5d                   	pop    %ebp
80102c12:	c3                   	ret
80102c13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c1a:	00 
80102c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102c20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102c27:	a1 94 26 11 80       	mov    0x80112694,%eax
80102c2c:	85 c0                	test   %eax,%eax
80102c2e:	75 20                	jne    80102c50 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102c30:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102c36:	85 db                	test   %ebx,%ebx
80102c38:	74 07                	je     80102c41 <kalloc+0x21>
    kmem.freelist = r->next;
80102c3a:	8b 03                	mov    (%ebx),%eax
80102c3c:	a3 98 26 11 80       	mov    %eax,0x80112698
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102c41:	89 d8                	mov    %ebx,%eax
80102c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c46:	c9                   	leave
80102c47:	c3                   	ret
80102c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c4f:	00 
    acquire(&kmem.lock);
80102c50:	83 ec 0c             	sub    $0xc,%esp
80102c53:	68 60 26 11 80       	push   $0x80112660
80102c58:	e8 03 1f 00 00       	call   80104b60 <acquire>
  r = kmem.freelist;
80102c5d:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(kmem.use_lock)
80102c63:	a1 94 26 11 80       	mov    0x80112694,%eax
  if(r)
80102c68:	83 c4 10             	add    $0x10,%esp
80102c6b:	85 db                	test   %ebx,%ebx
80102c6d:	74 08                	je     80102c77 <kalloc+0x57>
    kmem.freelist = r->next;
80102c6f:	8b 13                	mov    (%ebx),%edx
80102c71:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
80102c77:	85 c0                	test   %eax,%eax
80102c79:	74 c6                	je     80102c41 <kalloc+0x21>
    release(&kmem.lock);
80102c7b:	83 ec 0c             	sub    $0xc,%esp
80102c7e:	68 60 26 11 80       	push   $0x80112660
80102c83:	e8 78 1e 00 00       	call   80104b00 <release>
}
80102c88:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102c8a:	83 c4 10             	add    $0x10,%esp
}
80102c8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c90:	c9                   	leave
80102c91:	c3                   	ret
80102c92:	66 90                	xchg   %ax,%ax
80102c94:	66 90                	xchg   %ax,%ax
80102c96:	66 90                	xchg   %ax,%ax
80102c98:	66 90                	xchg   %ax,%ax
80102c9a:	66 90                	xchg   %ax,%ax
80102c9c:	66 90                	xchg   %ax,%ax
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ca5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ca6:	a8 01                	test   $0x1,%al
80102ca8:	0f 84 c2 00 00 00    	je     80102d70 <kbdgetc+0xd0>
{
80102cae:	55                   	push   %ebp
80102caf:	ba 60 00 00 00       	mov    $0x60,%edx
80102cb4:	89 e5                	mov    %esp,%ebp
80102cb6:	53                   	push   %ebx
80102cb7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102cb8:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  data = inb(KBDATAP);
80102cbe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102cc1:	3c e0                	cmp    $0xe0,%al
80102cc3:	74 5b                	je     80102d20 <kbdgetc+0x80>

    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cc5:	89 da                	mov    %ebx,%edx
80102cc7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102cca:	84 c0                	test   %al,%al
80102ccc:	78 62                	js     80102d30 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102cce:	85 d2                	test   %edx,%edx
80102cd0:	74 09                	je     80102cdb <kbdgetc+0x3b>
    //     return KEY_LEFT;
    //   case 0x4D:  
    //     shift &= ~E0ESC;
    //     return KEY_RIGHT;
    // }
    data |= 0x80;
80102cd2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102cd5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102cd8:	0f b6 c8             	movzbl %al,%ecx
    
  }

  shift |= shiftcode[data];
80102cdb:	0f b6 91 00 7f 10 80 	movzbl -0x7fef8100(%ecx),%edx
  shift ^= togglecode[data];
80102ce2:	0f b6 81 00 7e 10 80 	movzbl -0x7fef8200(%ecx),%eax
  shift |= shiftcode[data];
80102ce9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102ceb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ced:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102cef:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cf5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102cf8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102cfb:	8b 04 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%eax
80102d02:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102d06:	74 0b                	je     80102d13 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102d08:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d0b:	83 fa 19             	cmp    $0x19,%edx
80102d0e:	77 48                	ja     80102d58 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d10:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d16:	c9                   	leave
80102d17:	c3                   	ret
80102d18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d1f:	00 
    shift |= E0ESC;
80102d20:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102d23:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102d25:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
}
80102d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d2e:	c9                   	leave
80102d2f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102d30:	83 e0 7f             	and    $0x7f,%eax
80102d33:	85 d2                	test   %edx,%edx
80102d35:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102d38:	0f b6 81 00 7f 10 80 	movzbl -0x7fef8100(%ecx),%eax
80102d3f:	83 c8 40             	or     $0x40,%eax
80102d42:	0f b6 c0             	movzbl %al,%eax
80102d45:	f7 d0                	not    %eax
80102d47:	21 d8                	and    %ebx,%eax
80102d49:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    return 0;
80102d4e:	31 c0                	xor    %eax,%eax
80102d50:	eb d9                	jmp    80102d2b <kbdgetc+0x8b>
80102d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102d58:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102d5b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d61:	c9                   	leave
      c += 'a' - 'A';
80102d62:	83 f9 1a             	cmp    $0x1a,%ecx
80102d65:	0f 42 c2             	cmovb  %edx,%eax
}
80102d68:	c3                   	ret
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d75:	c3                   	ret
80102d76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d7d:	00 
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <kbdintr>:

void
kbdintr(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102d86:	68 a0 2c 10 80       	push   $0x80102ca0
80102d8b:	e8 50 de ff ff       	call   80100be0 <consoleintr>
}
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	c9                   	leave
80102d94:	c3                   	ret
80102d95:	66 90                	xchg   %ax,%ax
80102d97:	66 90                	xchg   %ax,%ax
80102d99:	66 90                	xchg   %ax,%ax
80102d9b:	66 90                	xchg   %ax,%ax
80102d9d:	66 90                	xchg   %ax,%ax
80102d9f:	90                   	nop

80102da0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102da0:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102da5:	85 c0                	test   %eax,%eax
80102da7:	0f 84 c3 00 00 00    	je     80102e70 <lapicinit+0xd0>
  lapic[index] = value;
80102dad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102db4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102db7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102dc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dc7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102dce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102dd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dd4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ddb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102dde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102de1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102de8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102deb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102df5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102df8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dfb:	8b 50 30             	mov    0x30(%eax),%edx
80102dfe:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102e04:	75 72                	jne    80102e78 <lapicinit+0xd8>
  lapic[index] = value;
80102e06:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e20:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e2d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e3a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102e41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e47:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102e4e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102e51:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102e5e:	80 e6 10             	and    $0x10,%dh
80102e61:	75 f5                	jne    80102e58 <lapicinit+0xb8>
  lapic[index] = value;
80102e63:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102e6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e6d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e70:	c3                   	ret
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102e78:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102e7f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e82:	8b 50 20             	mov    0x20(%eax),%edx
}
80102e85:	e9 7c ff ff ff       	jmp    80102e06 <lapicinit+0x66>
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102e90:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102e95:	85 c0                	test   %eax,%eax
80102e97:	74 07                	je     80102ea0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102e99:	8b 40 20             	mov    0x20(%eax),%eax
80102e9c:	c1 e8 18             	shr    $0x18,%eax
80102e9f:	c3                   	ret
    return 0;
80102ea0:	31 c0                	xor    %eax,%eax
}
80102ea2:	c3                   	ret
80102ea3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102eaa:	00 
80102eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102eb0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102eb0:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102eb5:	85 c0                	test   %eax,%eax
80102eb7:	74 0d                	je     80102ec6 <lapiceoi+0x16>
  lapic[index] = value;
80102eb9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ec0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ec6:	c3                   	ret
80102ec7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ece:	00 
80102ecf:	90                   	nop

80102ed0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ed0:	c3                   	ret
80102ed1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ed8:	00 
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ee0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ee0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ee6:	ba 70 00 00 00       	mov    $0x70,%edx
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ef1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ef4:	ee                   	out    %al,(%dx)
80102ef5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102efa:	ba 71 00 00 00       	mov    $0x71,%edx
80102eff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f00:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102f02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102f10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102f12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102f18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102f1e:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102f23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102f33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102f40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f6d:	c9                   	leave
80102f6e:	c3                   	ret
80102f6f:	90                   	nop

80102f70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102f70:	55                   	push   %ebp
80102f71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102f76:	ba 70 00 00 00       	mov    $0x70,%edx
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	57                   	push   %edi
80102f7e:	56                   	push   %esi
80102f7f:	53                   	push   %ebx
80102f80:	83 ec 4c             	sub    $0x4c,%esp
80102f83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f84:	ba 71 00 00 00       	mov    $0x71,%edx
80102f89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102f8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f8d:	bf 70 00 00 00       	mov    $0x70,%edi
80102f92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f95:	8d 76 00             	lea    0x0(%esi),%esi
80102f98:	31 c0                	xor    %eax,%eax
80102f9a:	89 fa                	mov    %edi,%edx
80102f9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102fa2:	89 ca                	mov    %ecx,%edx
80102fa4:	ec                   	in     (%dx),%al
80102fa5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fa8:	89 fa                	mov    %edi,%edx
80102faa:	b8 02 00 00 00       	mov    $0x2,%eax
80102faf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fb0:	89 ca                	mov    %ecx,%edx
80102fb2:	ec                   	in     (%dx),%al
80102fb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fb6:	89 fa                	mov    %edi,%edx
80102fb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102fbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fbe:	89 ca                	mov    %ecx,%edx
80102fc0:	ec                   	in     (%dx),%al
80102fc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fc4:	89 fa                	mov    %edi,%edx
80102fc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102fcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fcc:	89 ca                	mov    %ecx,%edx
80102fce:	ec                   	in     (%dx),%al
80102fcf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd2:	89 fa                	mov    %edi,%edx
80102fd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102fd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fda:	89 ca                	mov    %ecx,%edx
80102fdc:	ec                   	in     (%dx),%al
80102fdd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fdf:	89 fa                	mov    %edi,%edx
80102fe1:	b8 09 00 00 00       	mov    $0x9,%eax
80102fe6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe7:	89 ca                	mov    %ecx,%edx
80102fe9:	ec                   	in     (%dx),%al
80102fea:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fed:	89 fa                	mov    %edi,%edx
80102fef:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ff4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff5:	89 ca                	mov    %ecx,%edx
80102ff7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ff8:	84 c0                	test   %al,%al
80102ffa:	78 9c                	js     80102f98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ffc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103000:	89 f2                	mov    %esi,%edx
80103002:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103005:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103008:	89 fa                	mov    %edi,%edx
8010300a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010300d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103011:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103014:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103017:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010301b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010301e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103022:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103025:	31 c0                	xor    %eax,%eax
80103027:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103028:	89 ca                	mov    %ecx,%edx
8010302a:	ec                   	in     (%dx),%al
8010302b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010302e:	89 fa                	mov    %edi,%edx
80103030:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103033:	b8 02 00 00 00       	mov    $0x2,%eax
80103038:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103039:	89 ca                	mov    %ecx,%edx
8010303b:	ec                   	in     (%dx),%al
8010303c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303f:	89 fa                	mov    %edi,%edx
80103041:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103044:	b8 04 00 00 00       	mov    $0x4,%eax
80103049:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010304a:	89 ca                	mov    %ecx,%edx
8010304c:	ec                   	in     (%dx),%al
8010304d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103050:	89 fa                	mov    %edi,%edx
80103052:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103055:	b8 07 00 00 00       	mov    $0x7,%eax
8010305a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010305b:	89 ca                	mov    %ecx,%edx
8010305d:	ec                   	in     (%dx),%al
8010305e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103061:	89 fa                	mov    %edi,%edx
80103063:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103066:	b8 08 00 00 00       	mov    $0x8,%eax
8010306b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010306c:	89 ca                	mov    %ecx,%edx
8010306e:	ec                   	in     (%dx),%al
8010306f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103072:	89 fa                	mov    %edi,%edx
80103074:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103077:	b8 09 00 00 00       	mov    $0x9,%eax
8010307c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010307d:	89 ca                	mov    %ecx,%edx
8010307f:	ec                   	in     (%dx),%al
80103080:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103083:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103086:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103089:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010308c:	6a 18                	push   $0x18
8010308e:	50                   	push   %eax
8010308f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103092:	50                   	push   %eax
80103093:	e8 08 1c 00 00       	call   80104ca0 <memcmp>
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	85 c0                	test   %eax,%eax
8010309d:	0f 85 f5 fe ff ff    	jne    80102f98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801030a3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801030a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030aa:	89 f0                	mov    %esi,%eax
801030ac:	84 c0                	test   %al,%al
801030ae:	75 78                	jne    80103128 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801030b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030b3:	89 c2                	mov    %eax,%edx
801030b5:	83 e0 0f             	and    $0xf,%eax
801030b8:	c1 ea 04             	shr    $0x4,%edx
801030bb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030be:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801030c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801030c7:	89 c2                	mov    %eax,%edx
801030c9:	83 e0 0f             	and    $0xf,%eax
801030cc:	c1 ea 04             	shr    $0x4,%edx
801030cf:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030d2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801030d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030db:	89 c2                	mov    %eax,%edx
801030dd:	83 e0 0f             	and    $0xf,%eax
801030e0:	c1 ea 04             	shr    $0x4,%edx
801030e3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030e6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801030ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030ef:	89 c2                	mov    %eax,%edx
801030f1:	83 e0 0f             	and    $0xf,%eax
801030f4:	c1 ea 04             	shr    $0x4,%edx
801030f7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030fa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103100:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103103:	89 c2                	mov    %eax,%edx
80103105:	83 e0 0f             	and    $0xf,%eax
80103108:	c1 ea 04             	shr    $0x4,%edx
8010310b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010310e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103111:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103114:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103117:	89 c2                	mov    %eax,%edx
80103119:	83 e0 0f             	and    $0xf,%eax
8010311c:	c1 ea 04             	shr    $0x4,%edx
8010311f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103122:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103125:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103128:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010312b:	89 03                	mov    %eax,(%ebx)
8010312d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103130:	89 43 04             	mov    %eax,0x4(%ebx)
80103133:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103136:	89 43 08             	mov    %eax,0x8(%ebx)
80103139:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010313c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010313f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103142:	89 43 10             	mov    %eax,0x10(%ebx)
80103145:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103148:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010314b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103155:	5b                   	pop    %ebx
80103156:	5e                   	pop    %esi
80103157:	5f                   	pop    %edi
80103158:	5d                   	pop    %ebp
80103159:	c3                   	ret
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103160:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80103166:	85 c9                	test   %ecx,%ecx
80103168:	0f 8e 8a 00 00 00    	jle    801031f8 <install_trans+0x98>
{
8010316e:	55                   	push   %ebp
8010316f:	89 e5                	mov    %esp,%ebp
80103171:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103172:	31 ff                	xor    %edi,%edi
{
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 0c             	sub    $0xc,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103180:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80103185:	83 ec 08             	sub    $0x8,%esp
80103188:	01 f8                	add    %edi,%eax
8010318a:	83 c0 01             	add    $0x1,%eax
8010318d:	50                   	push   %eax
8010318e:	ff 35 04 27 11 80    	push   0x80112704
80103194:	e8 37 cf ff ff       	call   801000d0 <bread>
80103199:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010319b:	58                   	pop    %eax
8010319c:	5a                   	pop    %edx
8010319d:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
801031a4:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
801031aa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031ad:	e8 1e cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801031b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031b5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801031b7:	8d 46 5c             	lea    0x5c(%esi),%eax
801031ba:	68 00 02 00 00       	push   $0x200
801031bf:	50                   	push   %eax
801031c0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801031c3:	50                   	push   %eax
801031c4:	e8 27 1b 00 00       	call   80104cf0 <memmove>
    bwrite(dbuf);  // write dst to disk
801031c9:	89 1c 24             	mov    %ebx,(%esp)
801031cc:	e8 df cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801031d1:	89 34 24             	mov    %esi,(%esp)
801031d4:	e8 17 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801031d9:	89 1c 24             	mov    %ebx,(%esp)
801031dc:	e8 0f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031e1:	83 c4 10             	add    $0x10,%esp
801031e4:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
801031ea:	7f 94                	jg     80103180 <install_trans+0x20>
  }
}
801031ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031ef:	5b                   	pop    %ebx
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031f8:	c3                   	ret
801031f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103200 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103207:	ff 35 f4 26 11 80    	push   0x801126f4
8010320d:	ff 35 04 27 11 80    	push   0x80112704
80103213:	e8 b8 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103218:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010321b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010321d:	a1 08 27 11 80       	mov    0x80112708,%eax
80103222:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103225:	85 c0                	test   %eax,%eax
80103227:	7e 19                	jle    80103242 <write_head+0x42>
80103229:	31 d2                	xor    %edx,%edx
8010322b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103230:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80103237:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010323b:	83 c2 01             	add    $0x1,%edx
8010323e:	39 d0                	cmp    %edx,%eax
80103240:	75 ee                	jne    80103230 <write_head+0x30>
  }
  bwrite(buf);
80103242:	83 ec 0c             	sub    $0xc,%esp
80103245:	53                   	push   %ebx
80103246:	e8 65 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010324b:	89 1c 24             	mov    %ebx,(%esp)
8010324e:	e8 9d cf ff ff       	call   801001f0 <brelse>
}
80103253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103256:	83 c4 10             	add    $0x10,%esp
80103259:	c9                   	leave
8010325a:	c3                   	ret
8010325b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103260 <initlog>:
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	53                   	push   %ebx
80103264:	83 ec 2c             	sub    $0x2c,%esp
80103267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010326a:	68 f7 78 10 80       	push   $0x801078f7
8010326f:	68 c0 26 11 80       	push   $0x801126c0
80103274:	e8 f7 16 00 00       	call   80104970 <initlock>
  readsb(dev, &sb);
80103279:	58                   	pop    %eax
8010327a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010327d:	5a                   	pop    %edx
8010327e:	50                   	push   %eax
8010327f:	53                   	push   %ebx
80103280:	e8 7b e8 ff ff       	call   80101b00 <readsb>
  log.start = sb.logstart;
80103285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103288:	59                   	pop    %ecx
  log.dev = dev;
80103289:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
8010328f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103292:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80103297:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
8010329d:	5a                   	pop    %edx
8010329e:	50                   	push   %eax
8010329f:	53                   	push   %ebx
801032a0:	e8 2b ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801032a5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801032a8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801032ab:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
801032b1:	85 db                	test   %ebx,%ebx
801032b3:	7e 1d                	jle    801032d2 <initlog+0x72>
801032b5:	31 d2                	xor    %edx,%edx
801032b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032be:	00 
801032bf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801032c0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801032c4:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801032cb:	83 c2 01             	add    $0x1,%edx
801032ce:	39 d3                	cmp    %edx,%ebx
801032d0:	75 ee                	jne    801032c0 <initlog+0x60>
  brelse(buf);
801032d2:	83 ec 0c             	sub    $0xc,%esp
801032d5:	50                   	push   %eax
801032d6:	e8 15 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801032db:	e8 80 fe ff ff       	call   80103160 <install_trans>
  log.lh.n = 0;
801032e0:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
801032e7:	00 00 00 
  write_head(); // clear the log
801032ea:	e8 11 ff ff ff       	call   80103200 <write_head>
}
801032ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032f2:	83 c4 10             	add    $0x10,%esp
801032f5:	c9                   	leave
801032f6:	c3                   	ret
801032f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032fe:	00 
801032ff:	90                   	nop

80103300 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103306:	68 c0 26 11 80       	push   $0x801126c0
8010330b:	e8 50 18 00 00       	call   80104b60 <acquire>
80103310:	83 c4 10             	add    $0x10,%esp
80103313:	eb 18                	jmp    8010332d <begin_op+0x2d>
80103315:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103318:	83 ec 08             	sub    $0x8,%esp
8010331b:	68 c0 26 11 80       	push   $0x801126c0
80103320:	68 c0 26 11 80       	push   $0x801126c0
80103325:	e8 b6 12 00 00       	call   801045e0 <sleep>
8010332a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010332d:	a1 00 27 11 80       	mov    0x80112700,%eax
80103332:	85 c0                	test   %eax,%eax
80103334:	75 e2                	jne    80103318 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103336:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010333b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103341:	83 c0 01             	add    $0x1,%eax
80103344:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103347:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010334a:	83 fa 1e             	cmp    $0x1e,%edx
8010334d:	7f c9                	jg     80103318 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010334f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103352:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80103357:	68 c0 26 11 80       	push   $0x801126c0
8010335c:	e8 9f 17 00 00       	call   80104b00 <release>
      break;
    }
  }
}
80103361:	83 c4 10             	add    $0x10,%esp
80103364:	c9                   	leave
80103365:	c3                   	ret
80103366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010336d:	00 
8010336e:	66 90                	xchg   %ax,%ax

80103370 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103379:	68 c0 26 11 80       	push   $0x801126c0
8010337e:	e8 dd 17 00 00       	call   80104b60 <acquire>
  log.outstanding -= 1;
80103383:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80103388:	8b 35 00 27 11 80    	mov    0x80112700,%esi
8010338e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103391:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103394:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
8010339a:	85 f6                	test   %esi,%esi
8010339c:	0f 85 22 01 00 00    	jne    801034c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801033a2:	85 db                	test   %ebx,%ebx
801033a4:	0f 85 f6 00 00 00    	jne    801034a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801033aa:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
801033b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801033b4:	83 ec 0c             	sub    $0xc,%esp
801033b7:	68 c0 26 11 80       	push   $0x801126c0
801033bc:	e8 3f 17 00 00       	call   80104b00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801033c1:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
801033c7:	83 c4 10             	add    $0x10,%esp
801033ca:	85 c9                	test   %ecx,%ecx
801033cc:	7f 42                	jg     80103410 <end_op+0xa0>
    acquire(&log.lock);
801033ce:	83 ec 0c             	sub    $0xc,%esp
801033d1:	68 c0 26 11 80       	push   $0x801126c0
801033d6:	e8 85 17 00 00       	call   80104b60 <acquire>
    log.committing = 0;
801033db:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
801033e2:	00 00 00 
    wakeup(&log);
801033e5:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801033ec:	e8 af 12 00 00       	call   801046a0 <wakeup>
    release(&log.lock);
801033f1:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801033f8:	e8 03 17 00 00       	call   80104b00 <release>
801033fd:	83 c4 10             	add    $0x10,%esp
}
80103400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103403:	5b                   	pop    %ebx
80103404:	5e                   	pop    %esi
80103405:	5f                   	pop    %edi
80103406:	5d                   	pop    %ebp
80103407:	c3                   	ret
80103408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010340f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103410:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80103415:	83 ec 08             	sub    $0x8,%esp
80103418:	01 d8                	add    %ebx,%eax
8010341a:	83 c0 01             	add    $0x1,%eax
8010341d:	50                   	push   %eax
8010341e:	ff 35 04 27 11 80    	push   0x80112704
80103424:	e8 a7 cc ff ff       	call   801000d0 <bread>
80103429:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010342b:	58                   	pop    %eax
8010342c:	5a                   	pop    %edx
8010342d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
80103434:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
8010343a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010343d:	e8 8e cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103442:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103445:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103447:	8d 40 5c             	lea    0x5c(%eax),%eax
8010344a:	68 00 02 00 00       	push   $0x200
8010344f:	50                   	push   %eax
80103450:	8d 46 5c             	lea    0x5c(%esi),%eax
80103453:	50                   	push   %eax
80103454:	e8 97 18 00 00       	call   80104cf0 <memmove>
    bwrite(to);  // write the log
80103459:	89 34 24             	mov    %esi,(%esp)
8010345c:	e8 4f cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103461:	89 3c 24             	mov    %edi,(%esp)
80103464:	e8 87 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
80103469:	89 34 24             	mov    %esi,(%esp)
8010346c:	e8 7f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103471:	83 c4 10             	add    $0x10,%esp
80103474:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
8010347a:	7c 94                	jl     80103410 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010347c:	e8 7f fd ff ff       	call   80103200 <write_head>
    install_trans(); // Now install writes to home locations
80103481:	e8 da fc ff ff       	call   80103160 <install_trans>
    log.lh.n = 0;
80103486:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
8010348d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103490:	e8 6b fd ff ff       	call   80103200 <write_head>
80103495:	e9 34 ff ff ff       	jmp    801033ce <end_op+0x5e>
8010349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 c0 26 11 80       	push   $0x801126c0
801034a8:	e8 f3 11 00 00       	call   801046a0 <wakeup>
  release(&log.lock);
801034ad:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801034b4:	e8 47 16 00 00       	call   80104b00 <release>
801034b9:	83 c4 10             	add    $0x10,%esp
}
801034bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034bf:	5b                   	pop    %ebx
801034c0:	5e                   	pop    %esi
801034c1:	5f                   	pop    %edi
801034c2:	5d                   	pop    %ebp
801034c3:	c3                   	ret
    panic("log.committing");
801034c4:	83 ec 0c             	sub    $0xc,%esp
801034c7:	68 fb 78 10 80       	push   $0x801078fb
801034cc:	e8 af ce ff ff       	call   80100380 <panic>
801034d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034d8:	00 
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	53                   	push   %ebx
801034e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801034e7:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
801034ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801034f0:	83 fa 1d             	cmp    $0x1d,%edx
801034f3:	7f 7d                	jg     80103572 <log_write+0x92>
801034f5:	a1 f8 26 11 80       	mov    0x801126f8,%eax
801034fa:	83 e8 01             	sub    $0x1,%eax
801034fd:	39 c2                	cmp    %eax,%edx
801034ff:	7d 71                	jge    80103572 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103501:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80103506:	85 c0                	test   %eax,%eax
80103508:	7e 75                	jle    8010357f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010350a:	83 ec 0c             	sub    $0xc,%esp
8010350d:	68 c0 26 11 80       	push   $0x801126c0
80103512:	e8 49 16 00 00       	call   80104b60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103517:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	31 c0                	xor    %eax,%eax
8010351f:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103525:	85 d2                	test   %edx,%edx
80103527:	7f 0e                	jg     80103537 <log_write+0x57>
80103529:	eb 15                	jmp    80103540 <log_write+0x60>
8010352b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103530:	83 c0 01             	add    $0x1,%eax
80103533:	39 c2                	cmp    %eax,%edx
80103535:	74 29                	je     80103560 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103537:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
8010353e:	75 f0                	jne    80103530 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103540:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
80103547:	39 c2                	cmp    %eax,%edx
80103549:	74 1c                	je     80103567 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010354b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010354e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103551:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80103558:	c9                   	leave
  release(&log.lock);
80103559:	e9 a2 15 00 00       	jmp    80104b00 <release>
8010355e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103560:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
80103567:	83 c2 01             	add    $0x1,%edx
8010356a:	89 15 08 27 11 80    	mov    %edx,0x80112708
80103570:	eb d9                	jmp    8010354b <log_write+0x6b>
    panic("too big a transaction");
80103572:	83 ec 0c             	sub    $0xc,%esp
80103575:	68 0a 79 10 80       	push   $0x8010790a
8010357a:	e8 01 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010357f:	83 ec 0c             	sub    $0xc,%esp
80103582:	68 20 79 10 80       	push   $0x80107920
80103587:	e8 f4 cd ff ff       	call   80100380 <panic>
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	53                   	push   %ebx
80103594:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103597:	e8 64 09 00 00       	call   80103f00 <cpuid>
8010359c:	89 c3                	mov    %eax,%ebx
8010359e:	e8 5d 09 00 00       	call   80103f00 <cpuid>
801035a3:	83 ec 04             	sub    $0x4,%esp
801035a6:	53                   	push   %ebx
801035a7:	50                   	push   %eax
801035a8:	68 3b 79 10 80       	push   $0x8010793b
801035ad:	e8 ee d1 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801035b2:	e8 e9 28 00 00       	call   80105ea0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801035b7:	e8 e4 08 00 00       	call   80103ea0 <mycpu>
801035bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801035be:	b8 01 00 00 00       	mov    $0x1,%eax
801035c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801035ca:	e8 01 0c 00 00       	call   801041d0 <scheduler>
801035cf:	90                   	nop

801035d0 <mpenter>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801035d6:	e8 c5 39 00 00       	call   80106fa0 <switchkvm>
  seginit();
801035db:	e8 30 39 00 00       	call   80106f10 <seginit>
  lapicinit();
801035e0:	e8 bb f7 ff ff       	call   80102da0 <lapicinit>
  mpmain();
801035e5:	e8 a6 ff ff ff       	call   80103590 <mpmain>
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <main>:
{
801035f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801035f4:	83 e4 f0             	and    $0xfffffff0,%esp
801035f7:	ff 71 fc             	push   -0x4(%ecx)
801035fa:	55                   	push   %ebp
801035fb:	89 e5                	mov    %esp,%ebp
801035fd:	53                   	push   %ebx
801035fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801035ff:	83 ec 08             	sub    $0x8,%esp
80103602:	68 00 00 40 80       	push   $0x80400000
80103607:	68 f0 64 11 80       	push   $0x801164f0
8010360c:	e8 9f f5 ff ff       	call   80102bb0 <kinit1>
  kvmalloc();      // kernel page table
80103611:	e8 4a 3e 00 00       	call   80107460 <kvmalloc>
  mpinit();        // detect other processors
80103616:	e8 85 01 00 00       	call   801037a0 <mpinit>
  lapicinit();     // interrupt controller
8010361b:	e8 80 f7 ff ff       	call   80102da0 <lapicinit>
  seginit();       // segment descriptors
80103620:	e8 eb 38 00 00       	call   80106f10 <seginit>
  picinit();       // disable pic
80103625:	e8 86 03 00 00       	call   801039b0 <picinit>
  ioapicinit();    // another interrupt controller
8010362a:	e8 51 f3 ff ff       	call   80102980 <ioapicinit>
  consoleinit();   // console hardware
8010362f:	e8 ec d9 ff ff       	call   80101020 <consoleinit>
  uartinit();      // serial port
80103634:	e8 47 2b 00 00       	call   80106180 <uartinit>
  pinit();         // process table
80103639:	e8 42 08 00 00       	call   80103e80 <pinit>
  tvinit();        // trap vectors
8010363e:	e8 dd 27 00 00       	call   80105e20 <tvinit>
  binit();         // buffer cache
80103643:	e8 f8 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103648:	e8 a3 dd ff ff       	call   801013f0 <fileinit>
  ideinit();       // disk 
8010364d:	e8 0e f1 ff ff       	call   80102760 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103652:	83 c4 0c             	add    $0xc,%esp
80103655:	68 8a 00 00 00       	push   $0x8a
8010365a:	68 8c b4 10 80       	push   $0x8010b48c
8010365f:	68 00 70 00 80       	push   $0x80007000
80103664:	e8 87 16 00 00       	call   80104cf0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103673:	00 00 00 
80103676:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010367b:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
80103680:	76 7e                	jbe    80103700 <main+0x110>
80103682:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
80103687:	eb 20                	jmp    801036a9 <main+0xb9>
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103690:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103697:	00 00 00 
8010369a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801036a0:	05 c0 27 11 80       	add    $0x801127c0,%eax
801036a5:	39 c3                	cmp    %eax,%ebx
801036a7:	73 57                	jae    80103700 <main+0x110>
    if(c == mycpu())  // We've started already.
801036a9:	e8 f2 07 00 00       	call   80103ea0 <mycpu>
801036ae:	39 c3                	cmp    %eax,%ebx
801036b0:	74 de                	je     80103690 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801036b2:	e8 69 f5 ff ff       	call   80102c20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801036b7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801036ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801035d0,0x80006ff8
801036c1:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801036c4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801036cb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801036ce:	05 00 10 00 00       	add    $0x1000,%eax
801036d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801036d8:	0f b6 03             	movzbl (%ebx),%eax
801036db:	68 00 70 00 00       	push   $0x7000
801036e0:	50                   	push   %eax
801036e1:	e8 fa f7 ff ff       	call   80102ee0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801036e6:	83 c4 10             	add    $0x10,%esp
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801036f6:	85 c0                	test   %eax,%eax
801036f8:	74 f6                	je     801036f0 <main+0x100>
801036fa:	eb 94                	jmp    80103690 <main+0xa0>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	68 00 00 00 8e       	push   $0x8e000000
80103708:	68 00 00 40 80       	push   $0x80400000
8010370d:	e8 3e f4 ff ff       	call   80102b50 <kinit2>
  userinit();      // first user process
80103712:	e8 39 08 00 00       	call   80103f50 <userinit>
  mpmain();        // finish this processor's setup
80103717:	e8 74 fe ff ff       	call   80103590 <mpmain>
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103725:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010372b:	53                   	push   %ebx
  e = addr+len;
8010372c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010372f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103732:	39 de                	cmp    %ebx,%esi
80103734:	72 10                	jb     80103746 <mpsearch1+0x26>
80103736:	eb 50                	jmp    80103788 <mpsearch1+0x68>
80103738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010373f:	00 
80103740:	89 fe                	mov    %edi,%esi
80103742:	39 df                	cmp    %ebx,%edi
80103744:	73 42                	jae    80103788 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103746:	83 ec 04             	sub    $0x4,%esp
80103749:	8d 7e 10             	lea    0x10(%esi),%edi
8010374c:	6a 04                	push   $0x4
8010374e:	68 4f 79 10 80       	push   $0x8010794f
80103753:	56                   	push   %esi
80103754:	e8 47 15 00 00       	call   80104ca0 <memcmp>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	85 c0                	test   %eax,%eax
8010375e:	75 e0                	jne    80103740 <mpsearch1+0x20>
80103760:	89 f2                	mov    %esi,%edx
80103762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103768:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010376b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010376e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103770:	39 fa                	cmp    %edi,%edx
80103772:	75 f4                	jne    80103768 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103774:	84 c0                	test   %al,%al
80103776:	75 c8                	jne    80103740 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103778:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010377b:	89 f0                	mov    %esi,%eax
8010377d:	5b                   	pop    %ebx
8010377e:	5e                   	pop    %esi
8010377f:	5f                   	pop    %edi
80103780:	5d                   	pop    %ebp
80103781:	c3                   	ret
80103782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010378b:	31 f6                	xor    %esi,%esi
}
8010378d:	5b                   	pop    %ebx
8010378e:	89 f0                	mov    %esi,%eax
80103790:	5e                   	pop    %esi
80103791:	5f                   	pop    %edi
80103792:	5d                   	pop    %ebp
80103793:	c3                   	ret
80103794:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010379b:	00 
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
801037a4:	56                   	push   %esi
801037a5:	53                   	push   %ebx
801037a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801037b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801037b7:	c1 e0 08             	shl    $0x8,%eax
801037ba:	09 d0                	or     %edx,%eax
801037bc:	c1 e0 04             	shl    $0x4,%eax
801037bf:	75 1b                	jne    801037dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801037c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801037c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801037cf:	c1 e0 08             	shl    $0x8,%eax
801037d2:	09 d0                	or     %edx,%eax
801037d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801037d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801037dc:	ba 00 04 00 00       	mov    $0x400,%edx
801037e1:	e8 3a ff ff ff       	call   80103720 <mpsearch1>
801037e6:	89 c3                	mov    %eax,%ebx
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 84 58 01 00 00    	je     80103948 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037f0:	8b 73 04             	mov    0x4(%ebx),%esi
801037f3:	85 f6                	test   %esi,%esi
801037f5:	0f 84 3d 01 00 00    	je     80103938 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801037fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037fe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103807:	6a 04                	push   $0x4
80103809:	68 54 79 10 80       	push   $0x80107954
8010380e:	50                   	push   %eax
8010380f:	e8 8c 14 00 00       	call   80104ca0 <memcmp>
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	85 c0                	test   %eax,%eax
80103819:	0f 85 19 01 00 00    	jne    80103938 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010381f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103826:	3c 01                	cmp    $0x1,%al
80103828:	74 08                	je     80103832 <mpinit+0x92>
8010382a:	3c 04                	cmp    $0x4,%al
8010382c:	0f 85 06 01 00 00    	jne    80103938 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103832:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103839:	66 85 d2             	test   %dx,%dx
8010383c:	74 22                	je     80103860 <mpinit+0xc0>
8010383e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103841:	89 f0                	mov    %esi,%eax
  sum = 0;
80103843:	31 d2                	xor    %edx,%edx
80103845:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103848:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010384f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103852:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103854:	39 f8                	cmp    %edi,%eax
80103856:	75 f0                	jne    80103848 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103858:	84 d2                	test   %dl,%dl
8010385a:	0f 85 d8 00 00 00    	jne    80103938 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103860:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103869:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010386c:	a3 a0 26 11 80       	mov    %eax,0x801126a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103871:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103878:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010387e:	01 d7                	add    %edx,%edi
80103880:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103882:	bf 01 00 00 00       	mov    $0x1,%edi
80103887:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010388e:	00 
8010388f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103890:	39 d0                	cmp    %edx,%eax
80103892:	73 19                	jae    801038ad <mpinit+0x10d>
    switch(*p){
80103894:	0f b6 08             	movzbl (%eax),%ecx
80103897:	80 f9 02             	cmp    $0x2,%cl
8010389a:	0f 84 80 00 00 00    	je     80103920 <mpinit+0x180>
801038a0:	77 6e                	ja     80103910 <mpinit+0x170>
801038a2:	84 c9                	test   %cl,%cl
801038a4:	74 3a                	je     801038e0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801038a6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038a9:	39 d0                	cmp    %edx,%eax
801038ab:	72 e7                	jb     80103894 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801038ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801038b0:	85 ff                	test   %edi,%edi
801038b2:	0f 84 dd 00 00 00    	je     80103995 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801038b8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801038bc:	74 15                	je     801038d3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038be:	b8 70 00 00 00       	mov    $0x70,%eax
801038c3:	ba 22 00 00 00       	mov    $0x22,%edx
801038c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801038c9:	ba 23 00 00 00       	mov    $0x23,%edx
801038ce:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801038cf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038d2:	ee                   	out    %al,(%dx)
  }
}
801038d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d6:	5b                   	pop    %ebx
801038d7:	5e                   	pop    %esi
801038d8:	5f                   	pop    %edi
801038d9:	5d                   	pop    %ebp
801038da:	c3                   	ret
801038db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801038e0:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
801038e6:	83 f9 07             	cmp    $0x7,%ecx
801038e9:	7f 19                	jg     80103904 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038eb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801038f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038f5:	83 c1 01             	add    $0x1,%ecx
801038f8:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038fe:	88 9e c0 27 11 80    	mov    %bl,-0x7feed840(%esi)
      p += sizeof(struct mpproc);
80103904:	83 c0 14             	add    $0x14,%eax
      continue;
80103907:	eb 87                	jmp    80103890 <mpinit+0xf0>
80103909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103910:	83 e9 03             	sub    $0x3,%ecx
80103913:	80 f9 01             	cmp    $0x1,%cl
80103916:	76 8e                	jbe    801038a6 <mpinit+0x106>
80103918:	31 ff                	xor    %edi,%edi
8010391a:	e9 71 ff ff ff       	jmp    80103890 <mpinit+0xf0>
8010391f:	90                   	nop
      ioapicid = ioapic->apicno;
80103920:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103924:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103927:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010392d:	e9 5e ff ff ff       	jmp    80103890 <mpinit+0xf0>
80103932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103938:	83 ec 0c             	sub    $0xc,%esp
8010393b:	68 59 79 10 80       	push   $0x80107959
80103940:	e8 3b ca ff ff       	call   80100380 <panic>
80103945:	8d 76 00             	lea    0x0(%esi),%esi
{
80103948:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010394d:	eb 0b                	jmp    8010395a <mpinit+0x1ba>
8010394f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103950:	89 f3                	mov    %esi,%ebx
80103952:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103958:	74 de                	je     80103938 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010395a:	83 ec 04             	sub    $0x4,%esp
8010395d:	8d 73 10             	lea    0x10(%ebx),%esi
80103960:	6a 04                	push   $0x4
80103962:	68 4f 79 10 80       	push   $0x8010794f
80103967:	53                   	push   %ebx
80103968:	e8 33 13 00 00       	call   80104ca0 <memcmp>
8010396d:	83 c4 10             	add    $0x10,%esp
80103970:	85 c0                	test   %eax,%eax
80103972:	75 dc                	jne    80103950 <mpinit+0x1b0>
80103974:	89 da                	mov    %ebx,%edx
80103976:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010397d:	00 
8010397e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103980:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103983:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103986:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103988:	39 d6                	cmp    %edx,%esi
8010398a:	75 f4                	jne    80103980 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010398c:	84 c0                	test   %al,%al
8010398e:	75 c0                	jne    80103950 <mpinit+0x1b0>
80103990:	e9 5b fe ff ff       	jmp    801037f0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103995:	83 ec 0c             	sub    $0xc,%esp
80103998:	68 bc 7c 10 80       	push   $0x80107cbc
8010399d:	e8 de c9 ff ff       	call   80100380 <panic>
801039a2:	66 90                	xchg   %ax,%ax
801039a4:	66 90                	xchg   %ax,%ax
801039a6:	66 90                	xchg   %ax,%ax
801039a8:	66 90                	xchg   %ax,%ax
801039aa:	66 90                	xchg   %ax,%ax
801039ac:	66 90                	xchg   %ax,%ax
801039ae:	66 90                	xchg   %ax,%ax

801039b0 <picinit>:
801039b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039b5:	ba 21 00 00 00       	mov    $0x21,%edx
801039ba:	ee                   	out    %al,(%dx)
801039bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801039c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801039c1:	c3                   	ret
801039c2:	66 90                	xchg   %ax,%ax
801039c4:	66 90                	xchg   %ax,%ax
801039c6:	66 90                	xchg   %ax,%ax
801039c8:	66 90                	xchg   %ax,%ax
801039ca:	66 90                	xchg   %ax,%ax
801039cc:	66 90                	xchg   %ax,%ax
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 0c             	sub    $0xc,%esp
801039d9:	8b 75 08             	mov    0x8(%ebp),%esi
801039dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801039df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801039e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801039eb:	e8 20 da ff ff       	call   80101410 <filealloc>
801039f0:	89 06                	mov    %eax,(%esi)
801039f2:	85 c0                	test   %eax,%eax
801039f4:	0f 84 a5 00 00 00    	je     80103a9f <pipealloc+0xcf>
801039fa:	e8 11 da ff ff       	call   80101410 <filealloc>
801039ff:	89 07                	mov    %eax,(%edi)
80103a01:	85 c0                	test   %eax,%eax
80103a03:	0f 84 84 00 00 00    	je     80103a8d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a09:	e8 12 f2 ff ff       	call   80102c20 <kalloc>
80103a0e:	89 c3                	mov    %eax,%ebx
80103a10:	85 c0                	test   %eax,%eax
80103a12:	0f 84 a0 00 00 00    	je     80103ab8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103a18:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103a1f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103a22:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103a25:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103a2c:	00 00 00 
  p->nwrite = 0;
80103a2f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a36:	00 00 00 
  p->nread = 0;
80103a39:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103a40:	00 00 00 
  initlock(&p->lock, "pipe");
80103a43:	68 71 79 10 80       	push   $0x80107971
80103a48:	50                   	push   %eax
80103a49:	e8 22 0f 00 00       	call   80104970 <initlock>
  (*f0)->type = FD_PIPE;
80103a4e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103a50:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103a53:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103a59:	8b 06                	mov    (%esi),%eax
80103a5b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103a5f:	8b 06                	mov    (%esi),%eax
80103a61:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103a65:	8b 06                	mov    (%esi),%eax
80103a67:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103a6a:	8b 07                	mov    (%edi),%eax
80103a6c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103a72:	8b 07                	mov    (%edi),%eax
80103a74:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103a78:	8b 07                	mov    (%edi),%eax
80103a7a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103a7e:	8b 07                	mov    (%edi),%eax
80103a80:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103a83:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a88:	5b                   	pop    %ebx
80103a89:	5e                   	pop    %esi
80103a8a:	5f                   	pop    %edi
80103a8b:	5d                   	pop    %ebp
80103a8c:	c3                   	ret
  if(*f0)
80103a8d:	8b 06                	mov    (%esi),%eax
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	74 1e                	je     80103ab1 <pipealloc+0xe1>
    fileclose(*f0);
80103a93:	83 ec 0c             	sub    $0xc,%esp
80103a96:	50                   	push   %eax
80103a97:	e8 34 da ff ff       	call   801014d0 <fileclose>
80103a9c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a9f:	8b 07                	mov    (%edi),%eax
80103aa1:	85 c0                	test   %eax,%eax
80103aa3:	74 0c                	je     80103ab1 <pipealloc+0xe1>
    fileclose(*f1);
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	50                   	push   %eax
80103aa9:	e8 22 da ff ff       	call   801014d0 <fileclose>
80103aae:	83 c4 10             	add    $0x10,%esp
  return -1;
80103ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ab6:	eb cd                	jmp    80103a85 <pipealloc+0xb5>
  if(*f0)
80103ab8:	8b 06                	mov    (%esi),%eax
80103aba:	85 c0                	test   %eax,%eax
80103abc:	75 d5                	jne    80103a93 <pipealloc+0xc3>
80103abe:	eb df                	jmp    80103a9f <pipealloc+0xcf>

80103ac0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ac8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103acb:	83 ec 0c             	sub    $0xc,%esp
80103ace:	53                   	push   %ebx
80103acf:	e8 8c 10 00 00       	call   80104b60 <acquire>
  if(writable){
80103ad4:	83 c4 10             	add    $0x10,%esp
80103ad7:	85 f6                	test   %esi,%esi
80103ad9:	74 65                	je     80103b40 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103adb:	83 ec 0c             	sub    $0xc,%esp
80103ade:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103ae4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103aeb:	00 00 00 
    wakeup(&p->nread);
80103aee:	50                   	push   %eax
80103aef:	e8 ac 0b 00 00       	call   801046a0 <wakeup>
80103af4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103af7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103afd:	85 d2                	test   %edx,%edx
80103aff:	75 0a                	jne    80103b0b <pipeclose+0x4b>
80103b01:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b07:	85 c0                	test   %eax,%eax
80103b09:	74 15                	je     80103b20 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103b0b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b11:	5b                   	pop    %ebx
80103b12:	5e                   	pop    %esi
80103b13:	5d                   	pop    %ebp
    release(&p->lock);
80103b14:	e9 e7 0f 00 00       	jmp    80104b00 <release>
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	53                   	push   %ebx
80103b24:	e8 d7 0f 00 00       	call   80104b00 <release>
    kfree((char*)p);
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b32:	5b                   	pop    %ebx
80103b33:	5e                   	pop    %esi
80103b34:	5d                   	pop    %ebp
    kfree((char*)p);
80103b35:	e9 26 ef ff ff       	jmp    80102a60 <kfree>
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103b49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b50:	00 00 00 
    wakeup(&p->nwrite);
80103b53:	50                   	push   %eax
80103b54:	e8 47 0b 00 00       	call   801046a0 <wakeup>
80103b59:	83 c4 10             	add    $0x10,%esp
80103b5c:	eb 99                	jmp    80103af7 <pipeclose+0x37>
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 28             	sub    $0x28,%esp
80103b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b6c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b6f:	53                   	push   %ebx
80103b70:	e8 eb 0f 00 00       	call   80104b60 <acquire>
  for(i = 0; i < n; i++){
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	85 ff                	test   %edi,%edi
80103b7a:	0f 8e ce 00 00 00    	jle    80103c4e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b80:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103b89:	89 7d 10             	mov    %edi,0x10(%ebp)
80103b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b8f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103b92:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103b95:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b9b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ba1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ba7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103bad:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103bb0:	0f 85 b6 00 00 00    	jne    80103c6c <pipewrite+0x10c>
80103bb6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103bb9:	eb 3b                	jmp    80103bf6 <pipewrite+0x96>
80103bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103bc0:	e8 5b 03 00 00       	call   80103f20 <myproc>
80103bc5:	8b 48 24             	mov    0x24(%eax),%ecx
80103bc8:	85 c9                	test   %ecx,%ecx
80103bca:	75 34                	jne    80103c00 <pipewrite+0xa0>
      wakeup(&p->nread);
80103bcc:	83 ec 0c             	sub    $0xc,%esp
80103bcf:	56                   	push   %esi
80103bd0:	e8 cb 0a 00 00       	call   801046a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103bd5:	58                   	pop    %eax
80103bd6:	5a                   	pop    %edx
80103bd7:	53                   	push   %ebx
80103bd8:	57                   	push   %edi
80103bd9:	e8 02 0a 00 00       	call   801045e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103bde:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103be4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103bea:	83 c4 10             	add    $0x10,%esp
80103bed:	05 00 02 00 00       	add    $0x200,%eax
80103bf2:	39 c2                	cmp    %eax,%edx
80103bf4:	75 2a                	jne    80103c20 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103bf6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103bfc:	85 c0                	test   %eax,%eax
80103bfe:	75 c0                	jne    80103bc0 <pipewrite+0x60>
        release(&p->lock);
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	53                   	push   %ebx
80103c04:	e8 f7 0e 00 00       	call   80104b00 <release>
        return -1;
80103c09:	83 c4 10             	add    $0x10,%esp
80103c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c14:	5b                   	pop    %ebx
80103c15:	5e                   	pop    %esi
80103c16:	5f                   	pop    %edi
80103c17:	5d                   	pop    %ebp
80103c18:	c3                   	ret
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c23:	8d 42 01             	lea    0x1(%edx),%eax
80103c26:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80103c2c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c2f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c38:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80103c3c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c43:	39 c1                	cmp    %eax,%ecx
80103c45:	0f 85 50 ff ff ff    	jne    80103b9b <pipewrite+0x3b>
80103c4b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c57:	50                   	push   %eax
80103c58:	e8 43 0a 00 00       	call   801046a0 <wakeup>
  release(&p->lock);
80103c5d:	89 1c 24             	mov    %ebx,(%esp)
80103c60:	e8 9b 0e 00 00       	call   80104b00 <release>
  return n;
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	89 f8                	mov    %edi,%eax
80103c6a:	eb a5                	jmp    80103c11 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c6f:	eb b2                	jmp    80103c23 <pipewrite+0xc3>
80103c71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c78:	00 
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 18             	sub    $0x18,%esp
80103c89:	8b 75 08             	mov    0x8(%ebp),%esi
80103c8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103c8f:	56                   	push   %esi
80103c90:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c96:	e8 c5 0e 00 00       	call   80104b60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c9b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103caa:	74 2f                	je     80103cdb <piperead+0x5b>
80103cac:	eb 37                	jmp    80103ce5 <piperead+0x65>
80103cae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103cb0:	e8 6b 02 00 00       	call   80103f20 <myproc>
80103cb5:	8b 40 24             	mov    0x24(%eax),%eax
80103cb8:	85 c0                	test   %eax,%eax
80103cba:	0f 85 80 00 00 00    	jne    80103d40 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103cc0:	83 ec 08             	sub    $0x8,%esp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	e8 16 09 00 00       	call   801045e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cca:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103cd9:	75 0a                	jne    80103ce5 <piperead+0x65>
80103cdb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103ce1:	85 d2                	test   %edx,%edx
80103ce3:	75 cb                	jne    80103cb0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ce5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103ce8:	31 db                	xor    %ebx,%ebx
80103cea:	85 c9                	test   %ecx,%ecx
80103cec:	7f 26                	jg     80103d14 <piperead+0x94>
80103cee:	eb 2c                	jmp    80103d1c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103cf0:	8d 48 01             	lea    0x1(%eax),%ecx
80103cf3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103cf8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103cfe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103d03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d06:	83 c3 01             	add    $0x1,%ebx
80103d09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d0c:	74 0e                	je     80103d1c <piperead+0x9c>
80103d0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103d14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103d1a:	75 d4                	jne    80103cf0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103d1c:	83 ec 0c             	sub    $0xc,%esp
80103d1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103d25:	50                   	push   %eax
80103d26:	e8 75 09 00 00       	call   801046a0 <wakeup>
  release(&p->lock);
80103d2b:	89 34 24             	mov    %esi,(%esp)
80103d2e:	e8 cd 0d 00 00       	call   80104b00 <release>
  return i;
80103d33:	83 c4 10             	add    $0x10,%esp
}
80103d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d39:	89 d8                	mov    %ebx,%eax
80103d3b:	5b                   	pop    %ebx
80103d3c:	5e                   	pop    %esi
80103d3d:	5f                   	pop    %edi
80103d3e:	5d                   	pop    %ebp
80103d3f:	c3                   	ret
      release(&p->lock);
80103d40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d48:	56                   	push   %esi
80103d49:	e8 b2 0d 00 00       	call   80104b00 <release>
      return -1;
80103d4e:	83 c4 10             	add    $0x10,%esp
}
80103d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d54:	89 d8                	mov    %ebx,%eax
80103d56:	5b                   	pop    %ebx
80103d57:	5e                   	pop    %esi
80103d58:	5f                   	pop    %edi
80103d59:	5d                   	pop    %ebp
80103d5a:	c3                   	ret
80103d5b:	66 90                	xchg   %ax,%ax
80103d5d:	66 90                	xchg   %ax,%ax
80103d5f:	90                   	nop

80103d60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d64:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103d69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103d6c:	68 40 2d 11 80       	push   $0x80112d40
80103d71:	e8 ea 0d 00 00       	call   80104b60 <acquire>
80103d76:	83 c4 10             	add    $0x10,%esp
80103d79:	eb 10                	jmp    80103d8b <allocproc+0x2b>
80103d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d80:	83 c3 7c             	add    $0x7c,%ebx
80103d83:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103d89:	74 75                	je     80103e00 <allocproc+0xa0>
    if(p->state == UNUSED)
80103d8b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d8e:	85 c0                	test   %eax,%eax
80103d90:	75 ee                	jne    80103d80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103d92:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103d97:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d9a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103da1:	89 43 10             	mov    %eax,0x10(%ebx)
80103da4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103da7:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
80103dac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103db2:	e8 49 0d 00 00       	call   80104b00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103db7:	e8 64 ee ff ff       	call   80102c20 <kalloc>
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	89 43 08             	mov    %eax,0x8(%ebx)
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	74 53                	je     80103e19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103dc6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103dcc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103dcf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103dd4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103dd7:	c7 40 14 12 5e 10 80 	movl   $0x80105e12,0x14(%eax)
  p->context = (struct context*)sp;
80103dde:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103de1:	6a 14                	push   $0x14
80103de3:	6a 00                	push   $0x0
80103de5:	50                   	push   %eax
80103de6:	e8 75 0e 00 00       	call   80104c60 <memset>
  p->context->eip = (uint)forkret;
80103deb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103dee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103df1:	c7 40 10 30 3e 10 80 	movl   $0x80103e30,0x10(%eax)
}
80103df8:	89 d8                	mov    %ebx,%eax
80103dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dfd:	c9                   	leave
80103dfe:	c3                   	ret
80103dff:	90                   	nop
  release(&ptable.lock);
80103e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103e03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103e05:	68 40 2d 11 80       	push   $0x80112d40
80103e0a:	e8 f1 0c 00 00       	call   80104b00 <release>
  return 0;
80103e0f:	83 c4 10             	add    $0x10,%esp
}
80103e12:	89 d8                	mov    %ebx,%eax
80103e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e17:	c9                   	leave
80103e18:	c3                   	ret
    p->state = UNUSED;
80103e19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103e20:	31 db                	xor    %ebx,%ebx
80103e22:	eb ee                	jmp    80103e12 <allocproc+0xb2>
80103e24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2b:	00 
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103e36:	68 40 2d 11 80       	push   $0x80112d40
80103e3b:	e8 c0 0c 00 00       	call   80104b00 <release>

  if (first) {
80103e40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103e45:	83 c4 10             	add    $0x10,%esp
80103e48:	85 c0                	test   %eax,%eax
80103e4a:	75 04                	jne    80103e50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e4c:	c9                   	leave
80103e4d:	c3                   	ret
80103e4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103e50:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103e57:	00 00 00 
    iinit(ROOTDEV);
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	6a 01                	push   $0x1
80103e5f:	e8 dc dc ff ff       	call   80101b40 <iinit>
    initlog(ROOTDEV);
80103e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e6b:	e8 f0 f3 ff ff       	call   80103260 <initlog>
}
80103e70:	83 c4 10             	add    $0x10,%esp
80103e73:	c9                   	leave
80103e74:	c3                   	ret
80103e75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e7c:	00 
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <pinit>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e86:	68 76 79 10 80       	push   $0x80107976
80103e8b:	68 40 2d 11 80       	push   $0x80112d40
80103e90:	e8 db 0a 00 00       	call   80104970 <initlock>
}
80103e95:	83 c4 10             	add    $0x10,%esp
80103e98:	c9                   	leave
80103e99:	c3                   	ret
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ea0 <mycpu>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	56                   	push   %esi
80103ea4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ea5:	9c                   	pushf
80103ea6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ea7:	f6 c4 02             	test   $0x2,%ah
80103eaa:	75 46                	jne    80103ef2 <mycpu+0x52>
  apicid = lapicid();
80103eac:	e8 df ef ff ff       	call   80102e90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103eb1:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103eb7:	85 f6                	test   %esi,%esi
80103eb9:	7e 2a                	jle    80103ee5 <mycpu+0x45>
80103ebb:	31 d2                	xor    %edx,%edx
80103ebd:	eb 08                	jmp    80103ec7 <mycpu+0x27>
80103ebf:	90                   	nop
80103ec0:	83 c2 01             	add    $0x1,%edx
80103ec3:	39 f2                	cmp    %esi,%edx
80103ec5:	74 1e                	je     80103ee5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ec7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ecd:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103ed4:	39 c3                	cmp    %eax,%ebx
80103ed6:	75 e8                	jne    80103ec0 <mycpu+0x20>
}
80103ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103edb:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103ee1:	5b                   	pop    %ebx
80103ee2:	5e                   	pop    %esi
80103ee3:	5d                   	pop    %ebp
80103ee4:	c3                   	ret
  panic("unknown apicid\n");
80103ee5:	83 ec 0c             	sub    $0xc,%esp
80103ee8:	68 7d 79 10 80       	push   $0x8010797d
80103eed:	e8 8e c4 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ef2:	83 ec 0c             	sub    $0xc,%esp
80103ef5:	68 dc 7c 10 80       	push   $0x80107cdc
80103efa:	e8 81 c4 ff ff       	call   80100380 <panic>
80103eff:	90                   	nop

80103f00 <cpuid>:
cpuid() {
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103f06:	e8 95 ff ff ff       	call   80103ea0 <mycpu>
}
80103f0b:	c9                   	leave
  return mycpu()-cpus;
80103f0c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103f11:	c1 f8 04             	sar    $0x4,%eax
80103f14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103f1a:	c3                   	ret
80103f1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103f20 <myproc>:
myproc(void) {
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103f27:	e8 e4 0a 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103f2c:	e8 6f ff ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
80103f31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f37:	e8 24 0b 00 00       	call   80104a60 <popcli>
}
80103f3c:	89 d8                	mov    %ebx,%eax
80103f3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f41:	c9                   	leave
80103f42:	c3                   	ret
80103f43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f4a:	00 
80103f4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103f50 <userinit>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f57:	e8 04 fe ff ff       	call   80103d60 <allocproc>
80103f5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f5e:	a3 74 4c 11 80       	mov    %eax,0x80114c74
  if((p->pgdir = setupkvm()) == 0)
80103f63:	e8 78 34 00 00       	call   801073e0 <setupkvm>
80103f68:	89 43 04             	mov    %eax,0x4(%ebx)
80103f6b:	85 c0                	test   %eax,%eax
80103f6d:	0f 84 bd 00 00 00    	je     80104030 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f73:	83 ec 04             	sub    $0x4,%esp
80103f76:	68 2c 00 00 00       	push   $0x2c
80103f7b:	68 60 b4 10 80       	push   $0x8010b460
80103f80:	50                   	push   %eax
80103f81:	e8 3a 31 00 00       	call   801070c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f8f:	6a 4c                	push   $0x4c
80103f91:	6a 00                	push   $0x0
80103f93:	ff 73 18             	push   0x18(%ebx)
80103f96:	e8 c5 0c 00 00       	call   80104c60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fa3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103fa6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103fab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103faf:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103fb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103fc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103fc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103fcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103fcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103fd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103fd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103fe0:	8b 43 18             	mov    0x18(%ebx),%eax
80103fe3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fed:	6a 10                	push   $0x10
80103fef:	68 a6 79 10 80       	push   $0x801079a6
80103ff4:	50                   	push   %eax
80103ff5:	e8 16 0e 00 00       	call   80104e10 <safestrcpy>
  p->cwd = namei("/");
80103ffa:	c7 04 24 af 79 10 80 	movl   $0x801079af,(%esp)
80104001:	e8 3a e6 ff ff       	call   80102640 <namei>
80104006:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104009:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104010:	e8 4b 0b 00 00       	call   80104b60 <acquire>
  p->state = RUNNABLE;
80104015:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010401c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104023:	e8 d8 0a 00 00       	call   80104b00 <release>
}
80104028:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010402b:	83 c4 10             	add    $0x10,%esp
8010402e:	c9                   	leave
8010402f:	c3                   	ret
    panic("userinit: out of memory?");
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	68 8d 79 10 80       	push   $0x8010798d
80104038:	e8 43 c3 ff ff       	call   80100380 <panic>
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <growproc>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104048:	e8 c3 09 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010404d:	e8 4e fe ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
80104052:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104058:	e8 03 0a 00 00       	call   80104a60 <popcli>
  sz = curproc->sz;
8010405d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010405f:	85 f6                	test   %esi,%esi
80104061:	7f 1d                	jg     80104080 <growproc+0x40>
  } else if(n < 0){
80104063:	75 3b                	jne    801040a0 <growproc+0x60>
  switchuvm(curproc);
80104065:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104068:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010406a:	53                   	push   %ebx
8010406b:	e8 40 2f 00 00       	call   80106fb0 <switchuvm>
  return 0;
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	31 c0                	xor    %eax,%eax
}
80104075:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104078:	5b                   	pop    %ebx
80104079:	5e                   	pop    %esi
8010407a:	5d                   	pop    %ebp
8010407b:	c3                   	ret
8010407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104080:	83 ec 04             	sub    $0x4,%esp
80104083:	01 c6                	add    %eax,%esi
80104085:	56                   	push   %esi
80104086:	50                   	push   %eax
80104087:	ff 73 04             	push   0x4(%ebx)
8010408a:	e8 81 31 00 00       	call   80107210 <allocuvm>
8010408f:	83 c4 10             	add    $0x10,%esp
80104092:	85 c0                	test   %eax,%eax
80104094:	75 cf                	jne    80104065 <growproc+0x25>
      return -1;
80104096:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010409b:	eb d8                	jmp    80104075 <growproc+0x35>
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801040a0:	83 ec 04             	sub    $0x4,%esp
801040a3:	01 c6                	add    %eax,%esi
801040a5:	56                   	push   %esi
801040a6:	50                   	push   %eax
801040a7:	ff 73 04             	push   0x4(%ebx)
801040aa:	e8 81 32 00 00       	call   80107330 <deallocuvm>
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	85 c0                	test   %eax,%eax
801040b4:	75 af                	jne    80104065 <growproc+0x25>
801040b6:	eb de                	jmp    80104096 <growproc+0x56>
801040b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040bf:	00 

801040c0 <fork>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801040c9:	e8 42 09 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801040ce:	e8 cd fd ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
801040d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d9:	e8 82 09 00 00       	call   80104a60 <popcli>
  if((np = allocproc()) == 0){
801040de:	e8 7d fc ff ff       	call   80103d60 <allocproc>
801040e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040e6:	85 c0                	test   %eax,%eax
801040e8:	0f 84 d6 00 00 00    	je     801041c4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801040ee:	83 ec 08             	sub    $0x8,%esp
801040f1:	ff 33                	push   (%ebx)
801040f3:	89 c7                	mov    %eax,%edi
801040f5:	ff 73 04             	push   0x4(%ebx)
801040f8:	e8 d3 33 00 00       	call   801074d0 <copyuvm>
801040fd:	83 c4 10             	add    $0x10,%esp
80104100:	89 47 04             	mov    %eax,0x4(%edi)
80104103:	85 c0                	test   %eax,%eax
80104105:	0f 84 9a 00 00 00    	je     801041a5 <fork+0xe5>
  np->sz = curproc->sz;
8010410b:	8b 03                	mov    (%ebx),%eax
8010410d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104110:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104112:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104115:	89 c8                	mov    %ecx,%eax
80104117:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010411a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010411f:	8b 73 18             	mov    0x18(%ebx),%esi
80104122:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104124:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104126:	8b 40 18             	mov    0x18(%eax),%eax
80104129:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104130:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104134:	85 c0                	test   %eax,%eax
80104136:	74 13                	je     8010414b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	50                   	push   %eax
8010413c:	e8 3f d3 ff ff       	call   80101480 <filedup>
80104141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104144:	83 c4 10             	add    $0x10,%esp
80104147:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010414b:	83 c6 01             	add    $0x1,%esi
8010414e:	83 fe 10             	cmp    $0x10,%esi
80104151:	75 dd                	jne    80104130 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104153:	83 ec 0c             	sub    $0xc,%esp
80104156:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104159:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010415c:	e8 cf db ff ff       	call   80101d30 <idup>
80104161:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104164:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104167:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010416a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010416d:	6a 10                	push   $0x10
8010416f:	53                   	push   %ebx
80104170:	50                   	push   %eax
80104171:	e8 9a 0c 00 00       	call   80104e10 <safestrcpy>
  pid = np->pid;
80104176:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104179:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104180:	e8 db 09 00 00       	call   80104b60 <acquire>
  np->state = RUNNABLE;
80104185:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010418c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104193:	e8 68 09 00 00       	call   80104b00 <release>
  return pid;
80104198:	83 c4 10             	add    $0x10,%esp
}
8010419b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010419e:	89 d8                	mov    %ebx,%eax
801041a0:	5b                   	pop    %ebx
801041a1:	5e                   	pop    %esi
801041a2:	5f                   	pop    %edi
801041a3:	5d                   	pop    %ebp
801041a4:	c3                   	ret
    kfree(np->kstack);
801041a5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	ff 73 08             	push   0x8(%ebx)
801041ae:	e8 ad e8 ff ff       	call   80102a60 <kfree>
    np->kstack = 0;
801041b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801041ba:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801041bd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801041c4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041c9:	eb d0                	jmp    8010419b <fork+0xdb>
801041cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801041d0 <scheduler>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801041d9:	e8 c2 fc ff ff       	call   80103ea0 <mycpu>
  c->proc = 0;
801041de:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041e5:	00 00 00 
  struct cpu *c = mycpu();
801041e8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801041ea:	8d 78 04             	lea    0x4(%eax),%edi
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801041f0:	fb                   	sti
    acquire(&ptable.lock);
801041f1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
801041f9:	68 40 2d 11 80       	push   $0x80112d40
801041fe:	e8 5d 09 00 00       	call   80104b60 <acquire>
80104203:	83 c4 10             	add    $0x10,%esp
80104206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010420d:	00 
8010420e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104210:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104214:	75 33                	jne    80104249 <scheduler+0x79>
      switchuvm(p);
80104216:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104219:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010421f:	53                   	push   %ebx
80104220:	e8 8b 2d 00 00       	call   80106fb0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104225:	58                   	pop    %eax
80104226:	5a                   	pop    %edx
80104227:	ff 73 1c             	push   0x1c(%ebx)
8010422a:	57                   	push   %edi
      p->state = RUNNING;
8010422b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104232:	e8 34 0c 00 00       	call   80104e6b <swtch>
      switchkvm();
80104237:	e8 64 2d 00 00       	call   80106fa0 <switchkvm>
      c->proc = 0;
8010423c:	83 c4 10             	add    $0x10,%esp
8010423f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104246:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104249:	83 c3 7c             	add    $0x7c,%ebx
8010424c:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80104252:	75 bc                	jne    80104210 <scheduler+0x40>
    release(&ptable.lock);
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	68 40 2d 11 80       	push   $0x80112d40
8010425c:	e8 9f 08 00 00       	call   80104b00 <release>
    sti();
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	eb 8a                	jmp    801041f0 <scheduler+0x20>
80104266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010426d:	00 
8010426e:	66 90                	xchg   %ax,%ax

80104270 <sched>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
  pushcli();
80104275:	e8 96 07 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010427a:	e8 21 fc ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
8010427f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104285:	e8 d6 07 00 00       	call   80104a60 <popcli>
  if(!holding(&ptable.lock))
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 40 2d 11 80       	push   $0x80112d40
80104292:	e8 29 08 00 00       	call   80104ac0 <holding>
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	85 c0                	test   %eax,%eax
8010429c:	74 4f                	je     801042ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010429e:	e8 fd fb ff ff       	call   80103ea0 <mycpu>
801042a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042aa:	75 68                	jne    80104314 <sched+0xa4>
  if(p->state == RUNNING)
801042ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042b0:	74 55                	je     80104307 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042b2:	9c                   	pushf
801042b3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042b4:	f6 c4 02             	test   $0x2,%ah
801042b7:	75 41                	jne    801042fa <sched+0x8a>
  intena = mycpu()->intena;
801042b9:	e8 e2 fb ff ff       	call   80103ea0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042c7:	e8 d4 fb ff ff       	call   80103ea0 <mycpu>
801042cc:	83 ec 08             	sub    $0x8,%esp
801042cf:	ff 70 04             	push   0x4(%eax)
801042d2:	53                   	push   %ebx
801042d3:	e8 93 0b 00 00       	call   80104e6b <swtch>
  mycpu()->intena = intena;
801042d8:	e8 c3 fb ff ff       	call   80103ea0 <mycpu>
}
801042dd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e9:	5b                   	pop    %ebx
801042ea:	5e                   	pop    %esi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret
    panic("sched ptable.lock");
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	68 b1 79 10 80       	push   $0x801079b1
801042f5:	e8 86 c0 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	68 dd 79 10 80       	push   $0x801079dd
80104302:	e8 79 c0 ff ff       	call   80100380 <panic>
    panic("sched running");
80104307:	83 ec 0c             	sub    $0xc,%esp
8010430a:	68 cf 79 10 80       	push   $0x801079cf
8010430f:	e8 6c c0 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	68 c3 79 10 80       	push   $0x801079c3
8010431c:	e8 5f c0 ff ff       	call   80100380 <panic>
80104321:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104328:	00 
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104330 <exit>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104339:	e8 e2 fb ff ff       	call   80103f20 <myproc>
  if(curproc == initproc)
8010433e:	39 05 74 4c 11 80    	cmp    %eax,0x80114c74
80104344:	0f 84 fd 00 00 00    	je     80104447 <exit+0x117>
8010434a:	89 c3                	mov    %eax,%ebx
8010434c:	8d 70 28             	lea    0x28(%eax),%esi
8010434f:	8d 78 68             	lea    0x68(%eax),%edi
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104358:	8b 06                	mov    (%esi),%eax
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 12                	je     80104370 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010435e:	83 ec 0c             	sub    $0xc,%esp
80104361:	50                   	push   %eax
80104362:	e8 69 d1 ff ff       	call   801014d0 <fileclose>
      curproc->ofile[fd] = 0;
80104367:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010436d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104370:	83 c6 04             	add    $0x4,%esi
80104373:	39 f7                	cmp    %esi,%edi
80104375:	75 e1                	jne    80104358 <exit+0x28>
  begin_op();
80104377:	e8 84 ef ff ff       	call   80103300 <begin_op>
  iput(curproc->cwd);
8010437c:	83 ec 0c             	sub    $0xc,%esp
8010437f:	ff 73 68             	push   0x68(%ebx)
80104382:	e8 09 db ff ff       	call   80101e90 <iput>
  end_op();
80104387:	e8 e4 ef ff ff       	call   80103370 <end_op>
  curproc->cwd = 0;
8010438c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104393:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010439a:	e8 c1 07 00 00       	call   80104b60 <acquire>
  wakeup1(curproc->parent);
8010439f:	8b 53 14             	mov    0x14(%ebx),%edx
801043a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a5:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801043aa:	eb 0e                	jmp    801043ba <exit+0x8a>
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801043b8:	74 1c                	je     801043d6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801043ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043be:	75 f0                	jne    801043b0 <exit+0x80>
801043c0:	3b 50 20             	cmp    0x20(%eax),%edx
801043c3:	75 eb                	jne    801043b0 <exit+0x80>
      p->state = RUNNABLE;
801043c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043cc:	83 c0 7c             	add    $0x7c,%eax
801043cf:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801043d4:	75 e4                	jne    801043ba <exit+0x8a>
      p->parent = initproc;
801043d6:	8b 0d 74 4c 11 80    	mov    0x80114c74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043dc:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801043e1:	eb 10                	jmp    801043f3 <exit+0xc3>
801043e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801043e8:	83 c2 7c             	add    $0x7c,%edx
801043eb:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
801043f1:	74 3b                	je     8010442e <exit+0xfe>
    if(p->parent == curproc){
801043f3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801043f6:	75 f0                	jne    801043e8 <exit+0xb8>
      if(p->state == ZOMBIE)
801043f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043ff:	75 e7                	jne    801043e8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104401:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104406:	eb 12                	jmp    8010441a <exit+0xea>
80104408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010440f:	00 
80104410:	83 c0 7c             	add    $0x7c,%eax
80104413:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104418:	74 ce                	je     801043e8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010441a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010441e:	75 f0                	jne    80104410 <exit+0xe0>
80104420:	3b 48 20             	cmp    0x20(%eax),%ecx
80104423:	75 eb                	jne    80104410 <exit+0xe0>
      p->state = RUNNABLE;
80104425:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010442c:	eb e2                	jmp    80104410 <exit+0xe0>
  curproc->state = ZOMBIE;
8010442e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104435:	e8 36 fe ff ff       	call   80104270 <sched>
  panic("zombie exit");
8010443a:	83 ec 0c             	sub    $0xc,%esp
8010443d:	68 fe 79 10 80       	push   $0x801079fe
80104442:	e8 39 bf ff ff       	call   80100380 <panic>
    panic("init exiting");
80104447:	83 ec 0c             	sub    $0xc,%esp
8010444a:	68 f1 79 10 80       	push   $0x801079f1
8010444f:	e8 2c bf ff ff       	call   80100380 <panic>
80104454:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010445b:	00 
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <wait>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
  pushcli();
80104465:	e8 a6 05 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010446a:	e8 31 fa ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
8010446f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104475:	e8 e6 05 00 00       	call   80104a60 <popcli>
  acquire(&ptable.lock);
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	68 40 2d 11 80       	push   $0x80112d40
80104482:	e8 d9 06 00 00       	call   80104b60 <acquire>
80104487:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010448a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010448c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104491:	eb 10                	jmp    801044a3 <wait+0x43>
80104493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104498:	83 c3 7c             	add    $0x7c,%ebx
8010449b:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801044a1:	74 1b                	je     801044be <wait+0x5e>
      if(p->parent != curproc)
801044a3:	39 73 14             	cmp    %esi,0x14(%ebx)
801044a6:	75 f0                	jne    80104498 <wait+0x38>
      if(p->state == ZOMBIE){
801044a8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044ac:	74 62                	je     80104510 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801044b1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b6:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801044bc:	75 e5                	jne    801044a3 <wait+0x43>
    if(!havekids || curproc->killed){
801044be:	85 c0                	test   %eax,%eax
801044c0:	0f 84 a0 00 00 00    	je     80104566 <wait+0x106>
801044c6:	8b 46 24             	mov    0x24(%esi),%eax
801044c9:	85 c0                	test   %eax,%eax
801044cb:	0f 85 95 00 00 00    	jne    80104566 <wait+0x106>
  pushcli();
801044d1:	e8 3a 05 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801044d6:	e8 c5 f9 ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
801044db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044e1:	e8 7a 05 00 00       	call   80104a60 <popcli>
  if(p == 0)
801044e6:	85 db                	test   %ebx,%ebx
801044e8:	0f 84 8f 00 00 00    	je     8010457d <wait+0x11d>
  p->chan = chan;
801044ee:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801044f1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044f8:	e8 73 fd ff ff       	call   80104270 <sched>
  p->chan = 0;
801044fd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104504:	eb 84                	jmp    8010448a <wait+0x2a>
80104506:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010450d:	00 
8010450e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104510:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104513:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104516:	ff 73 08             	push   0x8(%ebx)
80104519:	e8 42 e5 ff ff       	call   80102a60 <kfree>
        p->kstack = 0;
8010451e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104525:	5a                   	pop    %edx
80104526:	ff 73 04             	push   0x4(%ebx)
80104529:	e8 32 2e 00 00       	call   80107360 <freevm>
        p->pid = 0;
8010452e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104535:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010453c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104540:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104547:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010454e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104555:	e8 a6 05 00 00       	call   80104b00 <release>
        return pid;
8010455a:	83 c4 10             	add    $0x10,%esp
}
8010455d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104560:	89 f0                	mov    %esi,%eax
80104562:	5b                   	pop    %ebx
80104563:	5e                   	pop    %esi
80104564:	5d                   	pop    %ebp
80104565:	c3                   	ret
      release(&ptable.lock);
80104566:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104569:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010456e:	68 40 2d 11 80       	push   $0x80112d40
80104573:	e8 88 05 00 00       	call   80104b00 <release>
      return -1;
80104578:	83 c4 10             	add    $0x10,%esp
8010457b:	eb e0                	jmp    8010455d <wait+0xfd>
    panic("sleep");
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	68 0a 7a 10 80       	push   $0x80107a0a
80104585:	e8 f6 bd ff ff       	call   80100380 <panic>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <yield>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104597:	68 40 2d 11 80       	push   $0x80112d40
8010459c:	e8 bf 05 00 00       	call   80104b60 <acquire>
  pushcli();
801045a1:	e8 6a 04 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801045a6:	e8 f5 f8 ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
801045ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045b1:	e8 aa 04 00 00       	call   80104a60 <popcli>
  myproc()->state = RUNNABLE;
801045b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045bd:	e8 ae fc ff ff       	call   80104270 <sched>
  release(&ptable.lock);
801045c2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801045c9:	e8 32 05 00 00       	call   80104b00 <release>
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	83 c4 10             	add    $0x10,%esp
801045d4:	c9                   	leave
801045d5:	c3                   	ret
801045d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045dd:	00 
801045de:	66 90                	xchg   %ax,%ax

801045e0 <sleep>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 0c             	sub    $0xc,%esp
801045e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045ef:	e8 1c 04 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801045f4:	e8 a7 f8 ff ff       	call   80103ea0 <mycpu>
  p = c->proc;
801045f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045ff:	e8 5c 04 00 00       	call   80104a60 <popcli>
  if(p == 0)
80104604:	85 db                	test   %ebx,%ebx
80104606:	0f 84 87 00 00 00    	je     80104693 <sleep+0xb3>
  if(lk == 0)
8010460c:	85 f6                	test   %esi,%esi
8010460e:	74 76                	je     80104686 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104610:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80104616:	74 50                	je     80104668 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	68 40 2d 11 80       	push   $0x80112d40
80104620:	e8 3b 05 00 00       	call   80104b60 <acquire>
    release(lk);
80104625:	89 34 24             	mov    %esi,(%esp)
80104628:	e8 d3 04 00 00       	call   80104b00 <release>
  p->chan = chan;
8010462d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104630:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104637:	e8 34 fc ff ff       	call   80104270 <sched>
  p->chan = 0;
8010463c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104643:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010464a:	e8 b1 04 00 00       	call   80104b00 <release>
    acquire(lk);
8010464f:	83 c4 10             	add    $0x10,%esp
80104652:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5f                   	pop    %edi
8010465b:	5d                   	pop    %ebp
    acquire(lk);
8010465c:	e9 ff 04 00 00       	jmp    80104b60 <acquire>
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104668:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010466b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104672:	e8 f9 fb ff ff       	call   80104270 <sched>
  p->chan = 0;
80104677:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010467e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104681:	5b                   	pop    %ebx
80104682:	5e                   	pop    %esi
80104683:	5f                   	pop    %edi
80104684:	5d                   	pop    %ebp
80104685:	c3                   	ret
    panic("sleep without lk");
80104686:	83 ec 0c             	sub    $0xc,%esp
80104689:	68 10 7a 10 80       	push   $0x80107a10
8010468e:	e8 ed bc ff ff       	call   80100380 <panic>
    panic("sleep");
80104693:	83 ec 0c             	sub    $0xc,%esp
80104696:	68 0a 7a 10 80       	push   $0x80107a0a
8010469b:	e8 e0 bc ff ff       	call   80100380 <panic>

801046a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 10             	sub    $0x10,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046aa:	68 40 2d 11 80       	push   $0x80112d40
801046af:	e8 ac 04 00 00       	call   80104b60 <acquire>
801046b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046b7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801046bc:	eb 0c                	jmp    801046ca <wakeup+0x2a>
801046be:	66 90                	xchg   %ax,%ax
801046c0:	83 c0 7c             	add    $0x7c,%eax
801046c3:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801046c8:	74 1c                	je     801046e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801046ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046ce:	75 f0                	jne    801046c0 <wakeup+0x20>
801046d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801046d3:	75 eb                	jne    801046c0 <wakeup+0x20>
      p->state = RUNNABLE;
801046d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046dc:	83 c0 7c             	add    $0x7c,%eax
801046df:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801046e4:	75 e4                	jne    801046ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801046e6:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave
  release(&ptable.lock);
801046f1:	e9 0a 04 00 00       	jmp    80104b00 <release>
801046f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046fd:	00 
801046fe:	66 90                	xchg   %ax,%ax

80104700 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 10             	sub    $0x10,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010470a:	68 40 2d 11 80       	push   $0x80112d40
8010470f:	e8 4c 04 00 00       	call   80104b60 <acquire>
80104714:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104717:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010471c:	eb 0c                	jmp    8010472a <kill+0x2a>
8010471e:	66 90                	xchg   %ax,%ax
80104720:	83 c0 7c             	add    $0x7c,%eax
80104723:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104728:	74 36                	je     80104760 <kill+0x60>
    if(p->pid == pid){
8010472a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010472d:	75 f1                	jne    80104720 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010472f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104733:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010473a:	75 07                	jne    80104743 <kill+0x43>
        p->state = RUNNABLE;
8010473c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	68 40 2d 11 80       	push   $0x80112d40
8010474b:	e8 b0 03 00 00       	call   80104b00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104753:	83 c4 10             	add    $0x10,%esp
80104756:	31 c0                	xor    %eax,%eax
}
80104758:	c9                   	leave
80104759:	c3                   	ret
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104760:	83 ec 0c             	sub    $0xc,%esp
80104763:	68 40 2d 11 80       	push   $0x80112d40
80104768:	e8 93 03 00 00       	call   80104b00 <release>
}
8010476d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104770:	83 c4 10             	add    $0x10,%esp
80104773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104778:	c9                   	leave
80104779:	c3                   	ret
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104788:	53                   	push   %ebx
80104789:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
8010478e:	83 ec 3c             	sub    $0x3c,%esp
80104791:	eb 24                	jmp    801047b7 <procdump+0x37>
80104793:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 cf 7b 10 80       	push   $0x80107bcf
801047a0:	e8 fb bf ff ff       	call   801007a0 <cprintf>
801047a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a8:	83 c3 7c             	add    $0x7c,%ebx
801047ab:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
801047b1:	0f 84 81 00 00 00    	je     80104838 <procdump+0xb8>
    if(p->state == UNUSED)
801047b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047ba:	85 c0                	test   %eax,%eax
801047bc:	74 ea                	je     801047a8 <procdump+0x28>
      state = "???";
801047be:	ba 21 7a 10 80       	mov    $0x80107a21,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047c3:	83 f8 05             	cmp    $0x5,%eax
801047c6:	77 11                	ja     801047d9 <procdump+0x59>
801047c8:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
      state = "???";
801047cf:	b8 21 7a 10 80       	mov    $0x80107a21,%eax
801047d4:	85 d2                	test   %edx,%edx
801047d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047d9:	53                   	push   %ebx
801047da:	52                   	push   %edx
801047db:	ff 73 a4             	push   -0x5c(%ebx)
801047de:	68 25 7a 10 80       	push   $0x80107a25
801047e3:	e8 b8 bf ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
801047e8:	83 c4 10             	add    $0x10,%esp
801047eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801047ef:	75 a7                	jne    80104798 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047f1:	83 ec 08             	sub    $0x8,%esp
801047f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047fa:	50                   	push   %eax
801047fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801047fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104801:	83 c0 08             	add    $0x8,%eax
80104804:	50                   	push   %eax
80104805:	e8 86 01 00 00       	call   80104990 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010480a:	83 c4 10             	add    $0x10,%esp
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	8b 17                	mov    (%edi),%edx
80104812:	85 d2                	test   %edx,%edx
80104814:	74 82                	je     80104798 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104816:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104819:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010481c:	52                   	push   %edx
8010481d:	68 61 77 10 80       	push   $0x80107761
80104822:	e8 79 bf ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104827:	83 c4 10             	add    $0x10,%esp
8010482a:	39 f7                	cmp    %esi,%edi
8010482c:	75 e2                	jne    80104810 <procdump+0x90>
8010482e:	e9 65 ff ff ff       	jmp    80104798 <procdump+0x18>
80104833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104838:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010483b:	5b                   	pop    %ebx
8010483c:	5e                   	pop    %esi
8010483d:	5f                   	pop    %edi
8010483e:	5d                   	pop    %ebp
8010483f:	c3                   	ret

80104840 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010484a:	68 58 7a 10 80       	push   $0x80107a58
8010484f:	8d 43 04             	lea    0x4(%ebx),%eax
80104852:	50                   	push   %eax
80104853:	e8 18 01 00 00       	call   80104970 <initlock>
  lk->name = name;
80104858:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010485b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104861:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104864:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010486b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010486e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104871:	c9                   	leave
80104872:	c3                   	ret
80104873:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487a:	00 
8010487b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104880 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104888:	8d 73 04             	lea    0x4(%ebx),%esi
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	56                   	push   %esi
8010488f:	e8 cc 02 00 00       	call   80104b60 <acquire>
  while (lk->locked) {
80104894:	8b 13                	mov    (%ebx),%edx
80104896:	83 c4 10             	add    $0x10,%esp
80104899:	85 d2                	test   %edx,%edx
8010489b:	74 16                	je     801048b3 <acquiresleep+0x33>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801048a0:	83 ec 08             	sub    $0x8,%esp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	e8 36 fd ff ff       	call   801045e0 <sleep>
  while (lk->locked) {
801048aa:	8b 03                	mov    (%ebx),%eax
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	85 c0                	test   %eax,%eax
801048b1:	75 ed                	jne    801048a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801048b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048b9:	e8 62 f6 ff ff       	call   80103f20 <myproc>
801048be:	8b 40 10             	mov    0x10(%eax),%eax
801048c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ca:	5b                   	pop    %ebx
801048cb:	5e                   	pop    %esi
801048cc:	5d                   	pop    %ebp
  release(&lk->lk);
801048cd:	e9 2e 02 00 00       	jmp    80104b00 <release>
801048d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048d9:	00 
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048e8:	8d 73 04             	lea    0x4(%ebx),%esi
801048eb:	83 ec 0c             	sub    $0xc,%esp
801048ee:	56                   	push   %esi
801048ef:	e8 6c 02 00 00       	call   80104b60 <acquire>
  lk->locked = 0;
801048f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104901:	89 1c 24             	mov    %ebx,(%esp)
80104904:	e8 97 fd ff ff       	call   801046a0 <wakeup>
  release(&lk->lk);
80104909:	83 c4 10             	add    $0x10,%esp
8010490c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010490f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104912:	5b                   	pop    %ebx
80104913:	5e                   	pop    %esi
80104914:	5d                   	pop    %ebp
  release(&lk->lk);
80104915:	e9 e6 01 00 00       	jmp    80104b00 <release>
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	31 ff                	xor    %edi,%edi
80104926:	56                   	push   %esi
80104927:	53                   	push   %ebx
80104928:	83 ec 18             	sub    $0x18,%esp
8010492b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010492e:	8d 73 04             	lea    0x4(%ebx),%esi
80104931:	56                   	push   %esi
80104932:	e8 29 02 00 00       	call   80104b60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104937:	8b 03                	mov    (%ebx),%eax
80104939:	83 c4 10             	add    $0x10,%esp
8010493c:	85 c0                	test   %eax,%eax
8010493e:	75 18                	jne    80104958 <holdingsleep+0x38>
  release(&lk->lk);
80104940:	83 ec 0c             	sub    $0xc,%esp
80104943:	56                   	push   %esi
80104944:	e8 b7 01 00 00       	call   80104b00 <release>
  return r;
}
80104949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010494c:	89 f8                	mov    %edi,%eax
8010494e:	5b                   	pop    %ebx
8010494f:	5e                   	pop    %esi
80104950:	5f                   	pop    %edi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret
80104953:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104958:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010495b:	e8 c0 f5 ff ff       	call   80103f20 <myproc>
80104960:	39 58 10             	cmp    %ebx,0x10(%eax)
80104963:	0f 94 c0             	sete   %al
80104966:	0f b6 c0             	movzbl %al,%eax
80104969:	89 c7                	mov    %eax,%edi
8010496b:	eb d3                	jmp    80104940 <holdingsleep+0x20>
8010496d:	66 90                	xchg   %ax,%ax
8010496f:	90                   	nop

80104970 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104976:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104979:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010497f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104982:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret
8010498b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104990 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	8b 45 08             	mov    0x8(%ebp),%eax
80104997:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010499a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010499d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801049a2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801049a7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049ac:	76 10                	jbe    801049be <getcallerpcs+0x2e>
801049ae:	eb 28                	jmp    801049d8 <getcallerpcs+0x48>
801049b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049bc:	77 1a                	ja     801049d8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049be:	8b 5a 04             	mov    0x4(%edx),%ebx
801049c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801049c4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801049c7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801049c9:	83 f8 0a             	cmp    $0xa,%eax
801049cc:	75 e2                	jne    801049b0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d1:	c9                   	leave
801049d2:	c3                   	ret
801049d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049d8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801049db:	83 c1 28             	add    $0x28,%ecx
801049de:	89 ca                	mov    %ecx,%edx
801049e0:	29 c2                	sub    %eax,%edx
801049e2:	83 e2 04             	and    $0x4,%edx
801049e5:	74 11                	je     801049f8 <getcallerpcs+0x68>
    pcs[i] = 0;
801049e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049ed:	83 c0 04             	add    $0x4,%eax
801049f0:	39 c1                	cmp    %eax,%ecx
801049f2:	74 da                	je     801049ce <getcallerpcs+0x3e>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801049f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049fe:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104a01:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104a08:	39 c1                	cmp    %eax,%ecx
80104a0a:	75 ec                	jne    801049f8 <getcallerpcs+0x68>
80104a0c:	eb c0                	jmp    801049ce <getcallerpcs+0x3e>
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	9c                   	pushf
80104a18:	5b                   	pop    %ebx
  asm volatile("cli");
80104a19:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a1a:	e8 81 f4 ff ff       	call   80103ea0 <mycpu>
80104a1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a25:	85 c0                	test   %eax,%eax
80104a27:	74 17                	je     80104a40 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104a29:	e8 72 f4 ff ff       	call   80103ea0 <mycpu>
80104a2e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a38:	c9                   	leave
80104a39:	c3                   	ret
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104a40:	e8 5b f4 ff ff       	call   80103ea0 <mycpu>
80104a45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a51:	eb d6                	jmp    80104a29 <pushcli+0x19>
80104a53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5a:	00 
80104a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a60 <popcli>:

void
popcli(void)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a66:	9c                   	pushf
80104a67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a68:	f6 c4 02             	test   $0x2,%ah
80104a6b:	75 35                	jne    80104aa2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a6d:	e8 2e f4 ff ff       	call   80103ea0 <mycpu>
80104a72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a79:	78 34                	js     80104aaf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a7b:	e8 20 f4 ff ff       	call   80103ea0 <mycpu>
80104a80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a86:	85 d2                	test   %edx,%edx
80104a88:	74 06                	je     80104a90 <popcli+0x30>
    sti();
}
80104a8a:	c9                   	leave
80104a8b:	c3                   	ret
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a90:	e8 0b f4 ff ff       	call   80103ea0 <mycpu>
80104a95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a9b:	85 c0                	test   %eax,%eax
80104a9d:	74 eb                	je     80104a8a <popcli+0x2a>
  asm volatile("sti");
80104a9f:	fb                   	sti
}
80104aa0:	c9                   	leave
80104aa1:	c3                   	ret
    panic("popcli - interruptible");
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	68 63 7a 10 80       	push   $0x80107a63
80104aaa:	e8 d1 b8 ff ff       	call   80100380 <panic>
    panic("popcli");
80104aaf:	83 ec 0c             	sub    $0xc,%esp
80104ab2:	68 7a 7a 10 80       	push   $0x80107a7a
80104ab7:	e8 c4 b8 ff ff       	call   80100380 <panic>
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <holding>:
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ac8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104aca:	e8 41 ff ff ff       	call   80104a10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104acf:	8b 06                	mov    (%esi),%eax
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	75 0b                	jne    80104ae0 <holding+0x20>
  popcli();
80104ad5:	e8 86 ff ff ff       	call   80104a60 <popcli>
}
80104ada:	89 d8                	mov    %ebx,%eax
80104adc:	5b                   	pop    %ebx
80104add:	5e                   	pop    %esi
80104ade:	5d                   	pop    %ebp
80104adf:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104ae0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ae3:	e8 b8 f3 ff ff       	call   80103ea0 <mycpu>
80104ae8:	39 c3                	cmp    %eax,%ebx
80104aea:	0f 94 c3             	sete   %bl
  popcli();
80104aed:	e8 6e ff ff ff       	call   80104a60 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104af2:	0f b6 db             	movzbl %bl,%ebx
}
80104af5:	89 d8                	mov    %ebx,%eax
80104af7:	5b                   	pop    %ebx
80104af8:	5e                   	pop    %esi
80104af9:	5d                   	pop    %ebp
80104afa:	c3                   	ret
80104afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104b00 <release>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104b08:	e8 03 ff ff ff       	call   80104a10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b0d:	8b 03                	mov    (%ebx),%eax
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	75 15                	jne    80104b28 <release+0x28>
  popcli();
80104b13:	e8 48 ff ff ff       	call   80104a60 <popcli>
    panic("release");
80104b18:	83 ec 0c             	sub    $0xc,%esp
80104b1b:	68 81 7a 10 80       	push   $0x80107a81
80104b20:	e8 5b b8 ff ff       	call   80100380 <panic>
80104b25:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b28:	8b 73 08             	mov    0x8(%ebx),%esi
80104b2b:	e8 70 f3 ff ff       	call   80103ea0 <mycpu>
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	75 df                	jne    80104b13 <release+0x13>
  popcli();
80104b34:	e8 27 ff ff ff       	call   80104a60 <popcli>
  lk->pcs[0] = 0;
80104b39:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b47:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b4c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b55:	5b                   	pop    %ebx
80104b56:	5e                   	pop    %esi
80104b57:	5d                   	pop    %ebp
  popcli();
80104b58:	e9 03 ff ff ff       	jmp    80104a60 <popcli>
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <acquire>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104b67:	e8 a4 fe ff ff       	call   80104a10 <pushcli>
  if(holding(lk))
80104b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104b6f:	e8 9c fe ff ff       	call   80104a10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b74:	8b 03                	mov    (%ebx),%eax
80104b76:	85 c0                	test   %eax,%eax
80104b78:	0f 85 b2 00 00 00    	jne    80104c30 <acquire+0xd0>
  popcli();
80104b7e:	e8 dd fe ff ff       	call   80104a60 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104b83:	b9 01 00 00 00       	mov    $0x1,%ecx
80104b88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104b90:	8b 55 08             	mov    0x8(%ebp),%edx
80104b93:	89 c8                	mov    %ecx,%eax
80104b95:	f0 87 02             	lock xchg %eax,(%edx)
80104b98:	85 c0                	test   %eax,%eax
80104b9a:	75 f4                	jne    80104b90 <acquire+0x30>
  __sync_synchronize();
80104b9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ba1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ba4:	e8 f7 f2 ff ff       	call   80103ea0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ba9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104bac:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104bae:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bb1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104bb7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104bbc:	77 32                	ja     80104bf0 <acquire+0x90>
  ebp = (uint*)v - 2;
80104bbe:	89 e8                	mov    %ebp,%eax
80104bc0:	eb 14                	jmp    80104bd6 <acquire+0x76>
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bd4:	77 1a                	ja     80104bf0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104bd6:	8b 58 04             	mov    0x4(%eax),%ebx
80104bd9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bdd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104be0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104be2:	83 fa 0a             	cmp    $0xa,%edx
80104be5:	75 e1                	jne    80104bc8 <acquire+0x68>
}
80104be7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bea:	c9                   	leave
80104beb:	c3                   	ret
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104bf4:	83 c1 34             	add    $0x34,%ecx
80104bf7:	89 ca                	mov    %ecx,%edx
80104bf9:	29 c2                	sub    %eax,%edx
80104bfb:	83 e2 04             	and    $0x4,%edx
80104bfe:	74 10                	je     80104c10 <acquire+0xb0>
    pcs[i] = 0;
80104c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c06:	83 c0 04             	add    $0x4,%eax
80104c09:	39 c1                	cmp    %eax,%ecx
80104c0b:	74 da                	je     80104be7 <acquire+0x87>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c16:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104c19:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104c20:	39 c1                	cmp    %eax,%ecx
80104c22:	75 ec                	jne    80104c10 <acquire+0xb0>
80104c24:	eb c1                	jmp    80104be7 <acquire+0x87>
80104c26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c2d:	00 
80104c2e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104c30:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104c33:	e8 68 f2 ff ff       	call   80103ea0 <mycpu>
80104c38:	39 c3                	cmp    %eax,%ebx
80104c3a:	0f 85 3e ff ff ff    	jne    80104b7e <acquire+0x1e>
  popcli();
80104c40:	e8 1b fe ff ff       	call   80104a60 <popcli>
    panic("acquire");
80104c45:	83 ec 0c             	sub    $0xc,%esp
80104c48:	68 89 7a 10 80       	push   $0x80107a89
80104c4d:	e8 2e b7 ff ff       	call   80100380 <panic>
80104c52:	66 90                	xchg   %ax,%ax
80104c54:	66 90                	xchg   %ax,%ax
80104c56:	66 90                	xchg   %ax,%ax
80104c58:	66 90                	xchg   %ax,%ax
80104c5a:	66 90                	xchg   %ax,%ax
80104c5c:	66 90                	xchg   %ax,%ax
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	8b 55 08             	mov    0x8(%ebp),%edx
80104c67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c6a:	89 d0                	mov    %edx,%eax
80104c6c:	09 c8                	or     %ecx,%eax
80104c6e:	a8 03                	test   $0x3,%al
80104c70:	75 1e                	jne    80104c90 <memset+0x30>
    c &= 0xFF;
80104c72:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c76:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104c79:	89 d7                	mov    %edx,%edi
80104c7b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104c81:	fc                   	cld
80104c82:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c84:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c87:	89 d0                	mov    %edx,%eax
80104c89:	c9                   	leave
80104c8a:	c3                   	ret
80104c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c93:	89 d7                	mov    %edx,%edi
80104c95:	fc                   	cld
80104c96:	f3 aa                	rep stos %al,%es:(%edi)
80104c98:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c9b:	89 d0                	mov    %edx,%eax
80104c9d:	c9                   	leave
80104c9e:	c3                   	ret
80104c9f:	90                   	nop

80104ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80104caa:	53                   	push   %ebx
80104cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cae:	85 f6                	test   %esi,%esi
80104cb0:	74 2e                	je     80104ce0 <memcmp+0x40>
80104cb2:	01 c6                	add    %eax,%esi
80104cb4:	eb 14                	jmp    80104cca <memcmp+0x2a>
80104cb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cbd:	00 
80104cbe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104cc0:	83 c0 01             	add    $0x1,%eax
80104cc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104cc6:	39 f0                	cmp    %esi,%eax
80104cc8:	74 16                	je     80104ce0 <memcmp+0x40>
    if(*s1 != *s2)
80104cca:	0f b6 08             	movzbl (%eax),%ecx
80104ccd:	0f b6 1a             	movzbl (%edx),%ebx
80104cd0:	38 d9                	cmp    %bl,%cl
80104cd2:	74 ec                	je     80104cc0 <memcmp+0x20>
      return *s1 - *s2;
80104cd4:	0f b6 c1             	movzbl %cl,%eax
80104cd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104cd9:	5b                   	pop    %ebx
80104cda:	5e                   	pop    %esi
80104cdb:	5d                   	pop    %ebp
80104cdc:	c3                   	ret
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	5b                   	pop    %ebx
  return 0;
80104ce1:	31 c0                	xor    %eax,%eax
}
80104ce3:	5e                   	pop    %esi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret
80104ce6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ced:	00 
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf7:	8b 45 10             	mov    0x10(%ebp),%eax
80104cfa:	56                   	push   %esi
80104cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cfe:	39 d6                	cmp    %edx,%esi
80104d00:	73 26                	jae    80104d28 <memmove+0x38>
80104d02:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104d05:	39 ca                	cmp    %ecx,%edx
80104d07:	73 1f                	jae    80104d28 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d09:	85 c0                	test   %eax,%eax
80104d0b:	74 0f                	je     80104d1c <memmove+0x2c>
80104d0d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104d10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d14:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d17:	83 e8 01             	sub    $0x1,%eax
80104d1a:	73 f4                	jae    80104d10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d1c:	5e                   	pop    %esi
80104d1d:	89 d0                	mov    %edx,%eax
80104d1f:	5f                   	pop    %edi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret
80104d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104d28:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104d2b:	89 d7                	mov    %edx,%edi
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	74 eb                	je     80104d1c <memmove+0x2c>
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104d38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104d39:	39 ce                	cmp    %ecx,%esi
80104d3b:	75 fb                	jne    80104d38 <memmove+0x48>
}
80104d3d:	5e                   	pop    %esi
80104d3e:	89 d0                	mov    %edx,%eax
80104d40:	5f                   	pop    %edi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret
80104d43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d4a:	00 
80104d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104d50:	eb 9e                	jmp    80104cf0 <memmove>
80104d52:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d59:	00 
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	8b 55 10             	mov    0x10(%ebp),%edx
80104d67:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104d6d:	85 d2                	test   %edx,%edx
80104d6f:	75 16                	jne    80104d87 <strncmp+0x27>
80104d71:	eb 2d                	jmp    80104da0 <strncmp+0x40>
80104d73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d78:	3a 19                	cmp    (%ecx),%bl
80104d7a:	75 12                	jne    80104d8e <strncmp+0x2e>
    n--, p++, q++;
80104d7c:	83 c0 01             	add    $0x1,%eax
80104d7f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d82:	83 ea 01             	sub    $0x1,%edx
80104d85:	74 19                	je     80104da0 <strncmp+0x40>
80104d87:	0f b6 18             	movzbl (%eax),%ebx
80104d8a:	84 db                	test   %bl,%bl
80104d8c:	75 ea                	jne    80104d78 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d8e:	0f b6 00             	movzbl (%eax),%eax
80104d91:	0f b6 11             	movzbl (%ecx),%edx
}
80104d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d97:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104d98:	29 d0                	sub    %edx,%eax
}
80104d9a:	c3                   	ret
80104d9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	c9                   	leave
80104da6:	c3                   	ret
80104da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dae:	00 
80104daf:	90                   	nop

80104db0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	56                   	push   %esi
80104db5:	8b 75 08             	mov    0x8(%ebp),%esi
80104db8:	53                   	push   %ebx
80104db9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104dbc:	89 f0                	mov    %esi,%eax
80104dbe:	eb 15                	jmp    80104dd5 <strncpy+0x25>
80104dc0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104dc4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104dc7:	83 c0 01             	add    $0x1,%eax
80104dca:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104dce:	88 48 ff             	mov    %cl,-0x1(%eax)
80104dd1:	84 c9                	test   %cl,%cl
80104dd3:	74 13                	je     80104de8 <strncpy+0x38>
80104dd5:	89 d3                	mov    %edx,%ebx
80104dd7:	83 ea 01             	sub    $0x1,%edx
80104dda:	85 db                	test   %ebx,%ebx
80104ddc:	7f e2                	jg     80104dc0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104dde:	5b                   	pop    %ebx
80104ddf:	89 f0                	mov    %esi,%eax
80104de1:	5e                   	pop    %esi
80104de2:	5f                   	pop    %edi
80104de3:	5d                   	pop    %ebp
80104de4:	c3                   	ret
80104de5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104de8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104deb:	83 e9 01             	sub    $0x1,%ecx
80104dee:	85 d2                	test   %edx,%edx
80104df0:	74 ec                	je     80104dde <strncpy+0x2e>
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104df8:	83 c0 01             	add    $0x1,%eax
80104dfb:	89 ca                	mov    %ecx,%edx
80104dfd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104e01:	29 c2                	sub    %eax,%edx
80104e03:	85 d2                	test   %edx,%edx
80104e05:	7f f1                	jg     80104df8 <strncpy+0x48>
}
80104e07:	5b                   	pop    %ebx
80104e08:	89 f0                	mov    %esi,%eax
80104e0a:	5e                   	pop    %esi
80104e0b:	5f                   	pop    %edi
80104e0c:	5d                   	pop    %ebp
80104e0d:	c3                   	ret
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	8b 55 10             	mov    0x10(%ebp),%edx
80104e17:	8b 75 08             	mov    0x8(%ebp),%esi
80104e1a:	53                   	push   %ebx
80104e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e1e:	85 d2                	test   %edx,%edx
80104e20:	7e 25                	jle    80104e47 <safestrcpy+0x37>
80104e22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e26:	89 f2                	mov    %esi,%edx
80104e28:	eb 16                	jmp    80104e40 <safestrcpy+0x30>
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e30:	0f b6 08             	movzbl (%eax),%ecx
80104e33:	83 c0 01             	add    $0x1,%eax
80104e36:	83 c2 01             	add    $0x1,%edx
80104e39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e3c:	84 c9                	test   %cl,%cl
80104e3e:	74 04                	je     80104e44 <safestrcpy+0x34>
80104e40:	39 d8                	cmp    %ebx,%eax
80104e42:	75 ec                	jne    80104e30 <safestrcpy+0x20>
    ;
  *s = 0;
80104e44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104e47:	89 f0                	mov    %esi,%eax
80104e49:	5b                   	pop    %ebx
80104e4a:	5e                   	pop    %esi
80104e4b:	5d                   	pop    %ebp
80104e4c:	c3                   	ret
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <strlen>:

int
strlen(const char *s)
{
80104e50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e58:	80 3a 00             	cmpb   $0x0,(%edx)
80104e5b:	74 0c                	je     80104e69 <strlen+0x19>
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	83 c0 01             	add    $0x1,%eax
80104e63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e67:	75 f7                	jne    80104e60 <strlen+0x10>
    ;
  return n;
}
80104e69:	5d                   	pop    %ebp
80104e6a:	c3                   	ret

80104e6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e73:	55                   	push   %ebp
  pushl %ebx
80104e74:	53                   	push   %ebx
  pushl %esi
80104e75:	56                   	push   %esi
  pushl %edi
80104e76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e7b:	5f                   	pop    %edi
  popl %esi
80104e7c:	5e                   	pop    %esi
  popl %ebx
80104e7d:	5b                   	pop    %ebx
  popl %ebp
80104e7e:	5d                   	pop    %ebp
  ret
80104e7f:	c3                   	ret

80104e80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	53                   	push   %ebx
80104e84:	83 ec 04             	sub    $0x4,%esp
80104e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e8a:	e8 91 f0 ff ff       	call   80103f20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e8f:	8b 00                	mov    (%eax),%eax
80104e91:	39 c3                	cmp    %eax,%ebx
80104e93:	73 1b                	jae    80104eb0 <fetchint+0x30>
80104e95:	8d 53 04             	lea    0x4(%ebx),%edx
80104e98:	39 d0                	cmp    %edx,%eax
80104e9a:	72 14                	jb     80104eb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9f:	8b 13                	mov    (%ebx),%edx
80104ea1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ea3:	31 c0                	xor    %eax,%eax
}
80104ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ea8:	c9                   	leave
80104ea9:	c3                   	ret
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb5:	eb ee                	jmp    80104ea5 <fetchint+0x25>
80104eb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ebe:	00 
80104ebf:	90                   	nop

80104ec0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	53                   	push   %ebx
80104ec4:	83 ec 04             	sub    $0x4,%esp
80104ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eca:	e8 51 f0 ff ff       	call   80103f20 <myproc>

  if(addr >= curproc->sz)
80104ecf:	3b 18                	cmp    (%eax),%ebx
80104ed1:	73 2d                	jae    80104f00 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ed6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ed8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104eda:	39 d3                	cmp    %edx,%ebx
80104edc:	73 22                	jae    80104f00 <fetchstr+0x40>
80104ede:	89 d8                	mov    %ebx,%eax
80104ee0:	eb 0d                	jmp    80104eef <fetchstr+0x2f>
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee8:	83 c0 01             	add    $0x1,%eax
80104eeb:	39 d0                	cmp    %edx,%eax
80104eed:	73 11                	jae    80104f00 <fetchstr+0x40>
    if(*s == 0)
80104eef:	80 38 00             	cmpb   $0x0,(%eax)
80104ef2:	75 f4                	jne    80104ee8 <fetchstr+0x28>
      return s - *pp;
80104ef4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef9:	c9                   	leave
80104efa:	c3                   	ret
80104efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f08:	c9                   	leave
80104f09:	c3                   	ret
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f15:	e8 06 f0 ff ff       	call   80103f20 <myproc>
80104f1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f1d:	8b 40 18             	mov    0x18(%eax),%eax
80104f20:	8b 40 44             	mov    0x44(%eax),%eax
80104f23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f26:	e8 f5 ef ff ff       	call   80103f20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f2e:	8b 00                	mov    (%eax),%eax
80104f30:	39 c6                	cmp    %eax,%esi
80104f32:	73 1c                	jae    80104f50 <argint+0x40>
80104f34:	8d 53 08             	lea    0x8(%ebx),%edx
80104f37:	39 d0                	cmp    %edx,%eax
80104f39:	72 15                	jb     80104f50 <argint+0x40>
  *ip = *(int*)(addr);
80104f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f41:	89 10                	mov    %edx,(%eax)
  return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	5b                   	pop    %ebx
80104f46:	5e                   	pop    %esi
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f55:	eb ee                	jmp    80104f45 <argint+0x35>
80104f57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f5e:	00 
80104f5f:	90                   	nop

80104f60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	53                   	push   %ebx
80104f66:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104f69:	e8 b2 ef ff ff       	call   80103f20 <myproc>
80104f6e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f70:	e8 ab ef ff ff       	call   80103f20 <myproc>
80104f75:	8b 55 08             	mov    0x8(%ebp),%edx
80104f78:	8b 40 18             	mov    0x18(%eax),%eax
80104f7b:	8b 40 44             	mov    0x44(%eax),%eax
80104f7e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f81:	e8 9a ef ff ff       	call   80103f20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f86:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f89:	8b 00                	mov    (%eax),%eax
80104f8b:	39 c7                	cmp    %eax,%edi
80104f8d:	73 31                	jae    80104fc0 <argptr+0x60>
80104f8f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104f92:	39 c8                	cmp    %ecx,%eax
80104f94:	72 2a                	jb     80104fc0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f96:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104f99:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f9c:	85 d2                	test   %edx,%edx
80104f9e:	78 20                	js     80104fc0 <argptr+0x60>
80104fa0:	8b 16                	mov    (%esi),%edx
80104fa2:	39 d0                	cmp    %edx,%eax
80104fa4:	73 1a                	jae    80104fc0 <argptr+0x60>
80104fa6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104fa9:	01 c3                	add    %eax,%ebx
80104fab:	39 da                	cmp    %ebx,%edx
80104fad:	72 11                	jb     80104fc0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104faf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104fb4:	31 c0                	xor    %eax,%eax
}
80104fb6:	83 c4 0c             	add    $0xc,%esp
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret
80104fbe:	66 90                	xchg   %ax,%ax
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb ef                	jmp    80104fb6 <argptr+0x56>
80104fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fce:	00 
80104fcf:	90                   	nop

80104fd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	e8 46 ef ff ff       	call   80103f20 <myproc>
80104fda:	8b 55 08             	mov    0x8(%ebp),%edx
80104fdd:	8b 40 18             	mov    0x18(%eax),%eax
80104fe0:	8b 40 44             	mov    0x44(%eax),%eax
80104fe3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fe6:	e8 35 ef ff ff       	call   80103f20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104feb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fee:	8b 00                	mov    (%eax),%eax
80104ff0:	39 c6                	cmp    %eax,%esi
80104ff2:	73 44                	jae    80105038 <argstr+0x68>
80104ff4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ff7:	39 d0                	cmp    %edx,%eax
80104ff9:	72 3d                	jb     80105038 <argstr+0x68>
  *ip = *(int*)(addr);
80104ffb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104ffe:	e8 1d ef ff ff       	call   80103f20 <myproc>
  if(addr >= curproc->sz)
80105003:	3b 18                	cmp    (%eax),%ebx
80105005:	73 31                	jae    80105038 <argstr+0x68>
  *pp = (char*)addr;
80105007:	8b 55 0c             	mov    0xc(%ebp),%edx
8010500a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010500c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010500e:	39 d3                	cmp    %edx,%ebx
80105010:	73 26                	jae    80105038 <argstr+0x68>
80105012:	89 d8                	mov    %ebx,%eax
80105014:	eb 11                	jmp    80105027 <argstr+0x57>
80105016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010501d:	00 
8010501e:	66 90                	xchg   %ax,%ax
80105020:	83 c0 01             	add    $0x1,%eax
80105023:	39 d0                	cmp    %edx,%eax
80105025:	73 11                	jae    80105038 <argstr+0x68>
    if(*s == 0)
80105027:	80 38 00             	cmpb   $0x0,(%eax)
8010502a:	75 f4                	jne    80105020 <argstr+0x50>
      return s - *pp;
8010502c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010502e:	5b                   	pop    %ebx
8010502f:	5e                   	pop    %esi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105038:	5b                   	pop    %ebx
    return -1;
80105039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010503e:	5e                   	pop    %esi
8010503f:	5d                   	pop    %ebp
80105040:	c3                   	ret
80105041:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105048:	00 
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105050 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105057:	e8 c4 ee ff ff       	call   80103f20 <myproc>
8010505c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010505e:	8b 40 18             	mov    0x18(%eax),%eax
80105061:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105064:	8d 50 ff             	lea    -0x1(%eax),%edx
80105067:	83 fa 14             	cmp    $0x14,%edx
8010506a:	77 24                	ja     80105090 <syscall+0x40>
8010506c:	8b 14 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%edx
80105073:	85 d2                	test   %edx,%edx
80105075:	74 19                	je     80105090 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105077:	ff d2                	call   *%edx
80105079:	89 c2                	mov    %eax,%edx
8010507b:	8b 43 18             	mov    0x18(%ebx),%eax
8010507e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105084:	c9                   	leave
80105085:	c3                   	ret
80105086:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010508d:	00 
8010508e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80105090:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105091:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105094:	50                   	push   %eax
80105095:	ff 73 10             	push   0x10(%ebx)
80105098:	68 91 7a 10 80       	push   $0x80107a91
8010509d:	e8 fe b6 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
801050a2:	8b 43 18             	mov    0x18(%ebx),%eax
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b2:	c9                   	leave
801050b3:	c3                   	ret
801050b4:	66 90                	xchg   %ax,%ax
801050b6:	66 90                	xchg   %ax,%ax
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801050c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801050c8:	53                   	push   %ebx
801050c9:	83 ec 34             	sub    $0x34,%esp
801050cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801050cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050d2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801050d5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801050d8:	57                   	push   %edi
801050d9:	50                   	push   %eax
801050da:	e8 81 d5 ff ff       	call   80102660 <nameiparent>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	74 5e                	je     80105144 <create+0x84>
    return 0;
  ilock(dp);
801050e6:	83 ec 0c             	sub    $0xc,%esp
801050e9:	89 c3                	mov    %eax,%ebx
801050eb:	50                   	push   %eax
801050ec:	e8 6f cc ff ff       	call   80101d60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801050f1:	83 c4 0c             	add    $0xc,%esp
801050f4:	6a 00                	push   $0x0
801050f6:	57                   	push   %edi
801050f7:	53                   	push   %ebx
801050f8:	e8 b3 d1 ff ff       	call   801022b0 <dirlookup>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	89 c6                	mov    %eax,%esi
80105102:	85 c0                	test   %eax,%eax
80105104:	74 4a                	je     80105150 <create+0x90>
    iunlockput(dp);
80105106:	83 ec 0c             	sub    $0xc,%esp
80105109:	53                   	push   %ebx
8010510a:	e8 e1 ce ff ff       	call   80101ff0 <iunlockput>
    ilock(ip);
8010510f:	89 34 24             	mov    %esi,(%esp)
80105112:	e8 49 cc ff ff       	call   80101d60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105117:	83 c4 10             	add    $0x10,%esp
8010511a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010511f:	75 17                	jne    80105138 <create+0x78>
80105121:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105126:	75 10                	jne    80105138 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010512b:	89 f0                	mov    %esi,%eax
8010512d:	5b                   	pop    %ebx
8010512e:	5e                   	pop    %esi
8010512f:	5f                   	pop    %edi
80105130:	5d                   	pop    %ebp
80105131:	c3                   	ret
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	56                   	push   %esi
8010513c:	e8 af ce ff ff       	call   80101ff0 <iunlockput>
    return 0;
80105141:	83 c4 10             	add    $0x10,%esp
}
80105144:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105147:	31 f6                	xor    %esi,%esi
}
80105149:	5b                   	pop    %ebx
8010514a:	89 f0                	mov    %esi,%eax
8010514c:	5e                   	pop    %esi
8010514d:	5f                   	pop    %edi
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105150:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105154:	83 ec 08             	sub    $0x8,%esp
80105157:	50                   	push   %eax
80105158:	ff 33                	push   (%ebx)
8010515a:	e8 91 ca ff ff       	call   80101bf0 <ialloc>
8010515f:	83 c4 10             	add    $0x10,%esp
80105162:	89 c6                	mov    %eax,%esi
80105164:	85 c0                	test   %eax,%eax
80105166:	0f 84 bc 00 00 00    	je     80105228 <create+0x168>
  ilock(ip);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	50                   	push   %eax
80105170:	e8 eb cb ff ff       	call   80101d60 <ilock>
  ip->major = major;
80105175:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105179:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010517d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105181:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105185:	b8 01 00 00 00       	mov    $0x1,%eax
8010518a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010518e:	89 34 24             	mov    %esi,(%esp)
80105191:	e8 1a cb ff ff       	call   80101cb0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010519e:	74 30                	je     801051d0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801051a0:	83 ec 04             	sub    $0x4,%esp
801051a3:	ff 76 04             	push   0x4(%esi)
801051a6:	57                   	push   %edi
801051a7:	53                   	push   %ebx
801051a8:	e8 d3 d3 ff ff       	call   80102580 <dirlink>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	78 67                	js     8010521b <create+0x15b>
  iunlockput(dp);
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	53                   	push   %ebx
801051b8:	e8 33 ce ff ff       	call   80101ff0 <iunlockput>
  return ip;
801051bd:	83 c4 10             	add    $0x10,%esp
}
801051c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c3:	89 f0                	mov    %esi,%eax
801051c5:	5b                   	pop    %ebx
801051c6:	5e                   	pop    %esi
801051c7:	5f                   	pop    %edi
801051c8:	5d                   	pop    %ebp
801051c9:	c3                   	ret
801051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801051d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801051d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801051d8:	53                   	push   %ebx
801051d9:	e8 d2 ca ff ff       	call   80101cb0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801051de:	83 c4 0c             	add    $0xc,%esp
801051e1:	ff 76 04             	push   0x4(%esi)
801051e4:	68 c9 7a 10 80       	push   $0x80107ac9
801051e9:	56                   	push   %esi
801051ea:	e8 91 d3 ff ff       	call   80102580 <dirlink>
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	85 c0                	test   %eax,%eax
801051f4:	78 18                	js     8010520e <create+0x14e>
801051f6:	83 ec 04             	sub    $0x4,%esp
801051f9:	ff 73 04             	push   0x4(%ebx)
801051fc:	68 c8 7a 10 80       	push   $0x80107ac8
80105201:	56                   	push   %esi
80105202:	e8 79 d3 ff ff       	call   80102580 <dirlink>
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	85 c0                	test   %eax,%eax
8010520c:	79 92                	jns    801051a0 <create+0xe0>
      panic("create dots");
8010520e:	83 ec 0c             	sub    $0xc,%esp
80105211:	68 bc 7a 10 80       	push   $0x80107abc
80105216:	e8 65 b1 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	68 cb 7a 10 80       	push   $0x80107acb
80105223:	e8 58 b1 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	68 ad 7a 10 80       	push   $0x80107aad
80105230:	e8 4b b1 ff ff       	call   80100380 <panic>
80105235:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010523c:	00 
8010523d:	8d 76 00             	lea    0x0(%esi),%esi

80105240 <sys_dup>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	56                   	push   %esi
80105244:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105245:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105248:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010524b:	50                   	push   %eax
8010524c:	6a 00                	push   $0x0
8010524e:	e8 bd fc ff ff       	call   80104f10 <argint>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	78 36                	js     80105290 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010525a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010525e:	77 30                	ja     80105290 <sys_dup+0x50>
80105260:	e8 bb ec ff ff       	call   80103f20 <myproc>
80105265:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105268:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010526c:	85 f6                	test   %esi,%esi
8010526e:	74 20                	je     80105290 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105270:	e8 ab ec ff ff       	call   80103f20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105275:	31 db                	xor    %ebx,%ebx
80105277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010527e:	00 
8010527f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105280:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105284:	85 d2                	test   %edx,%edx
80105286:	74 18                	je     801052a0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	75 f0                	jne    80105280 <sys_dup+0x40>
}
80105290:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105293:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105298:	89 d8                	mov    %ebx,%eax
8010529a:	5b                   	pop    %ebx
8010529b:	5e                   	pop    %esi
8010529c:	5d                   	pop    %ebp
8010529d:	c3                   	ret
8010529e:	66 90                	xchg   %ax,%ax
  filedup(f);
801052a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052a3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801052a7:	56                   	push   %esi
801052a8:	e8 d3 c1 ff ff       	call   80101480 <filedup>
  return fd;
801052ad:	83 c4 10             	add    $0x10,%esp
}
801052b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b3:	89 d8                	mov    %ebx,%eax
801052b5:	5b                   	pop    %ebx
801052b6:	5e                   	pop    %esi
801052b7:	5d                   	pop    %ebp
801052b8:	c3                   	ret
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_read>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052cb:	53                   	push   %ebx
801052cc:	6a 00                	push   $0x0
801052ce:	e8 3d fc ff ff       	call   80104f10 <argint>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	78 5e                	js     80105338 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052de:	77 58                	ja     80105338 <sys_read+0x78>
801052e0:	e8 3b ec ff ff       	call   80103f20 <myproc>
801052e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801052ec:	85 f6                	test   %esi,%esi
801052ee:	74 48                	je     80105338 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052f0:	83 ec 08             	sub    $0x8,%esp
801052f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f6:	50                   	push   %eax
801052f7:	6a 02                	push   $0x2
801052f9:	e8 12 fc ff ff       	call   80104f10 <argint>
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	85 c0                	test   %eax,%eax
80105303:	78 33                	js     80105338 <sys_read+0x78>
80105305:	83 ec 04             	sub    $0x4,%esp
80105308:	ff 75 f0             	push   -0x10(%ebp)
8010530b:	53                   	push   %ebx
8010530c:	6a 01                	push   $0x1
8010530e:	e8 4d fc ff ff       	call   80104f60 <argptr>
80105313:	83 c4 10             	add    $0x10,%esp
80105316:	85 c0                	test   %eax,%eax
80105318:	78 1e                	js     80105338 <sys_read+0x78>
  return fileread(f, p, n);
8010531a:	83 ec 04             	sub    $0x4,%esp
8010531d:	ff 75 f0             	push   -0x10(%ebp)
80105320:	ff 75 f4             	push   -0xc(%ebp)
80105323:	56                   	push   %esi
80105324:	e8 d7 c2 ff ff       	call   80101600 <fileread>
80105329:	83 c4 10             	add    $0x10,%esp
}
8010532c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010532f:	5b                   	pop    %ebx
80105330:	5e                   	pop    %esi
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret
80105333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb ed                	jmp    8010532c <sys_read+0x6c>
8010533f:	90                   	nop

80105340 <sys_write>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105345:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105348:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010534b:	53                   	push   %ebx
8010534c:	6a 00                	push   $0x0
8010534e:	e8 bd fb ff ff       	call   80104f10 <argint>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	78 5e                	js     801053b8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010535a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010535e:	77 58                	ja     801053b8 <sys_write+0x78>
80105360:	e8 bb eb ff ff       	call   80103f20 <myproc>
80105365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105368:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010536c:	85 f6                	test   %esi,%esi
8010536e:	74 48                	je     801053b8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105370:	83 ec 08             	sub    $0x8,%esp
80105373:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105376:	50                   	push   %eax
80105377:	6a 02                	push   $0x2
80105379:	e8 92 fb ff ff       	call   80104f10 <argint>
8010537e:	83 c4 10             	add    $0x10,%esp
80105381:	85 c0                	test   %eax,%eax
80105383:	78 33                	js     801053b8 <sys_write+0x78>
80105385:	83 ec 04             	sub    $0x4,%esp
80105388:	ff 75 f0             	push   -0x10(%ebp)
8010538b:	53                   	push   %ebx
8010538c:	6a 01                	push   $0x1
8010538e:	e8 cd fb ff ff       	call   80104f60 <argptr>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	78 1e                	js     801053b8 <sys_write+0x78>
  return filewrite(f, p, n);
8010539a:	83 ec 04             	sub    $0x4,%esp
8010539d:	ff 75 f0             	push   -0x10(%ebp)
801053a0:	ff 75 f4             	push   -0xc(%ebp)
801053a3:	56                   	push   %esi
801053a4:	e8 e7 c2 ff ff       	call   80101690 <filewrite>
801053a9:	83 c4 10             	add    $0x10,%esp
}
801053ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053af:	5b                   	pop    %ebx
801053b0:	5e                   	pop    %esi
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret
801053b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	eb ed                	jmp    801053ac <sys_write+0x6c>
801053bf:	90                   	nop

801053c0 <sys_close>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801053c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053cb:	50                   	push   %eax
801053cc:	6a 00                	push   $0x0
801053ce:	e8 3d fb ff ff       	call   80104f10 <argint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 3e                	js     80105418 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053de:	77 38                	ja     80105418 <sys_close+0x58>
801053e0:	e8 3b eb ff ff       	call   80103f20 <myproc>
801053e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e8:	8d 5a 08             	lea    0x8(%edx),%ebx
801053eb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801053ef:	85 f6                	test   %esi,%esi
801053f1:	74 25                	je     80105418 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801053f3:	e8 28 eb ff ff       	call   80103f20 <myproc>
  fileclose(f);
801053f8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053fb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105402:	00 
  fileclose(f);
80105403:	56                   	push   %esi
80105404:	e8 c7 c0 ff ff       	call   801014d0 <fileclose>
  return 0;
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	31 c0                	xor    %eax,%eax
}
8010540e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5d                   	pop    %ebp
80105414:	c3                   	ret
80105415:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb ef                	jmp    8010540e <sys_close+0x4e>
8010541f:	90                   	nop

80105420 <sys_fstat>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105425:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105428:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010542b:	53                   	push   %ebx
8010542c:	6a 00                	push   $0x0
8010542e:	e8 dd fa ff ff       	call   80104f10 <argint>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 46                	js     80105480 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010543a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010543e:	77 40                	ja     80105480 <sys_fstat+0x60>
80105440:	e8 db ea ff ff       	call   80103f20 <myproc>
80105445:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105448:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010544c:	85 f6                	test   %esi,%esi
8010544e:	74 30                	je     80105480 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105450:	83 ec 04             	sub    $0x4,%esp
80105453:	6a 14                	push   $0x14
80105455:	53                   	push   %ebx
80105456:	6a 01                	push   $0x1
80105458:	e8 03 fb ff ff       	call   80104f60 <argptr>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 1c                	js     80105480 <sys_fstat+0x60>
  return filestat(f, st);
80105464:	83 ec 08             	sub    $0x8,%esp
80105467:	ff 75 f4             	push   -0xc(%ebp)
8010546a:	56                   	push   %esi
8010546b:	e8 40 c1 ff ff       	call   801015b0 <filestat>
80105470:	83 c4 10             	add    $0x10,%esp
}
80105473:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105476:	5b                   	pop    %ebx
80105477:	5e                   	pop    %esi
80105478:	5d                   	pop    %ebp
80105479:	c3                   	ret
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ec                	jmp    80105473 <sys_fstat+0x53>
80105487:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010548e:	00 
8010548f:	90                   	nop

80105490 <sys_link>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105495:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105498:	53                   	push   %ebx
80105499:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010549c:	50                   	push   %eax
8010549d:	6a 00                	push   $0x0
8010549f:	e8 2c fb ff ff       	call   80104fd0 <argstr>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	0f 88 fb 00 00 00    	js     801055aa <sys_link+0x11a>
801054af:	83 ec 08             	sub    $0x8,%esp
801054b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801054b5:	50                   	push   %eax
801054b6:	6a 01                	push   $0x1
801054b8:	e8 13 fb ff ff       	call   80104fd0 <argstr>
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	85 c0                	test   %eax,%eax
801054c2:	0f 88 e2 00 00 00    	js     801055aa <sys_link+0x11a>
  begin_op();
801054c8:	e8 33 de ff ff       	call   80103300 <begin_op>
  if((ip = namei(old)) == 0){
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	ff 75 d4             	push   -0x2c(%ebp)
801054d3:	e8 68 d1 ff ff       	call   80102640 <namei>
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	89 c3                	mov    %eax,%ebx
801054dd:	85 c0                	test   %eax,%eax
801054df:	0f 84 df 00 00 00    	je     801055c4 <sys_link+0x134>
  ilock(ip);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	50                   	push   %eax
801054e9:	e8 72 c8 ff ff       	call   80101d60 <ilock>
  if(ip->type == T_DIR){
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054f6:	0f 84 b5 00 00 00    	je     801055b1 <sys_link+0x121>
  iupdate(ip);
801054fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801054ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105504:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105507:	53                   	push   %ebx
80105508:	e8 a3 c7 ff ff       	call   80101cb0 <iupdate>
  iunlock(ip);
8010550d:	89 1c 24             	mov    %ebx,(%esp)
80105510:	e8 2b c9 ff ff       	call   80101e40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105515:	58                   	pop    %eax
80105516:	5a                   	pop    %edx
80105517:	57                   	push   %edi
80105518:	ff 75 d0             	push   -0x30(%ebp)
8010551b:	e8 40 d1 ff ff       	call   80102660 <nameiparent>
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	89 c6                	mov    %eax,%esi
80105525:	85 c0                	test   %eax,%eax
80105527:	74 5b                	je     80105584 <sys_link+0xf4>
  ilock(dp);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	50                   	push   %eax
8010552d:	e8 2e c8 ff ff       	call   80101d60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105532:	8b 03                	mov    (%ebx),%eax
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	39 06                	cmp    %eax,(%esi)
80105539:	75 3d                	jne    80105578 <sys_link+0xe8>
8010553b:	83 ec 04             	sub    $0x4,%esp
8010553e:	ff 73 04             	push   0x4(%ebx)
80105541:	57                   	push   %edi
80105542:	56                   	push   %esi
80105543:	e8 38 d0 ff ff       	call   80102580 <dirlink>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	85 c0                	test   %eax,%eax
8010554d:	78 29                	js     80105578 <sys_link+0xe8>
  iunlockput(dp);
8010554f:	83 ec 0c             	sub    $0xc,%esp
80105552:	56                   	push   %esi
80105553:	e8 98 ca ff ff       	call   80101ff0 <iunlockput>
  iput(ip);
80105558:	89 1c 24             	mov    %ebx,(%esp)
8010555b:	e8 30 c9 ff ff       	call   80101e90 <iput>
  end_op();
80105560:	e8 0b de ff ff       	call   80103370 <end_op>
  return 0;
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	31 c0                	xor    %eax,%eax
}
8010556a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010556d:	5b                   	pop    %ebx
8010556e:	5e                   	pop    %esi
8010556f:	5f                   	pop    %edi
80105570:	5d                   	pop    %ebp
80105571:	c3                   	ret
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105578:	83 ec 0c             	sub    $0xc,%esp
8010557b:	56                   	push   %esi
8010557c:	e8 6f ca ff ff       	call   80101ff0 <iunlockput>
    goto bad;
80105581:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	53                   	push   %ebx
80105588:	e8 d3 c7 ff ff       	call   80101d60 <ilock>
  ip->nlink--;
8010558d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105592:	89 1c 24             	mov    %ebx,(%esp)
80105595:	e8 16 c7 ff ff       	call   80101cb0 <iupdate>
  iunlockput(ip);
8010559a:	89 1c 24             	mov    %ebx,(%esp)
8010559d:	e8 4e ca ff ff       	call   80101ff0 <iunlockput>
  end_op();
801055a2:	e8 c9 dd ff ff       	call   80103370 <end_op>
  return -1;
801055a7:	83 c4 10             	add    $0x10,%esp
    return -1;
801055aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055af:	eb b9                	jmp    8010556a <sys_link+0xda>
    iunlockput(ip);
801055b1:	83 ec 0c             	sub    $0xc,%esp
801055b4:	53                   	push   %ebx
801055b5:	e8 36 ca ff ff       	call   80101ff0 <iunlockput>
    end_op();
801055ba:	e8 b1 dd ff ff       	call   80103370 <end_op>
    return -1;
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	eb e6                	jmp    801055aa <sys_link+0x11a>
    end_op();
801055c4:	e8 a7 dd ff ff       	call   80103370 <end_op>
    return -1;
801055c9:	eb df                	jmp    801055aa <sys_link+0x11a>
801055cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801055d0 <sys_unlink>:
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801055d5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055d8:	53                   	push   %ebx
801055d9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801055dc:	50                   	push   %eax
801055dd:	6a 00                	push   $0x0
801055df:	e8 ec f9 ff ff       	call   80104fd0 <argstr>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	0f 88 54 01 00 00    	js     80105743 <sys_unlink+0x173>
  begin_op();
801055ef:	e8 0c dd ff ff       	call   80103300 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055f4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055f7:	83 ec 08             	sub    $0x8,%esp
801055fa:	53                   	push   %ebx
801055fb:	ff 75 c0             	push   -0x40(%ebp)
801055fe:	e8 5d d0 ff ff       	call   80102660 <nameiparent>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105609:	85 c0                	test   %eax,%eax
8010560b:	0f 84 58 01 00 00    	je     80105769 <sys_unlink+0x199>
  ilock(dp);
80105611:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105614:	83 ec 0c             	sub    $0xc,%esp
80105617:	57                   	push   %edi
80105618:	e8 43 c7 ff ff       	call   80101d60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010561d:	58                   	pop    %eax
8010561e:	5a                   	pop    %edx
8010561f:	68 c9 7a 10 80       	push   $0x80107ac9
80105624:	53                   	push   %ebx
80105625:	e8 66 cc ff ff       	call   80102290 <namecmp>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	0f 84 fb 00 00 00    	je     80105730 <sys_unlink+0x160>
80105635:	83 ec 08             	sub    $0x8,%esp
80105638:	68 c8 7a 10 80       	push   $0x80107ac8
8010563d:	53                   	push   %ebx
8010563e:	e8 4d cc ff ff       	call   80102290 <namecmp>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	0f 84 e2 00 00 00    	je     80105730 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010564e:	83 ec 04             	sub    $0x4,%esp
80105651:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105654:	50                   	push   %eax
80105655:	53                   	push   %ebx
80105656:	57                   	push   %edi
80105657:	e8 54 cc ff ff       	call   801022b0 <dirlookup>
8010565c:	83 c4 10             	add    $0x10,%esp
8010565f:	89 c3                	mov    %eax,%ebx
80105661:	85 c0                	test   %eax,%eax
80105663:	0f 84 c7 00 00 00    	je     80105730 <sys_unlink+0x160>
  ilock(ip);
80105669:	83 ec 0c             	sub    $0xc,%esp
8010566c:	50                   	push   %eax
8010566d:	e8 ee c6 ff ff       	call   80101d60 <ilock>
  if(ip->nlink < 1)
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010567a:	0f 8e 0a 01 00 00    	jle    8010578a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105680:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105685:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105688:	74 66                	je     801056f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010568a:	83 ec 04             	sub    $0x4,%esp
8010568d:	6a 10                	push   $0x10
8010568f:	6a 00                	push   $0x0
80105691:	57                   	push   %edi
80105692:	e8 c9 f5 ff ff       	call   80104c60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105697:	6a 10                	push   $0x10
80105699:	ff 75 c4             	push   -0x3c(%ebp)
8010569c:	57                   	push   %edi
8010569d:	ff 75 b4             	push   -0x4c(%ebp)
801056a0:	e8 cb ca ff ff       	call   80102170 <writei>
801056a5:	83 c4 20             	add    $0x20,%esp
801056a8:	83 f8 10             	cmp    $0x10,%eax
801056ab:	0f 85 cc 00 00 00    	jne    8010577d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801056b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056b6:	0f 84 94 00 00 00    	je     80105750 <sys_unlink+0x180>
  iunlockput(dp);
801056bc:	83 ec 0c             	sub    $0xc,%esp
801056bf:	ff 75 b4             	push   -0x4c(%ebp)
801056c2:	e8 29 c9 ff ff       	call   80101ff0 <iunlockput>
  ip->nlink--;
801056c7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056cc:	89 1c 24             	mov    %ebx,(%esp)
801056cf:	e8 dc c5 ff ff       	call   80101cb0 <iupdate>
  iunlockput(ip);
801056d4:	89 1c 24             	mov    %ebx,(%esp)
801056d7:	e8 14 c9 ff ff       	call   80101ff0 <iunlockput>
  end_op();
801056dc:	e8 8f dc ff ff       	call   80103370 <end_op>
  return 0;
801056e1:	83 c4 10             	add    $0x10,%esp
801056e4:	31 c0                	xor    %eax,%eax
}
801056e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e9:	5b                   	pop    %ebx
801056ea:	5e                   	pop    %esi
801056eb:	5f                   	pop    %edi
801056ec:	5d                   	pop    %ebp
801056ed:	c3                   	ret
801056ee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056f4:	76 94                	jbe    8010568a <sys_unlink+0xba>
801056f6:	be 20 00 00 00       	mov    $0x20,%esi
801056fb:	eb 0b                	jmp    80105708 <sys_unlink+0x138>
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
80105700:	83 c6 10             	add    $0x10,%esi
80105703:	3b 73 58             	cmp    0x58(%ebx),%esi
80105706:	73 82                	jae    8010568a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105708:	6a 10                	push   $0x10
8010570a:	56                   	push   %esi
8010570b:	57                   	push   %edi
8010570c:	53                   	push   %ebx
8010570d:	e8 5e c9 ff ff       	call   80102070 <readi>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	83 f8 10             	cmp    $0x10,%eax
80105718:	75 56                	jne    80105770 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010571a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010571f:	74 df                	je     80105700 <sys_unlink+0x130>
    iunlockput(ip);
80105721:	83 ec 0c             	sub    $0xc,%esp
80105724:	53                   	push   %ebx
80105725:	e8 c6 c8 ff ff       	call   80101ff0 <iunlockput>
    goto bad;
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	ff 75 b4             	push   -0x4c(%ebp)
80105736:	e8 b5 c8 ff ff       	call   80101ff0 <iunlockput>
  end_op();
8010573b:	e8 30 dc ff ff       	call   80103370 <end_op>
  return -1;
80105740:	83 c4 10             	add    $0x10,%esp
    return -1;
80105743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105748:	eb 9c                	jmp    801056e6 <sys_unlink+0x116>
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105750:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105753:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105756:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010575b:	50                   	push   %eax
8010575c:	e8 4f c5 ff ff       	call   80101cb0 <iupdate>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	e9 53 ff ff ff       	jmp    801056bc <sys_unlink+0xec>
    end_op();
80105769:	e8 02 dc ff ff       	call   80103370 <end_op>
    return -1;
8010576e:	eb d3                	jmp    80105743 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	68 ed 7a 10 80       	push   $0x80107aed
80105778:	e8 03 ac ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	68 ff 7a 10 80       	push   $0x80107aff
80105785:	e8 f6 ab ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	68 db 7a 10 80       	push   $0x80107adb
80105792:	e8 e9 ab ff ff       	call   80100380 <panic>
80105797:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010579e:	00 
8010579f:	90                   	nop

801057a0 <sys_open>:

int
sys_open(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801057a8:	53                   	push   %ebx
801057a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057ac:	50                   	push   %eax
801057ad:	6a 00                	push   $0x0
801057af:	e8 1c f8 ff ff       	call   80104fd0 <argstr>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
801057b9:	0f 88 8e 00 00 00    	js     8010584d <sys_open+0xad>
801057bf:	83 ec 08             	sub    $0x8,%esp
801057c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057c5:	50                   	push   %eax
801057c6:	6a 01                	push   $0x1
801057c8:	e8 43 f7 ff ff       	call   80104f10 <argint>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 79                	js     8010584d <sys_open+0xad>
    return -1;

  begin_op();
801057d4:	e8 27 db ff ff       	call   80103300 <begin_op>

  if(omode & O_CREATE){
801057d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057dd:	75 79                	jne    80105858 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057df:	83 ec 0c             	sub    $0xc,%esp
801057e2:	ff 75 e0             	push   -0x20(%ebp)
801057e5:	e8 56 ce ff ff       	call   80102640 <namei>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	89 c6                	mov    %eax,%esi
801057ef:	85 c0                	test   %eax,%eax
801057f1:	0f 84 7e 00 00 00    	je     80105875 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801057f7:	83 ec 0c             	sub    $0xc,%esp
801057fa:	50                   	push   %eax
801057fb:	e8 60 c5 ff ff       	call   80101d60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105800:	83 c4 10             	add    $0x10,%esp
80105803:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105808:	0f 84 ba 00 00 00    	je     801058c8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010580e:	e8 fd bb ff ff       	call   80101410 <filealloc>
80105813:	89 c7                	mov    %eax,%edi
80105815:	85 c0                	test   %eax,%eax
80105817:	74 23                	je     8010583c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105819:	e8 02 e7 ff ff       	call   80103f20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010581e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105820:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105824:	85 d2                	test   %edx,%edx
80105826:	74 58                	je     80105880 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105828:	83 c3 01             	add    $0x1,%ebx
8010582b:	83 fb 10             	cmp    $0x10,%ebx
8010582e:	75 f0                	jne    80105820 <sys_open+0x80>
    if(f)
      fileclose(f);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	57                   	push   %edi
80105834:	e8 97 bc ff ff       	call   801014d0 <fileclose>
80105839:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	56                   	push   %esi
80105840:	e8 ab c7 ff ff       	call   80101ff0 <iunlockput>
    end_op();
80105845:	e8 26 db ff ff       	call   80103370 <end_op>
    return -1;
8010584a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010584d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105852:	eb 65                	jmp    801058b9 <sys_open+0x119>
80105854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	31 c9                	xor    %ecx,%ecx
8010585d:	ba 02 00 00 00       	mov    $0x2,%edx
80105862:	6a 00                	push   $0x0
80105864:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105867:	e8 54 f8 ff ff       	call   801050c0 <create>
    if(ip == 0){
8010586c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010586f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105871:	85 c0                	test   %eax,%eax
80105873:	75 99                	jne    8010580e <sys_open+0x6e>
      end_op();
80105875:	e8 f6 da ff ff       	call   80103370 <end_op>
      return -1;
8010587a:	eb d1                	jmp    8010584d <sys_open+0xad>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105880:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105883:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105887:	56                   	push   %esi
80105888:	e8 b3 c5 ff ff       	call   80101e40 <iunlock>
  end_op();
8010588d:	e8 de da ff ff       	call   80103370 <end_op>

  f->type = FD_INODE;
80105892:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105898:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010589b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010589e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801058a1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801058a3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058aa:	f7 d0                	not    %eax
801058ac:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058af:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058b2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058b5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058bc:	89 d8                	mov    %ebx,%eax
801058be:	5b                   	pop    %ebx
801058bf:	5e                   	pop    %esi
801058c0:	5f                   	pop    %edi
801058c1:	5d                   	pop    %ebp
801058c2:	c3                   	ret
801058c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801058c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058cb:	85 c9                	test   %ecx,%ecx
801058cd:	0f 84 3b ff ff ff    	je     8010580e <sys_open+0x6e>
801058d3:	e9 64 ff ff ff       	jmp    8010583c <sys_open+0x9c>
801058d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058df:	00 

801058e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058e6:	e8 15 da ff ff       	call   80103300 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f1:	50                   	push   %eax
801058f2:	6a 00                	push   $0x0
801058f4:	e8 d7 f6 ff ff       	call   80104fd0 <argstr>
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	78 30                	js     80105930 <sys_mkdir+0x50>
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105906:	31 c9                	xor    %ecx,%ecx
80105908:	ba 01 00 00 00       	mov    $0x1,%edx
8010590d:	6a 00                	push   $0x0
8010590f:	e8 ac f7 ff ff       	call   801050c0 <create>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	85 c0                	test   %eax,%eax
80105919:	74 15                	je     80105930 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010591b:	83 ec 0c             	sub    $0xc,%esp
8010591e:	50                   	push   %eax
8010591f:	e8 cc c6 ff ff       	call   80101ff0 <iunlockput>
  end_op();
80105924:	e8 47 da ff ff       	call   80103370 <end_op>
  return 0;
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	31 c0                	xor    %eax,%eax
}
8010592e:	c9                   	leave
8010592f:	c3                   	ret
    end_op();
80105930:	e8 3b da ff ff       	call   80103370 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010593a:	c9                   	leave
8010593b:	c3                   	ret
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_mknod>:

int
sys_mknod(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105946:	e8 b5 d9 ff ff       	call   80103300 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010594b:	83 ec 08             	sub    $0x8,%esp
8010594e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105951:	50                   	push   %eax
80105952:	6a 00                	push   $0x0
80105954:	e8 77 f6 ff ff       	call   80104fd0 <argstr>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	85 c0                	test   %eax,%eax
8010595e:	78 60                	js     801059c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105960:	83 ec 08             	sub    $0x8,%esp
80105963:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105966:	50                   	push   %eax
80105967:	6a 01                	push   $0x1
80105969:	e8 a2 f5 ff ff       	call   80104f10 <argint>
  if((argstr(0, &path)) < 0 ||
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	85 c0                	test   %eax,%eax
80105973:	78 4b                	js     801059c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105975:	83 ec 08             	sub    $0x8,%esp
80105978:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010597b:	50                   	push   %eax
8010597c:	6a 02                	push   $0x2
8010597e:	e8 8d f5 ff ff       	call   80104f10 <argint>
     argint(1, &major) < 0 ||
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 36                	js     801059c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010598a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010598e:	83 ec 0c             	sub    $0xc,%esp
80105991:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105995:	ba 03 00 00 00       	mov    $0x3,%edx
8010599a:	50                   	push   %eax
8010599b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010599e:	e8 1d f7 ff ff       	call   801050c0 <create>
     argint(2, &minor) < 0 ||
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	74 16                	je     801059c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	50                   	push   %eax
801059ae:	e8 3d c6 ff ff       	call   80101ff0 <iunlockput>
  end_op();
801059b3:	e8 b8 d9 ff ff       	call   80103370 <end_op>
  return 0;
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	31 c0                	xor    %eax,%eax
}
801059bd:	c9                   	leave
801059be:	c3                   	ret
801059bf:	90                   	nop
    end_op();
801059c0:	e8 ab d9 ff ff       	call   80103370 <end_op>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ca:	c9                   	leave
801059cb:	c3                   	ret
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_chdir>:

int
sys_chdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
801059d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059d8:	e8 43 e5 ff ff       	call   80103f20 <myproc>
801059dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059df:	e8 1c d9 ff ff       	call   80103300 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059e4:	83 ec 08             	sub    $0x8,%esp
801059e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 de f5 ff ff       	call   80104fd0 <argstr>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 77                	js     80105a70 <sys_chdir+0xa0>
801059f9:	83 ec 0c             	sub    $0xc,%esp
801059fc:	ff 75 f4             	push   -0xc(%ebp)
801059ff:	e8 3c cc ff ff       	call   80102640 <namei>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	89 c3                	mov    %eax,%ebx
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	74 63                	je     80105a70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	50                   	push   %eax
80105a11:	e8 4a c3 ff ff       	call   80101d60 <ilock>
  if(ip->type != T_DIR){
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a1e:	75 30                	jne    80105a50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	53                   	push   %ebx
80105a24:	e8 17 c4 ff ff       	call   80101e40 <iunlock>
  iput(curproc->cwd);
80105a29:	58                   	pop    %eax
80105a2a:	ff 76 68             	push   0x68(%esi)
80105a2d:	e8 5e c4 ff ff       	call   80101e90 <iput>
  end_op();
80105a32:	e8 39 d9 ff ff       	call   80103370 <end_op>
  curproc->cwd = ip;
80105a37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	31 c0                	xor    %eax,%eax
}
80105a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a42:	5b                   	pop    %ebx
80105a43:	5e                   	pop    %esi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret
80105a46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4d:	00 
80105a4e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	53                   	push   %ebx
80105a54:	e8 97 c5 ff ff       	call   80101ff0 <iunlockput>
    end_op();
80105a59:	e8 12 d9 ff ff       	call   80103370 <end_op>
    return -1;
80105a5e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a66:	eb d7                	jmp    80105a3f <sys_chdir+0x6f>
80105a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6f:	00 
    end_op();
80105a70:	e8 fb d8 ff ff       	call   80103370 <end_op>
    return -1;
80105a75:	eb ea                	jmp    80105a61 <sys_chdir+0x91>
80105a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a7e:	00 
80105a7f:	90                   	nop

80105a80 <sys_exec>:

int
sys_exec(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a85:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a8b:	53                   	push   %ebx
80105a8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a92:	50                   	push   %eax
80105a93:	6a 00                	push   $0x0
80105a95:	e8 36 f5 ff ff       	call   80104fd0 <argstr>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	0f 88 87 00 00 00    	js     80105b2c <sys_exec+0xac>
80105aa5:	83 ec 08             	sub    $0x8,%esp
80105aa8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105aae:	50                   	push   %eax
80105aaf:	6a 01                	push   $0x1
80105ab1:	e8 5a f4 ff ff       	call   80104f10 <argint>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 6f                	js     80105b2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105abd:	83 ec 04             	sub    $0x4,%esp
80105ac0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105ac6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ac8:	68 80 00 00 00       	push   $0x80
80105acd:	6a 00                	push   $0x0
80105acf:	56                   	push   %esi
80105ad0:	e8 8b f1 ff ff       	call   80104c60 <memset>
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105adf:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ae9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105af0:	50                   	push   %eax
80105af1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105af7:	01 f8                	add    %edi,%eax
80105af9:	50                   	push   %eax
80105afa:	e8 81 f3 ff ff       	call   80104e80 <fetchint>
80105aff:	83 c4 10             	add    $0x10,%esp
80105b02:	85 c0                	test   %eax,%eax
80105b04:	78 26                	js     80105b2c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105b06:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b0c:	85 c0                	test   %eax,%eax
80105b0e:	74 30                	je     80105b40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b10:	83 ec 08             	sub    $0x8,%esp
80105b13:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105b16:	52                   	push   %edx
80105b17:	50                   	push   %eax
80105b18:	e8 a3 f3 ff ff       	call   80104ec0 <fetchstr>
80105b1d:	83 c4 10             	add    $0x10,%esp
80105b20:	85 c0                	test   %eax,%eax
80105b22:	78 08                	js     80105b2c <sys_exec+0xac>
  for(i=0;; i++){
80105b24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b27:	83 fb 20             	cmp    $0x20,%ebx
80105b2a:	75 b4                	jne    80105ae0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b34:	5b                   	pop    %ebx
80105b35:	5e                   	pop    %esi
80105b36:	5f                   	pop    %edi
80105b37:	5d                   	pop    %ebp
80105b38:	c3                   	ret
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105b40:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b47:	00 00 00 00 
  return exec(path, argv);
80105b4b:	83 ec 08             	sub    $0x8,%esp
80105b4e:	56                   	push   %esi
80105b4f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105b55:	e8 16 b5 ff ff       	call   80101070 <exec>
80105b5a:	83 c4 10             	add    $0x10,%esp
}
80105b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b60:	5b                   	pop    %ebx
80105b61:	5e                   	pop    %esi
80105b62:	5f                   	pop    %edi
80105b63:	5d                   	pop    %ebp
80105b64:	c3                   	ret
80105b65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6c:	00 
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi

80105b70 <sys_pipe>:

int
sys_pipe(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b75:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b78:	53                   	push   %ebx
80105b79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b7c:	6a 08                	push   $0x8
80105b7e:	50                   	push   %eax
80105b7f:	6a 00                	push   $0x0
80105b81:	e8 da f3 ff ff       	call   80104f60 <argptr>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	0f 88 8b 00 00 00    	js     80105c1c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b91:	83 ec 08             	sub    $0x8,%esp
80105b94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b97:	50                   	push   %eax
80105b98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b9b:	50                   	push   %eax
80105b9c:	e8 2f de ff ff       	call   801039d0 <pipealloc>
80105ba1:	83 c4 10             	add    $0x10,%esp
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 74                	js     80105c1c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ba8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105bab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105bad:	e8 6e e3 ff ff       	call   80103f20 <myproc>
    if(curproc->ofile[fd] == 0){
80105bb2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bb6:	85 f6                	test   %esi,%esi
80105bb8:	74 16                	je     80105bd0 <sys_pipe+0x60>
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c3 01             	add    $0x1,%ebx
80105bc3:	83 fb 10             	cmp    $0x10,%ebx
80105bc6:	74 3d                	je     80105c05 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105bc8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bcc:	85 f6                	test   %esi,%esi
80105bce:	75 f0                	jne    80105bc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105bd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105bd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bda:	e8 41 e3 ff ff       	call   80103f20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bdf:	31 d2                	xor    %edx,%edx
80105be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105be8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bec:	85 c9                	test   %ecx,%ecx
80105bee:	74 38                	je     80105c28 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105bf0:	83 c2 01             	add    $0x1,%edx
80105bf3:	83 fa 10             	cmp    $0x10,%edx
80105bf6:	75 f0                	jne    80105be8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105bf8:	e8 23 e3 ff ff       	call   80103f20 <myproc>
80105bfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c04:	00 
    fileclose(rf);
80105c05:	83 ec 0c             	sub    $0xc,%esp
80105c08:	ff 75 e0             	push   -0x20(%ebp)
80105c0b:	e8 c0 b8 ff ff       	call   801014d0 <fileclose>
    fileclose(wf);
80105c10:	58                   	pop    %eax
80105c11:	ff 75 e4             	push   -0x1c(%ebp)
80105c14:	e8 b7 b8 ff ff       	call   801014d0 <fileclose>
    return -1;
80105c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80105c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c21:	eb 16                	jmp    80105c39 <sys_pipe+0xc9>
80105c23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105c28:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105c2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c2f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c31:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c34:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c37:	31 c0                	xor    %eax,%eax
}
80105c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c3c:	5b                   	pop    %ebx
80105c3d:	5e                   	pop    %esi
80105c3e:	5f                   	pop    %edi
80105c3f:	5d                   	pop    %ebp
80105c40:	c3                   	ret
80105c41:	66 90                	xchg   %ax,%ax
80105c43:	66 90                	xchg   %ax,%ax
80105c45:	66 90                	xchg   %ax,%ax
80105c47:	66 90                	xchg   %ax,%ax
80105c49:	66 90                	xchg   %ax,%ax
80105c4b:	66 90                	xchg   %ax,%ax
80105c4d:	66 90                	xchg   %ax,%ax
80105c4f:	90                   	nop

80105c50 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105c50:	e9 6b e4 ff ff       	jmp    801040c0 <fork>
80105c55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c5c:	00 
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <sys_exit>:
}

int
sys_exit(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c66:	e8 c5 e6 ff ff       	call   80104330 <exit>
  return 0;  // not reached
}
80105c6b:	31 c0                	xor    %eax,%eax
80105c6d:	c9                   	leave
80105c6e:	c3                   	ret
80105c6f:	90                   	nop

80105c70 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105c70:	e9 eb e7 ff ff       	jmp    80104460 <wait>
80105c75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c7c:	00 
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi

80105c80 <sys_kill>:
}

int
sys_kill(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 7f f2 ff ff       	call   80104f10 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 18                	js     80105cb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	ff 75 f4             	push   -0xc(%ebp)
80105c9e:	e8 5d ea ff ff       	call   80104700 <kill>
80105ca3:	83 c4 10             	add    $0x10,%esp
}
80105ca6:	c9                   	leave
80105ca7:	c3                   	ret
80105ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105caf:	00 
80105cb0:	c9                   	leave
    return -1;
80105cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb6:	c3                   	ret
80105cb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cbe:	00 
80105cbf:	90                   	nop

80105cc0 <sys_getpid>:

int
sys_getpid(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cc6:	e8 55 e2 ff ff       	call   80103f20 <myproc>
80105ccb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cce:	c9                   	leave
80105ccf:	c3                   	ret

80105cd0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cda:	50                   	push   %eax
80105cdb:	6a 00                	push   $0x0
80105cdd:	e8 2e f2 ff ff       	call   80104f10 <argint>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 27                	js     80105d10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ce9:	e8 32 e2 ff ff       	call   80103f20 <myproc>
  if(growproc(n) < 0)
80105cee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105cf1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cf3:	ff 75 f4             	push   -0xc(%ebp)
80105cf6:	e8 45 e3 ff ff       	call   80104040 <growproc>
80105cfb:	83 c4 10             	add    $0x10,%esp
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	78 0e                	js     80105d10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d02:	89 d8                	mov    %ebx,%eax
80105d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d07:	c9                   	leave
80105d08:	c3                   	ret
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d15:	eb eb                	jmp    80105d02 <sys_sbrk+0x32>
80105d17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d1e:	00 
80105d1f:	90                   	nop

80105d20 <sys_sleep>:

int
sys_sleep(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 de f1 ff ff       	call   80104f10 <argint>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 64                	js     80105d9d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105d39:	83 ec 0c             	sub    $0xc,%esp
80105d3c:	68 a0 4c 11 80       	push   $0x80114ca0
80105d41:	e8 1a ee ff ff       	call   80104b60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d49:	8b 1d 80 4c 11 80    	mov    0x80114c80,%ebx
  while(ticks - ticks0 < n){
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	85 d2                	test   %edx,%edx
80105d54:	75 2b                	jne    80105d81 <sys_sleep+0x61>
80105d56:	eb 58                	jmp    80105db0 <sys_sleep+0x90>
80105d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d60:	83 ec 08             	sub    $0x8,%esp
80105d63:	68 a0 4c 11 80       	push   $0x80114ca0
80105d68:	68 80 4c 11 80       	push   $0x80114c80
80105d6d:	e8 6e e8 ff ff       	call   801045e0 <sleep>
  while(ticks - ticks0 < n){
80105d72:	a1 80 4c 11 80       	mov    0x80114c80,%eax
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	29 d8                	sub    %ebx,%eax
80105d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d7f:	73 2f                	jae    80105db0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d81:	e8 9a e1 ff ff       	call   80103f20 <myproc>
80105d86:	8b 40 24             	mov    0x24(%eax),%eax
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	74 d3                	je     80105d60 <sys_sleep+0x40>
      release(&tickslock);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	68 a0 4c 11 80       	push   $0x80114ca0
80105d95:	e8 66 ed ff ff       	call   80104b00 <release>
      return -1;
80105d9a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da5:	c9                   	leave
80105da6:	c3                   	ret
80105da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dae:	00 
80105daf:	90                   	nop
  release(&tickslock);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	68 a0 4c 11 80       	push   $0x80114ca0
80105db8:	e8 43 ed ff ff       	call   80104b00 <release>
}
80105dbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	31 c0                	xor    %eax,%eax
}
80105dc5:	c9                   	leave
80105dc6:	c3                   	ret
80105dc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dce:	00 
80105dcf:	90                   	nop

80105dd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	53                   	push   %ebx
80105dd4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105dd7:	68 a0 4c 11 80       	push   $0x80114ca0
80105ddc:	e8 7f ed ff ff       	call   80104b60 <acquire>
  xticks = ticks;
80105de1:	8b 1d 80 4c 11 80    	mov    0x80114c80,%ebx
  release(&tickslock);
80105de7:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
80105dee:	e8 0d ed ff ff       	call   80104b00 <release>
  return xticks;
}
80105df3:	89 d8                	mov    %ebx,%eax
80105df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df8:	c9                   	leave
80105df9:	c3                   	ret

80105dfa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dfa:	1e                   	push   %ds
  pushl %es
80105dfb:	06                   	push   %es
  pushl %fs
80105dfc:	0f a0                	push   %fs
  pushl %gs
80105dfe:	0f a8                	push   %gs
  pushal
80105e00:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e01:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e05:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e07:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e09:	54                   	push   %esp
  call trap
80105e0a:	e8 c1 00 00 00       	call   80105ed0 <trap>
  addl $4, %esp
80105e0f:	83 c4 04             	add    $0x4,%esp

80105e12 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e12:	61                   	popa
  popl %gs
80105e13:	0f a9                	pop    %gs
  popl %fs
80105e15:	0f a1                	pop    %fs
  popl %es
80105e17:	07                   	pop    %es
  popl %ds
80105e18:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e19:	83 c4 08             	add    $0x8,%esp
  iret
80105e1c:	cf                   	iret
80105e1d:	66 90                	xchg   %ax,%ax
80105e1f:	90                   	nop

80105e20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e21:	31 c0                	xor    %eax,%eax
{
80105e23:	89 e5                	mov    %esp,%ebp
80105e25:	83 ec 08             	sub    $0x8,%esp
80105e28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e2f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e30:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e37:	c7 04 c5 e2 4c 11 80 	movl   $0x8e000008,-0x7feeb31e(,%eax,8)
80105e3e:	08 00 00 8e 
80105e42:	66 89 14 c5 e0 4c 11 	mov    %dx,-0x7feeb320(,%eax,8)
80105e49:	80 
80105e4a:	c1 ea 10             	shr    $0x10,%edx
80105e4d:	66 89 14 c5 e6 4c 11 	mov    %dx,-0x7feeb31a(,%eax,8)
80105e54:	80 
  for(i = 0; i < 256; i++)
80105e55:	83 c0 01             	add    $0x1,%eax
80105e58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e5d:	75 d1                	jne    80105e30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e62:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e67:	c7 05 e2 4e 11 80 08 	movl   $0xef000008,0x80114ee2
80105e6e:	00 00 ef 
  initlock(&tickslock, "time");
80105e71:	68 0e 7b 10 80       	push   $0x80107b0e
80105e76:	68 a0 4c 11 80       	push   $0x80114ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e7b:	66 a3 e0 4e 11 80    	mov    %ax,0x80114ee0
80105e81:	c1 e8 10             	shr    $0x10,%eax
80105e84:	66 a3 e6 4e 11 80    	mov    %ax,0x80114ee6
  initlock(&tickslock, "time");
80105e8a:	e8 e1 ea ff ff       	call   80104970 <initlock>
}
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	c9                   	leave
80105e93:	c3                   	ret
80105e94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e9b:	00 
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <idtinit>:

void
idtinit(void)
{
80105ea0:	55                   	push   %ebp
  pd[0] = size-1;
80105ea1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ea6:	89 e5                	mov    %esp,%ebp
80105ea8:	83 ec 10             	sub    $0x10,%esp
80105eab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105eaf:	b8 e0 4c 11 80       	mov    $0x80114ce0,%eax
80105eb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105eb8:	c1 e8 10             	shr    $0x10,%eax
80105ebb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ebf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ec2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ec5:	c9                   	leave
80105ec6:	c3                   	ret
80105ec7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ece:	00 
80105ecf:	90                   	nop

80105ed0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	83 ec 1c             	sub    $0x1c,%esp
80105ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105edc:	8b 43 30             	mov    0x30(%ebx),%eax
80105edf:	83 f8 40             	cmp    $0x40,%eax
80105ee2:	0f 84 58 01 00 00    	je     80106040 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ee8:	83 e8 20             	sub    $0x20,%eax
80105eeb:	83 f8 1f             	cmp    $0x1f,%eax
80105eee:	0f 87 7c 00 00 00    	ja     80105f70 <trap+0xa0>
80105ef4:	ff 24 85 78 80 10 80 	jmp    *-0x7fef7f88(,%eax,4)
80105efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105f00:	e8 eb c8 ff ff       	call   801027f0 <ideintr>
    lapiceoi();
80105f05:	e8 a6 cf ff ff       	call   80102eb0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0a:	e8 11 e0 ff ff       	call   80103f20 <myproc>
80105f0f:	85 c0                	test   %eax,%eax
80105f11:	74 1a                	je     80105f2d <trap+0x5d>
80105f13:	e8 08 e0 ff ff       	call   80103f20 <myproc>
80105f18:	8b 50 24             	mov    0x24(%eax),%edx
80105f1b:	85 d2                	test   %edx,%edx
80105f1d:	74 0e                	je     80105f2d <trap+0x5d>
80105f1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f23:	f7 d0                	not    %eax
80105f25:	a8 03                	test   $0x3,%al
80105f27:	0f 84 db 01 00 00    	je     80106108 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f2d:	e8 ee df ff ff       	call   80103f20 <myproc>
80105f32:	85 c0                	test   %eax,%eax
80105f34:	74 0f                	je     80105f45 <trap+0x75>
80105f36:	e8 e5 df ff ff       	call   80103f20 <myproc>
80105f3b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f3f:	0f 84 ab 00 00 00    	je     80105ff0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f45:	e8 d6 df ff ff       	call   80103f20 <myproc>
80105f4a:	85 c0                	test   %eax,%eax
80105f4c:	74 1a                	je     80105f68 <trap+0x98>
80105f4e:	e8 cd df ff ff       	call   80103f20 <myproc>
80105f53:	8b 40 24             	mov    0x24(%eax),%eax
80105f56:	85 c0                	test   %eax,%eax
80105f58:	74 0e                	je     80105f68 <trap+0x98>
80105f5a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f5e:	f7 d0                	not    %eax
80105f60:	a8 03                	test   $0x3,%al
80105f62:	0f 84 05 01 00 00    	je     8010606d <trap+0x19d>
    exit();
}
80105f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f6b:	5b                   	pop    %ebx
80105f6c:	5e                   	pop    %esi
80105f6d:	5f                   	pop    %edi
80105f6e:	5d                   	pop    %ebp
80105f6f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f70:	e8 ab df ff ff       	call   80103f20 <myproc>
80105f75:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	0f 84 a2 01 00 00    	je     80106122 <trap+0x252>
80105f80:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f84:	0f 84 98 01 00 00    	je     80106122 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f8a:	0f 20 d1             	mov    %cr2,%ecx
80105f8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f90:	e8 6b df ff ff       	call   80103f00 <cpuid>
80105f95:	8b 73 30             	mov    0x30(%ebx),%esi
80105f98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f9b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105fa1:	e8 7a df ff ff       	call   80103f20 <myproc>
80105fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fa9:	e8 72 df ff ff       	call   80103f20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fb1:	51                   	push   %ecx
80105fb2:	57                   	push   %edi
80105fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fb6:	52                   	push   %edx
80105fb7:	ff 75 e4             	push   -0x1c(%ebp)
80105fba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fbb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105fbe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fc1:	56                   	push   %esi
80105fc2:	ff 70 10             	push   0x10(%eax)
80105fc5:	68 5c 7d 10 80       	push   $0x80107d5c
80105fca:	e8 d1 a7 ff ff       	call   801007a0 <cprintf>
    myproc()->killed = 1;
80105fcf:	83 c4 20             	add    $0x20,%esp
80105fd2:	e8 49 df ff ff       	call   80103f20 <myproc>
80105fd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fde:	e8 3d df ff ff       	call   80103f20 <myproc>
80105fe3:	85 c0                	test   %eax,%eax
80105fe5:	0f 85 28 ff ff ff    	jne    80105f13 <trap+0x43>
80105feb:	e9 3d ff ff ff       	jmp    80105f2d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105ff0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ff4:	0f 85 4b ff ff ff    	jne    80105f45 <trap+0x75>
    yield();
80105ffa:	e8 91 e5 ff ff       	call   80104590 <yield>
80105fff:	e9 41 ff ff ff       	jmp    80105f45 <trap+0x75>
80106004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106008:	8b 7b 38             	mov    0x38(%ebx),%edi
8010600b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010600f:	e8 ec de ff ff       	call   80103f00 <cpuid>
80106014:	57                   	push   %edi
80106015:	56                   	push   %esi
80106016:	50                   	push   %eax
80106017:	68 04 7d 10 80       	push   $0x80107d04
8010601c:	e8 7f a7 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80106021:	e8 8a ce ff ff       	call   80102eb0 <lapiceoi>
    break;
80106026:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106029:	e8 f2 de ff ff       	call   80103f20 <myproc>
8010602e:	85 c0                	test   %eax,%eax
80106030:	0f 85 dd fe ff ff    	jne    80105f13 <trap+0x43>
80106036:	e9 f2 fe ff ff       	jmp    80105f2d <trap+0x5d>
8010603b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106040:	e8 db de ff ff       	call   80103f20 <myproc>
80106045:	8b 70 24             	mov    0x24(%eax),%esi
80106048:	85 f6                	test   %esi,%esi
8010604a:	0f 85 c8 00 00 00    	jne    80106118 <trap+0x248>
    myproc()->tf = tf;
80106050:	e8 cb de ff ff       	call   80103f20 <myproc>
80106055:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106058:	e8 f3 ef ff ff       	call   80105050 <syscall>
    if(myproc()->killed)
8010605d:	e8 be de ff ff       	call   80103f20 <myproc>
80106062:	8b 48 24             	mov    0x24(%eax),%ecx
80106065:	85 c9                	test   %ecx,%ecx
80106067:	0f 84 fb fe ff ff    	je     80105f68 <trap+0x98>
}
8010606d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106070:	5b                   	pop    %ebx
80106071:	5e                   	pop    %esi
80106072:	5f                   	pop    %edi
80106073:	5d                   	pop    %ebp
      exit();
80106074:	e9 b7 e2 ff ff       	jmp    80104330 <exit>
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106080:	e8 4b 02 00 00       	call   801062d0 <uartintr>
    lapiceoi();
80106085:	e8 26 ce ff ff       	call   80102eb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010608a:	e8 91 de ff ff       	call   80103f20 <myproc>
8010608f:	85 c0                	test   %eax,%eax
80106091:	0f 85 7c fe ff ff    	jne    80105f13 <trap+0x43>
80106097:	e9 91 fe ff ff       	jmp    80105f2d <trap+0x5d>
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801060a0:	e8 db cc ff ff       	call   80102d80 <kbdintr>
    lapiceoi();
801060a5:	e8 06 ce ff ff       	call   80102eb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060aa:	e8 71 de ff ff       	call   80103f20 <myproc>
801060af:	85 c0                	test   %eax,%eax
801060b1:	0f 85 5c fe ff ff    	jne    80105f13 <trap+0x43>
801060b7:	e9 71 fe ff ff       	jmp    80105f2d <trap+0x5d>
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801060c0:	e8 3b de ff ff       	call   80103f00 <cpuid>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	0f 85 38 fe ff ff    	jne    80105f05 <trap+0x35>
      acquire(&tickslock);
801060cd:	83 ec 0c             	sub    $0xc,%esp
801060d0:	68 a0 4c 11 80       	push   $0x80114ca0
801060d5:	e8 86 ea ff ff       	call   80104b60 <acquire>
      ticks++;
801060da:	83 05 80 4c 11 80 01 	addl   $0x1,0x80114c80
      wakeup(&ticks);
801060e1:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
801060e8:	e8 b3 e5 ff ff       	call   801046a0 <wakeup>
      release(&tickslock);
801060ed:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
801060f4:	e8 07 ea ff ff       	call   80104b00 <release>
801060f9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801060fc:	e9 04 fe ff ff       	jmp    80105f05 <trap+0x35>
80106101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106108:	e8 23 e2 ff ff       	call   80104330 <exit>
8010610d:	e9 1b fe ff ff       	jmp    80105f2d <trap+0x5d>
80106112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106118:	e8 13 e2 ff ff       	call   80104330 <exit>
8010611d:	e9 2e ff ff ff       	jmp    80106050 <trap+0x180>
80106122:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106125:	e8 d6 dd ff ff       	call   80103f00 <cpuid>
8010612a:	83 ec 0c             	sub    $0xc,%esp
8010612d:	56                   	push   %esi
8010612e:	57                   	push   %edi
8010612f:	50                   	push   %eax
80106130:	ff 73 30             	push   0x30(%ebx)
80106133:	68 28 7d 10 80       	push   $0x80107d28
80106138:	e8 63 a6 ff ff       	call   801007a0 <cprintf>
      panic("trap");
8010613d:	83 c4 14             	add    $0x14,%esp
80106140:	68 13 7b 10 80       	push   $0x80107b13
80106145:	e8 36 a2 ff ff       	call   80100380 <panic>
8010614a:	66 90                	xchg   %ax,%ax
8010614c:	66 90                	xchg   %ax,%ax
8010614e:	66 90                	xchg   %ax,%ax

80106150 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106150:	a1 e0 54 11 80       	mov    0x801154e0,%eax
80106155:	85 c0                	test   %eax,%eax
80106157:	74 17                	je     80106170 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106159:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010615e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010615f:	a8 01                	test   $0x1,%al
80106161:	74 0d                	je     80106170 <uartgetc+0x20>
80106163:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106168:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106169:	0f b6 c0             	movzbl %al,%eax
8010616c:	c3                   	ret
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106175:	c3                   	ret
80106176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010617d:	00 
8010617e:	66 90                	xchg   %ax,%ax

80106180 <uartinit>:
{
80106180:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106181:	31 c9                	xor    %ecx,%ecx
80106183:	89 c8                	mov    %ecx,%eax
80106185:	89 e5                	mov    %esp,%ebp
80106187:	57                   	push   %edi
80106188:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010618d:	56                   	push   %esi
8010618e:	89 fa                	mov    %edi,%edx
80106190:	53                   	push   %ebx
80106191:	83 ec 1c             	sub    $0x1c,%esp
80106194:	ee                   	out    %al,(%dx)
80106195:	be fb 03 00 00       	mov    $0x3fb,%esi
8010619a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010619f:	89 f2                	mov    %esi,%edx
801061a1:	ee                   	out    %al,(%dx)
801061a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801061a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ac:	ee                   	out    %al,(%dx)
801061ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801061b2:	89 c8                	mov    %ecx,%eax
801061b4:	89 da                	mov    %ebx,%edx
801061b6:	ee                   	out    %al,(%dx)
801061b7:	b8 03 00 00 00       	mov    $0x3,%eax
801061bc:	89 f2                	mov    %esi,%edx
801061be:	ee                   	out    %al,(%dx)
801061bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061c4:	89 c8                	mov    %ecx,%eax
801061c6:	ee                   	out    %al,(%dx)
801061c7:	b8 01 00 00 00       	mov    $0x1,%eax
801061cc:	89 da                	mov    %ebx,%edx
801061ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061d5:	3c ff                	cmp    $0xff,%al
801061d7:	0f 84 7c 00 00 00    	je     80106259 <uartinit+0xd9>
  uart = 1;
801061dd:	c7 05 e0 54 11 80 01 	movl   $0x1,0x801154e0
801061e4:	00 00 00 
801061e7:	89 fa                	mov    %edi,%edx
801061e9:	ec                   	in     (%dx),%al
801061ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061f0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061f3:	bf 18 7b 10 80       	mov    $0x80107b18,%edi
801061f8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801061fd:	6a 00                	push   $0x0
801061ff:	6a 04                	push   $0x4
80106201:	e8 1a c8 ff ff       	call   80102a20 <ioapicenable>
80106206:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106209:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010620d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106210:	a1 e0 54 11 80       	mov    0x801154e0,%eax
80106215:	85 c0                	test   %eax,%eax
80106217:	74 32                	je     8010624b <uartinit+0xcb>
80106219:	89 f2                	mov    %esi,%edx
8010621b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010621c:	a8 20                	test   $0x20,%al
8010621e:	75 21                	jne    80106241 <uartinit+0xc1>
80106220:	bb 80 00 00 00       	mov    $0x80,%ebx
80106225:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106228:	83 ec 0c             	sub    $0xc,%esp
8010622b:	6a 0a                	push   $0xa
8010622d:	e8 9e cc ff ff       	call   80102ed0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106232:	83 c4 10             	add    $0x10,%esp
80106235:	83 eb 01             	sub    $0x1,%ebx
80106238:	74 07                	je     80106241 <uartinit+0xc1>
8010623a:	89 f2                	mov    %esi,%edx
8010623c:	ec                   	in     (%dx),%al
8010623d:	a8 20                	test   $0x20,%al
8010623f:	74 e7                	je     80106228 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106241:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106246:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010624a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010624b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010624f:	83 c7 01             	add    $0x1,%edi
80106252:	88 45 e7             	mov    %al,-0x19(%ebp)
80106255:	84 c0                	test   %al,%al
80106257:	75 b7                	jne    80106210 <uartinit+0x90>
}
80106259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625c:	5b                   	pop    %ebx
8010625d:	5e                   	pop    %esi
8010625e:	5f                   	pop    %edi
8010625f:	5d                   	pop    %ebp
80106260:	c3                   	ret
80106261:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106268:	00 
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106270 <uartputc>:
  if(!uart)
80106270:	a1 e0 54 11 80       	mov    0x801154e0,%eax
80106275:	85 c0                	test   %eax,%eax
80106277:	74 4f                	je     801062c8 <uartputc+0x58>
{
80106279:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010627a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010627f:	89 e5                	mov    %esp,%ebp
80106281:	56                   	push   %esi
80106282:	53                   	push   %ebx
80106283:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106284:	a8 20                	test   $0x20,%al
80106286:	75 29                	jne    801062b1 <uartputc+0x41>
80106288:	bb 80 00 00 00       	mov    $0x80,%ebx
8010628d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106298:	83 ec 0c             	sub    $0xc,%esp
8010629b:	6a 0a                	push   $0xa
8010629d:	e8 2e cc ff ff       	call   80102ed0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	83 eb 01             	sub    $0x1,%ebx
801062a8:	74 07                	je     801062b1 <uartputc+0x41>
801062aa:	89 f2                	mov    %esi,%edx
801062ac:	ec                   	in     (%dx),%al
801062ad:	a8 20                	test   $0x20,%al
801062af:	74 e7                	je     80106298 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b1:	8b 45 08             	mov    0x8(%ebp),%eax
801062b4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062b9:	ee                   	out    %al,(%dx)
}
801062ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062bd:	5b                   	pop    %ebx
801062be:	5e                   	pop    %esi
801062bf:	5d                   	pop    %ebp
801062c0:	c3                   	ret
801062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062c8:	c3                   	ret
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <uartintr>:

void
uartintr(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801062d6:	68 50 61 10 80       	push   $0x80106150
801062db:	e8 00 a9 ff ff       	call   80100be0 <consoleintr>
}
801062e0:	83 c4 10             	add    $0x10,%esp
801062e3:	c9                   	leave
801062e4:	c3                   	ret

801062e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $0
801062e7:	6a 00                	push   $0x0
  jmp alltraps
801062e9:	e9 0c fb ff ff       	jmp    80105dfa <alltraps>

801062ee <vector1>:
.globl vector1
vector1:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $1
801062f0:	6a 01                	push   $0x1
  jmp alltraps
801062f2:	e9 03 fb ff ff       	jmp    80105dfa <alltraps>

801062f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $2
801062f9:	6a 02                	push   $0x2
  jmp alltraps
801062fb:	e9 fa fa ff ff       	jmp    80105dfa <alltraps>

80106300 <vector3>:
.globl vector3
vector3:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $3
80106302:	6a 03                	push   $0x3
  jmp alltraps
80106304:	e9 f1 fa ff ff       	jmp    80105dfa <alltraps>

80106309 <vector4>:
.globl vector4
vector4:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $4
8010630b:	6a 04                	push   $0x4
  jmp alltraps
8010630d:	e9 e8 fa ff ff       	jmp    80105dfa <alltraps>

80106312 <vector5>:
.globl vector5
vector5:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $5
80106314:	6a 05                	push   $0x5
  jmp alltraps
80106316:	e9 df fa ff ff       	jmp    80105dfa <alltraps>

8010631b <vector6>:
.globl vector6
vector6:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $6
8010631d:	6a 06                	push   $0x6
  jmp alltraps
8010631f:	e9 d6 fa ff ff       	jmp    80105dfa <alltraps>

80106324 <vector7>:
.globl vector7
vector7:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $7
80106326:	6a 07                	push   $0x7
  jmp alltraps
80106328:	e9 cd fa ff ff       	jmp    80105dfa <alltraps>

8010632d <vector8>:
.globl vector8
vector8:
  pushl $8
8010632d:	6a 08                	push   $0x8
  jmp alltraps
8010632f:	e9 c6 fa ff ff       	jmp    80105dfa <alltraps>

80106334 <vector9>:
.globl vector9
vector9:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $9
80106336:	6a 09                	push   $0x9
  jmp alltraps
80106338:	e9 bd fa ff ff       	jmp    80105dfa <alltraps>

8010633d <vector10>:
.globl vector10
vector10:
  pushl $10
8010633d:	6a 0a                	push   $0xa
  jmp alltraps
8010633f:	e9 b6 fa ff ff       	jmp    80105dfa <alltraps>

80106344 <vector11>:
.globl vector11
vector11:
  pushl $11
80106344:	6a 0b                	push   $0xb
  jmp alltraps
80106346:	e9 af fa ff ff       	jmp    80105dfa <alltraps>

8010634b <vector12>:
.globl vector12
vector12:
  pushl $12
8010634b:	6a 0c                	push   $0xc
  jmp alltraps
8010634d:	e9 a8 fa ff ff       	jmp    80105dfa <alltraps>

80106352 <vector13>:
.globl vector13
vector13:
  pushl $13
80106352:	6a 0d                	push   $0xd
  jmp alltraps
80106354:	e9 a1 fa ff ff       	jmp    80105dfa <alltraps>

80106359 <vector14>:
.globl vector14
vector14:
  pushl $14
80106359:	6a 0e                	push   $0xe
  jmp alltraps
8010635b:	e9 9a fa ff ff       	jmp    80105dfa <alltraps>

80106360 <vector15>:
.globl vector15
vector15:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $15
80106362:	6a 0f                	push   $0xf
  jmp alltraps
80106364:	e9 91 fa ff ff       	jmp    80105dfa <alltraps>

80106369 <vector16>:
.globl vector16
vector16:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $16
8010636b:	6a 10                	push   $0x10
  jmp alltraps
8010636d:	e9 88 fa ff ff       	jmp    80105dfa <alltraps>

80106372 <vector17>:
.globl vector17
vector17:
  pushl $17
80106372:	6a 11                	push   $0x11
  jmp alltraps
80106374:	e9 81 fa ff ff       	jmp    80105dfa <alltraps>

80106379 <vector18>:
.globl vector18
vector18:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $18
8010637b:	6a 12                	push   $0x12
  jmp alltraps
8010637d:	e9 78 fa ff ff       	jmp    80105dfa <alltraps>

80106382 <vector19>:
.globl vector19
vector19:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $19
80106384:	6a 13                	push   $0x13
  jmp alltraps
80106386:	e9 6f fa ff ff       	jmp    80105dfa <alltraps>

8010638b <vector20>:
.globl vector20
vector20:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $20
8010638d:	6a 14                	push   $0x14
  jmp alltraps
8010638f:	e9 66 fa ff ff       	jmp    80105dfa <alltraps>

80106394 <vector21>:
.globl vector21
vector21:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $21
80106396:	6a 15                	push   $0x15
  jmp alltraps
80106398:	e9 5d fa ff ff       	jmp    80105dfa <alltraps>

8010639d <vector22>:
.globl vector22
vector22:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $22
8010639f:	6a 16                	push   $0x16
  jmp alltraps
801063a1:	e9 54 fa ff ff       	jmp    80105dfa <alltraps>

801063a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $23
801063a8:	6a 17                	push   $0x17
  jmp alltraps
801063aa:	e9 4b fa ff ff       	jmp    80105dfa <alltraps>

801063af <vector24>:
.globl vector24
vector24:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $24
801063b1:	6a 18                	push   $0x18
  jmp alltraps
801063b3:	e9 42 fa ff ff       	jmp    80105dfa <alltraps>

801063b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $25
801063ba:	6a 19                	push   $0x19
  jmp alltraps
801063bc:	e9 39 fa ff ff       	jmp    80105dfa <alltraps>

801063c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $26
801063c3:	6a 1a                	push   $0x1a
  jmp alltraps
801063c5:	e9 30 fa ff ff       	jmp    80105dfa <alltraps>

801063ca <vector27>:
.globl vector27
vector27:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $27
801063cc:	6a 1b                	push   $0x1b
  jmp alltraps
801063ce:	e9 27 fa ff ff       	jmp    80105dfa <alltraps>

801063d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $28
801063d5:	6a 1c                	push   $0x1c
  jmp alltraps
801063d7:	e9 1e fa ff ff       	jmp    80105dfa <alltraps>

801063dc <vector29>:
.globl vector29
vector29:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $29
801063de:	6a 1d                	push   $0x1d
  jmp alltraps
801063e0:	e9 15 fa ff ff       	jmp    80105dfa <alltraps>

801063e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $30
801063e7:	6a 1e                	push   $0x1e
  jmp alltraps
801063e9:	e9 0c fa ff ff       	jmp    80105dfa <alltraps>

801063ee <vector31>:
.globl vector31
vector31:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $31
801063f0:	6a 1f                	push   $0x1f
  jmp alltraps
801063f2:	e9 03 fa ff ff       	jmp    80105dfa <alltraps>

801063f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $32
801063f9:	6a 20                	push   $0x20
  jmp alltraps
801063fb:	e9 fa f9 ff ff       	jmp    80105dfa <alltraps>

80106400 <vector33>:
.globl vector33
vector33:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $33
80106402:	6a 21                	push   $0x21
  jmp alltraps
80106404:	e9 f1 f9 ff ff       	jmp    80105dfa <alltraps>

80106409 <vector34>:
.globl vector34
vector34:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $34
8010640b:	6a 22                	push   $0x22
  jmp alltraps
8010640d:	e9 e8 f9 ff ff       	jmp    80105dfa <alltraps>

80106412 <vector35>:
.globl vector35
vector35:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $35
80106414:	6a 23                	push   $0x23
  jmp alltraps
80106416:	e9 df f9 ff ff       	jmp    80105dfa <alltraps>

8010641b <vector36>:
.globl vector36
vector36:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $36
8010641d:	6a 24                	push   $0x24
  jmp alltraps
8010641f:	e9 d6 f9 ff ff       	jmp    80105dfa <alltraps>

80106424 <vector37>:
.globl vector37
vector37:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $37
80106426:	6a 25                	push   $0x25
  jmp alltraps
80106428:	e9 cd f9 ff ff       	jmp    80105dfa <alltraps>

8010642d <vector38>:
.globl vector38
vector38:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $38
8010642f:	6a 26                	push   $0x26
  jmp alltraps
80106431:	e9 c4 f9 ff ff       	jmp    80105dfa <alltraps>

80106436 <vector39>:
.globl vector39
vector39:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $39
80106438:	6a 27                	push   $0x27
  jmp alltraps
8010643a:	e9 bb f9 ff ff       	jmp    80105dfa <alltraps>

8010643f <vector40>:
.globl vector40
vector40:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $40
80106441:	6a 28                	push   $0x28
  jmp alltraps
80106443:	e9 b2 f9 ff ff       	jmp    80105dfa <alltraps>

80106448 <vector41>:
.globl vector41
vector41:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $41
8010644a:	6a 29                	push   $0x29
  jmp alltraps
8010644c:	e9 a9 f9 ff ff       	jmp    80105dfa <alltraps>

80106451 <vector42>:
.globl vector42
vector42:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $42
80106453:	6a 2a                	push   $0x2a
  jmp alltraps
80106455:	e9 a0 f9 ff ff       	jmp    80105dfa <alltraps>

8010645a <vector43>:
.globl vector43
vector43:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $43
8010645c:	6a 2b                	push   $0x2b
  jmp alltraps
8010645e:	e9 97 f9 ff ff       	jmp    80105dfa <alltraps>

80106463 <vector44>:
.globl vector44
vector44:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $44
80106465:	6a 2c                	push   $0x2c
  jmp alltraps
80106467:	e9 8e f9 ff ff       	jmp    80105dfa <alltraps>

8010646c <vector45>:
.globl vector45
vector45:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $45
8010646e:	6a 2d                	push   $0x2d
  jmp alltraps
80106470:	e9 85 f9 ff ff       	jmp    80105dfa <alltraps>

80106475 <vector46>:
.globl vector46
vector46:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $46
80106477:	6a 2e                	push   $0x2e
  jmp alltraps
80106479:	e9 7c f9 ff ff       	jmp    80105dfa <alltraps>

8010647e <vector47>:
.globl vector47
vector47:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $47
80106480:	6a 2f                	push   $0x2f
  jmp alltraps
80106482:	e9 73 f9 ff ff       	jmp    80105dfa <alltraps>

80106487 <vector48>:
.globl vector48
vector48:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $48
80106489:	6a 30                	push   $0x30
  jmp alltraps
8010648b:	e9 6a f9 ff ff       	jmp    80105dfa <alltraps>

80106490 <vector49>:
.globl vector49
vector49:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $49
80106492:	6a 31                	push   $0x31
  jmp alltraps
80106494:	e9 61 f9 ff ff       	jmp    80105dfa <alltraps>

80106499 <vector50>:
.globl vector50
vector50:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $50
8010649b:	6a 32                	push   $0x32
  jmp alltraps
8010649d:	e9 58 f9 ff ff       	jmp    80105dfa <alltraps>

801064a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $51
801064a4:	6a 33                	push   $0x33
  jmp alltraps
801064a6:	e9 4f f9 ff ff       	jmp    80105dfa <alltraps>

801064ab <vector52>:
.globl vector52
vector52:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $52
801064ad:	6a 34                	push   $0x34
  jmp alltraps
801064af:	e9 46 f9 ff ff       	jmp    80105dfa <alltraps>

801064b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $53
801064b6:	6a 35                	push   $0x35
  jmp alltraps
801064b8:	e9 3d f9 ff ff       	jmp    80105dfa <alltraps>

801064bd <vector54>:
.globl vector54
vector54:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $54
801064bf:	6a 36                	push   $0x36
  jmp alltraps
801064c1:	e9 34 f9 ff ff       	jmp    80105dfa <alltraps>

801064c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $55
801064c8:	6a 37                	push   $0x37
  jmp alltraps
801064ca:	e9 2b f9 ff ff       	jmp    80105dfa <alltraps>

801064cf <vector56>:
.globl vector56
vector56:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $56
801064d1:	6a 38                	push   $0x38
  jmp alltraps
801064d3:	e9 22 f9 ff ff       	jmp    80105dfa <alltraps>

801064d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $57
801064da:	6a 39                	push   $0x39
  jmp alltraps
801064dc:	e9 19 f9 ff ff       	jmp    80105dfa <alltraps>

801064e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $58
801064e3:	6a 3a                	push   $0x3a
  jmp alltraps
801064e5:	e9 10 f9 ff ff       	jmp    80105dfa <alltraps>

801064ea <vector59>:
.globl vector59
vector59:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $59
801064ec:	6a 3b                	push   $0x3b
  jmp alltraps
801064ee:	e9 07 f9 ff ff       	jmp    80105dfa <alltraps>

801064f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $60
801064f5:	6a 3c                	push   $0x3c
  jmp alltraps
801064f7:	e9 fe f8 ff ff       	jmp    80105dfa <alltraps>

801064fc <vector61>:
.globl vector61
vector61:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $61
801064fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106500:	e9 f5 f8 ff ff       	jmp    80105dfa <alltraps>

80106505 <vector62>:
.globl vector62
vector62:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $62
80106507:	6a 3e                	push   $0x3e
  jmp alltraps
80106509:	e9 ec f8 ff ff       	jmp    80105dfa <alltraps>

8010650e <vector63>:
.globl vector63
vector63:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $63
80106510:	6a 3f                	push   $0x3f
  jmp alltraps
80106512:	e9 e3 f8 ff ff       	jmp    80105dfa <alltraps>

80106517 <vector64>:
.globl vector64
vector64:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $64
80106519:	6a 40                	push   $0x40
  jmp alltraps
8010651b:	e9 da f8 ff ff       	jmp    80105dfa <alltraps>

80106520 <vector65>:
.globl vector65
vector65:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $65
80106522:	6a 41                	push   $0x41
  jmp alltraps
80106524:	e9 d1 f8 ff ff       	jmp    80105dfa <alltraps>

80106529 <vector66>:
.globl vector66
vector66:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $66
8010652b:	6a 42                	push   $0x42
  jmp alltraps
8010652d:	e9 c8 f8 ff ff       	jmp    80105dfa <alltraps>

80106532 <vector67>:
.globl vector67
vector67:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $67
80106534:	6a 43                	push   $0x43
  jmp alltraps
80106536:	e9 bf f8 ff ff       	jmp    80105dfa <alltraps>

8010653b <vector68>:
.globl vector68
vector68:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $68
8010653d:	6a 44                	push   $0x44
  jmp alltraps
8010653f:	e9 b6 f8 ff ff       	jmp    80105dfa <alltraps>

80106544 <vector69>:
.globl vector69
vector69:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $69
80106546:	6a 45                	push   $0x45
  jmp alltraps
80106548:	e9 ad f8 ff ff       	jmp    80105dfa <alltraps>

8010654d <vector70>:
.globl vector70
vector70:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $70
8010654f:	6a 46                	push   $0x46
  jmp alltraps
80106551:	e9 a4 f8 ff ff       	jmp    80105dfa <alltraps>

80106556 <vector71>:
.globl vector71
vector71:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $71
80106558:	6a 47                	push   $0x47
  jmp alltraps
8010655a:	e9 9b f8 ff ff       	jmp    80105dfa <alltraps>

8010655f <vector72>:
.globl vector72
vector72:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $72
80106561:	6a 48                	push   $0x48
  jmp alltraps
80106563:	e9 92 f8 ff ff       	jmp    80105dfa <alltraps>

80106568 <vector73>:
.globl vector73
vector73:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $73
8010656a:	6a 49                	push   $0x49
  jmp alltraps
8010656c:	e9 89 f8 ff ff       	jmp    80105dfa <alltraps>

80106571 <vector74>:
.globl vector74
vector74:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $74
80106573:	6a 4a                	push   $0x4a
  jmp alltraps
80106575:	e9 80 f8 ff ff       	jmp    80105dfa <alltraps>

8010657a <vector75>:
.globl vector75
vector75:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $75
8010657c:	6a 4b                	push   $0x4b
  jmp alltraps
8010657e:	e9 77 f8 ff ff       	jmp    80105dfa <alltraps>

80106583 <vector76>:
.globl vector76
vector76:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $76
80106585:	6a 4c                	push   $0x4c
  jmp alltraps
80106587:	e9 6e f8 ff ff       	jmp    80105dfa <alltraps>

8010658c <vector77>:
.globl vector77
vector77:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $77
8010658e:	6a 4d                	push   $0x4d
  jmp alltraps
80106590:	e9 65 f8 ff ff       	jmp    80105dfa <alltraps>

80106595 <vector78>:
.globl vector78
vector78:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $78
80106597:	6a 4e                	push   $0x4e
  jmp alltraps
80106599:	e9 5c f8 ff ff       	jmp    80105dfa <alltraps>

8010659e <vector79>:
.globl vector79
vector79:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $79
801065a0:	6a 4f                	push   $0x4f
  jmp alltraps
801065a2:	e9 53 f8 ff ff       	jmp    80105dfa <alltraps>

801065a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $80
801065a9:	6a 50                	push   $0x50
  jmp alltraps
801065ab:	e9 4a f8 ff ff       	jmp    80105dfa <alltraps>

801065b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $81
801065b2:	6a 51                	push   $0x51
  jmp alltraps
801065b4:	e9 41 f8 ff ff       	jmp    80105dfa <alltraps>

801065b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $82
801065bb:	6a 52                	push   $0x52
  jmp alltraps
801065bd:	e9 38 f8 ff ff       	jmp    80105dfa <alltraps>

801065c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $83
801065c4:	6a 53                	push   $0x53
  jmp alltraps
801065c6:	e9 2f f8 ff ff       	jmp    80105dfa <alltraps>

801065cb <vector84>:
.globl vector84
vector84:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $84
801065cd:	6a 54                	push   $0x54
  jmp alltraps
801065cf:	e9 26 f8 ff ff       	jmp    80105dfa <alltraps>

801065d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $85
801065d6:	6a 55                	push   $0x55
  jmp alltraps
801065d8:	e9 1d f8 ff ff       	jmp    80105dfa <alltraps>

801065dd <vector86>:
.globl vector86
vector86:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $86
801065df:	6a 56                	push   $0x56
  jmp alltraps
801065e1:	e9 14 f8 ff ff       	jmp    80105dfa <alltraps>

801065e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $87
801065e8:	6a 57                	push   $0x57
  jmp alltraps
801065ea:	e9 0b f8 ff ff       	jmp    80105dfa <alltraps>

801065ef <vector88>:
.globl vector88
vector88:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $88
801065f1:	6a 58                	push   $0x58
  jmp alltraps
801065f3:	e9 02 f8 ff ff       	jmp    80105dfa <alltraps>

801065f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $89
801065fa:	6a 59                	push   $0x59
  jmp alltraps
801065fc:	e9 f9 f7 ff ff       	jmp    80105dfa <alltraps>

80106601 <vector90>:
.globl vector90
vector90:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $90
80106603:	6a 5a                	push   $0x5a
  jmp alltraps
80106605:	e9 f0 f7 ff ff       	jmp    80105dfa <alltraps>

8010660a <vector91>:
.globl vector91
vector91:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $91
8010660c:	6a 5b                	push   $0x5b
  jmp alltraps
8010660e:	e9 e7 f7 ff ff       	jmp    80105dfa <alltraps>

80106613 <vector92>:
.globl vector92
vector92:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $92
80106615:	6a 5c                	push   $0x5c
  jmp alltraps
80106617:	e9 de f7 ff ff       	jmp    80105dfa <alltraps>

8010661c <vector93>:
.globl vector93
vector93:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $93
8010661e:	6a 5d                	push   $0x5d
  jmp alltraps
80106620:	e9 d5 f7 ff ff       	jmp    80105dfa <alltraps>

80106625 <vector94>:
.globl vector94
vector94:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $94
80106627:	6a 5e                	push   $0x5e
  jmp alltraps
80106629:	e9 cc f7 ff ff       	jmp    80105dfa <alltraps>

8010662e <vector95>:
.globl vector95
vector95:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $95
80106630:	6a 5f                	push   $0x5f
  jmp alltraps
80106632:	e9 c3 f7 ff ff       	jmp    80105dfa <alltraps>

80106637 <vector96>:
.globl vector96
vector96:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $96
80106639:	6a 60                	push   $0x60
  jmp alltraps
8010663b:	e9 ba f7 ff ff       	jmp    80105dfa <alltraps>

80106640 <vector97>:
.globl vector97
vector97:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $97
80106642:	6a 61                	push   $0x61
  jmp alltraps
80106644:	e9 b1 f7 ff ff       	jmp    80105dfa <alltraps>

80106649 <vector98>:
.globl vector98
vector98:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $98
8010664b:	6a 62                	push   $0x62
  jmp alltraps
8010664d:	e9 a8 f7 ff ff       	jmp    80105dfa <alltraps>

80106652 <vector99>:
.globl vector99
vector99:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $99
80106654:	6a 63                	push   $0x63
  jmp alltraps
80106656:	e9 9f f7 ff ff       	jmp    80105dfa <alltraps>

8010665b <vector100>:
.globl vector100
vector100:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $100
8010665d:	6a 64                	push   $0x64
  jmp alltraps
8010665f:	e9 96 f7 ff ff       	jmp    80105dfa <alltraps>

80106664 <vector101>:
.globl vector101
vector101:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $101
80106666:	6a 65                	push   $0x65
  jmp alltraps
80106668:	e9 8d f7 ff ff       	jmp    80105dfa <alltraps>

8010666d <vector102>:
.globl vector102
vector102:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $102
8010666f:	6a 66                	push   $0x66
  jmp alltraps
80106671:	e9 84 f7 ff ff       	jmp    80105dfa <alltraps>

80106676 <vector103>:
.globl vector103
vector103:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $103
80106678:	6a 67                	push   $0x67
  jmp alltraps
8010667a:	e9 7b f7 ff ff       	jmp    80105dfa <alltraps>

8010667f <vector104>:
.globl vector104
vector104:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $104
80106681:	6a 68                	push   $0x68
  jmp alltraps
80106683:	e9 72 f7 ff ff       	jmp    80105dfa <alltraps>

80106688 <vector105>:
.globl vector105
vector105:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $105
8010668a:	6a 69                	push   $0x69
  jmp alltraps
8010668c:	e9 69 f7 ff ff       	jmp    80105dfa <alltraps>

80106691 <vector106>:
.globl vector106
vector106:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $106
80106693:	6a 6a                	push   $0x6a
  jmp alltraps
80106695:	e9 60 f7 ff ff       	jmp    80105dfa <alltraps>

8010669a <vector107>:
.globl vector107
vector107:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $107
8010669c:	6a 6b                	push   $0x6b
  jmp alltraps
8010669e:	e9 57 f7 ff ff       	jmp    80105dfa <alltraps>

801066a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $108
801066a5:	6a 6c                	push   $0x6c
  jmp alltraps
801066a7:	e9 4e f7 ff ff       	jmp    80105dfa <alltraps>

801066ac <vector109>:
.globl vector109
vector109:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $109
801066ae:	6a 6d                	push   $0x6d
  jmp alltraps
801066b0:	e9 45 f7 ff ff       	jmp    80105dfa <alltraps>

801066b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $110
801066b7:	6a 6e                	push   $0x6e
  jmp alltraps
801066b9:	e9 3c f7 ff ff       	jmp    80105dfa <alltraps>

801066be <vector111>:
.globl vector111
vector111:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $111
801066c0:	6a 6f                	push   $0x6f
  jmp alltraps
801066c2:	e9 33 f7 ff ff       	jmp    80105dfa <alltraps>

801066c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $112
801066c9:	6a 70                	push   $0x70
  jmp alltraps
801066cb:	e9 2a f7 ff ff       	jmp    80105dfa <alltraps>

801066d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $113
801066d2:	6a 71                	push   $0x71
  jmp alltraps
801066d4:	e9 21 f7 ff ff       	jmp    80105dfa <alltraps>

801066d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $114
801066db:	6a 72                	push   $0x72
  jmp alltraps
801066dd:	e9 18 f7 ff ff       	jmp    80105dfa <alltraps>

801066e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $115
801066e4:	6a 73                	push   $0x73
  jmp alltraps
801066e6:	e9 0f f7 ff ff       	jmp    80105dfa <alltraps>

801066eb <vector116>:
.globl vector116
vector116:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $116
801066ed:	6a 74                	push   $0x74
  jmp alltraps
801066ef:	e9 06 f7 ff ff       	jmp    80105dfa <alltraps>

801066f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $117
801066f6:	6a 75                	push   $0x75
  jmp alltraps
801066f8:	e9 fd f6 ff ff       	jmp    80105dfa <alltraps>

801066fd <vector118>:
.globl vector118
vector118:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $118
801066ff:	6a 76                	push   $0x76
  jmp alltraps
80106701:	e9 f4 f6 ff ff       	jmp    80105dfa <alltraps>

80106706 <vector119>:
.globl vector119
vector119:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $119
80106708:	6a 77                	push   $0x77
  jmp alltraps
8010670a:	e9 eb f6 ff ff       	jmp    80105dfa <alltraps>

8010670f <vector120>:
.globl vector120
vector120:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $120
80106711:	6a 78                	push   $0x78
  jmp alltraps
80106713:	e9 e2 f6 ff ff       	jmp    80105dfa <alltraps>

80106718 <vector121>:
.globl vector121
vector121:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $121
8010671a:	6a 79                	push   $0x79
  jmp alltraps
8010671c:	e9 d9 f6 ff ff       	jmp    80105dfa <alltraps>

80106721 <vector122>:
.globl vector122
vector122:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $122
80106723:	6a 7a                	push   $0x7a
  jmp alltraps
80106725:	e9 d0 f6 ff ff       	jmp    80105dfa <alltraps>

8010672a <vector123>:
.globl vector123
vector123:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $123
8010672c:	6a 7b                	push   $0x7b
  jmp alltraps
8010672e:	e9 c7 f6 ff ff       	jmp    80105dfa <alltraps>

80106733 <vector124>:
.globl vector124
vector124:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $124
80106735:	6a 7c                	push   $0x7c
  jmp alltraps
80106737:	e9 be f6 ff ff       	jmp    80105dfa <alltraps>

8010673c <vector125>:
.globl vector125
vector125:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $125
8010673e:	6a 7d                	push   $0x7d
  jmp alltraps
80106740:	e9 b5 f6 ff ff       	jmp    80105dfa <alltraps>

80106745 <vector126>:
.globl vector126
vector126:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $126
80106747:	6a 7e                	push   $0x7e
  jmp alltraps
80106749:	e9 ac f6 ff ff       	jmp    80105dfa <alltraps>

8010674e <vector127>:
.globl vector127
vector127:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $127
80106750:	6a 7f                	push   $0x7f
  jmp alltraps
80106752:	e9 a3 f6 ff ff       	jmp    80105dfa <alltraps>

80106757 <vector128>:
.globl vector128
vector128:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $128
80106759:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010675e:	e9 97 f6 ff ff       	jmp    80105dfa <alltraps>

80106763 <vector129>:
.globl vector129
vector129:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $129
80106765:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010676a:	e9 8b f6 ff ff       	jmp    80105dfa <alltraps>

8010676f <vector130>:
.globl vector130
vector130:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $130
80106771:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106776:	e9 7f f6 ff ff       	jmp    80105dfa <alltraps>

8010677b <vector131>:
.globl vector131
vector131:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $131
8010677d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106782:	e9 73 f6 ff ff       	jmp    80105dfa <alltraps>

80106787 <vector132>:
.globl vector132
vector132:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $132
80106789:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010678e:	e9 67 f6 ff ff       	jmp    80105dfa <alltraps>

80106793 <vector133>:
.globl vector133
vector133:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $133
80106795:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010679a:	e9 5b f6 ff ff       	jmp    80105dfa <alltraps>

8010679f <vector134>:
.globl vector134
vector134:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $134
801067a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067a6:	e9 4f f6 ff ff       	jmp    80105dfa <alltraps>

801067ab <vector135>:
.globl vector135
vector135:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $135
801067ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801067b2:	e9 43 f6 ff ff       	jmp    80105dfa <alltraps>

801067b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $136
801067b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801067be:	e9 37 f6 ff ff       	jmp    80105dfa <alltraps>

801067c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $137
801067c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801067ca:	e9 2b f6 ff ff       	jmp    80105dfa <alltraps>

801067cf <vector138>:
.globl vector138
vector138:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $138
801067d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801067d6:	e9 1f f6 ff ff       	jmp    80105dfa <alltraps>

801067db <vector139>:
.globl vector139
vector139:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $139
801067dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067e2:	e9 13 f6 ff ff       	jmp    80105dfa <alltraps>

801067e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $140
801067e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ee:	e9 07 f6 ff ff       	jmp    80105dfa <alltraps>

801067f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $141
801067f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067fa:	e9 fb f5 ff ff       	jmp    80105dfa <alltraps>

801067ff <vector142>:
.globl vector142
vector142:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $142
80106801:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106806:	e9 ef f5 ff ff       	jmp    80105dfa <alltraps>

8010680b <vector143>:
.globl vector143
vector143:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $143
8010680d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106812:	e9 e3 f5 ff ff       	jmp    80105dfa <alltraps>

80106817 <vector144>:
.globl vector144
vector144:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $144
80106819:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010681e:	e9 d7 f5 ff ff       	jmp    80105dfa <alltraps>

80106823 <vector145>:
.globl vector145
vector145:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $145
80106825:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010682a:	e9 cb f5 ff ff       	jmp    80105dfa <alltraps>

8010682f <vector146>:
.globl vector146
vector146:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $146
80106831:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106836:	e9 bf f5 ff ff       	jmp    80105dfa <alltraps>

8010683b <vector147>:
.globl vector147
vector147:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $147
8010683d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106842:	e9 b3 f5 ff ff       	jmp    80105dfa <alltraps>

80106847 <vector148>:
.globl vector148
vector148:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $148
80106849:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010684e:	e9 a7 f5 ff ff       	jmp    80105dfa <alltraps>

80106853 <vector149>:
.globl vector149
vector149:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $149
80106855:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010685a:	e9 9b f5 ff ff       	jmp    80105dfa <alltraps>

8010685f <vector150>:
.globl vector150
vector150:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $150
80106861:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106866:	e9 8f f5 ff ff       	jmp    80105dfa <alltraps>

8010686b <vector151>:
.globl vector151
vector151:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $151
8010686d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106872:	e9 83 f5 ff ff       	jmp    80105dfa <alltraps>

80106877 <vector152>:
.globl vector152
vector152:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $152
80106879:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010687e:	e9 77 f5 ff ff       	jmp    80105dfa <alltraps>

80106883 <vector153>:
.globl vector153
vector153:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $153
80106885:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010688a:	e9 6b f5 ff ff       	jmp    80105dfa <alltraps>

8010688f <vector154>:
.globl vector154
vector154:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $154
80106891:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106896:	e9 5f f5 ff ff       	jmp    80105dfa <alltraps>

8010689b <vector155>:
.globl vector155
vector155:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $155
8010689d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068a2:	e9 53 f5 ff ff       	jmp    80105dfa <alltraps>

801068a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $156
801068a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801068ae:	e9 47 f5 ff ff       	jmp    80105dfa <alltraps>

801068b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $157
801068b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801068ba:	e9 3b f5 ff ff       	jmp    80105dfa <alltraps>

801068bf <vector158>:
.globl vector158
vector158:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $158
801068c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801068c6:	e9 2f f5 ff ff       	jmp    80105dfa <alltraps>

801068cb <vector159>:
.globl vector159
vector159:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $159
801068cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801068d2:	e9 23 f5 ff ff       	jmp    80105dfa <alltraps>

801068d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $160
801068d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801068de:	e9 17 f5 ff ff       	jmp    80105dfa <alltraps>

801068e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $161
801068e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068ea:	e9 0b f5 ff ff       	jmp    80105dfa <alltraps>

801068ef <vector162>:
.globl vector162
vector162:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $162
801068f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068f6:	e9 ff f4 ff ff       	jmp    80105dfa <alltraps>

801068fb <vector163>:
.globl vector163
vector163:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $163
801068fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106902:	e9 f3 f4 ff ff       	jmp    80105dfa <alltraps>

80106907 <vector164>:
.globl vector164
vector164:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $164
80106909:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010690e:	e9 e7 f4 ff ff       	jmp    80105dfa <alltraps>

80106913 <vector165>:
.globl vector165
vector165:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $165
80106915:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010691a:	e9 db f4 ff ff       	jmp    80105dfa <alltraps>

8010691f <vector166>:
.globl vector166
vector166:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $166
80106921:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106926:	e9 cf f4 ff ff       	jmp    80105dfa <alltraps>

8010692b <vector167>:
.globl vector167
vector167:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $167
8010692d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106932:	e9 c3 f4 ff ff       	jmp    80105dfa <alltraps>

80106937 <vector168>:
.globl vector168
vector168:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $168
80106939:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010693e:	e9 b7 f4 ff ff       	jmp    80105dfa <alltraps>

80106943 <vector169>:
.globl vector169
vector169:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $169
80106945:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010694a:	e9 ab f4 ff ff       	jmp    80105dfa <alltraps>

8010694f <vector170>:
.globl vector170
vector170:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $170
80106951:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106956:	e9 9f f4 ff ff       	jmp    80105dfa <alltraps>

8010695b <vector171>:
.globl vector171
vector171:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $171
8010695d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106962:	e9 93 f4 ff ff       	jmp    80105dfa <alltraps>

80106967 <vector172>:
.globl vector172
vector172:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $172
80106969:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010696e:	e9 87 f4 ff ff       	jmp    80105dfa <alltraps>

80106973 <vector173>:
.globl vector173
vector173:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $173
80106975:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010697a:	e9 7b f4 ff ff       	jmp    80105dfa <alltraps>

8010697f <vector174>:
.globl vector174
vector174:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $174
80106981:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106986:	e9 6f f4 ff ff       	jmp    80105dfa <alltraps>

8010698b <vector175>:
.globl vector175
vector175:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $175
8010698d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106992:	e9 63 f4 ff ff       	jmp    80105dfa <alltraps>

80106997 <vector176>:
.globl vector176
vector176:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $176
80106999:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010699e:	e9 57 f4 ff ff       	jmp    80105dfa <alltraps>

801069a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $177
801069a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069aa:	e9 4b f4 ff ff       	jmp    80105dfa <alltraps>

801069af <vector178>:
.globl vector178
vector178:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $178
801069b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801069b6:	e9 3f f4 ff ff       	jmp    80105dfa <alltraps>

801069bb <vector179>:
.globl vector179
vector179:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $179
801069bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801069c2:	e9 33 f4 ff ff       	jmp    80105dfa <alltraps>

801069c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $180
801069c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801069ce:	e9 27 f4 ff ff       	jmp    80105dfa <alltraps>

801069d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $181
801069d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801069da:	e9 1b f4 ff ff       	jmp    80105dfa <alltraps>

801069df <vector182>:
.globl vector182
vector182:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $182
801069e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069e6:	e9 0f f4 ff ff       	jmp    80105dfa <alltraps>

801069eb <vector183>:
.globl vector183
vector183:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $183
801069ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069f2:	e9 03 f4 ff ff       	jmp    80105dfa <alltraps>

801069f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $184
801069f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069fe:	e9 f7 f3 ff ff       	jmp    80105dfa <alltraps>

80106a03 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $185
80106a05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a0a:	e9 eb f3 ff ff       	jmp    80105dfa <alltraps>

80106a0f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $186
80106a11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a16:	e9 df f3 ff ff       	jmp    80105dfa <alltraps>

80106a1b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $187
80106a1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a22:	e9 d3 f3 ff ff       	jmp    80105dfa <alltraps>

80106a27 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $188
80106a29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a2e:	e9 c7 f3 ff ff       	jmp    80105dfa <alltraps>

80106a33 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $189
80106a35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a3a:	e9 bb f3 ff ff       	jmp    80105dfa <alltraps>

80106a3f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $190
80106a41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a46:	e9 af f3 ff ff       	jmp    80105dfa <alltraps>

80106a4b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $191
80106a4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a52:	e9 a3 f3 ff ff       	jmp    80105dfa <alltraps>

80106a57 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $192
80106a59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a5e:	e9 97 f3 ff ff       	jmp    80105dfa <alltraps>

80106a63 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $193
80106a65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a6a:	e9 8b f3 ff ff       	jmp    80105dfa <alltraps>

80106a6f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $194
80106a71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a76:	e9 7f f3 ff ff       	jmp    80105dfa <alltraps>

80106a7b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $195
80106a7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a82:	e9 73 f3 ff ff       	jmp    80105dfa <alltraps>

80106a87 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $196
80106a89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a8e:	e9 67 f3 ff ff       	jmp    80105dfa <alltraps>

80106a93 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $197
80106a95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a9a:	e9 5b f3 ff ff       	jmp    80105dfa <alltraps>

80106a9f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $198
80106aa1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106aa6:	e9 4f f3 ff ff       	jmp    80105dfa <alltraps>

80106aab <vector199>:
.globl vector199
vector199:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $199
80106aad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ab2:	e9 43 f3 ff ff       	jmp    80105dfa <alltraps>

80106ab7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $200
80106ab9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106abe:	e9 37 f3 ff ff       	jmp    80105dfa <alltraps>

80106ac3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $201
80106ac5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106aca:	e9 2b f3 ff ff       	jmp    80105dfa <alltraps>

80106acf <vector202>:
.globl vector202
vector202:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $202
80106ad1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ad6:	e9 1f f3 ff ff       	jmp    80105dfa <alltraps>

80106adb <vector203>:
.globl vector203
vector203:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $203
80106add:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ae2:	e9 13 f3 ff ff       	jmp    80105dfa <alltraps>

80106ae7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $204
80106ae9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106aee:	e9 07 f3 ff ff       	jmp    80105dfa <alltraps>

80106af3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $205
80106af5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106afa:	e9 fb f2 ff ff       	jmp    80105dfa <alltraps>

80106aff <vector206>:
.globl vector206
vector206:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $206
80106b01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b06:	e9 ef f2 ff ff       	jmp    80105dfa <alltraps>

80106b0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $207
80106b0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b12:	e9 e3 f2 ff ff       	jmp    80105dfa <alltraps>

80106b17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $208
80106b19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b1e:	e9 d7 f2 ff ff       	jmp    80105dfa <alltraps>

80106b23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $209
80106b25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b2a:	e9 cb f2 ff ff       	jmp    80105dfa <alltraps>

80106b2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $210
80106b31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b36:	e9 bf f2 ff ff       	jmp    80105dfa <alltraps>

80106b3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $211
80106b3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b42:	e9 b3 f2 ff ff       	jmp    80105dfa <alltraps>

80106b47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $212
80106b49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b4e:	e9 a7 f2 ff ff       	jmp    80105dfa <alltraps>

80106b53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $213
80106b55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b5a:	e9 9b f2 ff ff       	jmp    80105dfa <alltraps>

80106b5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $214
80106b61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b66:	e9 8f f2 ff ff       	jmp    80105dfa <alltraps>

80106b6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $215
80106b6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b72:	e9 83 f2 ff ff       	jmp    80105dfa <alltraps>

80106b77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $216
80106b79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b7e:	e9 77 f2 ff ff       	jmp    80105dfa <alltraps>

80106b83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $217
80106b85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b8a:	e9 6b f2 ff ff       	jmp    80105dfa <alltraps>

80106b8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $218
80106b91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b96:	e9 5f f2 ff ff       	jmp    80105dfa <alltraps>

80106b9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $219
80106b9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ba2:	e9 53 f2 ff ff       	jmp    80105dfa <alltraps>

80106ba7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $220
80106ba9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106bae:	e9 47 f2 ff ff       	jmp    80105dfa <alltraps>

80106bb3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $221
80106bb5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106bba:	e9 3b f2 ff ff       	jmp    80105dfa <alltraps>

80106bbf <vector222>:
.globl vector222
vector222:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $222
80106bc1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106bc6:	e9 2f f2 ff ff       	jmp    80105dfa <alltraps>

80106bcb <vector223>:
.globl vector223
vector223:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $223
80106bcd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106bd2:	e9 23 f2 ff ff       	jmp    80105dfa <alltraps>

80106bd7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $224
80106bd9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106bde:	e9 17 f2 ff ff       	jmp    80105dfa <alltraps>

80106be3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $225
80106be5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106bea:	e9 0b f2 ff ff       	jmp    80105dfa <alltraps>

80106bef <vector226>:
.globl vector226
vector226:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $226
80106bf1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bf6:	e9 ff f1 ff ff       	jmp    80105dfa <alltraps>

80106bfb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $227
80106bfd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c02:	e9 f3 f1 ff ff       	jmp    80105dfa <alltraps>

80106c07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $228
80106c09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c0e:	e9 e7 f1 ff ff       	jmp    80105dfa <alltraps>

80106c13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $229
80106c15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c1a:	e9 db f1 ff ff       	jmp    80105dfa <alltraps>

80106c1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $230
80106c21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c26:	e9 cf f1 ff ff       	jmp    80105dfa <alltraps>

80106c2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $231
80106c2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c32:	e9 c3 f1 ff ff       	jmp    80105dfa <alltraps>

80106c37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $232
80106c39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c3e:	e9 b7 f1 ff ff       	jmp    80105dfa <alltraps>

80106c43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $233
80106c45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c4a:	e9 ab f1 ff ff       	jmp    80105dfa <alltraps>

80106c4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $234
80106c51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c56:	e9 9f f1 ff ff       	jmp    80105dfa <alltraps>

80106c5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $235
80106c5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c62:	e9 93 f1 ff ff       	jmp    80105dfa <alltraps>

80106c67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $236
80106c69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c6e:	e9 87 f1 ff ff       	jmp    80105dfa <alltraps>

80106c73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $237
80106c75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c7a:	e9 7b f1 ff ff       	jmp    80105dfa <alltraps>

80106c7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $238
80106c81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c86:	e9 6f f1 ff ff       	jmp    80105dfa <alltraps>

80106c8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $239
80106c8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c92:	e9 63 f1 ff ff       	jmp    80105dfa <alltraps>

80106c97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $240
80106c99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c9e:	e9 57 f1 ff ff       	jmp    80105dfa <alltraps>

80106ca3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $241
80106ca5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106caa:	e9 4b f1 ff ff       	jmp    80105dfa <alltraps>

80106caf <vector242>:
.globl vector242
vector242:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $242
80106cb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106cb6:	e9 3f f1 ff ff       	jmp    80105dfa <alltraps>

80106cbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $243
80106cbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106cc2:	e9 33 f1 ff ff       	jmp    80105dfa <alltraps>

80106cc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $244
80106cc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106cce:	e9 27 f1 ff ff       	jmp    80105dfa <alltraps>

80106cd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $245
80106cd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106cda:	e9 1b f1 ff ff       	jmp    80105dfa <alltraps>

80106cdf <vector246>:
.globl vector246
vector246:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $246
80106ce1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ce6:	e9 0f f1 ff ff       	jmp    80105dfa <alltraps>

80106ceb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $247
80106ced:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cf2:	e9 03 f1 ff ff       	jmp    80105dfa <alltraps>

80106cf7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $248
80106cf9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cfe:	e9 f7 f0 ff ff       	jmp    80105dfa <alltraps>

80106d03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $249
80106d05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d0a:	e9 eb f0 ff ff       	jmp    80105dfa <alltraps>

80106d0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $250
80106d11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d16:	e9 df f0 ff ff       	jmp    80105dfa <alltraps>

80106d1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $251
80106d1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d22:	e9 d3 f0 ff ff       	jmp    80105dfa <alltraps>

80106d27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $252
80106d29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d2e:	e9 c7 f0 ff ff       	jmp    80105dfa <alltraps>

80106d33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $253
80106d35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d3a:	e9 bb f0 ff ff       	jmp    80105dfa <alltraps>

80106d3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $254
80106d41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d46:	e9 af f0 ff ff       	jmp    80105dfa <alltraps>

80106d4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $255
80106d4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d52:	e9 a3 f0 ff ff       	jmp    80105dfa <alltraps>
80106d57:	66 90                	xchg   %ax,%ax
80106d59:	66 90                	xchg   %ax,%ax
80106d5b:	66 90                	xchg   %ax,%ax
80106d5d:	66 90                	xchg   %ax,%ax
80106d5f:	90                   	nop

80106d60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d72:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106d75:	39 d3                	cmp    %edx,%ebx
80106d77:	73 56                	jae    80106dcf <deallocuvm.part.0+0x6f>
80106d79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106d7c:	89 c6                	mov    %eax,%esi
80106d7e:	89 d7                	mov    %edx,%edi
80106d80:	eb 12                	jmp    80106d94 <deallocuvm.part.0+0x34>
80106d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d88:	83 c2 01             	add    $0x1,%edx
80106d8b:	89 d3                	mov    %edx,%ebx
80106d8d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d90:	39 fb                	cmp    %edi,%ebx
80106d92:	73 38                	jae    80106dcc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106d94:	89 da                	mov    %ebx,%edx
80106d96:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d99:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106d9c:	a8 01                	test   $0x1,%al
80106d9e:	74 e8                	je     80106d88 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106da0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106da7:	c1 e9 0a             	shr    $0xa,%ecx
80106daa:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106db0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106db7:	85 c0                	test   %eax,%eax
80106db9:	74 cd                	je     80106d88 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106dbb:	8b 10                	mov    (%eax),%edx
80106dbd:	f6 c2 01             	test   $0x1,%dl
80106dc0:	75 1e                	jne    80106de0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106dc2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dc8:	39 fb                	cmp    %edi,%ebx
80106dca:	72 c8                	jb     80106d94 <deallocuvm.part.0+0x34>
80106dcc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd2:	89 c8                	mov    %ecx,%eax
80106dd4:	5b                   	pop    %ebx
80106dd5:	5e                   	pop    %esi
80106dd6:	5f                   	pop    %edi
80106dd7:	5d                   	pop    %ebp
80106dd8:	c3                   	ret
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106de0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106de6:	74 26                	je     80106e0e <deallocuvm.part.0+0xae>
      kfree(v);
80106de8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106deb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106df4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106dfa:	52                   	push   %edx
80106dfb:	e8 60 bc ff ff       	call   80102a60 <kfree>
      *pte = 0;
80106e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106e03:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106e0c:	eb 82                	jmp    80106d90 <deallocuvm.part.0+0x30>
        panic("kfree");
80106e0e:	83 ec 0c             	sub    $0xc,%esp
80106e11:	68 ec 78 10 80       	push   $0x801078ec
80106e16:	e8 65 95 ff ff       	call   80100380 <panic>
80106e1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106e20 <mappages>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106e26:	89 d3                	mov    %edx,%ebx
80106e28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e2e:	83 ec 1c             	sub    $0x1c,%esp
80106e31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e40:	8b 45 08             	mov    0x8(%ebp),%eax
80106e43:	29 d8                	sub    %ebx,%eax
80106e45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e48:	eb 3f                	jmp    80106e89 <mappages+0x69>
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e50:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e57:	c1 ea 0a             	shr    $0xa,%edx
80106e5a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e60:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e67:	85 c0                	test   %eax,%eax
80106e69:	74 75                	je     80106ee0 <mappages+0xc0>
    if(*pte & PTE_P)
80106e6b:	f6 00 01             	testb  $0x1,(%eax)
80106e6e:	0f 85 86 00 00 00    	jne    80106efa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106e74:	0b 75 0c             	or     0xc(%ebp),%esi
80106e77:	83 ce 01             	or     $0x1,%esi
80106e7a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e7f:	39 c3                	cmp    %eax,%ebx
80106e81:	74 6d                	je     80106ef0 <mappages+0xd0>
    a += PGSIZE;
80106e83:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e8c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106e8f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106e92:	89 d8                	mov    %ebx,%eax
80106e94:	c1 e8 16             	shr    $0x16,%eax
80106e97:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e9a:	8b 07                	mov    (%edi),%eax
80106e9c:	a8 01                	test   $0x1,%al
80106e9e:	75 b0                	jne    80106e50 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ea0:	e8 7b bd ff ff       	call   80102c20 <kalloc>
80106ea5:	85 c0                	test   %eax,%eax
80106ea7:	74 37                	je     80106ee0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ea9:	83 ec 04             	sub    $0x4,%esp
80106eac:	68 00 10 00 00       	push   $0x1000
80106eb1:	6a 00                	push   $0x0
80106eb3:	50                   	push   %eax
80106eb4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106eb7:	e8 a4 dd ff ff       	call   80104c60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ebc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ebf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ec2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ec8:	83 c8 07             	or     $0x7,%eax
80106ecb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ecd:	89 d8                	mov    %ebx,%eax
80106ecf:	c1 e8 0a             	shr    $0xa,%eax
80106ed2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ed7:	01 d0                	add    %edx,%eax
80106ed9:	eb 90                	jmp    80106e6b <mappages+0x4b>
80106edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ee8:	5b                   	pop    %ebx
80106ee9:	5e                   	pop    %esi
80106eea:	5f                   	pop    %edi
80106eeb:	5d                   	pop    %ebp
80106eec:	c3                   	ret
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret
      panic("remap");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 20 7b 10 80       	push   $0x80107b20
80106f02:	e8 79 94 ff ff       	call   80100380 <panic>
80106f07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f0e:	00 
80106f0f:	90                   	nop

80106f10 <seginit>:
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f16:	e8 e5 cf ff ff       	call   80103f00 <cpuid>
  pd[0] = size-1;
80106f1b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f20:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f26:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106f2a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106f31:	ff 00 00 
80106f34:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106f3b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f3e:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106f45:	ff 00 00 
80106f48:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106f4f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f52:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106f59:	ff 00 00 
80106f5c:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106f63:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f66:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106f6d:	ff 00 00 
80106f70:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106f77:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f7a:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
80106f7f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f83:	c1 e8 10             	shr    $0x10,%eax
80106f86:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f8a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f8d:	0f 01 10             	lgdtl  (%eax)
}
80106f90:	c9                   	leave
80106f91:	c3                   	ret
80106f92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f99:	00 
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fa0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fa0:	a1 e4 54 11 80       	mov    0x801154e4,%eax
80106fa5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106faa:	0f 22 d8             	mov    %eax,%cr3
}
80106fad:	c3                   	ret
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <switchuvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106fbc:	85 f6                	test   %esi,%esi
80106fbe:	0f 84 cb 00 00 00    	je     8010708f <switchuvm+0xdf>
  if(p->kstack == 0)
80106fc4:	8b 46 08             	mov    0x8(%esi),%eax
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	0f 84 da 00 00 00    	je     801070a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106fcf:	8b 46 04             	mov    0x4(%esi),%eax
80106fd2:	85 c0                	test   %eax,%eax
80106fd4:	0f 84 c2 00 00 00    	je     8010709c <switchuvm+0xec>
  pushcli();
80106fda:	e8 31 da ff ff       	call   80104a10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fdf:	e8 bc ce ff ff       	call   80103ea0 <mycpu>
80106fe4:	89 c3                	mov    %eax,%ebx
80106fe6:	e8 b5 ce ff ff       	call   80103ea0 <mycpu>
80106feb:	89 c7                	mov    %eax,%edi
80106fed:	e8 ae ce ff ff       	call   80103ea0 <mycpu>
80106ff2:	83 c7 08             	add    $0x8,%edi
80106ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ff8:	e8 a3 ce ff ff       	call   80103ea0 <mycpu>
80106ffd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107000:	ba 67 00 00 00       	mov    $0x67,%edx
80107005:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010700c:	83 c0 08             	add    $0x8,%eax
8010700f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107016:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010701b:	83 c1 08             	add    $0x8,%ecx
8010701e:	c1 e8 18             	shr    $0x18,%eax
80107021:	c1 e9 10             	shr    $0x10,%ecx
80107024:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010702a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107030:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107035:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010703c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107041:	e8 5a ce ff ff       	call   80103ea0 <mycpu>
80107046:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010704d:	e8 4e ce ff ff       	call   80103ea0 <mycpu>
80107052:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107056:	8b 5e 08             	mov    0x8(%esi),%ebx
80107059:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010705f:	e8 3c ce ff ff       	call   80103ea0 <mycpu>
80107064:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107067:	e8 34 ce ff ff       	call   80103ea0 <mycpu>
8010706c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107070:	b8 28 00 00 00       	mov    $0x28,%eax
80107075:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107078:	8b 46 04             	mov    0x4(%esi),%eax
8010707b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107080:	0f 22 d8             	mov    %eax,%cr3
}
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	5e                   	pop    %esi
80107088:	5f                   	pop    %edi
80107089:	5d                   	pop    %ebp
  popcli();
8010708a:	e9 d1 d9 ff ff       	jmp    80104a60 <popcli>
    panic("switchuvm: no process");
8010708f:	83 ec 0c             	sub    $0xc,%esp
80107092:	68 26 7b 10 80       	push   $0x80107b26
80107097:	e8 e4 92 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	68 51 7b 10 80       	push   $0x80107b51
801070a4:	e8 d7 92 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801070a9:	83 ec 0c             	sub    $0xc,%esp
801070ac:	68 3c 7b 10 80       	push   $0x80107b3c
801070b1:	e8 ca 92 ff ff       	call   80100380 <panic>
801070b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070bd:	00 
801070be:	66 90                	xchg   %ax,%ax

801070c0 <inituvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 45 08             	mov    0x8(%ebp),%eax
801070cc:	8b 75 10             	mov    0x10(%ebp),%esi
801070cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
801070d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070db:	77 49                	ja     80107126 <inituvm+0x66>
  mem = kalloc();
801070dd:	e8 3e bb ff ff       	call   80102c20 <kalloc>
  memset(mem, 0, PGSIZE);
801070e2:	83 ec 04             	sub    $0x4,%esp
801070e5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070ea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070ec:	6a 00                	push   $0x0
801070ee:	50                   	push   %eax
801070ef:	e8 6c db ff ff       	call   80104c60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070f4:	58                   	pop    %eax
801070f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070fb:	5a                   	pop    %edx
801070fc:	6a 06                	push   $0x6
801070fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107103:	31 d2                	xor    %edx,%edx
80107105:	50                   	push   %eax
80107106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107109:	e8 12 fd ff ff       	call   80106e20 <mappages>
  memmove(mem, init, sz);
8010710e:	83 c4 10             	add    $0x10,%esp
80107111:	89 75 10             	mov    %esi,0x10(%ebp)
80107114:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107117:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010711a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107121:	e9 ca db ff ff       	jmp    80104cf0 <memmove>
    panic("inituvm: more than a page");
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 65 7b 10 80       	push   $0x80107b65
8010712e:	e8 4d 92 ff ff       	call   80100380 <panic>
80107133:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010713a:	00 
8010713b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107140 <loaduvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107149:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010714c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010714f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107155:	0f 85 a2 00 00 00    	jne    801071fd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010715b:	85 ff                	test   %edi,%edi
8010715d:	74 7d                	je     801071dc <loaduvm+0x9c>
8010715f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107160:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107163:	8b 55 08             	mov    0x8(%ebp),%edx
80107166:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107168:	89 c1                	mov    %eax,%ecx
8010716a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010716d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107170:	f6 c1 01             	test   $0x1,%cl
80107173:	75 13                	jne    80107188 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107175:	83 ec 0c             	sub    $0xc,%esp
80107178:	68 7f 7b 10 80       	push   $0x80107b7f
8010717d:	e8 fe 91 ff ff       	call   80100380 <panic>
80107182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107188:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010718b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107191:	25 fc 0f 00 00       	and    $0xffc,%eax
80107196:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010719d:	85 c9                	test   %ecx,%ecx
8010719f:	74 d4                	je     80107175 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801071a1:	89 fb                	mov    %edi,%ebx
801071a3:	b8 00 10 00 00       	mov    $0x1000,%eax
801071a8:	29 f3                	sub    %esi,%ebx
801071aa:	39 c3                	cmp    %eax,%ebx
801071ac:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071af:	53                   	push   %ebx
801071b0:	8b 45 14             	mov    0x14(%ebp),%eax
801071b3:	01 f0                	add    %esi,%eax
801071b5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801071b6:	8b 01                	mov    (%ecx),%eax
801071b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071bd:	05 00 00 00 80       	add    $0x80000000,%eax
801071c2:	50                   	push   %eax
801071c3:	ff 75 10             	push   0x10(%ebp)
801071c6:	e8 a5 ae ff ff       	call   80102070 <readi>
801071cb:	83 c4 10             	add    $0x10,%esp
801071ce:	39 d8                	cmp    %ebx,%eax
801071d0:	75 1e                	jne    801071f0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801071d2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071d8:	39 fe                	cmp    %edi,%esi
801071da:	72 84                	jb     80107160 <loaduvm+0x20>
}
801071dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071df:	31 c0                	xor    %eax,%eax
}
801071e1:	5b                   	pop    %ebx
801071e2:	5e                   	pop    %esi
801071e3:	5f                   	pop    %edi
801071e4:	5d                   	pop    %ebp
801071e5:	c3                   	ret
801071e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ed:	00 
801071ee:	66 90                	xchg   %ax,%ax
801071f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f8:	5b                   	pop    %ebx
801071f9:	5e                   	pop    %esi
801071fa:	5f                   	pop    %edi
801071fb:	5d                   	pop    %ebp
801071fc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801071fd:	83 ec 0c             	sub    $0xc,%esp
80107200:	68 a0 7d 10 80       	push   $0x80107da0
80107205:	e8 76 91 ff ff       	call   80100380 <panic>
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <allocuvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
80107219:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010721c:	85 f6                	test   %esi,%esi
8010721e:	0f 88 98 00 00 00    	js     801072bc <allocuvm+0xac>
80107224:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107226:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107229:	0f 82 a1 00 00 00    	jb     801072d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010722f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107232:	05 ff 0f 00 00       	add    $0xfff,%eax
80107237:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010723c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010723e:	39 f0                	cmp    %esi,%eax
80107240:	0f 83 8d 00 00 00    	jae    801072d3 <allocuvm+0xc3>
80107246:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107249:	eb 44                	jmp    8010728f <allocuvm+0x7f>
8010724b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107250:	83 ec 04             	sub    $0x4,%esp
80107253:	68 00 10 00 00       	push   $0x1000
80107258:	6a 00                	push   $0x0
8010725a:	50                   	push   %eax
8010725b:	e8 00 da ff ff       	call   80104c60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107260:	58                   	pop    %eax
80107261:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107267:	5a                   	pop    %edx
80107268:	6a 06                	push   $0x6
8010726a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010726f:	89 fa                	mov    %edi,%edx
80107271:	50                   	push   %eax
80107272:	8b 45 08             	mov    0x8(%ebp),%eax
80107275:	e8 a6 fb ff ff       	call   80106e20 <mappages>
8010727a:	83 c4 10             	add    $0x10,%esp
8010727d:	85 c0                	test   %eax,%eax
8010727f:	78 5f                	js     801072e0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107281:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107287:	39 f7                	cmp    %esi,%edi
80107289:	0f 83 89 00 00 00    	jae    80107318 <allocuvm+0x108>
    mem = kalloc();
8010728f:	e8 8c b9 ff ff       	call   80102c20 <kalloc>
80107294:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107296:	85 c0                	test   %eax,%eax
80107298:	75 b6                	jne    80107250 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010729a:	83 ec 0c             	sub    $0xc,%esp
8010729d:	68 9d 7b 10 80       	push   $0x80107b9d
801072a2:	e8 f9 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801072a7:	83 c4 10             	add    $0x10,%esp
801072aa:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072ad:	74 0d                	je     801072bc <allocuvm+0xac>
801072af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072b2:	8b 45 08             	mov    0x8(%ebp),%eax
801072b5:	89 f2                	mov    %esi,%edx
801072b7:	e8 a4 fa ff ff       	call   80106d60 <deallocuvm.part.0>
    return 0;
801072bc:	31 d2                	xor    %edx,%edx
}
801072be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c1:	89 d0                	mov    %edx,%eax
801072c3:	5b                   	pop    %ebx
801072c4:	5e                   	pop    %esi
801072c5:	5f                   	pop    %edi
801072c6:	5d                   	pop    %ebp
801072c7:	c3                   	ret
801072c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072cf:	00 
    return oldsz;
801072d0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801072d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d6:	89 d0                	mov    %edx,%eax
801072d8:	5b                   	pop    %ebx
801072d9:	5e                   	pop    %esi
801072da:	5f                   	pop    %edi
801072db:	5d                   	pop    %ebp
801072dc:	c3                   	ret
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072e0:	83 ec 0c             	sub    $0xc,%esp
801072e3:	68 b5 7b 10 80       	push   $0x80107bb5
801072e8:	e8 b3 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801072ed:	83 c4 10             	add    $0x10,%esp
801072f0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072f3:	74 0d                	je     80107302 <allocuvm+0xf2>
801072f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072f8:	8b 45 08             	mov    0x8(%ebp),%eax
801072fb:	89 f2                	mov    %esi,%edx
801072fd:	e8 5e fa ff ff       	call   80106d60 <deallocuvm.part.0>
      kfree(mem);
80107302:	83 ec 0c             	sub    $0xc,%esp
80107305:	53                   	push   %ebx
80107306:	e8 55 b7 ff ff       	call   80102a60 <kfree>
      return 0;
8010730b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010730e:	31 d2                	xor    %edx,%edx
80107310:	eb ac                	jmp    801072be <allocuvm+0xae>
80107312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107318:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010731b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010731e:	5b                   	pop    %ebx
8010731f:	5e                   	pop    %esi
80107320:	89 d0                	mov    %edx,%eax
80107322:	5f                   	pop    %edi
80107323:	5d                   	pop    %ebp
80107324:	c3                   	ret
80107325:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010732c:	00 
8010732d:	8d 76 00             	lea    0x0(%esi),%esi

80107330 <deallocuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	8b 55 0c             	mov    0xc(%ebp),%edx
80107336:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107339:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010733c:	39 d1                	cmp    %edx,%ecx
8010733e:	73 10                	jae    80107350 <deallocuvm+0x20>
}
80107340:	5d                   	pop    %ebp
80107341:	e9 1a fa ff ff       	jmp    80106d60 <deallocuvm.part.0>
80107346:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010734d:	00 
8010734e:	66 90                	xchg   %ax,%ax
80107350:	89 d0                	mov    %edx,%eax
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret
80107354:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010735b:	00 
8010735c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107360 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 0c             	sub    $0xc,%esp
80107369:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010736c:	85 f6                	test   %esi,%esi
8010736e:	74 59                	je     801073c9 <freevm+0x69>
  if(newsz >= oldsz)
80107370:	31 c9                	xor    %ecx,%ecx
80107372:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107377:	89 f0                	mov    %esi,%eax
80107379:	89 f3                	mov    %esi,%ebx
8010737b:	e8 e0 f9 ff ff       	call   80106d60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107380:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107386:	eb 0f                	jmp    80107397 <freevm+0x37>
80107388:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010738f:	00 
80107390:	83 c3 04             	add    $0x4,%ebx
80107393:	39 fb                	cmp    %edi,%ebx
80107395:	74 23                	je     801073ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107397:	8b 03                	mov    (%ebx),%eax
80107399:	a8 01                	test   $0x1,%al
8010739b:	74 f3                	je     80107390 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010739d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073a2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073ad:	50                   	push   %eax
801073ae:	e8 ad b6 ff ff       	call   80102a60 <kfree>
801073b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073b6:	39 fb                	cmp    %edi,%ebx
801073b8:	75 dd                	jne    80107397 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c0:	5b                   	pop    %ebx
801073c1:	5e                   	pop    %esi
801073c2:	5f                   	pop    %edi
801073c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073c4:	e9 97 b6 ff ff       	jmp    80102a60 <kfree>
    panic("freevm: no pgdir");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 d1 7b 10 80       	push   $0x80107bd1
801073d1:	e8 aa 8f ff ff       	call   80100380 <panic>
801073d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073dd:	00 
801073de:	66 90                	xchg   %ax,%ax

801073e0 <setupkvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	56                   	push   %esi
801073e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073e5:	e8 36 b8 ff ff       	call   80102c20 <kalloc>
801073ea:	85 c0                	test   %eax,%eax
801073ec:	74 5e                	je     8010744c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801073ee:	83 ec 04             	sub    $0x4,%esp
801073f1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073f8:	68 00 10 00 00       	push   $0x1000
801073fd:	6a 00                	push   $0x0
801073ff:	50                   	push   %eax
80107400:	e8 5b d8 ff ff       	call   80104c60 <memset>
80107405:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107408:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010740b:	83 ec 08             	sub    $0x8,%esp
8010740e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107411:	8b 13                	mov    (%ebx),%edx
80107413:	ff 73 0c             	push   0xc(%ebx)
80107416:	50                   	push   %eax
80107417:	29 c1                	sub    %eax,%ecx
80107419:	89 f0                	mov    %esi,%eax
8010741b:	e8 00 fa ff ff       	call   80106e20 <mappages>
80107420:	83 c4 10             	add    $0x10,%esp
80107423:	85 c0                	test   %eax,%eax
80107425:	78 19                	js     80107440 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107427:	83 c3 10             	add    $0x10,%ebx
8010742a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107430:	75 d6                	jne    80107408 <setupkvm+0x28>
}
80107432:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107435:	89 f0                	mov    %esi,%eax
80107437:	5b                   	pop    %ebx
80107438:	5e                   	pop    %esi
80107439:	5d                   	pop    %ebp
8010743a:	c3                   	ret
8010743b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	56                   	push   %esi
80107444:	e8 17 ff ff ff       	call   80107360 <freevm>
      return 0;
80107449:	83 c4 10             	add    $0x10,%esp
}
8010744c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010744f:	31 f6                	xor    %esi,%esi
}
80107451:	89 f0                	mov    %esi,%eax
80107453:	5b                   	pop    %ebx
80107454:	5e                   	pop    %esi
80107455:	5d                   	pop    %ebp
80107456:	c3                   	ret
80107457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010745e:	00 
8010745f:	90                   	nop

80107460 <kvmalloc>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107466:	e8 75 ff ff ff       	call   801073e0 <setupkvm>
8010746b:	a3 e4 54 11 80       	mov    %eax,0x801154e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107470:	05 00 00 00 80       	add    $0x80000000,%eax
80107475:	0f 22 d8             	mov    %eax,%cr3
}
80107478:	c9                   	leave
80107479:	c3                   	ret
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107480 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	83 ec 08             	sub    $0x8,%esp
80107486:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107489:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010748c:	89 c1                	mov    %eax,%ecx
8010748e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107491:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107494:	f6 c2 01             	test   $0x1,%dl
80107497:	75 17                	jne    801074b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107499:	83 ec 0c             	sub    $0xc,%esp
8010749c:	68 e2 7b 10 80       	push   $0x80107be2
801074a1:	e8 da 8e ff ff       	call   80100380 <panic>
801074a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074ad:	00 
801074ae:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801074b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074c5:	85 c0                	test   %eax,%eax
801074c7:	74 d0                	je     80107499 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074cc:	c9                   	leave
801074cd:	c3                   	ret
801074ce:	66 90                	xchg   %ax,%ax

801074d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074d9:	e8 02 ff ff ff       	call   801073e0 <setupkvm>
801074de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074e1:	85 c0                	test   %eax,%eax
801074e3:	0f 84 e9 00 00 00    	je     801075d2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074ec:	85 c9                	test   %ecx,%ecx
801074ee:	0f 84 b2 00 00 00    	je     801075a6 <copyuvm+0xd6>
801074f4:	31 f6                	xor    %esi,%esi
801074f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074fd:	00 
801074fe:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107500:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107503:	89 f0                	mov    %esi,%eax
80107505:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107508:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010750b:	a8 01                	test   $0x1,%al
8010750d:	75 11                	jne    80107520 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010750f:	83 ec 0c             	sub    $0xc,%esp
80107512:	68 ec 7b 10 80       	push   $0x80107bec
80107517:	e8 64 8e ff ff       	call   80100380 <panic>
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107520:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107522:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107527:	c1 ea 0a             	shr    $0xa,%edx
8010752a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107530:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107537:	85 c0                	test   %eax,%eax
80107539:	74 d4                	je     8010750f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010753b:	8b 00                	mov    (%eax),%eax
8010753d:	a8 01                	test   $0x1,%al
8010753f:	0f 84 9f 00 00 00    	je     801075e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107545:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107547:	25 ff 0f 00 00       	and    $0xfff,%eax
8010754c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010754f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107555:	e8 c6 b6 ff ff       	call   80102c20 <kalloc>
8010755a:	89 c3                	mov    %eax,%ebx
8010755c:	85 c0                	test   %eax,%eax
8010755e:	74 64                	je     801075c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107560:	83 ec 04             	sub    $0x4,%esp
80107563:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107569:	68 00 10 00 00       	push   $0x1000
8010756e:	57                   	push   %edi
8010756f:	50                   	push   %eax
80107570:	e8 7b d7 ff ff       	call   80104cf0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107575:	58                   	pop    %eax
80107576:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757c:	5a                   	pop    %edx
8010757d:	ff 75 e4             	push   -0x1c(%ebp)
80107580:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107585:	89 f2                	mov    %esi,%edx
80107587:	50                   	push   %eax
80107588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758b:	e8 90 f8 ff ff       	call   80106e20 <mappages>
80107590:	83 c4 10             	add    $0x10,%esp
80107593:	85 c0                	test   %eax,%eax
80107595:	78 21                	js     801075b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107597:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010759d:	3b 75 0c             	cmp    0xc(%ebp),%esi
801075a0:	0f 82 5a ff ff ff    	jb     80107500 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801075a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ac:	5b                   	pop    %ebx
801075ad:	5e                   	pop    %esi
801075ae:	5f                   	pop    %edi
801075af:	5d                   	pop    %ebp
801075b0:	c3                   	ret
801075b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	53                   	push   %ebx
801075bc:	e8 9f b4 ff ff       	call   80102a60 <kfree>
      goto bad;
801075c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801075c4:	83 ec 0c             	sub    $0xc,%esp
801075c7:	ff 75 e0             	push   -0x20(%ebp)
801075ca:	e8 91 fd ff ff       	call   80107360 <freevm>
  return 0;
801075cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801075d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801075d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075df:	5b                   	pop    %ebx
801075e0:	5e                   	pop    %esi
801075e1:	5f                   	pop    %edi
801075e2:	5d                   	pop    %ebp
801075e3:	c3                   	ret
      panic("copyuvm: page not present");
801075e4:	83 ec 0c             	sub    $0xc,%esp
801075e7:	68 06 7c 10 80       	push   $0x80107c06
801075ec:	e8 8f 8d ff ff       	call   80100380 <panic>
801075f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075f8:	00 
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107600 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107606:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107609:	89 c1                	mov    %eax,%ecx
8010760b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010760e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107611:	f6 c2 01             	test   $0x1,%dl
80107614:	0f 84 f8 00 00 00    	je     80107712 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010761a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010761d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107623:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107624:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107629:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107630:	89 d0                	mov    %edx,%eax
80107632:	f7 d2                	not    %edx
80107634:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107639:	05 00 00 00 80       	add    $0x80000000,%eax
8010763e:	83 e2 05             	and    $0x5,%edx
80107641:	ba 00 00 00 00       	mov    $0x0,%edx
80107646:	0f 45 c2             	cmovne %edx,%eax
}
80107649:	c3                   	ret
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107650 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	57                   	push   %edi
80107654:	56                   	push   %esi
80107655:	53                   	push   %ebx
80107656:	83 ec 0c             	sub    $0xc,%esp
80107659:	8b 75 14             	mov    0x14(%ebp),%esi
8010765c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010765f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107662:	85 f6                	test   %esi,%esi
80107664:	75 51                	jne    801076b7 <copyout+0x67>
80107666:	e9 9d 00 00 00       	jmp    80107708 <copyout+0xb8>
8010766b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107670:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107676:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010767c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107682:	74 74                	je     801076f8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107684:	89 fb                	mov    %edi,%ebx
80107686:	29 c3                	sub    %eax,%ebx
80107688:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010768e:	39 f3                	cmp    %esi,%ebx
80107690:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107693:	29 f8                	sub    %edi,%eax
80107695:	83 ec 04             	sub    $0x4,%esp
80107698:	01 c1                	add    %eax,%ecx
8010769a:	53                   	push   %ebx
8010769b:	52                   	push   %edx
8010769c:	89 55 10             	mov    %edx,0x10(%ebp)
8010769f:	51                   	push   %ecx
801076a0:	e8 4b d6 ff ff       	call   80104cf0 <memmove>
    len -= n;
    buf += n;
801076a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801076b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801076b3:	29 de                	sub    %ebx,%esi
801076b5:	74 51                	je     80107708 <copyout+0xb8>
  if(*pde & PTE_P){
801076b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801076ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801076be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801076c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801076ca:	f6 c1 01             	test   $0x1,%cl
801076cd:	0f 84 46 00 00 00    	je     80107719 <copyout.cold>
  return &pgtab[PTX(va)];
801076d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076db:	c1 eb 0c             	shr    $0xc,%ebx
801076de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076eb:	89 d9                	mov    %ebx,%ecx
801076ed:	f7 d1                	not    %ecx
801076ef:	83 e1 05             	and    $0x5,%ecx
801076f2:	0f 84 78 ff ff ff    	je     80107670 <copyout+0x20>
  }
  return 0;
}
801076f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107700:	5b                   	pop    %ebx
80107701:	5e                   	pop    %esi
80107702:	5f                   	pop    %edi
80107703:	5d                   	pop    %ebp
80107704:	c3                   	ret
80107705:	8d 76 00             	lea    0x0(%esi),%esi
80107708:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010770b:	31 c0                	xor    %eax,%eax
}
8010770d:	5b                   	pop    %ebx
8010770e:	5e                   	pop    %esi
8010770f:	5f                   	pop    %edi
80107710:	5d                   	pop    %ebp
80107711:	c3                   	ret

80107712 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107712:	a1 00 00 00 00       	mov    0x0,%eax
80107717:	0f 0b                	ud2

80107719 <copyout.cold>:
80107719:	a1 00 00 00 00       	mov    0x0,%eax
8010771e:	0f 0b                	ud2
