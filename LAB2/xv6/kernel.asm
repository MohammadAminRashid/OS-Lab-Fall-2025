
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 7d 11 80       	mov    $0x80117d70,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 4c 10 80       	mov    $0x80104c10,%eax
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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 8f 10 80       	push   $0x80108f40
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 35 5f 00 00       	call   80105f90 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 8f 10 80       	push   $0x80108f47
80100097:	50                   	push   %eax
80100098:	e8 c3 5d 00 00       	call   80105e60 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 97 60 00 00       	call   80106180 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 b9 5f 00 00       	call   80106120 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 5d 00 00       	call   80105ea0 <acquiresleep>
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
8010018c:	e8 1f 3d 00 00       	call   80103eb0 <iderw>
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
801001a1:	68 4e 8f 10 80       	push   $0x80108f4e
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
801001be:	e8 7d 5d 00 00       	call   80105f40 <holdingsleep>
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
801001d4:	e9 d7 3c 00 00       	jmp    80103eb0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 8f 10 80       	push   $0x80108f5f
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
801001ff:	e8 3c 5d 00 00       	call   80105f40 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 5c 00 00       	call   80105f00 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 60 5f 00 00       	call   80106180 <acquire>
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
8010023f:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 b2 5e 00 00       	jmp    80106120 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 8f 10 80       	push   $0x80108f66
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
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
80100294:	e8 c7 31 00 00       	call   80103460 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 17 11 80 	movl   $0x801117c0,(%esp)
801002a0:	e8 db 5e 00 00       	call   80106180 <acquire>
  while (n > 0)
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
  {
    while (input.r == input.w)
801002b0:	a1 80 a0 10 80       	mov    0x8010a080,%eax
801002b5:	39 05 84 a0 10 80    	cmp    %eax,0x8010a084
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 c0 17 11 80       	push   $0x801117c0
801002c8:	68 80 a0 10 80       	push   $0x8010a080
801002cd:	e8 2e 59 00 00       	call   80105c00 <sleep>
    while (input.r == input.w)
801002d2:	a1 80 a0 10 80       	mov    0x8010a080,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 84 a0 10 80    	cmp    0x8010a084,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if (myproc()->killed)
801002e2:	e8 59 52 00 00       	call   80105540 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 17 11 80       	push   $0x801117c0
801002f6:	e8 25 5e 00 00       	call   80106120 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 30 00 00       	call   80103380 <ilock>
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
8010031b:	89 15 80 a0 10 80    	mov    %edx,0x8010a080
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 00 a0 10 80 	movsbl -0x7fef6000(%edx),%ecx
    if (c == C('D'))
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if (c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 c0 17 11 80       	push   $0x801117c0
8010034c:	e8 cf 5d 00 00       	call   80106120 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 30 00 00       	call   80103380 <ilock>
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
      if (n < target)
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 80 a0 10 80       	mov    %eax,0x8010a080
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
80100389:	c7 05 f4 17 11 80 00 	movl   $0x0,0x801117f4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 12 41 00 00       	call   801044b0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 8f 10 80       	push   $0x80108f6d
801003a7:	e8 24 04 00 00       	call   801007d0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 1b 04 00 00       	call   801007d0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4b 94 10 80 	movl   $0x8010944b,(%esp)
801003bc:	e8 0f 04 00 00       	call   801007d0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 5b 00 00       	call   80105fb0 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 8f 10 80       	push   $0x80108f81
801003dd:	e8 ee 03 00 00       	call   801007d0 <cprintf>
  for (i = 0; i < 10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 f8 17 11 80 01 	movl   $0x1,0x801117f8
801003f0:	00 00 00 
  for (;;)
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
8010040b:	56                   	push   %esi
8010040c:	53                   	push   %ebx
8010040d:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100412:	89 da                	mov    %ebx,%edx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	bf d5 03 00 00       	mov    $0x3d5,%edi
8010041d:	89 fa                	mov    %edi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100420:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 da                	mov    %ebx,%edx
80100425:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042a:	c1 e6 08             	shl    $0x8,%esi
8010042d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042e:	89 fa                	mov    %edi,%edx
80100430:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100431:	0f b6 d8             	movzbl %al,%ebx
80100434:	09 f3                	or     %esi,%ebx
  if (c == '\n')
80100436:	83 f9 0a             	cmp    $0xa,%ecx
80100439:	74 4d                	je     80100488 <cgaputc+0x88>
  else if (c == KEY_RIGHT)
8010043b:	81 f9 e5 00 00 00    	cmp    $0xe5,%ecx
80100441:	0f 84 41 01 00 00    	je     80100588 <cgaputc+0x188>
  else if (c == KEY_LEFT)
80100447:	81 f9 e4 00 00 00    	cmp    $0xe4,%ecx
8010044d:	0f 84 fd 00 00 00    	je     80100550 <cgaputc+0x150>
  else if (c == BACKSPACE)
80100453:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100459:	0f 84 19 01 00 00    	je     80100578 <cgaputc+0x178>
    crt[pos++] = (c & 0xff) | 0xF000;
8010045f:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
    pos++;
80100462:	83 c3 01             	add    $0x1,%ebx
  else if (input.color == 'W')
80100465:	80 3d a0 a0 10 80 57 	cmpb   $0x57,0x8010a0a0
    crt[pos++] = (c & 0xff) | 0xF000;
8010046c:	0f b6 c9             	movzbl %cl,%ecx
  else if (input.color == 'W')
8010046f:	0f 84 eb 00 00 00    	je     80100560 <cgaputc+0x160>
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
80100475:	80 cd 07             	or     $0x7,%ch
80100478:	66 89 88 00 80 0b 80 	mov    %cx,-0x7ff48000(%eax)
8010047f:	eb 1a                	jmp    8010049b <cgaputc+0x9b>
80100481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos % 80;
80100488:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
8010048d:	f7 e3                	mul    %ebx
8010048f:	c1 ea 06             	shr    $0x6,%edx
80100492:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100495:	c1 e0 04             	shl    $0x4,%eax
80100498:	8d 58 50             	lea    0x50(%eax),%ebx
  if (pos < 0 || pos > 25 * 80)
8010049b:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004a1:	0f 8f fc 00 00 00    	jg     801005a3 <cgaputc+0x1a3>
  if ((pos / 80) >= 24)
801004a7:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004ad:	7f 51                	jg     80100500 <cgaputc+0x100>
  outb(CRTPORT + 1, pos);
801004af:	88 5d e7             	mov    %bl,-0x19(%ebp)
  outb(CRTPORT + 1, pos >> 8);
801004b2:	0f b6 ff             	movzbl %bh,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004b5:	be d4 03 00 00       	mov    $0x3d4,%esi
801004ba:	b8 0e 00 00 00       	mov    $0xe,%eax
801004bf:	89 f2                	mov    %esi,%edx
801004c1:	ee                   	out    %al,(%dx)
801004c2:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004c7:	89 f8                	mov    %edi,%eax
801004c9:	89 ca                	mov    %ecx,%edx
801004cb:	ee                   	out    %al,(%dx)
801004cc:	b8 0f 00 00 00       	mov    $0xf,%eax
801004d1:	89 f2                	mov    %esi,%edx
801004d3:	ee                   	out    %al,(%dx)
801004d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004d8:	89 ca                	mov    %ecx,%edx
801004da:	ee                   	out    %al,(%dx)
  if (input.mode != 2)
801004db:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
801004e2:	74 0d                	je     801004f1 <cgaputc+0xf1>
    crt[pos] = ' ' | 0x0700;
801004e4:	b8 20 07 00 00       	mov    $0x720,%eax
801004e9:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004f0:	80 
}
801004f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004f4:	5b                   	pop    %ebx
801004f5:	5e                   	pop    %esi
801004f6:	5f                   	pop    %edi
801004f7:	5d                   	pop    %ebp
801004f8:	c3                   	ret
801004f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100500:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100503:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT + 1, pos);
80100506:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
8010050b:	68 60 0e 00 00       	push   $0xe60
80100510:	68 a0 80 0b 80       	push   $0x800b80a0
80100515:	68 00 80 0b 80       	push   $0x800b8000
8010051a:	e8 f1 5d 00 00       	call   80106310 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010051f:	b8 80 07 00 00       	mov    $0x780,%eax
80100524:	83 c4 0c             	add    $0xc,%esp
80100527:	29 d8                	sub    %ebx,%eax
80100529:	01 c0                	add    %eax,%eax
8010052b:	50                   	push   %eax
8010052c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100533:	6a 00                	push   $0x0
80100535:	50                   	push   %eax
80100536:	e8 45 5d 00 00       	call   80106280 <memset>
  outb(CRTPORT + 1, pos);
8010053b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010053e:	83 c4 10             	add    $0x10,%esp
80100541:	e9 6f ff ff ff       	jmp    801004b5 <cgaputc+0xb5>
80100546:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010054d:	00 
8010054e:	66 90                	xchg   %ax,%ax
    --pos;
80100550:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100553:	ee                   	out    %al,(%dx)
}
80100554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100557:	5b                   	pop    %ebx
80100558:	5e                   	pop    %esi
80100559:	5f                   	pop    %edi
8010055a:	5d                   	pop    %ebp
8010055b:	c3                   	ret
8010055c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c & 0xff) | 0xF000;
80100560:	66 81 c9 00 f0       	or     $0xf000,%cx
80100565:	66 89 88 00 80 0b 80 	mov    %cx,-0x7ff48000(%eax)
8010056c:	e9 2a ff ff ff       	jmp    8010049b <cgaputc+0x9b>
80100571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (pos > 0)
80100578:	85 db                	test   %ebx,%ebx
8010057a:	74 1c                	je     80100598 <cgaputc+0x198>
      --pos;
8010057c:	83 eb 01             	sub    $0x1,%ebx
8010057f:	e9 17 ff ff ff       	jmp    8010049b <cgaputc+0x9b>
80100584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos++;
80100588:	8d 43 01             	lea    0x1(%ebx),%eax
8010058b:	ee                   	out    %al,(%dx)
}
8010058c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010058f:	5b                   	pop    %ebx
80100590:	5e                   	pop    %esi
80100591:	5f                   	pop    %edi
80100592:	5d                   	pop    %ebp
80100593:	c3                   	ret
80100594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100598:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
8010059c:	31 ff                	xor    %edi,%edi
8010059e:	e9 12 ff ff ff       	jmp    801004b5 <cgaputc+0xb5>
    panic("pos under/overflow");
801005a3:	83 ec 0c             	sub    $0xc,%esp
801005a6:	68 85 8f 10 80       	push   $0x80108f85
801005ab:	e8 d0 fd ff ff       	call   80100380 <panic>

801005b0 <consputc>:
  if (panicked)
801005b0:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
801005b6:	85 d2                	test   %edx,%edx
801005b8:	74 06                	je     801005c0 <consputc+0x10>
  asm volatile("cli");
801005ba:	fa                   	cli
    for (;;)
801005bb:	eb fe                	jmp    801005bb <consputc+0xb>
801005bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801005c0:	55                   	push   %ebp
801005c1:	89 e5                	mov    %esp,%ebp
801005c3:	56                   	push   %esi
801005c4:	53                   	push   %ebx
801005c5:	83 ec 10             	sub    $0x10,%esp
  if (c == BACKSPACE)
801005c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801005cd:	74 2f                	je     801005fe <consputc+0x4e>
  else if (c == KEY_LEFT)
801005cf:	3d e4 00 00 00       	cmp    $0xe4,%eax
801005d4:	0f 84 b4 00 00 00    	je     8010068e <consputc+0xde>
  else if (c == KEY_RIGHT)
801005da:	3d e5 00 00 00       	cmp    $0xe5,%eax
801005df:	74 52                	je     80100633 <consputc+0x83>
    uartputc(c);
801005e1:	83 ec 0c             	sub    $0xc,%esp
801005e4:	50                   	push   %eax
801005e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801005e8:	e8 a3 74 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801005ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005f0:	83 c4 10             	add    $0x10,%esp
}
801005f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801005f6:	5b                   	pop    %ebx
801005f7:	5e                   	pop    %esi
801005f8:	5d                   	pop    %ebp
    cgaputc(c);
801005f9:	e9 02 fe ff ff       	jmp    80100400 <cgaputc>
    uartputc('\b');
801005fe:	83 ec 0c             	sub    $0xc,%esp
80100601:	6a 08                	push   $0x8
80100603:	e8 88 74 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
80100608:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010060f:	e8 7c 74 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
80100614:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010061b:	e8 70 74 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100620:	83 c4 10             	add    $0x10,%esp
}
80100623:	8d 65 f8             	lea    -0x8(%ebp),%esp
    cgaputc(c);
80100626:	b8 00 01 00 00       	mov    $0x100,%eax
}
8010062b:	5b                   	pop    %ebx
8010062c:	5e                   	pop    %esi
8010062d:	5d                   	pop    %ebp
    cgaputc(c);
8010062e:	e9 cd fd ff ff       	jmp    80100400 <cgaputc>
    uartputc('\033');
80100633:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100636:	be d4 03 00 00       	mov    $0x3d4,%esi
8010063b:	6a 1b                	push   $0x1b
8010063d:	e8 4e 74 00 00       	call   80107a90 <uartputc>
    uartputc('[');
80100642:	c7 04 24 5b 00 00 00 	movl   $0x5b,(%esp)
80100649:	e8 42 74 00 00       	call   80107a90 <uartputc>
    uartputc('C');
8010064e:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80100655:	e8 36 74 00 00       	call   80107a90 <uartputc>
8010065a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010065f:	89 f2                	mov    %esi,%edx
80100661:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100662:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100667:	89 ca                	mov    %ecx,%edx
80100669:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010066a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010066d:	89 f2                	mov    %esi,%edx
8010066f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100674:	c1 e3 08             	shl    $0x8,%ebx
80100677:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100678:	89 ca                	mov    %ecx,%edx
8010067a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010067b:	0f b6 c0             	movzbl %al,%eax
8010067e:	09 d8                	or     %ebx,%eax
    pos++;
80100680:	83 c0 01             	add    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100683:	ee                   	out    %al,(%dx)
    return;
80100684:	83 c4 10             	add    $0x10,%esp
}
80100687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010068a:	5b                   	pop    %ebx
8010068b:	5e                   	pop    %esi
8010068c:	5d                   	pop    %ebp
8010068d:	c3                   	ret
    uartputc('\b');
8010068e:	83 ec 0c             	sub    $0xc,%esp
80100691:	be d4 03 00 00       	mov    $0x3d4,%esi
80100696:	6a 08                	push   $0x8
80100698:	e8 f3 73 00 00       	call   80107a90 <uartputc>
8010069d:	b8 0e 00 00 00       	mov    $0xe,%eax
801006a2:	89 f2                	mov    %esi,%edx
801006a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006a5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801006aa:	89 ca                	mov    %ecx,%edx
801006ac:	ec                   	in     (%dx),%al
801006ad:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006b0:	89 f2                	mov    %esi,%edx
801006b2:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
801006b7:	c1 e3 08             	shl    $0x8,%ebx
801006ba:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006bb:	89 ca                	mov    %ecx,%edx
801006bd:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801006be:	0f b6 c0             	movzbl %al,%eax
801006c1:	09 d8                	or     %ebx,%eax
    --pos;
801006c3:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006c6:	ee                   	out    %al,(%dx)
    return;
801006c7:	83 c4 10             	add    $0x10,%esp
801006ca:	eb bb                	jmp    80100687 <consputc+0xd7>
801006cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801006d0 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 18             	sub    $0x18,%esp
801006d9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801006dc:	ff 75 08             	push   0x8(%ebp)
801006df:	e8 7c 2d 00 00       	call   80103460 <iunlock>
  acquire(&cons.lock);
801006e4:	c7 04 24 c0 17 11 80 	movl   $0x801117c0,(%esp)
801006eb:	e8 90 5a 00 00       	call   80106180 <acquire>
  for (i = 0; i < n; i++)
801006f0:	83 c4 10             	add    $0x10,%esp
801006f3:	85 f6                	test   %esi,%esi
801006f5:	7e 18                	jle    8010070f <consolewrite+0x3f>
801006f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006fa:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006fd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100700:	0f b6 07             	movzbl (%edi),%eax
  for (i = 0; i < n; i++)
80100703:	83 c7 01             	add    $0x1,%edi
    consputc(buf[i] & 0xff);
80100706:	e8 a5 fe ff ff       	call   801005b0 <consputc>
  for (i = 0; i < n; i++)
8010070b:	39 df                	cmp    %ebx,%edi
8010070d:	75 f1                	jne    80100700 <consolewrite+0x30>
  release(&cons.lock);
8010070f:	83 ec 0c             	sub    $0xc,%esp
80100712:	68 c0 17 11 80       	push   $0x801117c0
80100717:	e8 04 5a 00 00       	call   80106120 <release>
  ilock(ip);
8010071c:	58                   	pop    %eax
8010071d:	ff 75 08             	push   0x8(%ebp)
80100720:	e8 5b 2c 00 00       	call   80103380 <ilock>

  return n;
}
80100725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100728:	89 f0                	mov    %esi,%eax
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret
8010072f:	90                   	nop

80100730 <printint>:
{
80100730:	55                   	push   %ebp
80100731:	89 e5                	mov    %esp,%ebp
80100733:	57                   	push   %edi
80100734:	56                   	push   %esi
80100735:	53                   	push   %ebx
80100736:	89 d3                	mov    %edx,%ebx
80100738:	83 ec 2c             	sub    $0x2c,%esp
  if (sign && (sign = xx < 0))
8010073b:	85 c0                	test   %eax,%eax
8010073d:	79 05                	jns    80100744 <printint+0x14>
8010073f:	83 e1 01             	and    $0x1,%ecx
80100742:	75 6a                	jne    801007ae <printint+0x7e>
    x = xx;
80100744:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010074b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010074d:	31 f6                	xor    %esi,%esi
8010074f:	90                   	nop
    buf[i++] = digits[x % base];
80100750:	89 c8                	mov    %ecx,%eax
80100752:	31 d2                	xor    %edx,%edx
80100754:	89 f7                	mov    %esi,%edi
80100756:	f7 f3                	div    %ebx
80100758:	8d 76 01             	lea    0x1(%esi),%esi
8010075b:	0f b6 92 08 95 10 80 	movzbl -0x7fef6af8(%edx),%edx
80100762:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  } while ((x /= base) != 0);
80100766:	89 ca                	mov    %ecx,%edx
80100768:	89 c1                	mov    %eax,%ecx
8010076a:	39 da                	cmp    %ebx,%edx
8010076c:	73 e2                	jae    80100750 <printint+0x20>
  if (sign)
8010076e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100771:	85 d2                	test   %edx,%edx
80100773:	74 07                	je     8010077c <printint+0x4c>
    buf[i++] = '-';
80100775:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while (--i >= 0)
8010077a:	89 f7                	mov    %esi,%edi
8010077c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010077f:	01 f7                	add    %esi,%edi
  if (panicked)
80100781:	a1 f8 17 11 80       	mov    0x801117f8,%eax
    consputc(buf[i]);
80100786:	0f be 1f             	movsbl (%edi),%ebx
  if (panicked)
80100789:	85 c0                	test   %eax,%eax
8010078b:	74 03                	je     80100790 <printint+0x60>
  asm volatile("cli");
8010078d:	fa                   	cli
    for (;;)
8010078e:	eb fe                	jmp    8010078e <printint+0x5e>
    uartputc(c);
80100790:	83 ec 0c             	sub    $0xc,%esp
80100793:	53                   	push   %ebx
80100794:	e8 f7 72 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100799:	89 d8                	mov    %ebx,%eax
8010079b:	e8 60 fc ff ff       	call   80100400 <cgaputc>
  while (--i >= 0)
801007a0:	8d 47 ff             	lea    -0x1(%edi),%eax
801007a3:	83 c4 10             	add    $0x10,%esp
801007a6:	39 f7                	cmp    %esi,%edi
801007a8:	74 11                	je     801007bb <printint+0x8b>
801007aa:	89 c7                	mov    %eax,%edi
801007ac:	eb d3                	jmp    80100781 <printint+0x51>
    x = -xx;
801007ae:	f7 d8                	neg    %eax
  if (sign && (sign = xx < 0))
801007b0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801007b7:	89 c1                	mov    %eax,%ecx
801007b9:	eb 92                	jmp    8010074d <printint+0x1d>
}
801007bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007be:	5b                   	pop    %ebx
801007bf:	5e                   	pop    %esi
801007c0:	5f                   	pop    %edi
801007c1:	5d                   	pop    %ebp
801007c2:	c3                   	ret
801007c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801007ca:	00 
801007cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801007d0 <cprintf>:
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	57                   	push   %edi
801007d4:	56                   	push   %esi
801007d5:	53                   	push   %ebx
801007d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007d9:	8b 3d f4 17 11 80    	mov    0x801117f4,%edi
  if (fmt == 0)
801007df:	8b 75 08             	mov    0x8(%ebp),%esi
  if (locking)
801007e2:	85 ff                	test   %edi,%edi
801007e4:	0f 85 26 01 00 00    	jne    80100910 <cprintf+0x140>
  if (fmt == 0)
801007ea:	85 f6                	test   %esi,%esi
801007ec:	0f 84 e2 01 00 00    	je     801009d4 <cprintf+0x204>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801007f2:	0f b6 06             	movzbl (%esi),%eax
801007f5:	85 c0                	test   %eax,%eax
801007f7:	74 63                	je     8010085c <cprintf+0x8c>
  argp = (uint *)(void *)(&fmt + 1);
801007f9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801007fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801007ff:	31 db                	xor    %ebx,%ebx
80100801:	89 d7                	mov    %edx,%edi
    if (c != '%')
80100803:	83 f8 25             	cmp    $0x25,%eax
80100806:	75 60                	jne    80100868 <cprintf+0x98>
    c = fmt[++i] & 0xff;
80100808:	83 c3 01             	add    $0x1,%ebx
8010080b:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if (c == 0)
8010080f:	85 c9                	test   %ecx,%ecx
80100811:	74 3e                	je     80100851 <cprintf+0x81>
    switch (c)
80100813:	83 f9 70             	cmp    $0x70,%ecx
80100816:	0f 84 c4 00 00 00    	je     801008e0 <cprintf+0x110>
8010081c:	7f 6a                	jg     80100888 <cprintf+0xb8>
8010081e:	83 f9 25             	cmp    $0x25,%ecx
80100821:	0f 84 d9 00 00 00    	je     80100900 <cprintf+0x130>
80100827:	83 f9 64             	cmp    $0x64,%ecx
8010082a:	75 66                	jne    80100892 <cprintf+0xc2>
      printint(*argp++, 10, 1);
8010082c:	8d 47 04             	lea    0x4(%edi),%eax
8010082f:	b9 01 00 00 00       	mov    $0x1,%ecx
80100834:	ba 0a 00 00 00       	mov    $0xa,%edx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100839:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 10, 1);
8010083c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010083f:	8b 07                	mov    (%edi),%eax
80100841:	e8 ea fe ff ff       	call   80100730 <printint>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100846:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 10, 1);
8010084a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010084d:	85 c0                	test   %eax,%eax
8010084f:	75 b2                	jne    80100803 <cprintf+0x33>
80100851:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (locking)
80100854:	85 ff                	test   %edi,%edi
80100856:	0f 85 d7 00 00 00    	jne    80100933 <cprintf+0x163>
}
8010085c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010085f:	5b                   	pop    %ebx
80100860:	5e                   	pop    %esi
80100861:	5f                   	pop    %edi
80100862:	5d                   	pop    %ebp
80100863:	c3                   	ret
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc(c);
80100868:	e8 43 fd ff ff       	call   801005b0 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010086d:	83 c3 01             	add    $0x1,%ebx
80100870:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100874:	85 c0                	test   %eax,%eax
80100876:	75 8b                	jne    80100803 <cprintf+0x33>
80100878:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (locking)
8010087b:	85 ff                	test   %edi,%edi
8010087d:	74 dd                	je     8010085c <cprintf+0x8c>
8010087f:	e9 af 00 00 00       	jmp    80100933 <cprintf+0x163>
80100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100888:	83 f9 73             	cmp    $0x73,%ecx
8010088b:	74 1b                	je     801008a8 <cprintf+0xd8>
8010088d:	83 f9 78             	cmp    $0x78,%ecx
80100890:	74 4e                	je     801008e0 <cprintf+0x110>
  if (panicked)
80100892:	a1 f8 17 11 80       	mov    0x801117f8,%eax
80100897:	85 c0                	test   %eax,%eax
80100899:	0f 84 c5 00 00 00    	je     80100964 <cprintf+0x194>
8010089f:	fa                   	cli
    for (;;)
801008a0:	eb fe                	jmp    801008a0 <cprintf+0xd0>
801008a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if ((s = (char *)*argp++) == 0)
801008a8:	8b 17                	mov    (%edi),%edx
801008aa:	8d 47 04             	lea    0x4(%edi),%eax
801008ad:	85 d2                	test   %edx,%edx
801008af:	0f 84 d6 00 00 00    	je     8010098b <cprintf+0x1bb>
      for (; *s; s++)
801008b5:	0f b6 0a             	movzbl (%edx),%ecx
      if ((s = (char *)*argp++) == 0)
801008b8:	89 d7                	mov    %edx,%edi
      for (; *s; s++)
801008ba:	84 c9                	test   %cl,%cl
801008bc:	0f 84 0b 01 00 00    	je     801009cd <cprintf+0x1fd>
801008c2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008c5:	89 fb                	mov    %edi,%ebx
801008c7:	89 f7                	mov    %esi,%edi
801008c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801008cc:	89 c8                	mov    %ecx,%eax
  if (panicked)
801008ce:	8b 0d f8 17 11 80    	mov    0x801117f8,%ecx
801008d4:	85 c9                	test   %ecx,%ecx
801008d6:	0f 84 be 00 00 00    	je     8010099a <cprintf+0x1ca>
801008dc:	fa                   	cli
    for (;;)
801008dd:	eb fe                	jmp    801008dd <cprintf+0x10d>
801008df:	90                   	nop
      printint(*argp++, 16, 0);
801008e0:	8d 47 04             	lea    0x4(%edi),%eax
801008e3:	31 c9                	xor    %ecx,%ecx
801008e5:	ba 10 00 00 00       	mov    $0x10,%edx
801008ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008ed:	8b 07                	mov    (%edi),%eax
801008ef:	e8 3c fe ff ff       	call   80100730 <printint>
801008f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801008f7:	e9 71 ff ff ff       	jmp    8010086d <cprintf+0x9d>
801008fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (panicked)
80100900:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
80100906:	85 d2                	test   %edx,%edx
80100908:	74 3e                	je     80100948 <cprintf+0x178>
8010090a:	fa                   	cli
    for (;;)
8010090b:	eb fe                	jmp    8010090b <cprintf+0x13b>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&cons.lock);
80100910:	83 ec 0c             	sub    $0xc,%esp
80100913:	68 c0 17 11 80       	push   $0x801117c0
80100918:	e8 63 58 00 00       	call   80106180 <acquire>
  if (fmt == 0)
8010091d:	83 c4 10             	add    $0x10,%esp
80100920:	85 f6                	test   %esi,%esi
80100922:	0f 84 ac 00 00 00    	je     801009d4 <cprintf+0x204>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100928:	0f b6 06             	movzbl (%esi),%eax
8010092b:	85 c0                	test   %eax,%eax
8010092d:	0f 85 c6 fe ff ff    	jne    801007f9 <cprintf+0x29>
    release(&cons.lock);
80100933:	83 ec 0c             	sub    $0xc,%esp
80100936:	68 c0 17 11 80       	push   $0x801117c0
8010093b:	e8 e0 57 00 00       	call   80106120 <release>
80100940:	83 c4 10             	add    $0x10,%esp
80100943:	e9 14 ff ff ff       	jmp    8010085c <cprintf+0x8c>
    uartputc(c);
80100948:	83 ec 0c             	sub    $0xc,%esp
8010094b:	6a 25                	push   $0x25
8010094d:	e8 3e 71 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100952:	b8 25 00 00 00       	mov    $0x25,%eax
80100957:	e8 a4 fa ff ff       	call   80100400 <cgaputc>
}
8010095c:	83 c4 10             	add    $0x10,%esp
8010095f:	e9 09 ff ff ff       	jmp    8010086d <cprintf+0x9d>
    uartputc(c);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010096a:	6a 25                	push   $0x25
8010096c:	e8 1f 71 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100971:	b8 25 00 00 00       	mov    $0x25,%eax
80100976:	e8 85 fa ff ff       	call   80100400 <cgaputc>
      consputc(c);
8010097b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010097e:	e8 2d fc ff ff       	call   801005b0 <consputc>
      break;
80100983:	83 c4 10             	add    $0x10,%esp
80100986:	e9 e2 fe ff ff       	jmp    8010086d <cprintf+0x9d>
8010098b:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100990:	bf 98 8f 10 80       	mov    $0x80108f98,%edi
80100995:	e9 28 ff ff ff       	jmp    801008c2 <cprintf+0xf2>
    uartputc(c);
8010099a:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010099d:	0f be f0             	movsbl %al,%esi
      for (; *s; s++)
801009a0:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009a3:	56                   	push   %esi
801009a4:	e8 e7 70 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801009a9:	89 f0                	mov    %esi,%eax
801009ab:	e8 50 fa ff ff       	call   80100400 <cgaputc>
      for (; *s; s++)
801009b0:	0f b6 03             	movzbl (%ebx),%eax
801009b3:	83 c4 10             	add    $0x10,%esp
801009b6:	84 c0                	test   %al,%al
801009b8:	0f 85 10 ff ff ff    	jne    801008ce <cprintf+0xfe>
      if ((s = (char *)*argp++) == 0)
801009be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801009c1:	89 fe                	mov    %edi,%esi
801009c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801009c6:	89 c7                	mov    %eax,%edi
801009c8:	e9 a0 fe ff ff       	jmp    8010086d <cprintf+0x9d>
801009cd:	89 c7                	mov    %eax,%edi
801009cf:	e9 99 fe ff ff       	jmp    8010086d <cprintf+0x9d>
    panic("null fmt");
801009d4:	83 ec 0c             	sub    $0xc,%esp
801009d7:	68 9f 8f 10 80       	push   $0x80108f9f
801009dc:	e8 9f f9 ff ff       	call   80100380 <panic>
801009e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801009e8:	00 
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801009f0 <printbuf>:
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	56                   	push   %esi
801009f4:	53                   	push   %ebx
  for (uint i = input.e + 1; i < input.end_pos; i++)
801009f5:	a1 88 a0 10 80       	mov    0x8010a088,%eax
801009fa:	8d 58 01             	lea    0x1(%eax),%ebx
801009fd:	3b 1d 8c a0 10 80    	cmp    0x8010a08c,%ebx
80100a03:	73 3c                	jae    80100a41 <printbuf+0x51>
    consputc(input.buf[i % INPUT_BUF]);
80100a05:	89 d8                	mov    %ebx,%eax
  if (panicked)
80100a07:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
    consputc(input.buf[i % INPUT_BUF]);
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
  if (panicked)
80100a17:	85 d2                	test   %edx,%edx
80100a19:	74 05                	je     80100a20 <printbuf+0x30>
80100a1b:	fa                   	cli
    for (;;)
80100a1c:	eb fe                	jmp    80100a1c <printbuf+0x2c>
80100a1e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100a20:	83 ec 0c             	sub    $0xc,%esp
    consputc(input.buf[i % INPUT_BUF]);
80100a23:	0f be f0             	movsbl %al,%esi
  for (uint i = input.e + 1; i < input.end_pos; i++)
80100a26:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100a29:	56                   	push   %esi
80100a2a:	e8 61 70 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100a2f:	89 f0                	mov    %esi,%eax
80100a31:	e8 ca f9 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e + 1; i < input.end_pos; i++)
80100a36:	83 c4 10             	add    $0x10,%esp
80100a39:	3b 1d 8c a0 10 80    	cmp    0x8010a08c,%ebx
80100a3f:	72 c4                	jb     80100a05 <printbuf+0x15>
}
80100a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100a44:	5b                   	pop    %ebx
80100a45:	5e                   	pop    %esi
80100a46:	5d                   	pop    %ebp
80100a47:	c3                   	ret
80100a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a4f:	00 

80100a50 <set_cursor>:
{
80100a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a51:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a56:	89 e5                	mov    %esp,%ebp
80100a58:	56                   	push   %esi
80100a59:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a5e:	53                   	push   %ebx
80100a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100a62:	89 f2                	mov    %esi,%edx
80100a64:	ee                   	out    %al,(%dx)
80100a65:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
80100a6a:	89 c8                	mov    %ecx,%eax
80100a6c:	c1 f8 08             	sar    $0x8,%eax
80100a6f:	89 da                	mov    %ebx,%edx
80100a71:	ee                   	out    %al,(%dx)
80100a72:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a77:	89 f2                	mov    %esi,%edx
80100a79:	ee                   	out    %al,(%dx)
80100a7a:	89 c8                	mov    %ecx,%eax
80100a7c:	89 da                	mov    %ebx,%edx
80100a7e:	ee                   	out    %al,(%dx)
}
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5d                   	pop    %ebp
80100a82:	c3                   	ret
80100a83:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a8a:	00 
80100a8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100a90 <move_cursor>:
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	57                   	push   %edi
80100a94:	bf 0e 00 00 00       	mov    $0xe,%edi
80100a99:	56                   	push   %esi
80100a9a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a9f:	89 f8                	mov    %edi,%eax
80100aa1:	53                   	push   %ebx
80100aa2:	89 f2                	mov    %esi,%edx
80100aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100aa5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100aaa:	89 da                	mov    %ebx,%edx
80100aac:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100aad:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ab0:	89 f2                	mov    %esi,%edx
80100ab2:	c1 e0 08             	shl    $0x8,%eax
80100ab5:	89 c1                	mov    %eax,%ecx
80100ab7:	b8 0f 00 00 00       	mov    $0xf,%eax
80100abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100abd:	89 da                	mov    %ebx,%edx
80100abf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ac0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ac3:	89 f2                	mov    %esi,%edx
80100ac5:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100ac7:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100acc:	03 4d 08             	add    0x8(%ebp),%ecx
  if (pos >= 25 * 80)
80100acf:	39 c1                	cmp    %eax,%ecx
80100ad1:	0f 4f c8             	cmovg  %eax,%ecx
80100ad4:	31 c0                	xor    %eax,%eax
80100ad6:	85 c9                	test   %ecx,%ecx
80100ad8:	0f 48 c8             	cmovs  %eax,%ecx
80100adb:	89 f8                	mov    %edi,%eax
80100add:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100ade:	89 cf                	mov    %ecx,%edi
80100ae0:	89 da                	mov    %ebx,%edx
80100ae2:	c1 ff 08             	sar    $0x8,%edi
80100ae5:	89 f8                	mov    %edi,%eax
80100ae7:	ee                   	out    %al,(%dx)
80100ae8:	b8 0f 00 00 00       	mov    $0xf,%eax
80100aed:	89 f2                	mov    %esi,%edx
80100aef:	ee                   	out    %al,(%dx)
80100af0:	89 c8                	mov    %ecx,%eax
80100af2:	89 da                	mov    %ebx,%edx
80100af4:	ee                   	out    %al,(%dx)
}
80100af5:	5b                   	pop    %ebx
80100af6:	5e                   	pop    %esi
80100af7:	5f                   	pop    %edi
80100af8:	5d                   	pop    %ebp
80100af9:	c3                   	ret
80100afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b00 <move_chars_left>:
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
80100b06:	83 ec 1c             	sub    $0x1c,%esp
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100b09:	8b 3d 8c a0 10 80    	mov    0x8010a08c,%edi
80100b0f:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80100b14:	8d 57 ff             	lea    -0x1(%edi),%edx
80100b17:	39 d0                	cmp    %edx,%eax
80100b19:	0f 83 c2 00 00 00    	jae    80100be1 <move_chars_left+0xe1>
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100b1f:	8d 70 01             	lea    0x1(%eax),%esi
80100b22:	83 e0 7f             	and    $0x7f,%eax
80100b25:	89 f2                	mov    %esi,%edx
80100b27:	83 e2 7f             	and    $0x7f,%edx
80100b2a:	0f be 9a 00 a0 10 80 	movsbl -0x7fef6000(%edx),%ebx
80100b31:	88 98 00 a0 10 80    	mov    %bl,-0x7fef6000(%eax)
  if (panicked)
80100b37:	a1 f8 17 11 80       	mov    0x801117f8,%eax
80100b3c:	85 c0                	test   %eax,%eax
80100b3e:	74 08                	je     80100b48 <move_chars_left+0x48>
  asm volatile("cli");
80100b40:	fa                   	cli
    for (;;)
80100b41:	eb fe                	jmp    80100b41 <move_chars_left+0x41>
80100b43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	53                   	push   %ebx
80100b4c:	e8 3f 6f 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100b51:	89 d8                	mov    %ebx,%eax
80100b53:	e8 a8 f8 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100b58:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b63:	39 d6                	cmp    %edx,%esi
80100b65:	73 04                	jae    80100b6b <move_chars_left+0x6b>
80100b67:	89 f0                	mov    %esi,%eax
80100b69:	eb b4                	jmp    80100b1f <move_chars_left+0x1f>
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100b6b:	8b 3d 88 a0 10 80    	mov    0x8010a088,%edi
80100b71:	39 d7                	cmp    %edx,%edi
80100b73:	73 6c                	jae    80100be1 <move_chars_left+0xe1>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100b78:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b7d:	8d 76 00             	lea    0x0(%esi),%esi
80100b80:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b85:	89 f2                	mov    %esi,%edx
80100b87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b88:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b8d:	89 da                	mov    %ebx,%edx
80100b8f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100b90:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b93:	89 f2                	mov    %esi,%edx
80100b95:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b9a:	c1 e1 08             	shl    $0x8,%ecx
80100b9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b9e:	89 da                	mov    %ebx,%edx
80100ba0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ba1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ba4:	89 f2                	mov    %esi,%edx
80100ba6:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100ba8:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100bad:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80100bb0:	39 c1                	cmp    %eax,%ecx
80100bb2:	0f 4f c8             	cmovg  %eax,%ecx
80100bb5:	31 c0                	xor    %eax,%eax
80100bb7:	85 c9                	test   %ecx,%ecx
80100bb9:	0f 48 c8             	cmovs  %eax,%ecx
80100bbc:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bc1:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100bc2:	89 ca                	mov    %ecx,%edx
80100bc4:	c1 fa 08             	sar    $0x8,%edx
80100bc7:	89 d0                	mov    %edx,%eax
80100bc9:	89 da                	mov    %ebx,%edx
80100bcb:	ee                   	out    %al,(%dx)
80100bcc:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bd1:	89 f2                	mov    %esi,%edx
80100bd3:	ee                   	out    %al,(%dx)
80100bd4:	89 c8                	mov    %ecx,%eax
80100bd6:	89 da                	mov    %ebx,%edx
80100bd8:	ee                   	out    %al,(%dx)
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100bd9:	83 c7 01             	add    $0x1,%edi
80100bdc:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100bdf:	75 9f                	jne    80100b80 <move_chars_left+0x80>
}
80100be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100be4:	5b                   	pop    %ebx
80100be5:	5e                   	pop    %esi
80100be6:	5f                   	pop    %edi
80100be7:	5d                   	pop    %ebp
80100be8:	c3                   	ret
80100be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100bf0 <move_chars_right>:
{
80100bf0:	55                   	push   %ebp
80100bf1:	89 e5                	mov    %esp,%ebp
80100bf3:	57                   	push   %edi
80100bf4:	56                   	push   %esi
80100bf5:	53                   	push   %ebx
80100bf6:	83 ec 0c             	sub    $0xc,%esp
  for (uint i = input.e; i <= input.end_pos; i++)
80100bf9:	8b 1d 88 a0 10 80    	mov    0x8010a088,%ebx
80100bff:	39 1d 8c a0 10 80    	cmp    %ebx,0x8010a08c
80100c05:	0f 82 ce 00 00 00    	jb     80100cd9 <move_chars_right+0xe9>
    input.buf[(i) % INPUT_BUF] = copy_buf[(i - 1) % INPUT_BUF];
80100c0b:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100c0e:	89 da                	mov    %ebx,%edx
80100c10:	83 e0 7f             	and    $0x7f,%eax
80100c13:	83 e2 7f             	and    $0x7f,%edx
80100c16:	0f b6 80 20 17 11 80 	movzbl -0x7feee8e0(%eax),%eax
80100c1d:	88 82 00 a0 10 80    	mov    %al,-0x7fef6000(%edx)
  if (panicked)
80100c23:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
80100c29:	85 d2                	test   %edx,%edx
80100c2b:	74 03                	je     80100c30 <move_chars_right+0x40>
  asm volatile("cli");
80100c2d:	fa                   	cli
    for (;;)
80100c2e:	eb fe                	jmp    80100c2e <move_chars_right+0x3e>
    uartputc(c);
80100c30:	83 ec 0c             	sub    $0xc,%esp
    consputc(input.buf[(i) % INPUT_BUF]);
80100c33:	0f be f0             	movsbl %al,%esi
  for (uint i = input.e; i <= input.end_pos; i++)
80100c36:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100c39:	56                   	push   %esi
80100c3a:	e8 51 6e 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80100c3f:	89 f0                	mov    %esi,%eax
80100c41:	e8 ba f7 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e; i <= input.end_pos; i++)
80100c46:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
80100c4b:	83 c4 10             	add    $0x10,%esp
80100c4e:	39 d8                	cmp    %ebx,%eax
80100c50:	73 b9                	jae    80100c0b <move_chars_right+0x1b>
  for (uint i = input.e; i <= input.end_pos; i++)
80100c52:	8b 35 88 a0 10 80    	mov    0x8010a088,%esi
80100c58:	39 f0                	cmp    %esi,%eax
80100c5a:	72 7d                	jb     80100cd9 <move_chars_right+0xe9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c5c:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c68:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c6d:	89 fa                	mov    %edi,%edx
80100c6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c70:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c75:	89 da                	mov    %ebx,%edx
80100c77:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100c78:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c7b:	89 fa                	mov    %edi,%edx
80100c7d:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c82:	c1 e1 08             	shl    $0x8,%ecx
80100c85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c86:	89 da                	mov    %ebx,%edx
80100c88:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100c89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c8c:	89 fa                	mov    %edi,%edx
80100c8e:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100c90:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100c95:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80100c98:	39 c1                	cmp    %eax,%ecx
80100c9a:	0f 4f c8             	cmovg  %eax,%ecx
80100c9d:	31 c0                	xor    %eax,%eax
80100c9f:	85 c9                	test   %ecx,%ecx
80100ca1:	0f 48 c8             	cmovs  %eax,%ecx
80100ca4:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ca9:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100caa:	89 ca                	mov    %ecx,%edx
80100cac:	c1 fa 08             	sar    $0x8,%edx
80100caf:	89 d0                	mov    %edx,%eax
80100cb1:	89 da                	mov    %ebx,%edx
80100cb3:	ee                   	out    %al,(%dx)
80100cb4:	b8 0f 00 00 00       	mov    $0xf,%eax
80100cb9:	89 fa                	mov    %edi,%edx
80100cbb:	ee                   	out    %al,(%dx)
80100cbc:	89 c8                	mov    %ecx,%eax
80100cbe:	89 da                	mov    %ebx,%edx
80100cc0:	ee                   	out    %al,(%dx)
    uartputc('\b');
80100cc1:	83 ec 0c             	sub    $0xc,%esp
  for (uint i = input.e; i <= input.end_pos; i++)
80100cc4:	83 c6 01             	add    $0x1,%esi
    uartputc('\b');
80100cc7:	6a 08                	push   $0x8
80100cc9:	e8 c2 6d 00 00       	call   80107a90 <uartputc>
  for (uint i = input.e; i <= input.end_pos; i++)
80100cce:	83 c4 10             	add    $0x10,%esp
80100cd1:	39 35 8c a0 10 80    	cmp    %esi,0x8010a08c
80100cd7:	73 8f                	jae    80100c68 <move_chars_right+0x78>
}
80100cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cdc:	5b                   	pop    %ebx
80100cdd:	5e                   	pop    %esi
80100cde:	5f                   	pop    %edi
80100cdf:	5d                   	pop    %ebp
80100ce0:	c3                   	ret
80100ce1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ce8:	00 
80100ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100cf0 <move_to_first_current>:
{
80100cf0:	55                   	push   %ebp
80100cf1:	89 e5                	mov    %esp,%ebp
80100cf3:	57                   	push   %edi
80100cf4:	56                   	push   %esi
80100cf5:	53                   	push   %ebx
80100cf6:	83 ec 08             	sub    $0x8,%esp
  while (j > input.w)
80100cf9:	a1 84 a0 10 80       	mov    0x8010a084,%eax
  int j = input.e;
80100cfe:	8b 35 88 a0 10 80    	mov    0x8010a088,%esi
  while (j > input.w)
80100d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100d07:	39 f0                	cmp    %esi,%eax
80100d09:	0f 83 02 01 00 00    	jae    80100e11 <move_to_first_current+0x121>
80100d0f:	89 75 ec             	mov    %esi,-0x14(%ebp)
80100d12:	89 f3                	mov    %esi,%ebx
80100d14:	31 c9                	xor    %ecx,%ecx
80100d16:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100d1b:	eb 6d                	jmp    80100d8a <move_to_first_current+0x9a>
80100d1d:	8d 76 00             	lea    0x0(%esi),%esi
80100d20:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d25:	89 fa                	mov    %edi,%edx
80100d27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d28:	be d5 03 00 00       	mov    $0x3d5,%esi
80100d2d:	89 f2                	mov    %esi,%edx
80100d2f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100d30:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d33:	89 fa                	mov    %edi,%edx
80100d35:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d3a:	c1 e1 08             	shl    $0x8,%ecx
80100d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d3e:	89 f2                	mov    %esi,%edx
80100d40:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100d41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d44:	89 fa                	mov    %edi,%edx
80100d46:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100d48:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100d4d:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80100d50:	39 c1                	cmp    %eax,%ecx
80100d52:	0f 4f c8             	cmovg  %eax,%ecx
80100d55:	31 c0                	xor    %eax,%eax
80100d57:	85 c9                	test   %ecx,%ecx
80100d59:	0f 48 c8             	cmovs  %eax,%ecx
80100d5c:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d61:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100d62:	89 ca                	mov    %ecx,%edx
80100d64:	c1 fa 08             	sar    $0x8,%edx
80100d67:	89 d0                	mov    %edx,%eax
80100d69:	89 f2                	mov    %esi,%edx
80100d6b:	ee                   	out    %al,(%dx)
80100d6c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d71:	89 fa                	mov    %edi,%edx
80100d73:	ee                   	out    %al,(%dx)
80100d74:	89 c8                	mov    %ecx,%eax
80100d76:	89 f2                	mov    %esi,%edx
80100d78:	ee                   	out    %al,(%dx)
    input.e--;
80100d79:	b9 01 00 00 00       	mov    $0x1,%ecx
80100d7e:	83 eb 01             	sub    $0x1,%ebx
  while (j > input.w)
80100d81:	39 5d f0             	cmp    %ebx,-0x10(%ebp)
80100d84:	0f 83 96 00 00 00    	jae    80100e20 <move_to_first_current+0x130>
    if (input.buf[j % INPUT_BUF] == ' ')
80100d8a:	89 da                	mov    %ebx,%edx
80100d8c:	c1 fa 1f             	sar    $0x1f,%edx
80100d8f:	c1 ea 19             	shr    $0x19,%edx
80100d92:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80100d95:	83 e0 7f             	and    $0x7f,%eax
80100d98:	29 d0                	sub    %edx,%eax
80100d9a:	80 b8 00 a0 10 80 20 	cmpb   $0x20,-0x7fef6000(%eax)
80100da1:	0f 85 79 ff ff ff    	jne    80100d20 <move_to_first_current+0x30>
80100da7:	8b 75 ec             	mov    -0x14(%ebp),%esi
80100daa:	84 c9                	test   %cl,%cl
80100dac:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100db1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100db6:	89 fa                	mov    %edi,%edx
80100db8:	0f 44 de             	cmove  %esi,%ebx
80100dbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dbc:	be d5 03 00 00       	mov    $0x3d5,%esi
80100dc1:	89 f2                	mov    %esi,%edx
80100dc3:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100dc4:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100dc7:	89 fa                	mov    %edi,%edx
80100dc9:	89 c1                	mov    %eax,%ecx
80100dcb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dd0:	c1 e1 08             	shl    $0x8,%ecx
80100dd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dd4:	89 f2                	mov    %esi,%edx
80100dd6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100dd7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100dda:	89 fa                	mov    %edi,%edx
80100ddc:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100dde:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100de3:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80100de6:	39 c1                	cmp    %eax,%ecx
80100de8:	0f 4f c8             	cmovg  %eax,%ecx
80100deb:	b8 0e 00 00 00       	mov    $0xe,%eax
80100df0:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100df1:	89 ca                	mov    %ecx,%edx
80100df3:	c1 fa 08             	sar    $0x8,%edx
80100df6:	89 d0                	mov    %edx,%eax
80100df8:	89 f2                	mov    %esi,%edx
80100dfa:	ee                   	out    %al,(%dx)
80100dfb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e00:	89 fa                	mov    %edi,%edx
80100e02:	ee                   	out    %al,(%dx)
80100e03:	89 c8                	mov    %ecx,%eax
80100e05:	89 f2                	mov    %esi,%edx
80100e07:	ee                   	out    %al,(%dx)
      input.e += 1;
80100e08:	83 c3 01             	add    $0x1,%ebx
80100e0b:	89 1d 88 a0 10 80    	mov    %ebx,0x8010a088
}
80100e11:	83 c4 08             	add    $0x8,%esp
80100e14:	5b                   	pop    %ebx
80100e15:	5e                   	pop    %esi
80100e16:	5f                   	pop    %edi
80100e17:	5d                   	pop    %ebp
80100e18:	c3                   	ret
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e20:	89 1d 88 a0 10 80    	mov    %ebx,0x8010a088
80100e26:	83 c4 08             	add    $0x8,%esp
80100e29:	5b                   	pop    %ebx
80100e2a:	5e                   	pop    %esi
80100e2b:	5f                   	pop    %edi
80100e2c:	5d                   	pop    %ebp
80100e2d:	c3                   	ret
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <move_to_first_previous>:
  int j = input.e;
80100e30:	8b 0d 88 a0 10 80    	mov    0x8010a088,%ecx
  while (j > input.w)
80100e36:	8b 15 84 a0 10 80    	mov    0x8010a084,%edx
80100e3c:	39 ca                	cmp    %ecx,%edx
80100e3e:	0f 83 7a 01 00 00    	jae    80100fbe <move_to_first_previous+0x18e>
{
80100e44:	55                   	push   %ebp
80100e45:	89 e5                	mov    %esp,%ebp
80100e47:	57                   	push   %edi
  while (j > input.w)
80100e48:	89 cf                	mov    %ecx,%edi
{
80100e4a:	56                   	push   %esi
80100e4b:	53                   	push   %ebx
  while (j > input.w)
80100e4c:	31 db                	xor    %ebx,%ebx
{
80100e4e:	83 ec 0c             	sub    $0xc,%esp
  int flag = 0;
80100e51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      flag = 2;
80100e58:	89 4d e8             	mov    %ecx,-0x18(%ebp)
80100e5b:	89 55 ec             	mov    %edx,-0x14(%ebp)
80100e5e:	e9 8d 00 00 00       	jmp    80100ef0 <move_to_first_previous+0xc0>
80100e63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (flag == 1 && input.buf[j % INPUT_BUF] != ' ')
80100e68:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80100e6b:	83 fb 01             	cmp    $0x1,%ebx
80100e6e:	0f 85 1c 01 00 00    	jne    80100f90 <move_to_first_previous+0x160>
      flag = 2;
80100e74:	3c 20                	cmp    $0x20,%al
80100e76:	b8 02 00 00 00       	mov    $0x2,%eax
80100e7b:	0f 44 c3             	cmove  %ebx,%eax
80100e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e81:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e86:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e8b:	89 f2                	mov    %esi,%edx
80100e8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100e8e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100e93:	89 da                	mov    %ebx,%edx
80100e95:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100e96:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e99:	89 f2                	mov    %esi,%edx
80100e9b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ea0:	c1 e1 08             	shl    $0x8,%ecx
80100ea3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ea4:	89 da                	mov    %ebx,%edx
80100ea6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ea7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100eaa:	89 f2                	mov    %esi,%edx
80100eac:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100eae:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100eb3:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80100eb6:	39 c1                	cmp    %eax,%ecx
80100eb8:	0f 4f c8             	cmovg  %eax,%ecx
80100ebb:	31 c0                	xor    %eax,%eax
80100ebd:	85 c9                	test   %ecx,%ecx
80100ebf:	0f 48 c8             	cmovs  %eax,%ecx
80100ec2:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ec7:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100ec8:	89 ca                	mov    %ecx,%edx
80100eca:	c1 fa 08             	sar    $0x8,%edx
80100ecd:	89 d0                	mov    %edx,%eax
80100ecf:	89 da                	mov    %ebx,%edx
80100ed1:	ee                   	out    %al,(%dx)
80100ed2:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ed7:	89 f2                	mov    %esi,%edx
80100ed9:	ee                   	out    %al,(%dx)
80100eda:	89 c8                	mov    %ecx,%eax
80100edc:	89 da                	mov    %ebx,%edx
80100ede:	ee                   	out    %al,(%dx)
    input.e--;
80100edf:	bb 01 00 00 00       	mov    $0x1,%ebx
80100ee4:	83 ef 01             	sub    $0x1,%edi
  while (j > input.w)
80100ee7:	39 7d ec             	cmp    %edi,-0x14(%ebp)
80100eea:	0f 83 c0 00 00 00    	jae    80100fb0 <move_to_first_previous+0x180>
    if (flag == 2 && input.buf[j % INPUT_BUF] == ' ')
80100ef0:	89 fa                	mov    %edi,%edx
80100ef2:	c1 fa 1f             	sar    $0x1f,%edx
80100ef5:	c1 ea 19             	shr    $0x19,%edx
80100ef8:	8d 04 17             	lea    (%edi,%edx,1),%eax
80100efb:	83 e0 7f             	and    $0x7f,%eax
80100efe:	29 d0                	sub    %edx,%eax
80100f00:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100f04:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
80100f0b:	0f 85 57 ff ff ff    	jne    80100e68 <move_to_first_previous+0x38>
80100f11:	3c 20                	cmp    $0x20,%al
80100f13:	0f 85 68 ff ff ff    	jne    80100e81 <move_to_first_previous+0x51>
80100f19:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80100f1c:	84 db                	test   %bl,%bl
80100f1e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f23:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f28:	89 f2                	mov    %esi,%edx
80100f2a:	0f 44 f9             	cmove  %ecx,%edi
80100f2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f2e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100f33:	89 da                	mov    %ebx,%edx
80100f35:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100f36:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f39:	89 f2                	mov    %esi,%edx
80100f3b:	89 c1                	mov    %eax,%ecx
80100f3d:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f42:	c1 e1 08             	shl    $0x8,%ecx
80100f45:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f46:	89 da                	mov    %ebx,%edx
80100f48:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100f49:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f4c:	89 f2                	mov    %esi,%edx
80100f4e:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80100f50:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80100f55:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80100f58:	39 c1                	cmp    %eax,%ecx
80100f5a:	0f 4f c8             	cmovg  %eax,%ecx
80100f5d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f62:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100f63:	89 ca                	mov    %ecx,%edx
80100f65:	c1 fa 08             	sar    $0x8,%edx
80100f68:	89 d0                	mov    %edx,%eax
80100f6a:	89 da                	mov    %ebx,%edx
80100f6c:	ee                   	out    %al,(%dx)
80100f6d:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f72:	89 f2                	mov    %esi,%edx
80100f74:	ee                   	out    %al,(%dx)
80100f75:	89 c8                	mov    %ecx,%eax
80100f77:	89 da                	mov    %ebx,%edx
80100f79:	ee                   	out    %al,(%dx)
      input.e++;
80100f7a:	8d 47 01             	lea    0x1(%edi),%eax
80100f7d:	a3 88 a0 10 80       	mov    %eax,0x8010a088
}
80100f82:	83 c4 0c             	add    $0xc,%esp
80100f85:	5b                   	pop    %ebx
80100f86:	5e                   	pop    %esi
80100f87:	5f                   	pop    %edi
80100f88:	5d                   	pop    %ebp
80100f89:	c3                   	ret
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (input.buf[j % INPUT_BUF] == ' ' && flag == 0)
80100f90:	8b 75 f0             	mov    -0x10(%ebp),%esi
80100f93:	85 f6                	test   %esi,%esi
80100f95:	0f 85 e6 fe ff ff    	jne    80100e81 <move_to_first_previous+0x51>
80100f9b:	3c 20                	cmp    $0x20,%al
80100f9d:	b8 01 00 00 00       	mov    $0x1,%eax
80100fa2:	0f 45 c6             	cmovne %esi,%eax
80100fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa8:	e9 d4 fe ff ff       	jmp    80100e81 <move_to_first_previous+0x51>
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
80100fb0:	89 3d 88 a0 10 80    	mov    %edi,0x8010a088
}
80100fb6:	83 c4 0c             	add    $0xc,%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
80100fbd:	c3                   	ret
80100fbe:	c3                   	ret
80100fbf:	90                   	nop

80100fc0 <print_select>:
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
  if (s1 < s2)
80100fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcc:	39 45 08             	cmp    %eax,0x8(%ebp)
80100fcf:	0f 83 34 01 00 00    	jae    80101109 <print_select+0x149>
    max = s2;
80100fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    min = s1;
80100fd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdb:	be d4 03 00 00       	mov    $0x3d4,%esi
80100fe0:	b8 0e 00 00 00       	mov    $0xe,%eax
80100fe5:	89 f2                	mov    %esi,%edx
80100fe7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100fe8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100fed:	89 da                	mov    %ebx,%edx
80100fef:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100ff0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ff3:	89 f2                	mov    %esi,%edx
80100ff5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ffa:	c1 e1 08             	shl    $0x8,%ecx
80100ffd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ffe:	89 da                	mov    %ebx,%edx
80101000:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101001:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101004:	89 f2                	mov    %esi,%edx
80101006:	09 c8                	or     %ecx,%eax
  int delta = (int)(min - input.e);
80101008:	89 f9                	mov    %edi,%ecx
8010100a:	2b 0d 88 a0 10 80    	sub    0x8010a088,%ecx
  pos += delta;
80101010:	01 c1                	add    %eax,%ecx
  if (pos >= 25 * 80)
80101012:	b8 cf 07 00 00       	mov    $0x7cf,%eax
80101017:	39 c1                	cmp    %eax,%ecx
80101019:	0f 4f c8             	cmovg  %eax,%ecx
8010101c:	31 c0                	xor    %eax,%eax
8010101e:	85 c9                	test   %ecx,%ecx
80101020:	0f 48 c8             	cmovs  %eax,%ecx
80101023:	b8 0e 00 00 00       	mov    $0xe,%eax
80101028:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101029:	89 ca                	mov    %ecx,%edx
8010102b:	c1 fa 08             	sar    $0x8,%edx
8010102e:	89 d0                	mov    %edx,%eax
80101030:	89 da                	mov    %ebx,%edx
80101032:	ee                   	out    %al,(%dx)
80101033:	b8 0f 00 00 00       	mov    $0xf,%eax
80101038:	89 f2                	mov    %esi,%edx
8010103a:	ee                   	out    %al,(%dx)
8010103b:	89 c8                	mov    %ecx,%eax
8010103d:	89 da                	mov    %ebx,%edx
8010103f:	ee                   	out    %al,(%dx)
  for (uint i = min; i <= max; i++)
80101040:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101043:	0f 82 ce 00 00 00    	jb     80101117 <print_select+0x157>
80101049:	89 fb                	mov    %edi,%ebx
    consputc(input.buf[i % INPUT_BUF]);
8010104b:	89 d8                	mov    %ebx,%eax
  if (panicked)
8010104d:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
    consputc(input.buf[i % INPUT_BUF]);
80101053:	83 e0 7f             	and    $0x7f,%eax
80101056:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
  if (panicked)
8010105d:	85 d2                	test   %edx,%edx
8010105f:	74 07                	je     80101068 <print_select+0xa8>
  asm volatile("cli");
80101061:	fa                   	cli
    for (;;)
80101062:	eb fe                	jmp    80101062 <print_select+0xa2>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80101068:	83 ec 0c             	sub    $0xc,%esp
    consputc(input.buf[i % INPUT_BUF]);
8010106b:	0f be f0             	movsbl %al,%esi
  for (uint i = min; i <= max; i++)
8010106e:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80101071:	56                   	push   %esi
80101072:	e8 19 6a 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80101077:	89 f0                	mov    %esi,%eax
80101079:	e8 82 f3 ff ff       	call   80100400 <cgaputc>
  for (uint i = min; i <= max; i++)
8010107e:	83 c4 10             	add    $0x10,%esp
80101081:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80101084:	73 c5                	jae    8010104b <print_select+0x8b>
  if (s1 > s2)
80101086:	8b 45 08             	mov    0x8(%ebp),%eax
80101089:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010108c:	0f 83 8d 00 00 00    	jae    8010111f <print_select+0x15f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101092:	be d4 03 00 00       	mov    $0x3d4,%esi
80101097:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010109e:	00 
8010109f:	90                   	nop
801010a0:	b8 0e 00 00 00       	mov    $0xe,%eax
801010a5:	89 f2                	mov    %esi,%edx
801010a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801010a8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801010ad:	89 da                	mov    %ebx,%edx
801010af:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801010b0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801010b3:	89 f2                	mov    %esi,%edx
801010b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801010ba:	c1 e1 08             	shl    $0x8,%ecx
801010bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801010be:	89 da                	mov    %ebx,%edx
801010c0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801010c1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801010c4:	89 f2                	mov    %esi,%edx
801010c6:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
801010c8:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801010cd:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
801010d0:	39 c1                	cmp    %eax,%ecx
801010d2:	0f 4f c8             	cmovg  %eax,%ecx
801010d5:	31 c0                	xor    %eax,%eax
801010d7:	85 c9                	test   %ecx,%ecx
801010d9:	0f 48 c8             	cmovs  %eax,%ecx
801010dc:	b8 0e 00 00 00       	mov    $0xe,%eax
801010e1:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801010e2:	89 ca                	mov    %ecx,%edx
801010e4:	c1 fa 08             	sar    $0x8,%edx
801010e7:	89 d0                	mov    %edx,%eax
801010e9:	89 da                	mov    %ebx,%edx
801010eb:	ee                   	out    %al,(%dx)
801010ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801010f1:	89 f2                	mov    %esi,%edx
801010f3:	ee                   	out    %al,(%dx)
801010f4:	89 c8                	mov    %ecx,%eax
801010f6:	89 da                	mov    %ebx,%edx
801010f8:	ee                   	out    %al,(%dx)
    for (uint i = min; i <= max; i++)
801010f9:	83 c7 01             	add    $0x1,%edi
801010fc:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ff:	73 9f                	jae    801010a0 <print_select+0xe0>
}
80101101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101104:	5b                   	pop    %ebx
80101105:	5e                   	pop    %esi
80101106:	5f                   	pop    %edi
80101107:	5d                   	pop    %ebp
80101108:	c3                   	ret
    max = s1;
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
    min = s2;
8010110c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    max = s1;
8010110f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101112:	e9 c4 fe ff ff       	jmp    80100fdb <print_select+0x1b>
  if (s1 > s2)
80101117:	8b 45 08             	mov    0x8(%ebp),%eax
8010111a:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010111d:	72 e2                	jb     80101101 <print_select+0x141>
8010111f:	be d4 03 00 00       	mov    $0x3d4,%esi
80101124:	b8 0e 00 00 00       	mov    $0xe,%eax
80101129:	89 f2                	mov    %esi,%edx
8010112b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010112c:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101131:	89 da                	mov    %ebx,%edx
80101133:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101134:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101137:	bf 0f 00 00 00       	mov    $0xf,%edi
8010113c:	89 f2                	mov    %esi,%edx
8010113e:	89 c1                	mov    %eax,%ecx
80101140:	89 f8                	mov    %edi,%eax
80101142:	c1 e1 08             	shl    $0x8,%ecx
80101145:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101146:	89 da                	mov    %ebx,%edx
80101148:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101149:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010114c:	89 f2                	mov    %esi,%edx
8010114e:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101150:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80101155:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80101158:	39 c1                	cmp    %eax,%ecx
8010115a:	0f 4f c8             	cmovg  %eax,%ecx
8010115d:	31 c0                	xor    %eax,%eax
8010115f:	85 c9                	test   %ecx,%ecx
80101161:	0f 48 c8             	cmovs  %eax,%ecx
80101164:	b8 0e 00 00 00       	mov    $0xe,%eax
80101169:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
8010116a:	89 c8                	mov    %ecx,%eax
8010116c:	89 da                	mov    %ebx,%edx
8010116e:	c1 f8 08             	sar    $0x8,%eax
80101171:	ee                   	out    %al,(%dx)
80101172:	89 f8                	mov    %edi,%eax
80101174:	89 f2                	mov    %esi,%edx
80101176:	ee                   	out    %al,(%dx)
80101177:	89 c8                	mov    %ecx,%eax
80101179:	89 da                	mov    %ebx,%edx
8010117b:	ee                   	out    %al,(%dx)
}
8010117c:	eb 83                	jmp    80101101 <print_select+0x141>
8010117e:	66 90                	xchg   %ax,%ax

80101180 <delete_selected>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 0c             	sub    $0xc,%esp
  if (input.s1 <= input.s2)
80101189:	8b 0d 94 a0 10 80    	mov    0x8010a094,%ecx
8010118f:	8b 35 98 a0 10 80    	mov    0x8010a098,%esi
  input.mode = 0;
80101195:	c7 05 9c a0 10 80 00 	movl   $0x0,0x8010a09c
8010119c:	00 00 00 
  if (input.s1 <= input.s2)
8010119f:	39 ce                	cmp    %ecx,%esi
801011a1:	72 7d                	jb     80101220 <delete_selected+0xa0>
801011a3:	bf d4 03 00 00       	mov    $0x3d4,%edi
801011a8:	b8 0e 00 00 00       	mov    $0xe,%eax
801011ad:	89 fa                	mov    %edi,%edx
801011af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801011b0:	ba d5 03 00 00       	mov    $0x3d5,%edx
801011b5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801011b6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801011b9:	89 fa                	mov    %edi,%edx
801011bb:	89 c3                	mov    %eax,%ebx
801011bd:	b8 0f 00 00 00       	mov    $0xf,%eax
801011c2:	c1 e3 08             	shl    $0x8,%ebx
801011c5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801011c6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801011cb:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801011cc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801011cf:	89 fa                	mov    %edi,%edx
801011d1:	09 c3                	or     %eax,%ebx
  if (pos >= 25 * 80)
801011d3:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801011d8:	83 c3 01             	add    $0x1,%ebx
  if (pos >= 25 * 80)
801011db:	39 c3                	cmp    %eax,%ebx
801011dd:	0f 4f d8             	cmovg  %eax,%ebx
801011e0:	b8 0e 00 00 00       	mov    $0xe,%eax
801011e5:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801011e6:	89 da                	mov    %ebx,%edx
801011e8:	c1 fa 08             	sar    $0x8,%edx
801011eb:	89 d0                	mov    %edx,%eax
801011ed:	ba d5 03 00 00       	mov    $0x3d5,%edx
801011f2:	ee                   	out    %al,(%dx)
801011f3:	b8 0f 00 00 00       	mov    $0xf,%eax
801011f8:	89 fa                	mov    %edi,%edx
801011fa:	ee                   	out    %al,(%dx)
801011fb:	ba d5 03 00 00       	mov    $0x3d5,%edx
80101200:	89 d8                	mov    %ebx,%eax
80101202:	ee                   	out    %al,(%dx)
    input.e++;
80101203:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101208:	83 c0 01             	add    $0x1,%eax
8010120b:	a3 88 a0 10 80       	mov    %eax,0x8010a088
  for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
80101210:	39 ce                	cmp    %ecx,%esi
80101212:	0f 89 82 00 00 00    	jns    8010129a <delete_selected+0x11a>
}
80101218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121b:	5b                   	pop    %ebx
8010121c:	5e                   	pop    %esi
8010121d:	5f                   	pop    %edi
8010121e:	5d                   	pop    %ebp
8010121f:	c3                   	ret
80101220:	bf d4 03 00 00       	mov    $0x3d4,%edi
    input.s2 = temp;
80101225:	89 0d 98 a0 10 80    	mov    %ecx,0x8010a098
8010122b:	b8 0e 00 00 00       	mov    $0xe,%eax
    move_cursor(1 + (int)(input.s2 - input.s1));
80101230:	29 f1                	sub    %esi,%ecx
    input.s1 = input.s2;
80101232:	89 35 94 a0 10 80    	mov    %esi,0x8010a094
80101238:	89 fa                	mov    %edi,%edx
8010123a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010123b:	be d5 03 00 00       	mov    $0x3d5,%esi
80101240:	89 f2                	mov    %esi,%edx
80101242:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101243:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101246:	89 fa                	mov    %edi,%edx
80101248:	b8 0f 00 00 00       	mov    $0xf,%eax
8010124d:	c1 e3 08             	shl    $0x8,%ebx
80101250:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101251:	89 f2                	mov    %esi,%edx
80101253:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101254:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101257:	89 fa                	mov    %edi,%edx
80101259:	09 d8                	or     %ebx,%eax
  pos += delta;
8010125b:	8d 5c 01 01          	lea    0x1(%ecx,%eax,1),%ebx
  if (pos >= 25 * 80)
8010125f:	b8 cf 07 00 00       	mov    $0x7cf,%eax
80101264:	39 c3                	cmp    %eax,%ebx
80101266:	0f 4f d8             	cmovg  %eax,%ebx
80101269:	31 c0                	xor    %eax,%eax
8010126b:	85 db                	test   %ebx,%ebx
8010126d:	0f 48 d8             	cmovs  %eax,%ebx
80101270:	b8 0e 00 00 00       	mov    $0xe,%eax
80101275:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101276:	89 da                	mov    %ebx,%edx
80101278:	c1 fa 08             	sar    $0x8,%edx
8010127b:	89 d0                	mov    %edx,%eax
8010127d:	89 f2                	mov    %esi,%edx
8010127f:	ee                   	out    %al,(%dx)
80101280:	b8 0f 00 00 00       	mov    $0xf,%eax
80101285:	89 fa                	mov    %edi,%edx
80101287:	ee                   	out    %al,(%dx)
80101288:	89 d8                	mov    %ebx,%eax
8010128a:	89 f2                	mov    %esi,%edx
8010128c:	ee                   	out    %al,(%dx)
    for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
8010128d:	85 c9                	test   %ecx,%ecx
8010128f:	78 87                	js     80101218 <delete_selected+0x98>
80101291:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101296:	8d 44 01 01          	lea    0x1(%ecx,%eax,1),%eax
{
8010129a:	31 db                	xor    %ebx,%ebx
    if (input.e < input.end_pos)
8010129c:	8b 15 8c a0 10 80    	mov    0x8010a08c,%edx
      input.e--;
801012a2:	8d 70 ff             	lea    -0x1(%eax),%esi
  if (panicked)
801012a5:	8b 0d f8 17 11 80    	mov    0x801117f8,%ecx
      input.e--;
801012ab:	89 35 88 a0 10 80    	mov    %esi,0x8010a088
    if (input.e < input.end_pos)
801012b1:	39 d0                	cmp    %edx,%eax
801012b3:	73 0b                	jae    801012c0 <delete_selected+0x140>
  if (panicked)
801012b5:	85 c9                	test   %ecx,%ecx
801012b7:	74 67                	je     80101320 <delete_selected+0x1a0>
  asm volatile("cli");
801012b9:	fa                   	cli
    for (;;)
801012ba:	eb fe                	jmp    801012ba <delete_selected+0x13a>
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      input.end_pos--;
801012c0:	83 ea 01             	sub    $0x1,%edx
801012c3:	89 15 8c a0 10 80    	mov    %edx,0x8010a08c
  if (panicked)
801012c9:	85 c9                	test   %ecx,%ecx
801012cb:	75 4c                	jne    80101319 <delete_selected+0x199>
    uartputc('\b');
801012cd:	83 ec 0c             	sub    $0xc,%esp
801012d0:	6a 08                	push   $0x8
801012d2:	e8 b9 67 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
801012d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801012de:	e8 ad 67 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
801012e3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801012ea:	e8 a1 67 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801012ef:	b8 00 01 00 00       	mov    $0x100,%eax
801012f4:	e8 07 f1 ff ff       	call   80100400 <cgaputc>
}
801012f9:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
801012fc:	a1 98 a0 10 80       	mov    0x8010a098,%eax
80101301:	83 c3 01             	add    $0x1,%ebx
80101304:	2b 05 94 a0 10 80    	sub    0x8010a094,%eax
8010130a:	39 d8                	cmp    %ebx,%eax
8010130c:	0f 8c 06 ff ff ff    	jl     80101218 <delete_selected+0x98>
80101312:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101317:	eb 83                	jmp    8010129c <delete_selected+0x11c>
80101319:	fa                   	cli
    for (;;)
8010131a:	eb fe                	jmp    8010131a <delete_selected+0x19a>
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80101320:	83 ec 0c             	sub    $0xc,%esp
80101323:	6a 08                	push   $0x8
80101325:	e8 66 67 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
8010132a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101331:	e8 5a 67 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
80101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010133d:	e8 4e 67 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80101342:	b8 00 01 00 00       	mov    $0x100,%eax
80101347:	e8 b4 f0 ff ff       	call   80100400 <cgaputc>
      move_chars_left();  //NOTE
8010134c:	e8 af f7 ff ff       	call   80100b00 <move_chars_left>
      input.end_pos--;
80101351:	83 2d 8c a0 10 80 01 	subl   $0x1,0x8010a08c
80101358:	83 c4 10             	add    $0x10,%esp
8010135b:	eb 9f                	jmp    801012fc <delete_selected+0x17c>
8010135d:	8d 76 00             	lea    0x0(%esi),%esi

80101360 <move_timed_chars_right>:
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	56                   	push   %esi
80101364:	8b 75 08             	mov    0x8(%ebp),%esi
80101367:	53                   	push   %ebx
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
80101368:	83 fe 7e             	cmp    $0x7e,%esi
8010136b:	77 39                	ja     801013a6 <move_timed_chars_right+0x46>
8010136d:	b9 7e 00 00 00       	mov    $0x7e,%ecx
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
80101378:	89 c8                	mov    %ecx,%eax
8010137a:	8d 59 01             	lea    0x1(%ecx),%ebx
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
8010137d:	83 e9 01             	sub    $0x1,%ecx
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
80101380:	83 e0 7f             	and    $0x7f,%eax
80101383:	83 e3 7f             	and    $0x7f,%ebx
80101386:	8b 14 c5 24 0f 11 80 	mov    -0x7feef0dc(,%eax,8),%edx
8010138d:	8b 04 c5 20 0f 11 80 	mov    -0x7feef0e0(,%eax,8),%eax
80101394:	89 14 dd 24 0f 11 80 	mov    %edx,-0x7feef0dc(,%ebx,8)
8010139b:	89 04 dd 20 0f 11 80 	mov    %eax,-0x7feef0e0(,%ebx,8)
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
801013a2:	39 f1                	cmp    %esi,%ecx
801013a4:	73 d2                	jae    80101378 <move_timed_chars_right+0x18>
}
801013a6:	5b                   	pop    %ebx
801013a7:	5e                   	pop    %esi
801013a8:	5d                   	pop    %ebp
801013a9:	c3                   	ret
801013aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013b0 <find_max_char_time_index>:
  for (uint i = 0; i < INPUT_BUF; i++)
801013b0:	31 c0                	xor    %eax,%eax
  uint max_time = 0;
801013b2:	31 c9                	xor    %ecx,%ecx
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (times_buf[i].time >= max_time)
801013b8:	8b 14 c5 24 0f 11 80 	mov    -0x7feef0dc(,%eax,8),%edx
801013bf:	39 ca                	cmp    %ecx,%edx
801013c1:	72 35                	jb     801013f8 <find_max_char_time_index+0x48>
{
801013c3:	55                   	push   %ebp
801013c4:	89 e5                	mov    %esp,%ebp
801013c6:	53                   	push   %ebx
      max_index = i;
801013c7:	89 c3                	mov    %eax,%ebx
  for (uint i = 0; i < INPUT_BUF; i++)
801013c9:	83 c0 01             	add    $0x1,%eax
      max_time = times_buf[i].time;
801013cc:	89 d1                	mov    %edx,%ecx
  for (uint i = 0; i < INPUT_BUF; i++)
801013ce:	3d 80 00 00 00       	cmp    $0x80,%eax
801013d3:	74 15                	je     801013ea <find_max_char_time_index+0x3a>
    if (times_buf[i].time >= max_time)
801013d5:	8b 14 c5 24 0f 11 80 	mov    -0x7feef0dc(,%eax,8),%edx
801013dc:	39 ca                	cmp    %ecx,%edx
801013de:	73 e7                	jae    801013c7 <find_max_char_time_index+0x17>
  for (uint i = 0; i < INPUT_BUF; i++)
801013e0:	83 c0 01             	add    $0x1,%eax
801013e3:	3d 80 00 00 00       	cmp    $0x80,%eax
801013e8:	75 eb                	jne    801013d5 <find_max_char_time_index+0x25>
}
801013ea:	89 d8                	mov    %ebx,%eax
801013ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013ef:	c9                   	leave
801013f0:	c3                   	ret
801013f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (uint i = 0; i < INPUT_BUF; i++)
801013f8:	83 c0 01             	add    $0x1,%eax
801013fb:	3d 80 00 00 00       	cmp    $0x80,%eax
80101400:	75 b6                	jne    801013b8 <find_max_char_time_index+0x8>
}
80101402:	89 d8                	mov    %ebx,%eax
80101404:	c3                   	ret
80101405:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010140c:	00 
8010140d:	8d 76 00             	lea    0x0(%esi),%esi

80101410 <move_timed_chars_left>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	83 ec 1c             	sub    $0x1c,%esp
80101419:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010141c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for (uint i = start_index; i < INPUT_BUF - 1; i++)
8010141f:	83 f9 7e             	cmp    $0x7e,%ecx
80101422:	77 28                	ja     8010144c <move_timed_chars_left+0x3c>
80101424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    times_buf[(i) % INPUT_BUF] = times_buf[(i + 1) % INPUT_BUF];
80101428:	83 c1 01             	add    $0x1,%ecx
8010142b:	8b 04 cd 20 0f 11 80 	mov    -0x7feef0e0(,%ecx,8),%eax
80101432:	8b 14 cd 24 0f 11 80 	mov    -0x7feef0dc(,%ecx,8),%edx
80101439:	89 04 cd 18 0f 11 80 	mov    %eax,-0x7feef0e8(,%ecx,8)
80101440:	89 14 cd 1c 0f 11 80 	mov    %edx,-0x7feef0e4(,%ecx,8)
  for (uint i = start_index; i < INPUT_BUF - 1; i++)
80101447:	83 f9 7f             	cmp    $0x7f,%ecx
8010144a:	75 dc                	jne    80101428 <move_timed_chars_left+0x18>
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
8010144c:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
80101451:	83 e8 01             	sub    $0x1,%eax
80101454:	39 c7                	cmp    %eax,%edi
80101456:	0f 83 c5 00 00 00    	jae    80101521 <move_timed_chars_left+0x111>
8010145c:	89 f8                	mov    %edi,%eax
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
8010145e:	8d 58 01             	lea    0x1(%eax),%ebx
80101461:	83 e0 7f             	and    $0x7f,%eax
80101464:	89 da                	mov    %ebx,%edx
80101466:	83 e2 7f             	and    $0x7f,%edx
80101469:	0f b6 92 00 a0 10 80 	movzbl -0x7fef6000(%edx),%edx
80101470:	88 90 00 a0 10 80    	mov    %dl,-0x7fef6000(%eax)
  if (panicked)
80101476:	a1 f8 17 11 80       	mov    0x801117f8,%eax
8010147b:	85 c0                	test   %eax,%eax
8010147d:	74 09                	je     80101488 <move_timed_chars_left+0x78>
8010147f:	fa                   	cli
    for (;;)
80101480:	eb fe                	jmp    80101480 <move_timed_chars_left+0x70>
80101482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(input.buf[i % INPUT_BUF]);
80101488:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
8010148b:	83 ec 0c             	sub    $0xc,%esp
8010148e:	56                   	push   %esi
8010148f:	e8 fc 65 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80101494:	89 f0                	mov    %esi,%eax
80101496:	e8 65 ef ff ff       	call   80100400 <cgaputc>
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
8010149b:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
801014a0:	83 c4 10             	add    $0x10,%esp
801014a3:	8d 50 ff             	lea    -0x1(%eax),%edx
801014a6:	39 d3                	cmp    %edx,%ebx
801014a8:	73 04                	jae    801014ae <move_timed_chars_left+0x9e>
801014aa:	89 d8                	mov    %ebx,%eax
801014ac:	eb b0                	jmp    8010145e <move_timed_chars_left+0x4e>
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
801014ae:	39 d7                	cmp    %edx,%edi
801014b0:	73 6f                	jae    80101521 <move_timed_chars_left+0x111>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014b5:	be d4 03 00 00       	mov    $0x3d4,%esi
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	b8 0e 00 00 00       	mov    $0xe,%eax
801014c5:	89 f2                	mov    %esi,%edx
801014c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801014c8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801014cd:	89 da                	mov    %ebx,%edx
801014cf:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801014d0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801014d3:	89 f2                	mov    %esi,%edx
801014d5:	b8 0f 00 00 00       	mov    $0xf,%eax
801014da:	c1 e1 08             	shl    $0x8,%ecx
801014dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801014de:	89 da                	mov    %ebx,%edx
801014e0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801014e1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801014e4:	89 f2                	mov    %esi,%edx
801014e6:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
801014e8:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801014ed:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
801014f0:	39 c1                	cmp    %eax,%ecx
801014f2:	0f 4f c8             	cmovg  %eax,%ecx
801014f5:	31 c0                	xor    %eax,%eax
801014f7:	85 c9                	test   %ecx,%ecx
801014f9:	0f 48 c8             	cmovs  %eax,%ecx
801014fc:	b8 0e 00 00 00       	mov    $0xe,%eax
80101501:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101502:	89 ca                	mov    %ecx,%edx
80101504:	c1 fa 08             	sar    $0x8,%edx
80101507:	89 d0                	mov    %edx,%eax
80101509:	89 da                	mov    %ebx,%edx
8010150b:	ee                   	out    %al,(%dx)
8010150c:	b8 0f 00 00 00       	mov    $0xf,%eax
80101511:	89 f2                	mov    %esi,%edx
80101513:	ee                   	out    %al,(%dx)
80101514:	89 c8                	mov    %ecx,%eax
80101516:	89 da                	mov    %ebx,%edx
80101518:	ee                   	out    %al,(%dx)
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
80101519:	83 c7 01             	add    $0x1,%edi
8010151c:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010151f:	75 9f                	jne    801014c0 <move_timed_chars_left+0xb0>
}
80101521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101524:	5b                   	pop    %ebx
80101525:	5e                   	pop    %esi
80101526:	5f                   	pop    %edi
80101527:	5d                   	pop    %ebp
80101528:	c3                   	ret
80101529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101530 <clear_char_time_array>:
  for (int i = 0; i < INPUT_BUF; i++)
80101530:	31 c0                	xor    %eax,%eax
80101532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    times_buf[i].time = 0;
80101538:	c7 04 c5 24 0f 11 80 	movl   $0x0,-0x7feef0dc(,%eax,8)
8010153f:	00 00 00 00 
    times_buf[i].c = '\0';
80101543:	c6 04 c5 20 0f 11 80 	movb   $0x0,-0x7feef0e0(,%eax,8)
8010154a:	00 
  for (int i = 0; i < INPUT_BUF; i++)
8010154b:	83 c0 01             	add    $0x1,%eax
8010154e:	3d 80 00 00 00       	cmp    $0x80,%eax
80101553:	75 e3                	jne    80101538 <clear_char_time_array+0x8>
}
80101555:	c3                   	ret
80101556:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010155d:	00 
8010155e:	66 90                	xchg   %ax,%ax

80101560 <has_prefix>:
int has_prefix(const char *s, const char *p) {
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	8b 55 0c             	mov    0xc(%ebp),%edx
80101566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  while (*p) {
80101569:	0f b6 02             	movzbl (%edx),%eax
8010156c:	84 c0                	test   %al,%al
8010156e:	75 16                	jne    80101586 <has_prefix+0x26>
80101570:	eb 1e                	jmp    80101590 <has_prefix+0x30>
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101578:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    s++; p++;
8010157c:	83 c2 01             	add    $0x1,%edx
8010157f:	83 c1 01             	add    $0x1,%ecx
  while (*p) {
80101582:	84 c0                	test   %al,%al
80101584:	74 0a                	je     80101590 <has_prefix+0x30>
    if (*s != *p) return 0;
80101586:	38 01                	cmp    %al,(%ecx)
80101588:	74 ee                	je     80101578 <has_prefix+0x18>
8010158a:	31 c0                	xor    %eax,%eax
}
8010158c:	5d                   	pop    %ebp
8010158d:	c3                   	ret
8010158e:	66 90                	xchg   %ax,%ax
  return 1;
80101590:	b8 01 00 00 00       	mov    $0x1,%eax
}
80101595:	5d                   	pop    %ebp
80101596:	c3                   	ret
80101597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010159e:	00 
8010159f:	90                   	nop

801015a0 <collect_matches>:
int collect_matches(const char *prefix, int *out_idx, int maxn) {
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
  int n = 0;
801015a4:	31 ff                	xor    %edi,%edi
int collect_matches(const char *prefix, int *out_idx, int maxn) {
801015a6:	56                   	push   %esi
801015a7:	8b 75 08             	mov    0x8(%ebp),%esi
801015aa:	53                   	push   %ebx
  for (int i = 0; i < (int)CMDS_COUNT; i++) {
801015ab:	31 db                	xor    %ebx,%ebx
801015ad:	8d 76 00             	lea    0x0(%esi),%esi
  while (*p) {
801015b0:	0f b6 06             	movzbl (%esi),%eax
    if (has_prefix(cmds[i], prefix)) {
801015b3:	8b 14 9d c0 a0 10 80 	mov    -0x7fef5f40(,%ebx,4),%edx
  while (*p) {
801015ba:	84 c0                	test   %al,%al
801015bc:	74 32                	je     801015f0 <collect_matches+0x50>
801015be:	89 f1                	mov    %esi,%ecx
801015c0:	eb 14                	jmp    801015d6 <collect_matches+0x36>
801015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015c8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    s++; p++;
801015cc:	83 c1 01             	add    $0x1,%ecx
801015cf:	83 c2 01             	add    $0x1,%edx
  while (*p) {
801015d2:	84 c0                	test   %al,%al
801015d4:	74 1a                	je     801015f0 <collect_matches+0x50>
    if (*s != *p) return 0;
801015d6:	38 02                	cmp    %al,(%edx)
801015d8:	74 ee                	je     801015c8 <collect_matches+0x28>
  for (int i = 0; i < (int)CMDS_COUNT; i++) {
801015da:	83 c3 01             	add    $0x1,%ebx
801015dd:	83 fb 13             	cmp    $0x13,%ebx
801015e0:	75 ce                	jne    801015b0 <collect_matches+0x10>
}
801015e2:	5b                   	pop    %ebx
801015e3:	89 f8                	mov    %edi,%eax
801015e5:	5e                   	pop    %esi
801015e6:	5f                   	pop    %edi
801015e7:	5d                   	pop    %ebp
801015e8:	c3                   	ret
801015e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (out_idx && n < maxn) out_idx[n] = i;
801015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f3:	85 c0                	test   %eax,%eax
801015f5:	74 0b                	je     80101602 <collect_matches+0x62>
801015f7:	39 7d 10             	cmp    %edi,0x10(%ebp)
801015fa:	7e 06                	jle    80101602 <collect_matches+0x62>
801015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801015ff:	89 1c b8             	mov    %ebx,(%eax,%edi,4)
  for (int i = 0; i < (int)CMDS_COUNT; i++) {
80101602:	83 c3 01             	add    $0x1,%ebx
      n++;
80101605:	83 c7 01             	add    $0x1,%edi
  for (int i = 0; i < (int)CMDS_COUNT; i++) {
80101608:	83 fb 13             	cmp    $0x13,%ebx
8010160b:	75 a3                	jne    801015b0 <collect_matches+0x10>
8010160d:	eb d3                	jmp    801015e2 <collect_matches+0x42>
8010160f:	90                   	nop

80101610 <consoleintr>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	81 ec b8 01 00 00    	sub    $0x1b8,%esp
8010161c:	8b 45 08             	mov    0x8(%ebp),%eax
8010161f:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  acquire(&cons.lock);
80101625:	68 c0 17 11 80       	push   $0x801117c0
8010162a:	e8 51 4b 00 00       	call   80106180 <acquire>
  if (input.e > input.end_pos)
8010162f:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101634:	83 c4 10             	add    $0x10,%esp
80101637:	39 05 8c a0 10 80    	cmp    %eax,0x8010a08c
8010163d:	73 05                	jae    80101644 <consoleintr+0x34>
    input.end_pos = input.e;
8010163f:	a3 8c a0 10 80       	mov    %eax,0x8010a08c
    switch (c)
80101644:	c7 85 60 fe ff ff 00 	movl   $0x0,-0x1a0(%ebp)
8010164b:	00 00 00 
  while ((c = getc()) >= 0)
8010164e:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
80101654:	ff d0                	call   *%eax
80101656:	89 c3                	mov    %eax,%ebx
80101658:	85 c0                	test   %eax,%eax
8010165a:	0f 88 28 01 00 00    	js     80101788 <consoleintr+0x178>
    if (c == '\n')
80101660:	83 fb 0a             	cmp    $0xa,%ebx
80101663:	74 1b                	je     80101680 <consoleintr+0x70>
    switch (c)
80101665:	83 fb 1a             	cmp    $0x1a,%ebx
80101668:	0f 8f 42 01 00 00    	jg     801017b0 <consoleintr+0x1a0>
8010166e:	85 db                	test   %ebx,%ebx
80101670:	74 dc                	je     8010164e <consoleintr+0x3e>
80101672:	83 fb 1a             	cmp    $0x1a,%ebx
80101675:	77 13                	ja     8010168a <consoleintr+0x7a>
80101677:	ff 24 9d 9c 94 10 80 	jmp    *-0x7fef6b64(,%ebx,4)
8010167e:	66 90                	xchg   %ax,%ax
      tab_count = 0;
80101680:	c7 05 a0 17 11 80 00 	movl   $0x0,0x801117a0
80101687:	00 00 00 
      if (c != 0 && input.e - input.r < INPUT_BUF)
8010168a:	a1 88 a0 10 80       	mov    0x8010a088,%eax
8010168f:	2b 05 80 a0 10 80    	sub    0x8010a080,%eax
80101695:	83 f8 7f             	cmp    $0x7f,%eax
80101698:	77 b4                	ja     8010164e <consoleintr+0x3e>
        if (input.mode == 2)
8010169a:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
801016a1:	0f 84 b2 07 00 00    	je     80101e59 <consoleintr+0x849>
        if ((input.e < input.end_pos) && c != '\n')
801016a7:	8b 15 8c a0 10 80    	mov    0x8010a08c,%edx
        c = (c == '\r') ? '\n' : c;
801016ad:	83 fb 0d             	cmp    $0xd,%ebx
801016b0:	0f 84 aa 01 00 00    	je     80101860 <consoleintr+0x250>
        if ((input.e < input.end_pos) && c != '\n')
801016b6:	a1 88 a0 10 80       	mov    0x8010a088,%eax
801016bb:	39 d0                	cmp    %edx,%eax
801016bd:	0f 83 3d 06 00 00    	jae    80101d00 <consoleintr+0x6f0>
801016c3:	83 fb 0a             	cmp    $0xa,%ebx
801016c6:	0f 84 94 01 00 00    	je     80101860 <consoleintr+0x250>
801016cc:	31 d2                	xor    %edx,%edx
801016ce:	66 90                	xchg   %ax,%ax
            copy_buf[i] = input.buf[i];
801016d0:	8b 8a 00 a0 10 80    	mov    -0x7fef6000(%edx),%ecx
801016d6:	83 c2 04             	add    $0x4,%edx
801016d9:	89 8a 1c 17 11 80    	mov    %ecx,-0x7feee8e4(%edx)
          for (int i = 0; i < INPUT_BUF; i++)
801016df:	81 fa 80 00 00 00    	cmp    $0x80,%edx
801016e5:	75 e9                	jne    801016d0 <consoleintr+0xc0>
          input.buf[input.e++ % INPUT_BUF] = c;
801016e7:	8d 50 01             	lea    0x1(%eax),%edx
801016ea:	83 e0 7f             	and    $0x7f,%eax
801016ed:	88 98 00 a0 10 80    	mov    %bl,-0x7fef6000(%eax)
          consputc(c);
801016f3:	89 d8                	mov    %ebx,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
801016f5:	89 15 88 a0 10 80    	mov    %edx,0x8010a088
          consputc(c);
801016fb:	e8 b0 ee ff ff       	call   801005b0 <consputc>
          move_chars_right();
80101700:	e8 eb f4 ff ff       	call   80100bf0 <move_chars_right>
          uint new_char_time_position_index = input.e - input.w - 1;
80101705:	a1 88 a0 10 80       	mov    0x8010a088,%eax
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
8010170a:	b9 7e 00 00 00       	mov    $0x7e,%ecx
          uint new_char_time_position_index = input.e - input.w - 1;
8010170f:	8d 78 ff             	lea    -0x1(%eax),%edi
80101712:	2b 3d 84 a0 10 80    	sub    0x8010a084,%edi
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
80101718:	83 ff 7e             	cmp    $0x7e,%edi
8010171b:	77 31                	ja     8010174e <consoleintr+0x13e>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
80101720:	89 c8                	mov    %ecx,%eax
80101722:	8d 71 01             	lea    0x1(%ecx),%esi
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
80101725:	83 e9 01             	sub    $0x1,%ecx
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
80101728:	83 e0 7f             	and    $0x7f,%eax
8010172b:	83 e6 7f             	and    $0x7f,%esi
8010172e:	8b 14 c5 24 0f 11 80 	mov    -0x7feef0dc(,%eax,8),%edx
80101735:	8b 04 c5 20 0f 11 80 	mov    -0x7feef0e0(,%eax,8),%eax
8010173c:	89 14 f5 24 0f 11 80 	mov    %edx,-0x7feef0dc(,%esi,8)
80101743:	89 04 f5 20 0f 11 80 	mov    %eax,-0x7feef0e0(,%esi,8)
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
8010174a:	39 f9                	cmp    %edi,%ecx
8010174c:	73 d2                	jae    80101720 <consoleintr+0x110>
          new_char.time = input.time++;
8010174e:	a1 90 a0 10 80       	mov    0x8010a090,%eax
          times_buf[new_char_time_position_index++] = new_char;
80101753:	88 1c fd 20 0f 11 80 	mov    %bl,-0x7feef0e0(,%edi,8)
          input.end_pos++;
8010175a:	83 05 8c a0 10 80 01 	addl   $0x1,0x8010a08c
          new_char.time = input.time++;
80101761:	8d 50 01             	lea    0x1(%eax),%edx
          times_buf[new_char_time_position_index++] = new_char;
80101764:	89 04 fd 24 0f 11 80 	mov    %eax,-0x7feef0dc(,%edi,8)
  while ((c = getc()) >= 0)
8010176b:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
          new_char.time = input.time++;
80101771:	89 15 90 a0 10 80    	mov    %edx,0x8010a090
  while ((c = getc()) >= 0)
80101777:	ff d0                	call   *%eax
80101779:	89 c3                	mov    %eax,%ebx
8010177b:	85 c0                	test   %eax,%eax
8010177d:	0f 89 dd fe ff ff    	jns    80101660 <consoleintr+0x50>
80101783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80101788:	83 ec 0c             	sub    $0xc,%esp
8010178b:	68 c0 17 11 80       	push   $0x801117c0
80101790:	e8 8b 49 00 00       	call   80106120 <release>
  if (doprocdump)
80101795:	8b 85 60 fe ff ff    	mov    -0x1a0(%ebp),%eax
8010179b:	83 c4 10             	add    $0x10,%esp
8010179e:	85 c0                	test   %eax,%eax
801017a0:	0f 85 aa 00 00 00    	jne    80101850 <consoleintr+0x240>
}
801017a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a9:	5b                   	pop    %ebx
801017aa:	5e                   	pop    %esi
801017ab:	5f                   	pop    %edi
801017ac:	5d                   	pop    %ebp
801017ad:	c3                   	ret
801017ae:	66 90                	xchg   %ax,%ax
    switch (c)
801017b0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801017b6:	0f 84 0c 05 00 00    	je     80101cc8 <consoleintr+0x6b8>
801017bc:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801017c2:	74 54                	je     80101818 <consoleintr+0x208>
801017c4:	83 fb 7f             	cmp    $0x7f,%ebx
801017c7:	0f 85 bd fe ff ff    	jne    8010168a <consoleintr+0x7a>
      if (input.mode == 2)
801017cd:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
801017d4:	0f 84 a6 08 00 00    	je     80102080 <consoleintr+0xa70>
      if (input.e != input.w)
801017da:	a1 88 a0 10 80       	mov    0x8010a088,%eax
801017df:	8b 0d 84 a0 10 80    	mov    0x8010a084,%ecx
801017e5:	39 c8                	cmp    %ecx,%eax
801017e7:	0f 84 61 fe ff ff    	je     8010164e <consoleintr+0x3e>
          input.e--;
801017ed:	8d 50 ff             	lea    -0x1(%eax),%edx
        if (input.e < input.end_pos)
801017f0:	3b 05 8c a0 10 80    	cmp    0x8010a08c,%eax
          input.e--;
801017f6:	89 15 88 a0 10 80    	mov    %edx,0x8010a088
        if (input.e < input.end_pos)
801017fc:	0f 83 57 08 00 00    	jae    80102059 <consoleintr+0xa49>
  if (panicked)
80101802:	8b 1d f8 17 11 80    	mov    0x801117f8,%ebx
80101808:	85 db                	test   %ebx,%ebx
8010180a:	0f 84 f6 08 00 00    	je     80102106 <consoleintr+0xaf6>
  asm volatile("cli");
80101810:	fa                   	cli
    for (;;)
80101811:	eb fe                	jmp    80101811 <consoleintr+0x201>
80101813:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.mode == 2)
80101818:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
8010181f:	0f 84 d8 01 00 00    	je     801019fd <consoleintr+0x3ed>
      if (input.e < input.end_pos)
80101825:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
8010182a:	39 05 88 a0 10 80    	cmp    %eax,0x8010a088
80101830:	0f 83 18 fe ff ff    	jae    8010164e <consoleintr+0x3e>
        consputc(KEY_RIGHT);
80101836:	b8 e5 00 00 00       	mov    $0xe5,%eax
8010183b:	e8 70 ed ff ff       	call   801005b0 <consputc>
        input.e++;
80101840:	83 05 88 a0 10 80 01 	addl   $0x1,0x8010a088
80101847:	e9 02 fe ff ff       	jmp    8010164e <consoleintr+0x3e>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80101850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101853:	5b                   	pop    %ebx
80101854:	5e                   	pop    %esi
80101855:	5f                   	pop    %edi
80101856:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
80101857:	e9 44 45 00 00       	jmp    80105da0 <procdump>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	8d 72 01             	lea    0x1(%edx),%esi
          wakeup(&input.r);
80101863:	83 ec 0c             	sub    $0xc,%esp
          input.buf[input.end_pos++ % INPUT_BUF] = c; 
80101866:	83 e2 7f             	and    $0x7f,%edx
80101869:	89 35 8c a0 10 80    	mov    %esi,0x8010a08c
8010186f:	c6 82 00 a0 10 80 0a 	movb   $0xa,-0x7fef6000(%edx)
          input.w = input.end_pos;
80101876:	89 35 84 a0 10 80    	mov    %esi,0x8010a084
          input.e = input.end_pos;
8010187c:	89 35 88 a0 10 80    	mov    %esi,0x8010a088
          wakeup(&input.r);
80101882:	68 80 a0 10 80       	push   $0x8010a080
80101887:	e8 34 44 00 00       	call   80105cc0 <wakeup>
8010188c:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < INPUT_BUF; i++)
8010188f:	31 c0                	xor    %eax,%eax
80101891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    times_buf[i].time = 0;
80101898:	c7 04 c5 24 0f 11 80 	movl   $0x0,-0x7feef0dc(,%eax,8)
8010189f:	00 00 00 00 
    times_buf[i].c = '\0';
801018a3:	c6 04 c5 20 0f 11 80 	movb   $0x0,-0x7feef0e0(,%eax,8)
801018aa:	00 
  for (int i = 0; i < INPUT_BUF; i++)
801018ab:	83 c0 01             	add    $0x1,%eax
801018ae:	3d 80 00 00 00       	cmp    $0x80,%eax
801018b3:	75 e3                	jne    80101898 <consoleintr+0x288>
            input.time = 0;
801018b5:	c7 05 90 a0 10 80 00 	movl   $0x0,0x8010a090
801018bc:	00 00 00 
801018bf:	e9 8a fd ff ff       	jmp    8010164e <consoleintr+0x3e>
  uint max_time = 0;
801018c4:	31 c9                	xor    %ecx,%ecx
  for (uint i = 0; i < INPUT_BUF; i++)
801018c6:	31 c0                	xor    %eax,%eax
      if (input.mode == 2)
801018c8:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
801018cf:	0f 84 28 01 00 00    	je     801019fd <consoleintr+0x3ed>
801018d5:	8b 9d 5c fe ff ff    	mov    -0x1a4(%ebp),%ebx
801018db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (times_buf[i].time >= max_time)
801018e0:	8b 14 c5 24 0f 11 80 	mov    -0x7feef0dc(,%eax,8),%edx
801018e7:	39 ca                	cmp    %ecx,%edx
801018e9:	72 04                	jb     801018ef <consoleintr+0x2df>
      max_time = times_buf[i].time;
801018eb:	89 d1                	mov    %edx,%ecx
      max_index = i;
801018ed:	89 c3                	mov    %eax,%ebx
  for (uint i = 0; i < INPUT_BUF; i++)
801018ef:	83 c0 01             	add    $0x1,%eax
801018f2:	3d 80 00 00 00       	cmp    $0x80,%eax
801018f7:	75 e7                	jne    801018e0 <consoleintr+0x2d0>
      uint interval = input.end_pos - input.w;
801018f9:	a1 84 a0 10 80       	mov    0x8010a084,%eax
801018fe:	8b 35 8c a0 10 80    	mov    0x8010a08c,%esi
80101904:	89 9d 5c fe ff ff    	mov    %ebx,-0x1a4(%ebp)
      uint cursor_index = input.e - input.w - 1;
8010190a:	89 c2                	mov    %eax,%edx
      uint absolute_char_index = input.w + removing_char_index;
8010190c:	01 c3                	add    %eax,%ebx
      uint cursor_index = input.e - input.w - 1;
8010190e:	f7 d2                	not    %edx
80101910:	03 15 88 a0 10 80    	add    0x8010a088,%edx
80101916:	89 95 58 fe ff ff    	mov    %edx,-0x1a8(%ebp)
      if (input.end_pos == input.w)
8010191c:	39 c6                	cmp    %eax,%esi
8010191e:	0f 84 45 09 00 00    	je     80102269 <consoleintr+0xc59>
  if (panicked)
80101924:	8b 0d f8 17 11 80    	mov    0x801117f8,%ecx
      else if (cursor_index > removing_char_index)
8010192a:	8b 95 58 fe ff ff    	mov    -0x1a8(%ebp),%edx
80101930:	39 95 5c fe ff ff    	cmp    %edx,-0x1a4(%ebp)
80101936:	0f 82 54 08 00 00    	jb     80102190 <consoleintr+0xb80>
      uint interval = input.end_pos - input.w;
8010193c:	29 c6                	sub    %eax,%esi
      else if (cursor_index < removing_char_index && removing_char_index < interval)
8010193e:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80101944:	39 f0                	cmp    %esi,%eax
80101946:	0f 83 24 06 00 00    	jae    80101f70 <consoleintr+0x960>
8010194c:	8b bd 58 fe ff ff    	mov    -0x1a8(%ebp),%edi
80101952:	39 c7                	cmp    %eax,%edi
80101954:	0f 83 16 06 00 00    	jae    80101f70 <consoleintr+0x960>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010195a:	89 8d 54 fe ff ff    	mov    %ecx,-0x1ac(%ebp)
80101960:	be d4 03 00 00       	mov    $0x3d4,%esi
80101965:	89 9d 50 fe ff ff    	mov    %ebx,-0x1b0(%ebp)
8010196b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101970:	b8 0e 00 00 00       	mov    $0xe,%eax
80101975:	89 f2                	mov    %esi,%edx
80101977:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101978:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010197d:	89 da                	mov    %ebx,%edx
8010197f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101980:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101983:	89 f2                	mov    %esi,%edx
80101985:	b8 0f 00 00 00       	mov    $0xf,%eax
8010198a:	c1 e1 08             	shl    $0x8,%ecx
8010198d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010198e:	89 da                	mov    %ebx,%edx
80101990:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101991:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101994:	89 f2                	mov    %esi,%edx
80101996:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101998:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
8010199d:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
801019a0:	39 c1                	cmp    %eax,%ecx
801019a2:	0f 4f c8             	cmovg  %eax,%ecx
801019a5:	b8 0e 00 00 00       	mov    $0xe,%eax
801019aa:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801019ab:	89 ca                	mov    %ecx,%edx
801019ad:	c1 fa 08             	sar    $0x8,%edx
801019b0:	89 d0                	mov    %edx,%eax
801019b2:	89 da                	mov    %ebx,%edx
801019b4:	ee                   	out    %al,(%dx)
801019b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801019ba:	89 f2                	mov    %esi,%edx
801019bc:	ee                   	out    %al,(%dx)
801019bd:	89 c8                	mov    %ecx,%eax
801019bf:	89 da                	mov    %ebx,%edx
801019c1:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i < removing_char_index; i++)
801019c2:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
801019c8:	83 c7 01             	add    $0x1,%edi
801019cb:	39 c7                	cmp    %eax,%edi
801019cd:	72 a1                	jb     80101970 <consoleintr+0x360>
  if (panicked)
801019cf:	8b 8d 54 fe ff ff    	mov    -0x1ac(%ebp),%ecx
801019d5:	8b 9d 50 fe ff ff    	mov    -0x1b0(%ebp),%ebx
801019db:	85 c9                	test   %ecx,%ecx
801019dd:	0f 84 af 08 00 00    	je     80102292 <consoleintr+0xc82>
  asm volatile("cli");
801019e3:	fa                   	cli
    for (;;)
801019e4:	eb fe                	jmp    801019e4 <consoleintr+0x3d4>
801019e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019ed:	00 
801019ee:	66 90                	xchg   %ax,%ax
      if (input.mode == 2)
801019f0:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
801019f7:	0f 85 7c 03 00 00    	jne    80101d79 <consoleintr+0x769>
        print_select(input.s1, input.s2);
801019fd:	83 ec 08             	sub    $0x8,%esp
80101a00:	ff 35 98 a0 10 80    	push   0x8010a098
80101a06:	ff 35 94 a0 10 80    	push   0x8010a094
80101a0c:	e8 af f5 ff ff       	call   80100fc0 <print_select>
        input.mode = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 05 9c a0 10 80 00 	movl   $0x0,0x8010a09c
80101a1b:	00 00 00 
80101a1e:	e9 2b fc ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (is_copy == 1)
80101a23:	83 3d 88 0e 11 80 01 	cmpl   $0x1,0x80110e88
80101a2a:	0f 85 1e fc ff ff    	jne    8010164e <consoleintr+0x3e>
        if (input.mode == 2)
80101a30:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
80101a37:	0f 84 83 0a 00 00    	je     801024c0 <consoleintr+0xeb0>
        for (uint i = inedx_copy1; i <= inedx_copy2; i++)
80101a3d:	8b 1d 84 0e 11 80    	mov    0x80110e84,%ebx
80101a43:	39 1d 80 0e 11 80    	cmp    %ebx,0x80110e80
80101a49:	0f 82 ff fb ff ff    	jb     8010164e <consoleintr+0x3e>
          if ((input.e < input.end_pos) && c != '\n')
80101a4f:	a1 88 a0 10 80       	mov    0x8010a088,%eax
          c = ctrl_c[i];
80101a54:	0f be b3 a0 0e 11 80 	movsbl -0x7feef160(%ebx),%esi
          input.buf[input.e++ % INPUT_BUF] = c;
80101a5b:	89 c7                	mov    %eax,%edi
          c = ctrl_c[i];
80101a5d:	89 f2                	mov    %esi,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
80101a5f:	8d 48 01             	lea    0x1(%eax),%ecx
80101a62:	83 e7 7f             	and    $0x7f,%edi
          if ((input.e < input.end_pos) && c != '\n')
80101a65:	3b 05 8c a0 10 80    	cmp    0x8010a08c,%eax
80101a6b:	0f 83 ef 06 00 00    	jae    80102160 <consoleintr+0xb50>
80101a71:	83 fe 0a             	cmp    $0xa,%esi
80101a74:	0f 85 f9 08 00 00    	jne    80102373 <consoleintr+0xd63>
          input.buf[input.e++ % INPUT_BUF] = c;
80101a7a:	89 0d 88 a0 10 80    	mov    %ecx,0x8010a088
80101a80:	c6 87 00 a0 10 80 0a 	movb   $0xa,-0x7fef6000(%edi)
        for (uint i = inedx_copy1; i <= inedx_copy2; i++)
80101a87:	83 c3 01             	add    $0x1,%ebx
80101a8a:	39 1d 80 0e 11 80    	cmp    %ebx,0x80110e80
80101a90:	73 bd                	jae    80101a4f <consoleintr+0x43f>
80101a92:	e9 b7 fb ff ff       	jmp    8010164e <consoleintr+0x3e>
80101a97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a9e:	00 
80101a9f:	90                   	nop
      if (input.mode == 2)
80101aa0:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
80101aa7:	0f 84 50 ff ff ff    	je     801019fd <consoleintr+0x3ed>
      int j = input.e;
80101aad:	a1 88 a0 10 80       	mov    0x8010a088,%eax
      while (j <= input.end_pos)
80101ab2:	8b 3d 8c a0 10 80    	mov    0x8010a08c,%edi
      int j = input.e;
80101ab8:	89 c1                	mov    %eax,%ecx
      while (j <= input.end_pos)
80101aba:	39 c7                	cmp    %eax,%edi
80101abc:	0f 82 8c fb ff ff    	jb     8010164e <consoleintr+0x3e>
      int flag = 0;
80101ac2:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
      int step = 0;
80101ac8:	31 d2                	xor    %edx,%edx
      int flag = 0;
80101aca:	31 f6                	xor    %esi,%esi
80101acc:	eb 1a                	jmp    80101ae8 <consoleintr+0x4d8>
80101ace:	66 90                	xchg   %ax,%ax
        if (input.buf[j % INPUT_BUF] == ' ')
80101ad0:	3c 20                	cmp    $0x20,%al
80101ad2:	0f 94 c0             	sete   %al
80101ad5:	0f b6 c0             	movzbl %al,%eax
80101ad8:	89 c6                	mov    %eax,%esi
        j++;
80101ada:	83 c1 01             	add    $0x1,%ecx
        step++;
80101add:	83 c2 01             	add    $0x1,%edx
      while (j <= input.end_pos)
80101ae0:	39 cf                	cmp    %ecx,%edi
80101ae2:	0f 82 66 fb ff ff    	jb     8010164e <consoleintr+0x3e>
        if (flag == 1 && input.buf[j % INPUT_BUF] != ' ')
80101ae8:	89 cb                	mov    %ecx,%ebx
80101aea:	c1 fb 1f             	sar    $0x1f,%ebx
80101aed:	c1 eb 19             	shr    $0x19,%ebx
80101af0:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
80101af3:	83 e0 7f             	and    $0x7f,%eax
80101af6:	29 d8                	sub    %ebx,%eax
80101af8:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
80101aff:	83 fe 01             	cmp    $0x1,%esi
80101b02:	75 cc                	jne    80101ad0 <consoleintr+0x4c0>
80101b04:	3c 20                	cmp    $0x20,%al
80101b06:	74 d2                	je     80101ada <consoleintr+0x4ca>
80101b08:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
        for (int i = 0; i < step; i++)
80101b0e:	31 ff                	xor    %edi,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b10:	be d4 03 00 00       	mov    $0x3d4,%esi
80101b15:	85 d2                	test   %edx,%edx
80101b17:	0f 84 31 fb ff ff    	je     8010164e <consoleintr+0x3e>
80101b1d:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
80101b23:	89 95 58 fe ff ff    	mov    %edx,-0x1a8(%ebp)
80101b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b30:	b8 0e 00 00 00       	mov    $0xe,%eax
80101b35:	89 f2                	mov    %esi,%edx
80101b37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b38:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101b3d:	89 da                	mov    %ebx,%edx
80101b3f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101b40:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b43:	89 f2                	mov    %esi,%edx
80101b45:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b4a:	c1 e1 08             	shl    $0x8,%ecx
80101b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b4e:	89 da                	mov    %ebx,%edx
80101b50:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101b51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b54:	89 f2                	mov    %esi,%edx
80101b56:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101b58:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80101b5d:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80101b60:	39 c1                	cmp    %eax,%ecx
80101b62:	0f 4f c8             	cmovg  %eax,%ecx
80101b65:	b8 0e 00 00 00       	mov    $0xe,%eax
80101b6a:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101b6b:	89 ca                	mov    %ecx,%edx
80101b6d:	c1 fa 08             	sar    $0x8,%edx
80101b70:	89 d0                	mov    %edx,%eax
80101b72:	89 da                	mov    %ebx,%edx
80101b74:	ee                   	out    %al,(%dx)
80101b75:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b7a:	89 f2                	mov    %esi,%edx
80101b7c:	ee                   	out    %al,(%dx)
80101b7d:	89 c8                	mov    %ecx,%eax
80101b7f:	89 da                	mov    %ebx,%edx
80101b81:	ee                   	out    %al,(%dx)
        for (int i = 0; i < step; i++)
80101b82:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80101b88:	83 c7 01             	add    $0x1,%edi
80101b8b:	39 c7                	cmp    %eax,%edi
80101b8d:	75 a1                	jne    80101b30 <consoleintr+0x520>
80101b8f:	8b 85 54 fe ff ff    	mov    -0x1ac(%ebp),%eax
80101b95:	01 f8                	add    %edi,%eax
80101b97:	a3 88 a0 10 80       	mov    %eax,0x8010a088
80101b9c:	e9 ad fa ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 2)
80101ba1:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
80101ba8:	0f 85 a0 fa ff ff    	jne    8010164e <consoleintr+0x3e>
        is_copy = 1;
80101bae:	c7 05 88 0e 11 80 01 	movl   $0x1,0x80110e88
80101bb5:	00 00 00 
80101bb8:	31 c0                	xor    %eax,%eax
80101bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          ctrl_c[i] = input.buf[i];
80101bc0:	8b 90 00 a0 10 80    	mov    -0x7fef6000(%eax),%edx
80101bc6:	83 c0 04             	add    $0x4,%eax
80101bc9:	89 90 9c 0e 11 80    	mov    %edx,-0x7feef164(%eax)
        for (int i = 0; i < INPUT_BUF; i++)
80101bcf:	3d 80 00 00 00       	cmp    $0x80,%eax
80101bd4:	75 ea                	jne    80101bc0 <consoleintr+0x5b0>
        if (input.s1 <= input.s2)
80101bd6:	a1 94 a0 10 80       	mov    0x8010a094,%eax
80101bdb:	8b 15 98 a0 10 80    	mov    0x8010a098,%edx
          inedx_copy1 = input.s1 % INPUT_BUF;
80101be1:	89 c1                	mov    %eax,%ecx
          inedx_copy2 = input.s2 % INPUT_BUF;
80101be3:	89 d3                	mov    %edx,%ebx
80101be5:	83 e3 7f             	and    $0x7f,%ebx
          inedx_copy1 = input.s1 % INPUT_BUF;
80101be8:	83 e1 7f             	and    $0x7f,%ecx
        if (input.s1 <= input.s2)
80101beb:	39 c2                	cmp    %eax,%edx
80101bed:	0f 82 6f 07 00 00    	jb     80102362 <consoleintr+0xd52>
          inedx_copy1 = input.s1 % INPUT_BUF;
80101bf3:	89 0d 84 0e 11 80    	mov    %ecx,0x80110e84
          inedx_copy2 = input.s2 % INPUT_BUF;
80101bf9:	89 1d 80 0e 11 80    	mov    %ebx,0x80110e80
80101bff:	e9 4a fa ff ff       	jmp    8010164e <consoleintr+0x3e>
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.mode == 2)
80101c08:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
80101c0f:	0f 84 e8 fd ff ff    	je     801019fd <consoleintr+0x3ed>
      if (input.e != input.w)
80101c15:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101c1a:	3b 05 84 a0 10 80    	cmp    0x8010a084,%eax
80101c20:	0f 84 28 fa ff ff    	je     8010164e <consoleintr+0x3e>
        if (input.buf[j % INPUT_BUF] == ' ' || input.buf[(j - 1) % INPUT_BUF] == ' ')
80101c26:	89 c1                	mov    %eax,%ecx
80101c28:	c1 f9 1f             	sar    $0x1f,%ecx
80101c2b:	c1 e9 19             	shr    $0x19,%ecx
80101c2e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80101c31:	83 e2 7f             	and    $0x7f,%edx
80101c34:	29 ca                	sub    %ecx,%edx
80101c36:	80 ba 00 a0 10 80 20 	cmpb   $0x20,-0x7fef6000(%edx)
80101c3d:	0f 84 0c 04 00 00    	je     8010204f <consoleintr+0xa3f>
80101c43:	83 e8 01             	sub    $0x1,%eax
80101c46:	99                   	cltd
80101c47:	c1 ea 19             	shr    $0x19,%edx
80101c4a:	01 d0                	add    %edx,%eax
80101c4c:	83 e0 7f             	and    $0x7f,%eax
80101c4f:	29 d0                	sub    %edx,%eax
80101c51:	80 b8 00 a0 10 80 20 	cmpb   $0x20,-0x7fef6000(%eax)
80101c58:	0f 84 f1 03 00 00    	je     8010204f <consoleintr+0xa3f>
          move_to_first_current();
80101c5e:	e8 8d f0 ff ff       	call   80100cf0 <move_to_first_current>
80101c63:	e9 e6 f9 ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 0)
80101c68:	a1 9c a0 10 80       	mov    0x8010a09c,%eax
80101c6d:	85 c0                	test   %eax,%eax
80101c6f:	0f 84 cb 01 00 00    	je     80101e40 <consoleintr+0x830>
      else if (input.mode == 1)
80101c75:	83 f8 01             	cmp    $0x1,%eax
80101c78:	0f 84 b2 05 00 00    	je     80102230 <consoleintr+0xc20>
      else if (input.mode == 2)
80101c7e:	83 f8 02             	cmp    $0x2,%eax
80101c81:	0f 85 c7 f9 ff ff    	jne    8010164e <consoleintr+0x3e>
80101c87:	e9 71 fd ff ff       	jmp    801019fd <consoleintr+0x3ed>
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.end_pos) {
80101c90:	8b 0d 88 a0 10 80    	mov    0x8010a088,%ecx
80101c96:	3b 0d 8c a0 10 80    	cmp    0x8010a08c,%ecx
80101c9c:	0f 85 ac f9 ff ff    	jne    8010164e <consoleintr+0x3e>
      if (pos < (int)input.w) {
80101ca2:	8b 35 84 a0 10 80    	mov    0x8010a084,%esi
      int pos = input.e - 1;
80101ca8:	8d 51 ff             	lea    -0x1(%ecx),%edx
      if (pos < (int)input.w) {
80101cab:	39 d6                	cmp    %edx,%esi
80101cad:	0f 8e d7 01 00 00    	jle    80101e8a <consoleintr+0x87a>
        tab_count = 0;
80101cb3:	c7 05 a0 17 11 80 00 	movl   $0x0,0x801117a0
80101cba:	00 00 00 
        break;
80101cbd:	e9 8c f9 ff ff       	jmp    8010164e <consoleintr+0x3e>
80101cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (input.mode == 2)
80101cc8:	83 3d 9c a0 10 80 02 	cmpl   $0x2,0x8010a09c
80101ccf:	0f 84 28 fd ff ff    	je     801019fd <consoleintr+0x3ed>
      if (input.e > input.w)
80101cd5:	a1 88 a0 10 80       	mov    0x8010a088,%eax
80101cda:	39 05 84 a0 10 80    	cmp    %eax,0x8010a084
80101ce0:	0f 83 68 f9 ff ff    	jae    8010164e <consoleintr+0x3e>
  if (panicked)
80101ce6:	8b 3d f8 17 11 80    	mov    0x801117f8,%edi
80101cec:	85 ff                	test   %edi,%edi
80101cee:	0f 84 ca 03 00 00    	je     801020be <consoleintr+0xaae>
  asm volatile("cli");
80101cf4:	fa                   	cli
    for (;;)
80101cf5:	eb fe                	jmp    80101cf5 <consoleintr+0x6e5>
80101cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cfe:	00 
80101cff:	90                   	nop
        if (input.e == input.end_pos + 1)
80101d00:	8d 72 01             	lea    0x1(%edx),%esi
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
80101d03:	83 fb 0a             	cmp    $0xa,%ebx
80101d06:	0f 84 57 fb ff ff    	je     80101863 <consoleintr+0x253>
80101d0c:	8b 3d 80 a0 10 80    	mov    0x8010a080,%edi
80101d12:	8d 8f 80 00 00 00    	lea    0x80(%edi),%ecx
80101d18:	39 c8                	cmp    %ecx,%eax
80101d1a:	0f 84 ff 02 00 00    	je     8010201f <consoleintr+0xa0f>
        input.buf[input.e++ % INPUT_BUF] = c;
80101d20:	8d 48 01             	lea    0x1(%eax),%ecx
80101d23:	89 0d 88 a0 10 80    	mov    %ecx,0x8010a088
80101d29:	89 c1                	mov    %eax,%ecx
80101d2b:	83 e1 7f             	and    $0x7f,%ecx
80101d2e:	88 99 00 a0 10 80    	mov    %bl,-0x7fef6000(%ecx)
        if (input.e == input.end_pos + 1)
80101d34:	39 d0                	cmp    %edx,%eax
80101d36:	0f 85 12 f9 ff ff    	jne    8010164e <consoleintr+0x3e>
          consputc(c);
80101d3c:	89 d8                	mov    %ebx,%eax
          input.end_pos++;
80101d3e:	89 35 8c a0 10 80    	mov    %esi,0x8010a08c
          consputc(c);
80101d44:	e8 67 e8 ff ff       	call   801005b0 <consputc>
          new_char.time = input.time++;
80101d49:	8b 15 90 a0 10 80    	mov    0x8010a090,%edx
          uint last_char_time_position_index = input.e - input.w - 1;
80101d4f:	a1 88 a0 10 80       	mov    0x8010a088,%eax
          new_char.time = input.time++;
80101d54:	8d 4a 01             	lea    0x1(%edx),%ecx
          uint last_char_time_position_index = input.e - input.w - 1;
80101d57:	83 e8 01             	sub    $0x1,%eax
80101d5a:	2b 05 84 a0 10 80    	sub    0x8010a084,%eax
          new_char.time = input.time++;
80101d60:	89 0d 90 a0 10 80    	mov    %ecx,0x8010a090
          times_buf[last_char_time_position_index] = new_char;
80101d66:	88 1c c5 20 0f 11 80 	mov    %bl,-0x7feef0e0(,%eax,8)
80101d6d:	89 14 c5 24 0f 11 80 	mov    %edx,-0x7feef0dc(,%eax,8)
80101d74:	e9 d5 f8 ff ff       	jmp    8010164e <consoleintr+0x3e>
      for (uint i = input.e; i < input.end_pos; i++)
80101d79:	8b 1d 8c a0 10 80    	mov    0x8010a08c,%ebx
80101d7f:	8b 3d 88 a0 10 80    	mov    0x8010a088,%edi
80101d85:	89 9d 58 fe ff ff    	mov    %ebx,-0x1a8(%ebp)
80101d8b:	39 df                	cmp    %ebx,%edi
80101d8d:	73 69                	jae    80101df8 <consoleintr+0x7e8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d8f:	be d4 03 00 00       	mov    $0x3d4,%esi
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d98:	b8 0e 00 00 00       	mov    $0xe,%eax
80101d9d:	89 f2                	mov    %esi,%edx
80101d9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101da0:	ba d5 03 00 00       	mov    $0x3d5,%edx
80101da5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101da6:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101da9:	89 f2                	mov    %esi,%edx
80101dab:	b8 0f 00 00 00       	mov    $0xf,%eax
80101db0:	c1 e1 08             	shl    $0x8,%ecx
80101db3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101db4:	ba d5 03 00 00       	mov    $0x3d5,%edx
80101db9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101dba:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101dbd:	89 f2                	mov    %esi,%edx
80101dbf:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101dc1:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80101dc6:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80101dc9:	39 c1                	cmp    %eax,%ecx
80101dcb:	0f 4f c8             	cmovg  %eax,%ecx
80101dce:	b8 0e 00 00 00       	mov    $0xe,%eax
80101dd3:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101dd4:	89 ca                	mov    %ecx,%edx
80101dd6:	c1 fa 08             	sar    $0x8,%edx
80101dd9:	89 d0                	mov    %edx,%eax
80101ddb:	ba d5 03 00 00       	mov    $0x3d5,%edx
80101de0:	ee                   	out    %al,(%dx)
80101de1:	b8 0f 00 00 00       	mov    $0xf,%eax
80101de6:	89 f2                	mov    %esi,%edx
80101de8:	ee                   	out    %al,(%dx)
80101de9:	ba d5 03 00 00       	mov    $0x3d5,%edx
80101dee:	89 c8                	mov    %ecx,%eax
80101df0:	ee                   	out    %al,(%dx)
      for (uint i = input.e; i < input.end_pos; i++)
80101df1:	83 c7 01             	add    $0x1,%edi
80101df4:	39 df                	cmp    %ebx,%edi
80101df6:	75 a0                	jne    80101d98 <consoleintr+0x788>
      while (input.end_pos != input.w &&
80101df8:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80101dfe:	8b 8d 58 fe ff ff    	mov    -0x1a8(%ebp),%ecx
80101e04:	39 05 84 a0 10 80    	cmp    %eax,0x8010a084
80101e0a:	0f 84 ff 01 00 00    	je     8010200f <consoleintr+0x9ff>
             input.buf[(input.end_pos - 1) % INPUT_BUF] != '\n')
80101e10:	8d 41 ff             	lea    -0x1(%ecx),%eax
80101e13:	89 c2                	mov    %eax,%edx
80101e15:	83 e2 7f             	and    $0x7f,%edx
      while (input.end_pos != input.w &&
80101e18:	80 ba 00 a0 10 80 0a 	cmpb   $0xa,-0x7fef6000(%edx)
80101e1f:	0f 84 e4 01 00 00    	je     80102009 <consoleintr+0x9f9>
  if (panicked)
80101e25:	8b 35 f8 17 11 80    	mov    0x801117f8,%esi
        input.end_pos--;
80101e2b:	a3 8c a0 10 80       	mov    %eax,0x8010a08c
  if (panicked)
80101e30:	85 f6                	test   %esi,%esi
80101e32:	0f 84 90 01 00 00    	je     80101fc8 <consoleintr+0x9b8>
  asm volatile("cli");
80101e38:	fa                   	cli
    for (;;)
80101e39:	eb fe                	jmp    80101e39 <consoleintr+0x829>
80101e3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        input.s1 = input.e;
80101e40:	a1 88 a0 10 80       	mov    0x8010a088,%eax
        input.mode = 1;
80101e45:	c7 05 9c a0 10 80 01 	movl   $0x1,0x8010a09c
80101e4c:	00 00 00 
        input.s1 = input.e;
80101e4f:	a3 94 a0 10 80       	mov    %eax,0x8010a094
        input.mode = 1;
80101e54:	e9 f5 f7 ff ff       	jmp    8010164e <consoleintr+0x3e>
          delete_selected();
80101e59:	e8 22 f3 ff ff       	call   80101180 <delete_selected>
        if ((input.e < input.end_pos) && c != '\n')
80101e5e:	8b 15 8c a0 10 80    	mov    0x8010a08c,%edx
        c = (c == '\r') ? '\n' : c;
80101e64:	83 fb 0d             	cmp    $0xd,%ebx
80101e67:	0f 85 49 f8 ff ff    	jne    801016b6 <consoleintr+0xa6>
80101e6d:	e9 ee f9 ff ff       	jmp    80101860 <consoleintr+0x250>
    switch (c)
80101e72:	c7 85 60 fe ff ff 01 	movl   $0x1,-0x1a0(%ebp)
80101e79:	00 00 00 
80101e7c:	e9 cd f7 ff ff       	jmp    8010164e <consoleintr+0x3e>
80101e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e88:	89 c2                	mov    %eax,%edx
        char ch = input.buf[pos % INPUT_BUF];
80101e8a:	89 d3                	mov    %edx,%ebx
80101e8c:	c1 fb 1f             	sar    $0x1f,%ebx
80101e8f:	c1 eb 19             	shr    $0x19,%ebx
80101e92:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80101e95:	83 e0 7f             	and    $0x7f,%eax
80101e98:	29 d8                	sub    %ebx,%eax
80101e9a:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
        if (ch == ' ' || ch == '\n') 
80101ea1:	3c 20                	cmp    $0x20,%al
80101ea3:	0f 84 eb 05 00 00    	je     80102494 <consoleintr+0xe84>
80101ea9:	3c 0a                	cmp    $0xa,%al
80101eab:	0f 84 e3 05 00 00    	je     80102494 <consoleintr+0xe84>
        pos--;
80101eb1:	8d 42 ff             	lea    -0x1(%edx),%eax
      while (pos >= (int)input.w) {
80101eb4:	39 c6                	cmp    %eax,%esi
80101eb6:	7e d0                	jle    80101e88 <consoleintr+0x878>
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101eb8:	39 ca                	cmp    %ecx,%edx
80101eba:	0f 8d f3 fd ff ff    	jge    80101cb3 <consoleintr+0x6a3>
80101ec0:	29 d1                	sub    %edx,%ecx
      int len = 0;
80101ec2:	31 db                	xor    %ebx,%ebx
80101ec4:	eb 0f                	jmp    80101ed5 <consoleintr+0x8c5>
80101ec6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ecd:	00 
80101ece:	66 90                	xchg   %ax,%ax
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101ed0:	83 fb 7f             	cmp    $0x7f,%ebx
80101ed3:	74 27                	je     80101efc <consoleintr+0x8ec>
        user_input[len++] = input.buf[i % INPUT_BUF];
80101ed5:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80101ed8:	83 c3 01             	add    $0x1,%ebx
80101edb:	89 c6                	mov    %eax,%esi
80101edd:	c1 fe 1f             	sar    $0x1f,%esi
80101ee0:	c1 ee 19             	shr    $0x19,%esi
80101ee3:	01 f0                	add    %esi,%eax
80101ee5:	83 e0 7f             	and    $0x7f,%eax
80101ee8:	29 f0                	sub    %esi,%eax
80101eea:	0f b6 80 00 a0 10 80 	movzbl -0x7fef6000(%eax),%eax
80101ef1:	88 84 1d 67 fe ff ff 	mov    %al,-0x199(%ebp,%ebx,1)
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101ef8:	39 cb                	cmp    %ecx,%ebx
80101efa:	75 d4                	jne    80101ed0 <consoleintr+0x8c0>
      tab_count++;
80101efc:	a1 a0 17 11 80       	mov    0x801117a0,%eax
      int m = collect_matches(user_input, cmd_indexes, 64);
80101f01:	83 ec 04             	sub    $0x4,%esp
80101f04:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
      user_input[len] = 0;
80101f0a:	c6 84 1d 68 fe ff ff 	movb   $0x0,-0x198(%ebp,%ebx,1)
80101f11:	00 
      tab_count++;
80101f12:	8d 50 01             	lea    0x1(%eax),%edx
      int m = collect_matches(user_input, cmd_indexes, 64);
80101f15:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
      tab_count++;
80101f1b:	89 15 a0 17 11 80    	mov    %edx,0x801117a0
80101f21:	89 95 58 fe ff ff    	mov    %edx,-0x1a8(%ebp)
      int m = collect_matches(user_input, cmd_indexes, 64);
80101f27:	6a 40                	push   $0x40
80101f29:	57                   	push   %edi
80101f2a:	50                   	push   %eax
80101f2b:	e8 70 f6 ff ff       	call   801015a0 <collect_matches>
      if (m == 0) {
80101f30:	83 c4 10             	add    $0x10,%esp
      int m = collect_matches(user_input, cmd_indexes, 64);
80101f33:	89 c6                	mov    %eax,%esi
      if (m == 0) {
80101f35:	85 c0                	test   %eax,%eax
80101f37:	0f 84 76 fd ff ff    	je     80101cb3 <consoleintr+0x6a3>
      else if (m == 1) {
80101f3d:	83 f8 01             	cmp    $0x1,%eax
80101f40:	8b 95 58 fe ff ff    	mov    -0x1a8(%ebp),%edx
80101f46:	0f 84 7e 05 00 00    	je     801024ca <consoleintr+0xeba>
        if (tab_count == 1) {
80101f4c:	83 fa 01             	cmp    $0x1,%edx
80101f4f:	0f 84 f9 f6 ff ff    	je     8010164e <consoleintr+0x3e>
  if (panicked)
80101f55:	8b 1d f8 17 11 80    	mov    0x801117f8,%ebx
80101f5b:	85 db                	test   %ebx,%ebx
80101f5d:	0f 84 e2 05 00 00    	je     80102545 <consoleintr+0xf35>
80101f63:	fa                   	cli
    for (;;)
80101f64:	eb fe                	jmp    80101f64 <consoleintr+0x954>
80101f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f6d:	00 
80101f6e:	66 90                	xchg   %ax,%ax
  if (panicked)
80101f70:	85 c9                	test   %ecx,%ecx
80101f72:	0f 85 e0 01 00 00    	jne    80102158 <consoleintr+0xb48>
    uartputc('\b');
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	6a 08                	push   $0x8
80101f7d:	e8 0e 5b 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
80101f82:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101f89:	e8 02 5b 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
80101f8e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80101f95:	e8 f6 5a 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80101f9a:	b8 00 01 00 00       	mov    $0x100,%eax
80101f9f:	e8 5c e4 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	53                   	push   %ebx
80101fa7:	ff b5 5c fe ff ff    	push   -0x1a4(%ebp)
80101fad:	e8 5e f4 ff ff       	call   80101410 <move_timed_chars_left>
        input.e--;
80101fb2:	83 2d 88 a0 10 80 01 	subl   $0x1,0x8010a088
80101fb9:	83 c4 10             	add    $0x10,%esp
      input.end_pos--;
80101fbc:	83 2d 8c a0 10 80 01 	subl   $0x1,0x8010a08c
      break;
80101fc3:	e9 86 f6 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80101fc8:	83 ec 0c             	sub    $0xc,%esp
80101fcb:	6a 08                	push   $0x8
80101fcd:	e8 be 5a 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
80101fd2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101fd9:	e8 b2 5a 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
80101fde:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80101fe5:	e8 a6 5a 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80101fea:	b8 00 01 00 00       	mov    $0x100,%eax
80101fef:	e8 0c e4 ff ff       	call   80100400 <cgaputc>
      while (input.end_pos != input.w &&
80101ff4:	8b 0d 8c a0 10 80    	mov    0x8010a08c,%ecx
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	3b 0d 84 a0 10 80    	cmp    0x8010a084,%ecx
80102003:	0f 85 07 fe ff ff    	jne    80101e10 <consoleintr+0x800>
80102009:	89 8d 58 fe ff ff    	mov    %ecx,-0x1a8(%ebp)
      input.e = input.end_pos;
8010200f:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80102015:	a3 88 a0 10 80       	mov    %eax,0x8010a088
      break;
8010201a:	e9 2f f6 ff ff       	jmp    8010164e <consoleintr+0x3e>
          wakeup(&input.r);
8010201f:	83 ec 0c             	sub    $0xc,%esp
          input.buf[input.end_pos++ % INPUT_BUF] = c; 
80102022:	83 e2 7f             	and    $0x7f,%edx
80102025:	89 35 8c a0 10 80    	mov    %esi,0x8010a08c
8010202b:	88 9a 00 a0 10 80    	mov    %bl,-0x7fef6000(%edx)
          input.w = input.end_pos;
80102031:	89 35 84 a0 10 80    	mov    %esi,0x8010a084
          input.e = input.end_pos;
80102037:	89 35 88 a0 10 80    	mov    %esi,0x8010a088
          wakeup(&input.r);
8010203d:	68 80 a0 10 80       	push   $0x8010a080
80102042:	e8 79 3c 00 00       	call   80105cc0 <wakeup>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	e9 ff f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
          move_to_first_previous();
8010204f:	e8 dc ed ff ff       	call   80100e30 <move_to_first_previous>
80102054:	e9 f5 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
          move_timed_chars_left(cursor_index, input.e);
80102059:	83 ec 08             	sub    $0x8,%esp
8010205c:	52                   	push   %edx
          uint cursor_index = input.e - input.w - 1 ;
8010205d:	29 ca                	sub    %ecx,%edx
8010205f:	8d 42 ff             	lea    -0x1(%edx),%eax
          move_timed_chars_left(cursor_index, input.e);
80102062:	50                   	push   %eax
80102063:	e8 a8 f3 ff ff       	call   80101410 <move_timed_chars_left>
  if (panicked)
80102068:	8b 3d f8 17 11 80    	mov    0x801117f8,%edi
          input.end_pos--;
8010206e:	83 2d 8c a0 10 80 01 	subl   $0x1,0x8010a08c
  if (panicked)
80102075:	83 c4 10             	add    $0x10,%esp
80102078:	85 ff                	test   %edi,%edi
8010207a:	74 0e                	je     8010208a <consoleintr+0xa7a>
8010207c:	fa                   	cli
    for (;;)
8010207d:	eb fe                	jmp    8010207d <consoleintr+0xa6d>
8010207f:	90                   	nop
        delete_selected();
80102080:	e8 fb f0 ff ff       	call   80101180 <delete_selected>
        break;
80102085:	e9 c4 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
8010208a:	83 ec 0c             	sub    $0xc,%esp
8010208d:	6a 08                	push   $0x8
8010208f:	e8 fc 59 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
80102094:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010209b:	e8 f0 59 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
801020a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801020a7:	e8 e4 59 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801020ac:	b8 00 01 00 00       	mov    $0x100,%eax
801020b1:	e8 4a e3 ff ff       	call   80100400 <cgaputc>
}
801020b6:	83 c4 10             	add    $0x10,%esp
801020b9:	e9 90 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
801020be:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020c1:	be d4 03 00 00       	mov    $0x3d4,%esi
801020c6:	6a 08                	push   $0x8
801020c8:	e8 c3 59 00 00       	call   80107a90 <uartputc>
801020cd:	b8 0e 00 00 00       	mov    $0xe,%eax
801020d2:	89 f2                	mov    %esi,%edx
801020d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801020da:	89 da                	mov    %ebx,%edx
801020dc:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801020dd:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020e0:	89 f2                	mov    %esi,%edx
801020e2:	b8 0f 00 00 00       	mov    $0xf,%eax
801020e7:	c1 e1 08             	shl    $0x8,%ecx
801020ea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020eb:	89 da                	mov    %ebx,%edx
801020ed:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801020ee:	0f b6 c0             	movzbl %al,%eax
801020f1:	09 c8                	or     %ecx,%eax
    --pos;
801020f3:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020f6:	ee                   	out    %al,(%dx)
        input.e--;
801020f7:	83 2d 88 a0 10 80 01 	subl   $0x1,0x8010a088
801020fe:	83 c4 10             	add    $0x10,%esp
80102101:	e9 48 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80102106:	83 ec 0c             	sub    $0xc,%esp
80102109:	6a 08                	push   $0x8
8010210b:	e8 80 59 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
80102110:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102117:	e8 74 59 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
8010211c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80102123:	e8 68 59 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80102128:	b8 00 01 00 00       	mov    $0x100,%eax
8010212d:	e8 ce e2 ff ff       	call   80100400 <cgaputc>
          uint cursor_index = input.e - input.w -1 ;
80102132:	a1 88 a0 10 80       	mov    0x8010a088,%eax
          move_timed_chars_left(cursor_index, input.e);
80102137:	5a                   	pop    %edx
80102138:	59                   	pop    %ecx
80102139:	50                   	push   %eax
          uint cursor_index = input.e - input.w -1 ;
8010213a:	83 e8 01             	sub    $0x1,%eax
8010213d:	2b 05 84 a0 10 80    	sub    0x8010a084,%eax
          move_timed_chars_left(cursor_index, input.e);
80102143:	50                   	push   %eax
80102144:	e8 c7 f2 ff ff       	call   80101410 <move_timed_chars_left>
          input.end_pos--;
80102149:	83 2d 8c a0 10 80 01 	subl   $0x1,0x8010a08c
80102150:	83 c4 10             	add    $0x10,%esp
80102153:	e9 f6 f4 ff ff       	jmp    8010164e <consoleintr+0x3e>
  asm volatile("cli");
80102158:	fa                   	cli
    for (;;)
80102159:	eb fe                	jmp    80102159 <consoleintr+0xb49>
8010215b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          input.buf[input.e++ % INPUT_BUF] = c;
80102160:	89 0d 88 a0 10 80    	mov    %ecx,0x8010a088
80102166:	88 97 00 a0 10 80    	mov    %dl,-0x7fef6000(%edi)
          if (input.e == input.end_pos + 1)
8010216c:	0f 85 15 f9 ff ff    	jne    80101a87 <consoleintr+0x477>
  if (panicked)
80102172:	8b 15 f8 17 11 80    	mov    0x801117f8,%edx
          if (input.e == input.end_pos + 1)
80102178:	89 0d 8c a0 10 80    	mov    %ecx,0x8010a08c
  if (panicked)
8010217e:	85 d2                	test   %edx,%edx
80102180:	0f 84 f6 02 00 00    	je     8010247c <consoleintr+0xe6c>
80102186:	fa                   	cli
    for (;;)
80102187:	eb fe                	jmp    80102187 <consoleintr+0xb77>
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	89 8d 54 fe ff ff    	mov    %ecx,-0x1ac(%ebp)
        for (uint i = cursor_index; i > removing_char_index; i--)
80102196:	89 d6                	mov    %edx,%esi
80102198:	89 9d 50 fe ff ff    	mov    %ebx,-0x1b0(%ebp)
8010219e:	66 90                	xchg   %ax,%ax
801021a0:	b8 0e 00 00 00       	mov    $0xe,%eax
801021a5:	ba d4 03 00 00       	mov    $0x3d4,%edx
801021aa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ab:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801021b0:	89 da                	mov    %ebx,%edx
801021b2:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021b3:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
801021b8:	0f b6 c8             	movzbl %al,%ecx
801021bb:	ba d4 03 00 00       	mov    $0x3d4,%edx
801021c0:	c1 e1 08             	shl    $0x8,%ecx
801021c3:	89 f8                	mov    %edi,%eax
801021c5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c6:	89 da                	mov    %ebx,%edx
801021c8:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801021c9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021cc:	ba d4 03 00 00       	mov    $0x3d4,%edx
801021d1:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
801021d3:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801021d8:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
801021db:	39 c1                	cmp    %eax,%ecx
801021dd:	0f 4f c8             	cmovg  %eax,%ecx
801021e0:	31 c0                	xor    %eax,%eax
801021e2:	85 c9                	test   %ecx,%ecx
801021e4:	0f 48 c8             	cmovs  %eax,%ecx
801021e7:	b8 0e 00 00 00       	mov    $0xe,%eax
801021ec:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801021ed:	89 c8                	mov    %ecx,%eax
801021ef:	89 da                	mov    %ebx,%edx
801021f1:	c1 f8 08             	sar    $0x8,%eax
801021f4:	ee                   	out    %al,(%dx)
801021f5:	ba d4 03 00 00       	mov    $0x3d4,%edx
801021fa:	89 f8                	mov    %edi,%eax
801021fc:	ee                   	out    %al,(%dx)
801021fd:	89 c8                	mov    %ecx,%eax
801021ff:	89 da                	mov    %ebx,%edx
80102201:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i > removing_char_index; i--)
80102202:	89 f2                	mov    %esi,%edx
80102204:	83 ee 01             	sub    $0x1,%esi
80102207:	39 b5 5c fe ff ff    	cmp    %esi,-0x1a4(%ebp)
8010220d:	75 91                	jne    801021a0 <consoleintr+0xb90>
  if (panicked)
8010220f:	8b 8d 54 fe ff ff    	mov    -0x1ac(%ebp),%ecx
80102215:	8b 9d 50 fe ff ff    	mov    -0x1b0(%ebp),%ebx
8010221b:	85 c9                	test   %ecx,%ecx
8010221d:	0f 84 9d 01 00 00    	je     801023c0 <consoleintr+0xdb0>
  asm volatile("cli");
80102223:	fa                   	cli
    for (;;)
80102224:	eb fe                	jmp    80102224 <consoleintr+0xc14>
80102226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010222d:	00 
8010222e:	66 90                	xchg   %ax,%ax
        input.s2 = input.e;
80102230:	a1 88 a0 10 80       	mov    0x8010a088,%eax
        print_select(input.s1, input.s2);
80102235:	83 ec 08             	sub    $0x8,%esp
        input.mode = 2;
80102238:	c7 05 9c a0 10 80 02 	movl   $0x2,0x8010a09c
8010223f:	00 00 00 
        input.color = 'W';
80102242:	c6 05 a0 a0 10 80 57 	movb   $0x57,0x8010a0a0
        input.s2 = input.e;
80102249:	a3 98 a0 10 80       	mov    %eax,0x8010a098
        print_select(input.s1, input.s2);
8010224e:	50                   	push   %eax
8010224f:	ff 35 94 a0 10 80    	push   0x8010a094
80102255:	e8 66 ed ff ff       	call   80100fc0 <print_select>
        input.color = 'B';
8010225a:	c6 05 a0 a0 10 80 42 	movb   $0x42,0x8010a0a0
80102261:	83 c4 10             	add    $0x10,%esp
80102264:	e9 e5 f3 ff ff       	jmp    8010164e <consoleintr+0x3e>
  for (int i = 0; i < INPUT_BUF; i++)
80102269:	31 c0                	xor    %eax,%eax
8010226b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    times_buf[i].time = 0;
80102270:	c7 04 c5 24 0f 11 80 	movl   $0x0,-0x7feef0dc(,%eax,8)
80102277:	00 00 00 00 
    times_buf[i].c = '\0';
8010227b:	c6 04 c5 20 0f 11 80 	movb   $0x0,-0x7feef0e0(,%eax,8)
80102282:	00 
  for (int i = 0; i < INPUT_BUF; i++)
80102283:	83 c0 01             	add    $0x1,%eax
80102286:	3d 80 00 00 00       	cmp    $0x80,%eax
8010228b:	75 e3                	jne    80102270 <consoleintr+0xc60>
8010228d:	e9 23 f6 ff ff       	jmp    801018b5 <consoleintr+0x2a5>
    uartputc('\b');
80102292:	83 ec 0c             	sub    $0xc,%esp
80102295:	6a 08                	push   $0x8
80102297:	e8 f4 57 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
8010229c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801022a3:	e8 e8 57 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
801022a8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801022af:	e8 dc 57 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801022b4:	b8 00 01 00 00       	mov    $0x100,%eax
801022b9:	e8 42 e1 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
801022be:	58                   	pop    %eax
801022bf:	5a                   	pop    %edx
801022c0:	53                   	push   %ebx
801022c1:	8b bd 5c fe ff ff    	mov    -0x1a4(%ebp),%edi
801022c7:	57                   	push   %edi
801022c8:	e8 43 f1 ff ff       	call   80101410 <move_timed_chars_left>
        for (uint i = cursor_index; i < removing_char_index - 1; i++)
801022cd:	89 f8                	mov    %edi,%eax
801022cf:	83 c4 10             	add    $0x10,%esp
801022d2:	83 e8 01             	sub    $0x1,%eax
801022d5:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
801022db:	39 85 58 fe ff ff    	cmp    %eax,-0x1a8(%ebp)
801022e1:	0f 83 d5 fc ff ff    	jae    80101fbc <consoleintr+0x9ac>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e7:	be d4 03 00 00       	mov    $0x3d4,%esi
801022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f0:	b8 0e 00 00 00       	mov    $0xe,%eax
801022f5:	89 f2                	mov    %esi,%edx
801022f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801022fd:	89 da                	mov    %ebx,%edx
801022ff:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102300:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
80102305:	0f b6 c8             	movzbl %al,%ecx
80102308:	89 f2                	mov    %esi,%edx
8010230a:	c1 e1 08             	shl    $0x8,%ecx
8010230d:	89 f8                	mov    %edi,%eax
8010230f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102310:	89 da                	mov    %ebx,%edx
80102312:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80102313:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102316:	89 f2                	mov    %esi,%edx
80102318:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
8010231a:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
8010231f:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80102322:	39 c1                	cmp    %eax,%ecx
80102324:	0f 4f c8             	cmovg  %eax,%ecx
80102327:	31 c0                	xor    %eax,%eax
80102329:	85 c9                	test   %ecx,%ecx
8010232b:	0f 48 c8             	cmovs  %eax,%ecx
8010232e:	b8 0e 00 00 00       	mov    $0xe,%eax
80102333:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80102334:	89 c8                	mov    %ecx,%eax
80102336:	89 da                	mov    %ebx,%edx
80102338:	c1 f8 08             	sar    $0x8,%eax
8010233b:	ee                   	out    %al,(%dx)
8010233c:	89 f8                	mov    %edi,%eax
8010233e:	89 f2                	mov    %esi,%edx
80102340:	ee                   	out    %al,(%dx)
80102341:	89 c8                	mov    %ecx,%eax
80102343:	89 da                	mov    %ebx,%edx
80102345:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i < removing_char_index - 1; i++)
80102346:	83 85 58 fe ff ff 01 	addl   $0x1,-0x1a8(%ebp)
8010234d:	8b bd 54 fe ff ff    	mov    -0x1ac(%ebp),%edi
80102353:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80102359:	39 f8                	cmp    %edi,%eax
8010235b:	75 93                	jne    801022f0 <consoleintr+0xce0>
8010235d:	e9 5a fc ff ff       	jmp    80101fbc <consoleintr+0x9ac>
          inedx_copy1 = input.s2 % INPUT_BUF;
80102362:	89 1d 84 0e 11 80    	mov    %ebx,0x80110e84
          inedx_copy2 = input.s1 % INPUT_BUF;
80102368:	89 0d 80 0e 11 80    	mov    %ecx,0x80110e80
8010236e:	e9 db f2 ff ff       	jmp    8010164e <consoleintr+0x3e>
          if ((input.e < input.end_pos) && c != '\n')
80102373:	88 95 58 fe ff ff    	mov    %dl,-0x1a8(%ebp)
80102379:	31 c0                	xor    %eax,%eax
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
              copy_buf[i] = input.buf[i];
80102380:	8b 90 00 a0 10 80    	mov    -0x7fef6000(%eax),%edx
80102386:	83 c0 04             	add    $0x4,%eax
80102389:	89 90 1c 17 11 80    	mov    %edx,-0x7feee8e4(%eax)
            for (int i = 0; i < INPUT_BUF; i++)
8010238f:	3d 80 00 00 00       	cmp    $0x80,%eax
80102394:	75 ea                	jne    80102380 <consoleintr+0xd70>
            input.buf[input.e++ % INPUT_BUF] = c;
80102396:	89 0d 88 a0 10 80    	mov    %ecx,0x8010a088
8010239c:	0f b6 95 58 fe ff ff 	movzbl -0x1a8(%ebp),%edx
  if (panicked)
801023a3:	8b 0d f8 17 11 80    	mov    0x801117f8,%ecx
            input.buf[input.e++ % INPUT_BUF] = c;
801023a9:	88 97 00 a0 10 80    	mov    %dl,-0x7fef6000(%edi)
  if (panicked)
801023af:	85 c9                	test   %ecx,%ecx
801023b1:	0f 84 e5 00 00 00    	je     8010249c <consoleintr+0xe8c>
  asm volatile("cli");
801023b7:	fa                   	cli
    for (;;)
801023b8:	eb fe                	jmp    801023b8 <consoleintr+0xda8>
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b');
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	89 95 54 fe ff ff    	mov    %edx,-0x1ac(%ebp)
801023c9:	6a 08                	push   $0x8
801023cb:	e8 c0 56 00 00       	call   80107a90 <uartputc>
    uartputc(' ');
801023d0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801023d7:	e8 b4 56 00 00       	call   80107a90 <uartputc>
    uartputc('\b');
801023dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801023e3:	e8 a8 56 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801023e8:	b8 00 01 00 00       	mov    $0x100,%eax
801023ed:	e8 0e e0 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
801023f2:	59                   	pop    %ecx
801023f3:	5e                   	pop    %esi
801023f4:	53                   	push   %ebx
801023f5:	ff b5 5c fe ff ff    	push   -0x1a4(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023fb:	be d4 03 00 00       	mov    $0x3d4,%esi
80102400:	e8 0b f0 ff ff       	call   80101410 <move_timed_chars_left>
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	b8 0e 00 00 00       	mov    $0xe,%eax
8010240d:	89 f2                	mov    %esi,%edx
8010240f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102410:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80102415:	89 da                	mov    %ebx,%edx
80102417:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102418:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
8010241d:	0f b6 c8             	movzbl %al,%ecx
80102420:	89 f2                	mov    %esi,%edx
80102422:	c1 e1 08             	shl    $0x8,%ecx
80102425:	89 f8                	mov    %edi,%eax
80102427:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102428:	89 da                	mov    %ebx,%edx
8010242a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010242b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010242e:	89 f2                	mov    %esi,%edx
80102430:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80102432:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80102437:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
8010243a:	39 c1                	cmp    %eax,%ecx
8010243c:	0f 4f c8             	cmovg  %eax,%ecx
8010243f:	b8 0e 00 00 00       	mov    $0xe,%eax
80102444:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80102445:	89 c8                	mov    %ecx,%eax
80102447:	89 da                	mov    %ebx,%edx
80102449:	c1 f8 08             	sar    $0x8,%eax
8010244c:	ee                   	out    %al,(%dx)
8010244d:	89 f8                	mov    %edi,%eax
8010244f:	89 f2                	mov    %esi,%edx
80102451:	ee                   	out    %al,(%dx)
80102452:	89 c8                	mov    %ecx,%eax
80102454:	89 da                	mov    %ebx,%edx
80102456:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i > removing_char_index; i--)
80102457:	8b bd 58 fe ff ff    	mov    -0x1a8(%ebp),%edi
8010245d:	89 f8                	mov    %edi,%eax
8010245f:	83 ef 01             	sub    $0x1,%edi
80102462:	89 bd 58 fe ff ff    	mov    %edi,-0x1a8(%ebp)
80102468:	39 85 54 fe ff ff    	cmp    %eax,-0x1ac(%ebp)
8010246e:	75 98                	jne    80102408 <consoleintr+0xdf8>
        input.e--;
80102470:	83 2d 88 a0 10 80 01 	subl   $0x1,0x8010a088
80102477:	e9 40 fb ff ff       	jmp    80101fbc <consoleintr+0x9ac>
    uartputc(c);
8010247c:	83 ec 0c             	sub    $0xc,%esp
8010247f:	56                   	push   %esi
80102480:	e8 0b 56 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80102485:	89 f0                	mov    %esi,%eax
80102487:	e8 74 df ff ff       	call   80100400 <cgaputc>
}
8010248c:	83 c4 10             	add    $0x10,%esp
8010248f:	e9 f3 f5 ff ff       	jmp    80101a87 <consoleintr+0x477>
      int start = pos + 1;
80102494:	83 c2 01             	add    $0x1,%edx
80102497:	e9 1c fa ff ff       	jmp    80101eb8 <consoleintr+0x8a8>
    uartputc(c);
8010249c:	83 ec 0c             	sub    $0xc,%esp
8010249f:	56                   	push   %esi
801024a0:	e8 eb 55 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801024a5:	89 f0                	mov    %esi,%eax
801024a7:	e8 54 df ff ff       	call   80100400 <cgaputc>
            move_chars_right();
801024ac:	e8 3f e7 ff ff       	call   80100bf0 <move_chars_right>
            input.end_pos++;
801024b1:	83 05 8c a0 10 80 01 	addl   $0x1,0x8010a08c
            continue;
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	e9 c7 f5 ff ff       	jmp    80101a87 <consoleintr+0x477>
          delete_selected();
801024c0:	e8 bb ec ff ff       	call   80101180 <delete_selected>
801024c5:	e9 73 f5 ff ff       	jmp    80101a3d <consoleintr+0x42d>
        if (tab_count == 1) {
801024ca:	83 fa 01             	cmp    $0x1,%edx
801024cd:	0f 85 e0 f7 ff ff    	jne    80101cb3 <consoleintr+0x6a3>
          const char *suffix = full + len; 
801024d3:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
801024d9:	03 1c 85 c0 a0 10 80 	add    -0x7fef5f40(,%eax,4),%ebx
          while (*suffix) {
801024e0:	0f b6 13             	movzbl (%ebx),%edx
801024e3:	84 d2                	test   %dl,%dl
801024e5:	0f 84 c8 f7 ff ff    	je     80101cb3 <consoleintr+0x6a3>
            if (input.end_pos - input.r >= INPUT_BUF) 
801024eb:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
801024f0:	89 c1                	mov    %eax,%ecx
801024f2:	2b 0d 80 a0 10 80    	sub    0x8010a080,%ecx
801024f8:	83 f9 7f             	cmp    $0x7f,%ecx
801024fb:	0f 87 b2 f7 ff ff    	ja     80101cb3 <consoleintr+0x6a3>
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
80102501:	89 c1                	mov    %eax,%ecx
            input.e++;
80102503:	83 05 88 a0 10 80 01 	addl   $0x1,0x8010a088
            input.end_pos++;
8010250a:	83 c0 01             	add    $0x1,%eax
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
8010250d:	83 e1 7f             	and    $0x7f,%ecx
  if (panicked)
80102510:	83 3d f8 17 11 80 00 	cmpl   $0x0,0x801117f8
            input.end_pos++;
80102517:	a3 8c a0 10 80       	mov    %eax,0x8010a08c
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
8010251c:	88 91 00 a0 10 80    	mov    %dl,-0x7fef6000(%ecx)
            consputc(*suffix);
80102522:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
80102525:	74 03                	je     8010252a <consoleintr+0xf1a>
  asm volatile("cli");
80102527:	fa                   	cli
    for (;;)
80102528:	eb fe                	jmp    80102528 <consoleintr+0xf18>
    uartputc(c);
8010252a:	83 ec 0c             	sub    $0xc,%esp
            consputc(*suffix);
8010252d:	0f be f0             	movsbl %al,%esi
            suffix++;
80102530:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80102533:	56                   	push   %esi
80102534:	e8 57 55 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
80102539:	89 f0                	mov    %esi,%eax
8010253b:	e8 c0 de ff ff       	call   80100400 <cgaputc>
            suffix++;
80102540:	83 c4 10             	add    $0x10,%esp
80102543:	eb 9b                	jmp    801024e0 <consoleintr+0xed0>
    uartputc(c);
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	6a 0a                	push   $0xa
8010254a:	e8 41 55 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
8010254f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102554:	e8 a7 de ff ff       	call   80100400 <cgaputc>
}
80102559:	83 c4 10             	add    $0x10,%esp
          for (int k = 0; k < m; k++) {
8010255c:	39 f3                	cmp    %esi,%ebx
8010255e:	7d 75                	jge    801025d5 <consoleintr+0xfc5>
            consputs(cmds[cmd_indexes[k]]);
80102560:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80102563:	89 b5 58 fe ff ff    	mov    %esi,-0x1a8(%ebp)
80102569:	89 de                	mov    %ebx,%esi
8010256b:	8b 14 85 c0 a0 10 80 	mov    -0x7fef5f40(,%eax,4),%edx
  while (*s) consputc(*s++);
80102572:	89 d3                	mov    %edx,%ebx
80102574:	0f be 03             	movsbl (%ebx),%eax
  if (panicked)
80102577:	8b 0d f8 17 11 80    	mov    0x801117f8,%ecx
  while (*s) consputc(*s++);
8010257d:	84 c0                	test   %al,%al
8010257f:	74 29                	je     801025aa <consoleintr+0xf9a>
  if (panicked)
80102581:	85 c9                	test   %ecx,%ecx
80102583:	74 03                	je     80102588 <consoleintr+0xf78>
80102585:	fa                   	cli
    for (;;)
80102586:	eb fe                	jmp    80102586 <consoleintr+0xf76>
    uartputc(c);
80102588:	83 ec 0c             	sub    $0xc,%esp
  while (*s) consputc(*s++);
8010258b:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
8010258e:	50                   	push   %eax
8010258f:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
80102595:	e8 f6 54 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
8010259a:	8b 85 54 fe ff ff    	mov    -0x1ac(%ebp),%eax
801025a0:	e8 5b de ff ff       	call   80100400 <cgaputc>
}
801025a5:	83 c4 10             	add    $0x10,%esp
801025a8:	eb ca                	jmp    80102574 <consoleintr+0xf64>
  if (panicked)
801025aa:	89 f3                	mov    %esi,%ebx
801025ac:	8b b5 58 fe ff ff    	mov    -0x1a8(%ebp),%esi
801025b2:	85 c9                	test   %ecx,%ecx
801025b4:	74 03                	je     801025b9 <consoleintr+0xfa9>
801025b6:	fa                   	cli
    for (;;)
801025b7:	eb fe                	jmp    801025b7 <consoleintr+0xfa7>
    uartputc(c);
801025b9:	83 ec 0c             	sub    $0xc,%esp
          for (int k = 0; k < m; k++) {
801025bc:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801025bf:	6a 20                	push   $0x20
801025c1:	e8 ca 54 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801025c6:	b8 20 00 00 00       	mov    $0x20,%eax
801025cb:	e8 30 de ff ff       	call   80100400 <cgaputc>
          for (int k = 0; k < m; k++) {
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	eb 87                	jmp    8010255c <consoleintr+0xf4c>
  if (panicked)
801025d5:	83 3d f8 17 11 80 00 	cmpl   $0x0,0x801117f8
801025dc:	74 03                	je     801025e1 <consoleintr+0xfd1>
801025de:	fa                   	cli
    for (;;)
801025df:	eb fe                	jmp    801025df <consoleintr+0xfcf>
    uartputc(c);
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	6a 0a                	push   $0xa
801025e6:	e8 a5 54 00 00       	call   80107a90 <uartputc>
    cgaputc(c);
801025eb:	b8 0a 00 00 00       	mov    $0xa,%eax
801025f0:	e8 0b de ff ff       	call   80100400 <cgaputc>
          tab_count = 0;
801025f5:	31 c0                	xor    %eax,%eax
801025f7:	a3 a0 17 11 80       	mov    %eax,0x801117a0
          input.buf[input.end_pos++ % INPUT_BUF] = '\n';
801025fc:	a1 8c a0 10 80       	mov    0x8010a08c,%eax
80102601:	89 c1                	mov    %eax,%ecx
80102603:	8d 50 01             	lea    0x1(%eax),%edx
          input.r = input.w-1;
80102606:	a3 80 a0 10 80       	mov    %eax,0x8010a080
          input.buf[input.end_pos++ % INPUT_BUF] = '\n';
8010260b:	83 e1 7f             	and    $0x7f,%ecx
8010260e:	89 15 8c a0 10 80    	mov    %edx,0x8010a08c
80102614:	c6 81 00 a0 10 80 0a 	movb   $0xa,-0x7fef6000(%ecx)
          input.w = input.end_pos;
8010261b:	89 15 84 a0 10 80    	mov    %edx,0x8010a084
          input.e = input.end_pos;
80102621:	89 15 88 a0 10 80    	mov    %edx,0x8010a088
          wakeup(&input.r);
80102627:	c7 04 24 80 a0 10 80 	movl   $0x8010a080,(%esp)
8010262e:	e8 8d 36 00 00       	call   80105cc0 <wakeup>
80102633:	83 c4 10             	add    $0x10,%esp
80102636:	e9 13 f0 ff ff       	jmp    8010164e <consoleintr+0x3e>
8010263b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102640 <consoleinit>:

void consoleinit(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80102646:	68 a8 8f 10 80       	push   $0x80108fa8
8010264b:	68 c0 17 11 80       	push   $0x801117c0
80102650:	e8 3b 39 00 00       	call   80105f90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80102655:	58                   	pop    %eax
80102656:	5a                   	pop    %edx
80102657:	6a 00                	push   $0x0
80102659:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010265b:	c7 05 ac 21 11 80 d0 	movl   $0x801006d0,0x801121ac
80102662:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80102665:	c7 05 a8 21 11 80 80 	movl   $0x80100280,0x801121a8
8010266c:	02 10 80 
  cons.locking = 1;
8010266f:	c7 05 f4 17 11 80 01 	movl   $0x1,0x801117f4
80102676:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80102679:	e8 c2 19 00 00       	call   80104040 <ioapicenable>
}
8010267e:	83 c4 10             	add    $0x10,%esp
80102681:	c9                   	leave
80102682:	c3                   	ret
80102683:	66 90                	xchg   %ax,%ax
80102685:	66 90                	xchg   %ax,%ax
80102687:	66 90                	xchg   %ax,%ax
80102689:	66 90                	xchg   %ax,%ax
8010268b:	66 90                	xchg   %ax,%ax
8010268d:	66 90                	xchg   %ax,%ax
8010268f:	90                   	nop

80102690 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	57                   	push   %edi
80102694:	56                   	push   %esi
80102695:	53                   	push   %ebx
80102696:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010269c:	e8 9f 2e 00 00       	call   80105540 <myproc>
801026a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801026a7:	e8 74 22 00 00       	call   80104920 <begin_op>

  if((ip = namei(path)) == 0){
801026ac:	83 ec 0c             	sub    $0xc,%esp
801026af:	ff 75 08             	push   0x8(%ebp)
801026b2:	e8 a9 15 00 00       	call   80103c60 <namei>
801026b7:	83 c4 10             	add    $0x10,%esp
801026ba:	85 c0                	test   %eax,%eax
801026bc:	0f 84 30 03 00 00    	je     801029f2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801026c2:	83 ec 0c             	sub    $0xc,%esp
801026c5:	89 c7                	mov    %eax,%edi
801026c7:	50                   	push   %eax
801026c8:	e8 b3 0c 00 00       	call   80103380 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801026cd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801026d3:	6a 34                	push   $0x34
801026d5:	6a 00                	push   $0x0
801026d7:	50                   	push   %eax
801026d8:	57                   	push   %edi
801026d9:	e8 b2 0f 00 00       	call   80103690 <readi>
801026de:	83 c4 20             	add    $0x20,%esp
801026e1:	83 f8 34             	cmp    $0x34,%eax
801026e4:	0f 85 01 01 00 00    	jne    801027eb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801026ea:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801026f1:	45 4c 46 
801026f4:	0f 85 f1 00 00 00    	jne    801027eb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801026fa:	e8 01 65 00 00       	call   80108c00 <setupkvm>
801026ff:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80102705:	85 c0                	test   %eax,%eax
80102707:	0f 84 de 00 00 00    	je     801027eb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010270d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80102714:	00 
80102715:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010271b:	0f 84 a1 02 00 00    	je     801029c2 <exec+0x332>
  sz = 0;
80102721:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80102728:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010272b:	31 db                	xor    %ebx,%ebx
8010272d:	e9 8c 00 00 00       	jmp    801027be <exec+0x12e>
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80102738:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010273f:	75 6c                	jne    801027ad <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80102741:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80102747:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010274d:	0f 82 87 00 00 00    	jb     801027da <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80102753:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80102759:	72 7f                	jb     801027da <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010275b:	83 ec 04             	sub    $0x4,%esp
8010275e:	50                   	push   %eax
8010275f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80102765:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010276b:	e8 c0 62 00 00       	call   80108a30 <allocuvm>
80102770:	83 c4 10             	add    $0x10,%esp
80102773:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102779:	85 c0                	test   %eax,%eax
8010277b:	74 5d                	je     801027da <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010277d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80102783:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102788:	75 50                	jne    801027da <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010278a:	83 ec 0c             	sub    $0xc,%esp
8010278d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80102793:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80102799:	57                   	push   %edi
8010279a:	50                   	push   %eax
8010279b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801027a1:	e8 ba 61 00 00       	call   80108960 <loaduvm>
801027a6:	83 c4 20             	add    $0x20,%esp
801027a9:	85 c0                	test   %eax,%eax
801027ab:	78 2d                	js     801027da <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801027ad:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801027b4:	83 c3 01             	add    $0x1,%ebx
801027b7:	83 c6 20             	add    $0x20,%esi
801027ba:	39 d8                	cmp    %ebx,%eax
801027bc:	7e 52                	jle    80102810 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801027be:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801027c4:	6a 20                	push   $0x20
801027c6:	56                   	push   %esi
801027c7:	50                   	push   %eax
801027c8:	57                   	push   %edi
801027c9:	e8 c2 0e 00 00       	call   80103690 <readi>
801027ce:	83 c4 10             	add    $0x10,%esp
801027d1:	83 f8 20             	cmp    $0x20,%eax
801027d4:	0f 84 5e ff ff ff    	je     80102738 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801027da:	83 ec 0c             	sub    $0xc,%esp
801027dd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801027e3:	e8 98 63 00 00       	call   80108b80 <freevm>
  if(ip){
801027e8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801027eb:	83 ec 0c             	sub    $0xc,%esp
801027ee:	57                   	push   %edi
801027ef:	e8 1c 0e 00 00       	call   80103610 <iunlockput>
    end_op();
801027f4:	e8 97 21 00 00       	call   80104990 <end_op>
801027f9:	83 c4 10             	add    $0x10,%esp
    return -1;
801027fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80102801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102804:	5b                   	pop    %ebx
80102805:	5e                   	pop    %esi
80102806:	5f                   	pop    %edi
80102807:	5d                   	pop    %ebp
80102808:	c3                   	ret
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80102810:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80102816:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010281c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102822:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80102828:	83 ec 0c             	sub    $0xc,%esp
8010282b:	57                   	push   %edi
8010282c:	e8 df 0d 00 00       	call   80103610 <iunlockput>
  end_op();
80102831:	e8 5a 21 00 00       	call   80104990 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102836:	83 c4 0c             	add    $0xc,%esp
80102839:	53                   	push   %ebx
8010283a:	56                   	push   %esi
8010283b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80102841:	56                   	push   %esi
80102842:	e8 e9 61 00 00       	call   80108a30 <allocuvm>
80102847:	83 c4 10             	add    $0x10,%esp
8010284a:	89 c7                	mov    %eax,%edi
8010284c:	85 c0                	test   %eax,%eax
8010284e:	0f 84 86 00 00 00    	je     801028da <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102854:	83 ec 08             	sub    $0x8,%esp
80102857:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010285d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010285f:	50                   	push   %eax
80102860:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80102861:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102863:	e8 38 64 00 00       	call   80108ca0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010286b:	83 c4 10             	add    $0x10,%esp
8010286e:	8b 10                	mov    (%eax),%edx
80102870:	85 d2                	test   %edx,%edx
80102872:	0f 84 56 01 00 00    	je     801029ce <exec+0x33e>
80102878:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010287e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102881:	eb 23                	jmp    801028a6 <exec+0x216>
80102883:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102888:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010288b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80102892:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80102898:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010289b:	85 d2                	test   %edx,%edx
8010289d:	74 51                	je     801028f0 <exec+0x260>
    if(argc >= MAXARG)
8010289f:	83 f8 20             	cmp    $0x20,%eax
801028a2:	74 36                	je     801028da <exec+0x24a>
801028a4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	52                   	push   %edx
801028aa:	e8 c1 3b 00 00       	call   80106470 <strlen>
801028af:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801028b1:	58                   	pop    %eax
801028b2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801028b5:	83 eb 01             	sub    $0x1,%ebx
801028b8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801028bb:	e8 b0 3b 00 00       	call   80106470 <strlen>
801028c0:	83 c0 01             	add    $0x1,%eax
801028c3:	50                   	push   %eax
801028c4:	ff 34 b7             	push   (%edi,%esi,4)
801028c7:	53                   	push   %ebx
801028c8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801028ce:	e8 9d 65 00 00       	call   80108e70 <copyout>
801028d3:	83 c4 20             	add    $0x20,%esp
801028d6:	85 c0                	test   %eax,%eax
801028d8:	79 ae                	jns    80102888 <exec+0x1f8>
    freevm(pgdir);
801028da:	83 ec 0c             	sub    $0xc,%esp
801028dd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801028e3:	e8 98 62 00 00       	call   80108b80 <freevm>
801028e8:	83 c4 10             	add    $0x10,%esp
801028eb:	e9 0c ff ff ff       	jmp    801027fc <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801028f0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801028f7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801028fd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102903:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80102906:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80102909:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80102910:	00 00 00 00 
  ustack[1] = argc;
80102914:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010291a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80102921:	ff ff ff 
  ustack[1] = argc;
80102924:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010292a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010292c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010292e:	29 d0                	sub    %edx,%eax
80102930:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102936:	56                   	push   %esi
80102937:	51                   	push   %ecx
80102938:	53                   	push   %ebx
80102939:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010293f:	e8 2c 65 00 00       	call   80108e70 <copyout>
80102944:	83 c4 10             	add    $0x10,%esp
80102947:	85 c0                	test   %eax,%eax
80102949:	78 8f                	js     801028da <exec+0x24a>
  for(last=s=path; *s; s++)
8010294b:	8b 45 08             	mov    0x8(%ebp),%eax
8010294e:	8b 55 08             	mov    0x8(%ebp),%edx
80102951:	0f b6 00             	movzbl (%eax),%eax
80102954:	84 c0                	test   %al,%al
80102956:	74 17                	je     8010296f <exec+0x2df>
80102958:	89 d1                	mov    %edx,%ecx
8010295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80102960:	83 c1 01             	add    $0x1,%ecx
80102963:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102965:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102968:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010296b:	84 c0                	test   %al,%al
8010296d:	75 f1                	jne    80102960 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010296f:	83 ec 04             	sub    $0x4,%esp
80102972:	6a 10                	push   $0x10
80102974:	52                   	push   %edx
80102975:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010297b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010297e:	50                   	push   %eax
8010297f:	e8 ac 3a 00 00       	call   80106430 <safestrcpy>
  curproc->pgdir = pgdir;
80102984:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010298a:	89 f0                	mov    %esi,%eax
8010298c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010298f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80102991:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102994:	89 c1                	mov    %eax,%ecx
80102996:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010299c:	8b 40 18             	mov    0x18(%eax),%eax
8010299f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801029a2:	8b 41 18             	mov    0x18(%ecx),%eax
801029a5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801029a8:	89 0c 24             	mov    %ecx,(%esp)
801029ab:	e8 20 5e 00 00       	call   801087d0 <switchuvm>
  freevm(oldpgdir);
801029b0:	89 34 24             	mov    %esi,(%esp)
801029b3:	e8 c8 61 00 00       	call   80108b80 <freevm>
  return 0;
801029b8:	83 c4 10             	add    $0x10,%esp
801029bb:	31 c0                	xor    %eax,%eax
801029bd:	e9 3f fe ff ff       	jmp    80102801 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801029c2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801029c7:	31 f6                	xor    %esi,%esi
801029c9:	e9 5a fe ff ff       	jmp    80102828 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801029ce:	be 10 00 00 00       	mov    $0x10,%esi
801029d3:	ba 04 00 00 00       	mov    $0x4,%edx
801029d8:	b8 03 00 00 00       	mov    $0x3,%eax
801029dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801029e4:	00 00 00 
801029e7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801029ed:	e9 17 ff ff ff       	jmp    80102909 <exec+0x279>
    end_op();
801029f2:	e8 99 1f 00 00       	call   80104990 <end_op>
    cprintf("exec: fail\n");
801029f7:	83 ec 0c             	sub    $0xc,%esp
801029fa:	68 13 90 10 80       	push   $0x80109013
801029ff:	e8 cc dd ff ff       	call   801007d0 <cprintf>
    return -1;
80102a04:	83 c4 10             	add    $0x10,%esp
80102a07:	e9 f0 fd ff ff       	jmp    801027fc <exec+0x16c>
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102a16:	68 1f 90 10 80       	push   $0x8010901f
80102a1b:	68 00 18 11 80       	push   $0x80111800
80102a20:	e8 6b 35 00 00       	call   80105f90 <initlock>
}
80102a25:	83 c4 10             	add    $0x10,%esp
80102a28:	c9                   	leave
80102a29:	c3                   	ret
80102a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102a34:	bb 34 18 11 80       	mov    $0x80111834,%ebx
{
80102a39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80102a3c:	68 00 18 11 80       	push   $0x80111800
80102a41:	e8 3a 37 00 00       	call   80106180 <acquire>
80102a46:	83 c4 10             	add    $0x10,%esp
80102a49:	eb 10                	jmp    80102a5b <filealloc+0x2b>
80102a4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102a50:	83 c3 18             	add    $0x18,%ebx
80102a53:	81 fb 94 21 11 80    	cmp    $0x80112194,%ebx
80102a59:	74 25                	je     80102a80 <filealloc+0x50>
    if(f->ref == 0){
80102a5b:	8b 43 04             	mov    0x4(%ebx),%eax
80102a5e:	85 c0                	test   %eax,%eax
80102a60:	75 ee                	jne    80102a50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102a62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102a65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80102a6c:	68 00 18 11 80       	push   $0x80111800
80102a71:	e8 aa 36 00 00       	call   80106120 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102a76:	89 d8                	mov    %ebx,%eax
      return f;
80102a78:	83 c4 10             	add    $0x10,%esp
}
80102a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a7e:	c9                   	leave
80102a7f:	c3                   	ret
  release(&ftable.lock);
80102a80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102a83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102a85:	68 00 18 11 80       	push   $0x80111800
80102a8a:	e8 91 36 00 00       	call   80106120 <release>
}
80102a8f:	89 d8                	mov    %ebx,%eax
  return 0;
80102a91:	83 c4 10             	add    $0x10,%esp
}
80102a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a97:	c9                   	leave
80102a98:	c3                   	ret
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 10             	sub    $0x10,%esp
80102aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80102aaa:	68 00 18 11 80       	push   $0x80111800
80102aaf:	e8 cc 36 00 00       	call   80106180 <acquire>
  if(f->ref < 1)
80102ab4:	8b 43 04             	mov    0x4(%ebx),%eax
80102ab7:	83 c4 10             	add    $0x10,%esp
80102aba:	85 c0                	test   %eax,%eax
80102abc:	7e 1a                	jle    80102ad8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80102abe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102ac1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102ac4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102ac7:	68 00 18 11 80       	push   $0x80111800
80102acc:	e8 4f 36 00 00       	call   80106120 <release>
  return f;
}
80102ad1:	89 d8                	mov    %ebx,%eax
80102ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ad6:	c9                   	leave
80102ad7:	c3                   	ret
    panic("filedup");
80102ad8:	83 ec 0c             	sub    $0xc,%esp
80102adb:	68 26 90 10 80       	push   $0x80109026
80102ae0:	e8 9b d8 ff ff       	call   80100380 <panic>
80102ae5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102aec:	00 
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	57                   	push   %edi
80102af4:	56                   	push   %esi
80102af5:	53                   	push   %ebx
80102af6:	83 ec 28             	sub    $0x28,%esp
80102af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80102afc:	68 00 18 11 80       	push   $0x80111800
80102b01:	e8 7a 36 00 00       	call   80106180 <acquire>
  if(f->ref < 1)
80102b06:	8b 53 04             	mov    0x4(%ebx),%edx
80102b09:	83 c4 10             	add    $0x10,%esp
80102b0c:	85 d2                	test   %edx,%edx
80102b0e:	0f 8e a5 00 00 00    	jle    80102bb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102b14:	83 ea 01             	sub    $0x1,%edx
80102b17:	89 53 04             	mov    %edx,0x4(%ebx)
80102b1a:	75 44                	jne    80102b60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80102b1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102b20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102b23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102b25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80102b2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80102b2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102b31:	8b 43 10             	mov    0x10(%ebx),%eax
80102b34:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80102b37:	68 00 18 11 80       	push   $0x80111800
80102b3c:	e8 df 35 00 00       	call   80106120 <release>

  if(ff.type == FD_PIPE)
80102b41:	83 c4 10             	add    $0x10,%esp
80102b44:	83 ff 01             	cmp    $0x1,%edi
80102b47:	74 57                	je     80102ba0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102b49:	83 ff 02             	cmp    $0x2,%edi
80102b4c:	74 2a                	je     80102b78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80102b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b51:	5b                   	pop    %ebx
80102b52:	5e                   	pop    %esi
80102b53:	5f                   	pop    %edi
80102b54:	5d                   	pop    %ebp
80102b55:	c3                   	ret
80102b56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b5d:	00 
80102b5e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80102b60:	c7 45 08 00 18 11 80 	movl   $0x80111800,0x8(%ebp)
}
80102b67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b6a:	5b                   	pop    %ebx
80102b6b:	5e                   	pop    %esi
80102b6c:	5f                   	pop    %edi
80102b6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80102b6e:	e9 ad 35 00 00       	jmp    80106120 <release>
80102b73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80102b78:	e8 a3 1d 00 00       	call   80104920 <begin_op>
    iput(ff.ip);
80102b7d:	83 ec 0c             	sub    $0xc,%esp
80102b80:	ff 75 e0             	push   -0x20(%ebp)
80102b83:	e8 28 09 00 00       	call   801034b0 <iput>
    end_op();
80102b88:	83 c4 10             	add    $0x10,%esp
}
80102b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8e:	5b                   	pop    %ebx
80102b8f:	5e                   	pop    %esi
80102b90:	5f                   	pop    %edi
80102b91:	5d                   	pop    %ebp
    end_op();
80102b92:	e9 f9 1d 00 00       	jmp    80104990 <end_op>
80102b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b9e:	00 
80102b9f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80102ba0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102ba4:	83 ec 08             	sub    $0x8,%esp
80102ba7:	53                   	push   %ebx
80102ba8:	56                   	push   %esi
80102ba9:	e8 32 25 00 00       	call   801050e0 <pipeclose>
80102bae:	83 c4 10             	add    $0x10,%esp
}
80102bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb4:	5b                   	pop    %ebx
80102bb5:	5e                   	pop    %esi
80102bb6:	5f                   	pop    %edi
80102bb7:	5d                   	pop    %ebp
80102bb8:	c3                   	ret
    panic("fileclose");
80102bb9:	83 ec 0c             	sub    $0xc,%esp
80102bbc:	68 2e 90 10 80       	push   $0x8010902e
80102bc1:	e8 ba d7 ff ff       	call   80100380 <panic>
80102bc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bcd:	00 
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	53                   	push   %ebx
80102bd4:	83 ec 04             	sub    $0x4,%esp
80102bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80102bda:	83 3b 02             	cmpl   $0x2,(%ebx)
80102bdd:	75 31                	jne    80102c10 <filestat+0x40>
    ilock(f->ip);
80102bdf:	83 ec 0c             	sub    $0xc,%esp
80102be2:	ff 73 10             	push   0x10(%ebx)
80102be5:	e8 96 07 00 00       	call   80103380 <ilock>
    stati(f->ip, st);
80102bea:	58                   	pop    %eax
80102beb:	5a                   	pop    %edx
80102bec:	ff 75 0c             	push   0xc(%ebp)
80102bef:	ff 73 10             	push   0x10(%ebx)
80102bf2:	e8 69 0a 00 00       	call   80103660 <stati>
    iunlock(f->ip);
80102bf7:	59                   	pop    %ecx
80102bf8:	ff 73 10             	push   0x10(%ebx)
80102bfb:	e8 60 08 00 00       	call   80103460 <iunlock>
    return 0;
  }
  return -1;
}
80102c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102c03:	83 c4 10             	add    $0x10,%esp
80102c06:	31 c0                	xor    %eax,%eax
}
80102c08:	c9                   	leave
80102c09:	c3                   	ret
80102c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c18:	c9                   	leave
80102c19:	c3                   	ret
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102c32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102c36:	74 60                	je     80102c98 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102c38:	8b 03                	mov    (%ebx),%eax
80102c3a:	83 f8 01             	cmp    $0x1,%eax
80102c3d:	74 41                	je     80102c80 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102c3f:	83 f8 02             	cmp    $0x2,%eax
80102c42:	75 5b                	jne    80102c9f <fileread+0x7f>
    ilock(f->ip);
80102c44:	83 ec 0c             	sub    $0xc,%esp
80102c47:	ff 73 10             	push   0x10(%ebx)
80102c4a:	e8 31 07 00 00       	call   80103380 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80102c4f:	57                   	push   %edi
80102c50:	ff 73 14             	push   0x14(%ebx)
80102c53:	56                   	push   %esi
80102c54:	ff 73 10             	push   0x10(%ebx)
80102c57:	e8 34 0a 00 00       	call   80103690 <readi>
80102c5c:	83 c4 20             	add    $0x20,%esp
80102c5f:	89 c6                	mov    %eax,%esi
80102c61:	85 c0                	test   %eax,%eax
80102c63:	7e 03                	jle    80102c68 <fileread+0x48>
      f->off += r;
80102c65:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102c68:	83 ec 0c             	sub    $0xc,%esp
80102c6b:	ff 73 10             	push   0x10(%ebx)
80102c6e:	e8 ed 07 00 00       	call   80103460 <iunlock>
    return r;
80102c73:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c79:	89 f0                	mov    %esi,%eax
80102c7b:	5b                   	pop    %ebx
80102c7c:	5e                   	pop    %esi
80102c7d:	5f                   	pop    %edi
80102c7e:	5d                   	pop    %ebp
80102c7f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80102c80:	8b 43 0c             	mov    0xc(%ebx),%eax
80102c83:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c89:	5b                   	pop    %ebx
80102c8a:	5e                   	pop    %esi
80102c8b:	5f                   	pop    %edi
80102c8c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80102c8d:	e9 0e 26 00 00       	jmp    801052a0 <piperead>
80102c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102c98:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102c9d:	eb d7                	jmp    80102c76 <fileread+0x56>
  panic("fileread");
80102c9f:	83 ec 0c             	sub    $0xc,%esp
80102ca2:	68 38 90 10 80       	push   $0x80109038
80102ca7:	e8 d4 d6 ff ff       	call   80100380 <panic>
80102cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 1c             	sub    $0x1c,%esp
80102cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102cc5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102cc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80102ccc:	0f 84 bb 00 00 00    	je     80102d8d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80102cd2:	8b 03                	mov    (%ebx),%eax
80102cd4:	83 f8 01             	cmp    $0x1,%eax
80102cd7:	0f 84 bf 00 00 00    	je     80102d9c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102cdd:	83 f8 02             	cmp    $0x2,%eax
80102ce0:	0f 85 c8 00 00 00    	jne    80102dae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80102ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80102ce9:	31 f6                	xor    %esi,%esi
    while(i < n){
80102ceb:	85 c0                	test   %eax,%eax
80102ced:	7f 30                	jg     80102d1f <filewrite+0x6f>
80102cef:	e9 94 00 00 00       	jmp    80102d88 <filewrite+0xd8>
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102cf8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80102cfb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
80102cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102d01:	ff 73 10             	push   0x10(%ebx)
80102d04:	e8 57 07 00 00       	call   80103460 <iunlock>
      end_op();
80102d09:	e8 82 1c 00 00       	call   80104990 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80102d0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d11:	83 c4 10             	add    $0x10,%esp
80102d14:	39 c7                	cmp    %eax,%edi
80102d16:	75 5c                	jne    80102d74 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102d18:	01 fe                	add    %edi,%esi
    while(i < n){
80102d1a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102d1d:	7e 69                	jle    80102d88 <filewrite+0xd8>
      int n1 = n - i;
80102d1f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80102d22:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80102d27:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80102d29:	39 c7                	cmp    %eax,%edi
80102d2b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80102d2e:	e8 ed 1b 00 00       	call   80104920 <begin_op>
      ilock(f->ip);
80102d33:	83 ec 0c             	sub    $0xc,%esp
80102d36:	ff 73 10             	push   0x10(%ebx)
80102d39:	e8 42 06 00 00       	call   80103380 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80102d3e:	57                   	push   %edi
80102d3f:	ff 73 14             	push   0x14(%ebx)
80102d42:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d45:	01 f0                	add    %esi,%eax
80102d47:	50                   	push   %eax
80102d48:	ff 73 10             	push   0x10(%ebx)
80102d4b:	e8 40 0a 00 00       	call   80103790 <writei>
80102d50:	83 c4 20             	add    $0x20,%esp
80102d53:	85 c0                	test   %eax,%eax
80102d55:	7f a1                	jg     80102cf8 <filewrite+0x48>
80102d57:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102d5a:	83 ec 0c             	sub    $0xc,%esp
80102d5d:	ff 73 10             	push   0x10(%ebx)
80102d60:	e8 fb 06 00 00       	call   80103460 <iunlock>
      end_op();
80102d65:	e8 26 1c 00 00       	call   80104990 <end_op>
      if(r < 0)
80102d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d6d:	83 c4 10             	add    $0x10,%esp
80102d70:	85 c0                	test   %eax,%eax
80102d72:	75 14                	jne    80102d88 <filewrite+0xd8>
        panic("short filewrite");
80102d74:	83 ec 0c             	sub    $0xc,%esp
80102d77:	68 41 90 10 80       	push   $0x80109041
80102d7c:	e8 ff d5 ff ff       	call   80100380 <panic>
80102d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102d88:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102d8b:	74 05                	je     80102d92 <filewrite+0xe2>
80102d8d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	89 f0                	mov    %esi,%eax
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80102d9c:	8b 43 0c             	mov    0xc(%ebx),%eax
80102d9f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da5:	5b                   	pop    %ebx
80102da6:	5e                   	pop    %esi
80102da7:	5f                   	pop    %edi
80102da8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102da9:	e9 d2 23 00 00       	jmp    80105180 <pipewrite>
  panic("filewrite");
80102dae:	83 ec 0c             	sub    $0xc,%esp
80102db1:	68 47 90 10 80       	push   $0x80109047
80102db6:	e8 c5 d5 ff ff       	call   80100380 <panic>
80102dbb:	66 90                	xchg   %ax,%ax
80102dbd:	66 90                	xchg   %ax,%ax
80102dbf:	90                   	nop

80102dc0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	57                   	push   %edi
80102dc4:	56                   	push   %esi
80102dc5:	53                   	push   %ebx
80102dc6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80102dc9:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
{
80102dcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102dd2:	85 c9                	test   %ecx,%ecx
80102dd4:	0f 84 8c 00 00 00    	je     80102e66 <balloc+0xa6>
80102dda:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
80102ddc:	89 f8                	mov    %edi,%eax
80102dde:	83 ec 08             	sub    $0x8,%esp
80102de1:	89 fe                	mov    %edi,%esi
80102de3:	c1 f8 0c             	sar    $0xc,%eax
80102de6:	03 05 6c 3e 11 80    	add    0x80113e6c,%eax
80102dec:	50                   	push   %eax
80102ded:	ff 75 dc             	push   -0x24(%ebp)
80102df0:	e8 db d2 ff ff       	call   801000d0 <bread>
80102df5:	83 c4 10             	add    $0x10,%esp
80102df8:	89 7d d8             	mov    %edi,-0x28(%ebp)
80102dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102dfe:	a1 54 3e 11 80       	mov    0x80113e54,%eax
80102e03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e06:	31 c0                	xor    %eax,%eax
80102e08:	eb 32                	jmp    80102e3c <balloc+0x7c>
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102e10:	89 c1                	mov    %eax,%ecx
80102e12:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102e17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
80102e1a:	83 e1 07             	and    $0x7,%ecx
80102e1d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102e1f:	89 c1                	mov    %eax,%ecx
80102e21:	c1 f9 03             	sar    $0x3,%ecx
80102e24:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80102e29:	89 fa                	mov    %edi,%edx
80102e2b:	85 df                	test   %ebx,%edi
80102e2d:	74 49                	je     80102e78 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102e2f:	83 c0 01             	add    $0x1,%eax
80102e32:	83 c6 01             	add    $0x1,%esi
80102e35:	3d 00 10 00 00       	cmp    $0x1000,%eax
80102e3a:	74 07                	je     80102e43 <balloc+0x83>
80102e3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102e3f:	39 d6                	cmp    %edx,%esi
80102e41:	72 cd                	jb     80102e10 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80102e43:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102e4c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80102e52:	e8 99 d3 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80102e57:	83 c4 10             	add    $0x10,%esp
80102e5a:	3b 3d 54 3e 11 80    	cmp    0x80113e54,%edi
80102e60:	0f 82 76 ff ff ff    	jb     80102ddc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 51 90 10 80       	push   $0x80109051
80102e6e:	e8 0d d5 ff ff       	call   80100380 <panic>
80102e73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80102e78:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80102e7b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80102e7e:	09 da                	or     %ebx,%edx
80102e80:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80102e84:	57                   	push   %edi
80102e85:	e8 76 1c 00 00       	call   80104b00 <log_write>
        brelse(bp);
80102e8a:	89 3c 24             	mov    %edi,(%esp)
80102e8d:	e8 5e d3 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80102e92:	58                   	pop    %eax
80102e93:	5a                   	pop    %edx
80102e94:	56                   	push   %esi
80102e95:	ff 75 dc             	push   -0x24(%ebp)
80102e98:	e8 33 d2 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102e9d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102ea0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80102ea2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ea5:	68 00 02 00 00       	push   $0x200
80102eaa:	6a 00                	push   $0x0
80102eac:	50                   	push   %eax
80102ead:	e8 ce 33 00 00       	call   80106280 <memset>
  log_write(bp);
80102eb2:	89 1c 24             	mov    %ebx,(%esp)
80102eb5:	e8 46 1c 00 00       	call   80104b00 <log_write>
  brelse(bp);
80102eba:	89 1c 24             	mov    %ebx,(%esp)
80102ebd:	e8 2e d3 ff ff       	call   801001f0 <brelse>
}
80102ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec5:	89 f0                	mov    %esi,%eax
80102ec7:	5b                   	pop    %ebx
80102ec8:	5e                   	pop    %esi
80102ec9:	5f                   	pop    %edi
80102eca:	5d                   	pop    %ebp
80102ecb:	c3                   	ret
80102ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ed0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102ed4:	31 ff                	xor    %edi,%edi
{
80102ed6:	56                   	push   %esi
80102ed7:	89 c6                	mov    %eax,%esi
80102ed9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102eda:	bb 34 22 11 80       	mov    $0x80112234,%ebx
{
80102edf:	83 ec 28             	sub    $0x28,%esp
80102ee2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102ee5:	68 00 22 11 80       	push   $0x80112200
80102eea:	e8 91 32 00 00       	call   80106180 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102eef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102ef2:	83 c4 10             	add    $0x10,%esp
80102ef5:	eb 1b                	jmp    80102f12 <iget+0x42>
80102ef7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102efe:	00 
80102eff:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102f00:	39 33                	cmp    %esi,(%ebx)
80102f02:	74 6c                	je     80102f70 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102f04:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102f0a:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80102f10:	74 26                	je     80102f38 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102f12:	8b 43 08             	mov    0x8(%ebx),%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	7f e7                	jg     80102f00 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102f19:	85 ff                	test   %edi,%edi
80102f1b:	75 e7                	jne    80102f04 <iget+0x34>
80102f1d:	85 c0                	test   %eax,%eax
80102f1f:	75 76                	jne    80102f97 <iget+0xc7>
      empty = ip;
80102f21:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102f23:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102f29:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80102f2f:	75 e1                	jne    80102f12 <iget+0x42>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80102f38:	85 ff                	test   %edi,%edi
80102f3a:	74 79                	je     80102fb5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80102f3c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80102f3f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80102f41:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80102f44:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80102f4b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80102f52:	68 00 22 11 80       	push   $0x80112200
80102f57:	e8 c4 31 00 00       	call   80106120 <release>

  return ip;
80102f5c:	83 c4 10             	add    $0x10,%esp
}
80102f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f62:	89 f8                	mov    %edi,%eax
80102f64:	5b                   	pop    %ebx
80102f65:	5e                   	pop    %esi
80102f66:	5f                   	pop    %edi
80102f67:	5d                   	pop    %ebp
80102f68:	c3                   	ret
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102f70:	39 53 04             	cmp    %edx,0x4(%ebx)
80102f73:	75 8f                	jne    80102f04 <iget+0x34>
      ip->ref++;
80102f75:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80102f78:	83 ec 0c             	sub    $0xc,%esp
      return ip;
80102f7b:	89 df                	mov    %ebx,%edi
      ip->ref++;
80102f7d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102f80:	68 00 22 11 80       	push   $0x80112200
80102f85:	e8 96 31 00 00       	call   80106120 <release>
      return ip;
80102f8a:	83 c4 10             	add    $0x10,%esp
}
80102f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f90:	89 f8                	mov    %edi,%eax
80102f92:	5b                   	pop    %ebx
80102f93:	5e                   	pop    %esi
80102f94:	5f                   	pop    %edi
80102f95:	5d                   	pop    %ebp
80102f96:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102f97:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102f9d:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80102fa3:	74 10                	je     80102fb5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102fa5:	8b 43 08             	mov    0x8(%ebx),%eax
80102fa8:	85 c0                	test   %eax,%eax
80102faa:	0f 8f 50 ff ff ff    	jg     80102f00 <iget+0x30>
80102fb0:	e9 68 ff ff ff       	jmp    80102f1d <iget+0x4d>
    panic("iget: no inodes");
80102fb5:	83 ec 0c             	sub    $0xc,%esp
80102fb8:	68 67 90 10 80       	push   $0x80109067
80102fbd:	e8 be d3 ff ff       	call   80100380 <panic>
80102fc2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fc9:	00 
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102fd0 <bfree>:
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80102fd3:	89 d0                	mov    %edx,%eax
80102fd5:	c1 e8 0c             	shr    $0xc,%eax
{
80102fd8:	89 e5                	mov    %esp,%ebp
80102fda:	56                   	push   %esi
80102fdb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
80102fdc:	03 05 6c 3e 11 80    	add    0x80113e6c,%eax
{
80102fe2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80102fe4:	83 ec 08             	sub    $0x8,%esp
80102fe7:	50                   	push   %eax
80102fe8:	51                   	push   %ecx
80102fe9:	e8 e2 d0 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80102fee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80102ff0:	c1 fb 03             	sar    $0x3,%ebx
80102ff3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80102ff6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80102ff8:	83 e1 07             	and    $0x7,%ecx
80102ffb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80103000:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80103006:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80103008:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010300d:	85 c1                	test   %eax,%ecx
8010300f:	74 23                	je     80103034 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80103011:	f7 d0                	not    %eax
  log_write(bp);
80103013:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80103016:	21 c8                	and    %ecx,%eax
80103018:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010301c:	56                   	push   %esi
8010301d:	e8 de 1a 00 00       	call   80104b00 <log_write>
  brelse(bp);
80103022:	89 34 24             	mov    %esi,(%esp)
80103025:	e8 c6 d1 ff ff       	call   801001f0 <brelse>
}
8010302a:	83 c4 10             	add    $0x10,%esp
8010302d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103030:	5b                   	pop    %ebx
80103031:	5e                   	pop    %esi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret
    panic("freeing free block");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 77 90 10 80       	push   $0x80109077
8010303c:	e8 3f d3 ff ff       	call   80100380 <panic>
80103041:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103048:	00 
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103050 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	89 c6                	mov    %eax,%esi
80103057:	53                   	push   %ebx
80103058:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010305b:	83 fa 0b             	cmp    $0xb,%edx
8010305e:	0f 86 8c 00 00 00    	jbe    801030f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80103064:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80103067:	83 fb 7f             	cmp    $0x7f,%ebx
8010306a:	0f 87 a2 00 00 00    	ja     80103112 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80103070:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80103076:	85 c0                	test   %eax,%eax
80103078:	74 5e                	je     801030d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010307a:	83 ec 08             	sub    $0x8,%esp
8010307d:	50                   	push   %eax
8010307e:	ff 36                	push   (%esi)
80103080:	e8 4b d0 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80103085:	83 c4 10             	add    $0x10,%esp
80103088:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010308c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010308e:	8b 3b                	mov    (%ebx),%edi
80103090:	85 ff                	test   %edi,%edi
80103092:	74 1c                	je     801030b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80103094:	83 ec 0c             	sub    $0xc,%esp
80103097:	52                   	push   %edx
80103098:	e8 53 d1 ff ff       	call   801001f0 <brelse>
8010309d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801030a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030a3:	89 f8                	mov    %edi,%eax
801030a5:	5b                   	pop    %ebx
801030a6:	5e                   	pop    %esi
801030a7:	5f                   	pop    %edi
801030a8:	5d                   	pop    %ebp
801030a9:	c3                   	ret
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801030b3:	8b 06                	mov    (%esi),%eax
801030b5:	e8 06 fd ff ff       	call   80102dc0 <balloc>
      log_write(bp);
801030ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801030bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801030c0:	89 03                	mov    %eax,(%ebx)
801030c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801030c4:	52                   	push   %edx
801030c5:	e8 36 1a 00 00       	call   80104b00 <log_write>
801030ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	eb c2                	jmp    80103094 <bmap+0x44>
801030d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801030d8:	8b 06                	mov    (%esi),%eax
801030da:	e8 e1 fc ff ff       	call   80102dc0 <balloc>
801030df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801030e5:	eb 93                	jmp    8010307a <bmap+0x2a>
801030e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030ee:	00 
801030ef:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801030f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801030f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801030f7:	85 ff                	test   %edi,%edi
801030f9:	75 a5                	jne    801030a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801030fb:	8b 00                	mov    (%eax),%eax
801030fd:	e8 be fc ff ff       	call   80102dc0 <balloc>
80103102:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80103106:	89 c7                	mov    %eax,%edi
}
80103108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310b:	5b                   	pop    %ebx
8010310c:	89 f8                	mov    %edi,%eax
8010310e:	5e                   	pop    %esi
8010310f:	5f                   	pop    %edi
80103110:	5d                   	pop    %ebp
80103111:	c3                   	ret
  panic("bmap: out of range");
80103112:	83 ec 0c             	sub    $0xc,%esp
80103115:	68 8a 90 10 80       	push   $0x8010908a
8010311a:	e8 61 d2 ff ff       	call   80100380 <panic>
8010311f:	90                   	nop

80103120 <readsb>:
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	56                   	push   %esi
80103124:	53                   	push   %ebx
80103125:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80103128:	83 ec 08             	sub    $0x8,%esp
8010312b:	6a 01                	push   $0x1
8010312d:	ff 75 08             	push   0x8(%ebp)
80103130:	e8 9b cf ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80103135:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80103138:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010313a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010313d:	6a 1c                	push   $0x1c
8010313f:	50                   	push   %eax
80103140:	56                   	push   %esi
80103141:	e8 ca 31 00 00       	call   80106310 <memmove>
  brelse(bp);
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010314c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5d                   	pop    %ebp
  brelse(bp);
80103152:	e9 99 d0 ff ff       	jmp    801001f0 <brelse>
80103157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010315e:	00 
8010315f:	90                   	nop

80103160 <iinit>:
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	bb 40 22 11 80       	mov    $0x80112240,%ebx
80103169:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010316c:	68 9d 90 10 80       	push   $0x8010909d
80103171:	68 00 22 11 80       	push   $0x80112200
80103176:	e8 15 2e 00 00       	call   80105f90 <initlock>
  for(i = 0; i < NINODE; i++) {
8010317b:	83 c4 10             	add    $0x10,%esp
8010317e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 a4 90 10 80       	push   $0x801090a4
80103188:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80103189:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010318f:	e8 cc 2c 00 00       	call   80105e60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80103194:	83 c4 10             	add    $0x10,%esp
80103197:	81 fb 60 3e 11 80    	cmp    $0x80113e60,%ebx
8010319d:	75 e1                	jne    80103180 <iinit+0x20>
  bp = bread(dev, 1);
8010319f:	83 ec 08             	sub    $0x8,%esp
801031a2:	6a 01                	push   $0x1
801031a4:	ff 75 08             	push   0x8(%ebp)
801031a7:	e8 24 cf ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801031ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801031af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801031b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801031b4:	6a 1c                	push   $0x1c
801031b6:	50                   	push   %eax
801031b7:	68 54 3e 11 80       	push   $0x80113e54
801031bc:	e8 4f 31 00 00       	call   80106310 <memmove>
  brelse(bp);
801031c1:	89 1c 24             	mov    %ebx,(%esp)
801031c4:	e8 27 d0 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801031c9:	ff 35 6c 3e 11 80    	push   0x80113e6c
801031cf:	ff 35 68 3e 11 80    	push   0x80113e68
801031d5:	ff 35 64 3e 11 80    	push   0x80113e64
801031db:	ff 35 60 3e 11 80    	push   0x80113e60
801031e1:	ff 35 5c 3e 11 80    	push   0x80113e5c
801031e7:	ff 35 58 3e 11 80    	push   0x80113e58
801031ed:	ff 35 54 3e 11 80    	push   0x80113e54
801031f3:	68 1c 95 10 80       	push   $0x8010951c
801031f8:	e8 d3 d5 ff ff       	call   801007d0 <cprintf>
}
801031fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103200:	83 c4 30             	add    $0x30,%esp
80103203:	c9                   	leave
80103204:	c3                   	ret
80103205:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010320c:	00 
8010320d:	8d 76 00             	lea    0x0(%esi),%esi

80103210 <ialloc>:
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
80103219:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010321c:	83 3d 5c 3e 11 80 01 	cmpl   $0x1,0x80113e5c
{
80103223:	8b 75 08             	mov    0x8(%ebp),%esi
80103226:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80103229:	0f 86 91 00 00 00    	jbe    801032c0 <ialloc+0xb0>
8010322f:	bf 01 00 00 00       	mov    $0x1,%edi
80103234:	eb 21                	jmp    80103257 <ialloc+0x47>
80103236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010323d:	00 
8010323e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80103240:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80103243:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80103246:	53                   	push   %ebx
80103247:	e8 a4 cf ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010324c:	83 c4 10             	add    $0x10,%esp
8010324f:	3b 3d 5c 3e 11 80    	cmp    0x80113e5c,%edi
80103255:	73 69                	jae    801032c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80103257:	89 f8                	mov    %edi,%eax
80103259:	83 ec 08             	sub    $0x8,%esp
8010325c:	c1 e8 03             	shr    $0x3,%eax
8010325f:	03 05 68 3e 11 80    	add    0x80113e68,%eax
80103265:	50                   	push   %eax
80103266:	56                   	push   %esi
80103267:	e8 64 ce ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010326c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010326f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80103271:	89 f8                	mov    %edi,%eax
80103273:	83 e0 07             	and    $0x7,%eax
80103276:	c1 e0 06             	shl    $0x6,%eax
80103279:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010327d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80103281:	75 bd                	jne    80103240 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80103283:	83 ec 04             	sub    $0x4,%esp
80103286:	6a 40                	push   $0x40
80103288:	6a 00                	push   $0x0
8010328a:	51                   	push   %ecx
8010328b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010328e:	e8 ed 2f 00 00       	call   80106280 <memset>
      dip->type = type;
80103293:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80103297:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010329a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010329d:	89 1c 24             	mov    %ebx,(%esp)
801032a0:	e8 5b 18 00 00       	call   80104b00 <log_write>
      brelse(bp);
801032a5:	89 1c 24             	mov    %ebx,(%esp)
801032a8:	e8 43 cf ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801032ad:	83 c4 10             	add    $0x10,%esp
}
801032b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801032b3:	89 fa                	mov    %edi,%edx
}
801032b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801032b6:	89 f0                	mov    %esi,%eax
}
801032b8:	5e                   	pop    %esi
801032b9:	5f                   	pop    %edi
801032ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801032bb:	e9 10 fc ff ff       	jmp    80102ed0 <iget>
  panic("ialloc: no inodes");
801032c0:	83 ec 0c             	sub    $0xc,%esp
801032c3:	68 aa 90 10 80       	push   $0x801090aa
801032c8:	e8 b3 d0 ff ff       	call   80100380 <panic>
801032cd:	8d 76 00             	lea    0x0(%esi),%esi

801032d0 <iupdate>:
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	56                   	push   %esi
801032d4:	53                   	push   %ebx
801032d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801032db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032de:	83 ec 08             	sub    $0x8,%esp
801032e1:	c1 e8 03             	shr    $0x3,%eax
801032e4:	03 05 68 3e 11 80    	add    0x80113e68,%eax
801032ea:	50                   	push   %eax
801032eb:	ff 73 a4             	push   -0x5c(%ebx)
801032ee:	e8 dd cd ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801032f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801032f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801032fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801032ff:	83 e0 07             	and    $0x7,%eax
80103302:	c1 e0 06             	shl    $0x6,%eax
80103305:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80103309:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010330c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80103310:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80103313:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80103317:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010331b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010331f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80103323:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80103327:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010332a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010332d:	6a 34                	push   $0x34
8010332f:	53                   	push   %ebx
80103330:	50                   	push   %eax
80103331:	e8 da 2f 00 00       	call   80106310 <memmove>
  log_write(bp);
80103336:	89 34 24             	mov    %esi,(%esp)
80103339:	e8 c2 17 00 00       	call   80104b00 <log_write>
  brelse(bp);
8010333e:	83 c4 10             	add    $0x10,%esp
80103341:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103344:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103347:	5b                   	pop    %ebx
80103348:	5e                   	pop    %esi
80103349:	5d                   	pop    %ebp
  brelse(bp);
8010334a:	e9 a1 ce ff ff       	jmp    801001f0 <brelse>
8010334f:	90                   	nop

80103350 <idup>:
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 10             	sub    $0x10,%esp
80103357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010335a:	68 00 22 11 80       	push   $0x80112200
8010335f:	e8 1c 2e 00 00       	call   80106180 <acquire>
  ip->ref++;
80103364:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80103368:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
8010336f:	e8 ac 2d 00 00       	call   80106120 <release>
}
80103374:	89 d8                	mov    %ebx,%eax
80103376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103379:	c9                   	leave
8010337a:	c3                   	ret
8010337b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103380 <ilock>:
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	56                   	push   %esi
80103384:	53                   	push   %ebx
80103385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80103388:	85 db                	test   %ebx,%ebx
8010338a:	0f 84 b7 00 00 00    	je     80103447 <ilock+0xc7>
80103390:	8b 53 08             	mov    0x8(%ebx),%edx
80103393:	85 d2                	test   %edx,%edx
80103395:	0f 8e ac 00 00 00    	jle    80103447 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	8d 43 0c             	lea    0xc(%ebx),%eax
801033a1:	50                   	push   %eax
801033a2:	e8 f9 2a 00 00       	call   80105ea0 <acquiresleep>
  if(ip->valid == 0){
801033a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801033aa:	83 c4 10             	add    $0x10,%esp
801033ad:	85 c0                	test   %eax,%eax
801033af:	74 0f                	je     801033c0 <ilock+0x40>
}
801033b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b4:	5b                   	pop    %ebx
801033b5:	5e                   	pop    %esi
801033b6:	5d                   	pop    %ebp
801033b7:	c3                   	ret
801033b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033bf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801033c0:	8b 43 04             	mov    0x4(%ebx),%eax
801033c3:	83 ec 08             	sub    $0x8,%esp
801033c6:	c1 e8 03             	shr    $0x3,%eax
801033c9:	03 05 68 3e 11 80    	add    0x80113e68,%eax
801033cf:	50                   	push   %eax
801033d0:	ff 33                	push   (%ebx)
801033d2:	e8 f9 cc ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801033d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801033da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801033dc:	8b 43 04             	mov    0x4(%ebx),%eax
801033df:	83 e0 07             	and    $0x7,%eax
801033e2:	c1 e0 06             	shl    $0x6,%eax
801033e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801033e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801033ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801033ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801033f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801033f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801033fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801033ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80103403:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80103407:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010340b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010340e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80103411:	6a 34                	push   $0x34
80103413:	50                   	push   %eax
80103414:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103417:	50                   	push   %eax
80103418:	e8 f3 2e 00 00       	call   80106310 <memmove>
    brelse(bp);
8010341d:	89 34 24             	mov    %esi,(%esp)
80103420:	e8 cb cd ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010342d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80103434:	0f 85 77 ff ff ff    	jne    801033b1 <ilock+0x31>
      panic("ilock: no type");
8010343a:	83 ec 0c             	sub    $0xc,%esp
8010343d:	68 c2 90 10 80       	push   $0x801090c2
80103442:	e8 39 cf ff ff       	call   80100380 <panic>
    panic("ilock");
80103447:	83 ec 0c             	sub    $0xc,%esp
8010344a:	68 bc 90 10 80       	push   $0x801090bc
8010344f:	e8 2c cf ff ff       	call   80100380 <panic>
80103454:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010345b:	00 
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103460 <iunlock>:
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
80103465:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103468:	85 db                	test   %ebx,%ebx
8010346a:	74 28                	je     80103494 <iunlock+0x34>
8010346c:	83 ec 0c             	sub    $0xc,%esp
8010346f:	8d 73 0c             	lea    0xc(%ebx),%esi
80103472:	56                   	push   %esi
80103473:	e8 c8 2a 00 00       	call   80105f40 <holdingsleep>
80103478:	83 c4 10             	add    $0x10,%esp
8010347b:	85 c0                	test   %eax,%eax
8010347d:	74 15                	je     80103494 <iunlock+0x34>
8010347f:	8b 43 08             	mov    0x8(%ebx),%eax
80103482:	85 c0                	test   %eax,%eax
80103484:	7e 0e                	jle    80103494 <iunlock+0x34>
  releasesleep(&ip->lock);
80103486:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103489:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010348c:	5b                   	pop    %ebx
8010348d:	5e                   	pop    %esi
8010348e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010348f:	e9 6c 2a 00 00       	jmp    80105f00 <releasesleep>
    panic("iunlock");
80103494:	83 ec 0c             	sub    $0xc,%esp
80103497:	68 d1 90 10 80       	push   $0x801090d1
8010349c:	e8 df ce ff ff       	call   80100380 <panic>
801034a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034a8:	00 
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <iput>:
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 28             	sub    $0x28,%esp
801034b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801034bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801034bf:	57                   	push   %edi
801034c0:	e8 db 29 00 00       	call   80105ea0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801034c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801034c8:	83 c4 10             	add    $0x10,%esp
801034cb:	85 d2                	test   %edx,%edx
801034cd:	74 07                	je     801034d6 <iput+0x26>
801034cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801034d4:	74 32                	je     80103508 <iput+0x58>
  releasesleep(&ip->lock);
801034d6:	83 ec 0c             	sub    $0xc,%esp
801034d9:	57                   	push   %edi
801034da:	e8 21 2a 00 00       	call   80105f00 <releasesleep>
  acquire(&icache.lock);
801034df:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
801034e6:	e8 95 2c 00 00       	call   80106180 <acquire>
  ip->ref--;
801034eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801034ef:	83 c4 10             	add    $0x10,%esp
801034f2:	c7 45 08 00 22 11 80 	movl   $0x80112200,0x8(%ebp)
}
801034f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034fc:	5b                   	pop    %ebx
801034fd:	5e                   	pop    %esi
801034fe:	5f                   	pop    %edi
801034ff:	5d                   	pop    %ebp
  release(&icache.lock);
80103500:	e9 1b 2c 00 00       	jmp    80106120 <release>
80103505:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	68 00 22 11 80       	push   $0x80112200
80103510:	e8 6b 2c 00 00       	call   80106180 <acquire>
    int r = ip->ref;
80103515:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80103518:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
8010351f:	e8 fc 2b 00 00       	call   80106120 <release>
    if(r == 1){
80103524:	83 c4 10             	add    $0x10,%esp
80103527:	83 fe 01             	cmp    $0x1,%esi
8010352a:	75 aa                	jne    801034d6 <iput+0x26>
8010352c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80103532:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80103535:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103538:	89 df                	mov    %ebx,%edi
8010353a:	89 cb                	mov    %ecx,%ebx
8010353c:	eb 09                	jmp    80103547 <iput+0x97>
8010353e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80103540:	83 c6 04             	add    $0x4,%esi
80103543:	39 de                	cmp    %ebx,%esi
80103545:	74 19                	je     80103560 <iput+0xb0>
    if(ip->addrs[i]){
80103547:	8b 16                	mov    (%esi),%edx
80103549:	85 d2                	test   %edx,%edx
8010354b:	74 f3                	je     80103540 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010354d:	8b 07                	mov    (%edi),%eax
8010354f:	e8 7c fa ff ff       	call   80102fd0 <bfree>
      ip->addrs[i] = 0;
80103554:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010355a:	eb e4                	jmp    80103540 <iput+0x90>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80103560:	89 fb                	mov    %edi,%ebx
80103562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103565:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010356b:	85 c0                	test   %eax,%eax
8010356d:	75 2d                	jne    8010359c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010356f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80103572:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80103579:	53                   	push   %ebx
8010357a:	e8 51 fd ff ff       	call   801032d0 <iupdate>
      ip->type = 0;
8010357f:	31 c0                	xor    %eax,%eax
80103581:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80103585:	89 1c 24             	mov    %ebx,(%esp)
80103588:	e8 43 fd ff ff       	call   801032d0 <iupdate>
      ip->valid = 0;
8010358d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80103594:	83 c4 10             	add    $0x10,%esp
80103597:	e9 3a ff ff ff       	jmp    801034d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010359c:	83 ec 08             	sub    $0x8,%esp
8010359f:	50                   	push   %eax
801035a0:	ff 33                	push   (%ebx)
801035a2:	e8 29 cb ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801035a7:	83 c4 10             	add    $0x10,%esp
801035aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801035ad:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801035b6:	8d 70 5c             	lea    0x5c(%eax),%esi
801035b9:	89 cf                	mov    %ecx,%edi
801035bb:	eb 0a                	jmp    801035c7 <iput+0x117>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
801035c0:	83 c6 04             	add    $0x4,%esi
801035c3:	39 fe                	cmp    %edi,%esi
801035c5:	74 0f                	je     801035d6 <iput+0x126>
      if(a[j])
801035c7:	8b 16                	mov    (%esi),%edx
801035c9:	85 d2                	test   %edx,%edx
801035cb:	74 f3                	je     801035c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801035cd:	8b 03                	mov    (%ebx),%eax
801035cf:	e8 fc f9 ff ff       	call   80102fd0 <bfree>
801035d4:	eb ea                	jmp    801035c0 <iput+0x110>
    brelse(bp);
801035d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035d9:	83 ec 0c             	sub    $0xc,%esp
801035dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801035df:	50                   	push   %eax
801035e0:	e8 0b cc ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801035e5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801035eb:	8b 03                	mov    (%ebx),%eax
801035ed:	e8 de f9 ff ff       	call   80102fd0 <bfree>
    ip->addrs[NDIRECT] = 0;
801035f2:	83 c4 10             	add    $0x10,%esp
801035f5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801035fc:	00 00 00 
801035ff:	e9 6b ff ff ff       	jmp    8010356f <iput+0xbf>
80103604:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010360b:	00 
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103610 <iunlockput>:
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	56                   	push   %esi
80103614:	53                   	push   %ebx
80103615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103618:	85 db                	test   %ebx,%ebx
8010361a:	74 34                	je     80103650 <iunlockput+0x40>
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	8d 73 0c             	lea    0xc(%ebx),%esi
80103622:	56                   	push   %esi
80103623:	e8 18 29 00 00       	call   80105f40 <holdingsleep>
80103628:	83 c4 10             	add    $0x10,%esp
8010362b:	85 c0                	test   %eax,%eax
8010362d:	74 21                	je     80103650 <iunlockput+0x40>
8010362f:	8b 43 08             	mov    0x8(%ebx),%eax
80103632:	85 c0                	test   %eax,%eax
80103634:	7e 1a                	jle    80103650 <iunlockput+0x40>
  releasesleep(&ip->lock);
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	56                   	push   %esi
8010363a:	e8 c1 28 00 00       	call   80105f00 <releasesleep>
  iput(ip);
8010363f:	83 c4 10             	add    $0x10,%esp
80103642:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103645:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5d                   	pop    %ebp
  iput(ip);
8010364b:	e9 60 fe ff ff       	jmp    801034b0 <iput>
    panic("iunlock");
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 d1 90 10 80       	push   $0x801090d1
80103658:	e8 23 cd ff ff       	call   80100380 <panic>
8010365d:	8d 76 00             	lea    0x0(%esi),%esi

80103660 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	8b 55 08             	mov    0x8(%ebp),%edx
80103666:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80103669:	8b 0a                	mov    (%edx),%ecx
8010366b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010366e:	8b 4a 04             	mov    0x4(%edx),%ecx
80103671:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80103674:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80103678:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010367b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010367f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80103683:	8b 52 58             	mov    0x58(%edx),%edx
80103686:	89 50 10             	mov    %edx,0x10(%eax)
}
80103689:	5d                   	pop    %ebp
8010368a:	c3                   	ret
8010368b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103690 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 1c             	sub    $0x1c,%esp
80103699:	8b 75 08             	mov    0x8(%ebp),%esi
8010369c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010369f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801036a2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
801036a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801036aa:	89 75 d8             	mov    %esi,-0x28(%ebp)
801036ad:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
801036b0:	0f 84 aa 00 00 00    	je     80103760 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801036b6:	8b 75 d8             	mov    -0x28(%ebp),%esi
801036b9:	8b 56 58             	mov    0x58(%esi),%edx
801036bc:	39 fa                	cmp    %edi,%edx
801036be:	0f 82 bd 00 00 00    	jb     80103781 <readi+0xf1>
801036c4:	89 f9                	mov    %edi,%ecx
801036c6:	31 db                	xor    %ebx,%ebx
801036c8:	01 c1                	add    %eax,%ecx
801036ca:	0f 92 c3             	setb   %bl
801036cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801036d0:	0f 82 ab 00 00 00    	jb     80103781 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801036d6:	89 d3                	mov    %edx,%ebx
801036d8:	29 fb                	sub    %edi,%ebx
801036da:	39 ca                	cmp    %ecx,%edx
801036dc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801036df:	85 c0                	test   %eax,%eax
801036e1:	74 73                	je     80103756 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801036e3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801036f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801036f3:	89 fa                	mov    %edi,%edx
801036f5:	c1 ea 09             	shr    $0x9,%edx
801036f8:	89 d8                	mov    %ebx,%eax
801036fa:	e8 51 f9 ff ff       	call   80103050 <bmap>
801036ff:	83 ec 08             	sub    $0x8,%esp
80103702:	50                   	push   %eax
80103703:	ff 33                	push   (%ebx)
80103705:	e8 c6 c9 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010370a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010370d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103712:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80103714:	89 f8                	mov    %edi,%eax
80103716:	25 ff 01 00 00       	and    $0x1ff,%eax
8010371b:	29 f3                	sub    %esi,%ebx
8010371d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
8010371f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103723:	39 d9                	cmp    %ebx,%ecx
80103725:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80103728:	83 c4 0c             	add    $0xc,%esp
8010372b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010372c:	01 de                	add    %ebx,%esi
8010372e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80103730:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103733:	50                   	push   %eax
80103734:	ff 75 e0             	push   -0x20(%ebp)
80103737:	e8 d4 2b 00 00       	call   80106310 <memmove>
    brelse(bp);
8010373c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010373f:	89 14 24             	mov    %edx,(%esp)
80103742:	e8 a9 ca ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80103747:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010374a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010374d:	83 c4 10             	add    $0x10,%esp
80103750:	39 de                	cmp    %ebx,%esi
80103752:	72 9c                	jb     801036f0 <readi+0x60>
80103754:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80103756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103759:	5b                   	pop    %ebx
8010375a:	5e                   	pop    %esi
8010375b:	5f                   	pop    %edi
8010375c:	5d                   	pop    %ebp
8010375d:	c3                   	ret
8010375e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80103760:	0f bf 56 52          	movswl 0x52(%esi),%edx
80103764:	66 83 fa 09          	cmp    $0x9,%dx
80103768:	77 17                	ja     80103781 <readi+0xf1>
8010376a:	8b 14 d5 a0 21 11 80 	mov    -0x7feede60(,%edx,8),%edx
80103771:	85 d2                	test   %edx,%edx
80103773:	74 0c                	je     80103781 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80103775:	89 45 10             	mov    %eax,0x10(%ebp)
}
80103778:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010377f:	ff e2                	jmp    *%edx
      return -1;
80103781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103786:	eb ce                	jmp    80103756 <readi+0xc6>
80103788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010378f:	00 

80103790 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 1c             	sub    $0x1c,%esp
80103799:	8b 45 08             	mov    0x8(%ebp),%eax
8010379c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010379f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801037a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801037a7:	89 7d dc             	mov    %edi,-0x24(%ebp)
801037aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
801037ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801037b0:	0f 84 ba 00 00 00    	je     80103870 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801037b6:	39 78 58             	cmp    %edi,0x58(%eax)
801037b9:	0f 82 ea 00 00 00    	jb     801038a9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801037bf:	8b 75 e0             	mov    -0x20(%ebp),%esi
801037c2:	89 f2                	mov    %esi,%edx
801037c4:	01 fa                	add    %edi,%edx
801037c6:	0f 82 dd 00 00 00    	jb     801038a9 <writei+0x119>
801037cc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801037d2:	0f 87 d1 00 00 00    	ja     801038a9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801037d8:	85 f6                	test   %esi,%esi
801037da:	0f 84 85 00 00 00    	je     80103865 <writei+0xd5>
801037e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801037e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801037f0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801037f3:	89 fa                	mov    %edi,%edx
801037f5:	c1 ea 09             	shr    $0x9,%edx
801037f8:	89 f0                	mov    %esi,%eax
801037fa:	e8 51 f8 ff ff       	call   80103050 <bmap>
801037ff:	83 ec 08             	sub    $0x8,%esp
80103802:	50                   	push   %eax
80103803:	ff 36                	push   (%esi)
80103805:	e8 c6 c8 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010380a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010380d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103810:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103815:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80103817:	89 f8                	mov    %edi,%eax
80103819:	25 ff 01 00 00       	and    $0x1ff,%eax
8010381e:	29 d3                	sub    %edx,%ebx
80103820:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103822:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103826:	39 d9                	cmp    %ebx,%ecx
80103828:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010382b:	83 c4 0c             	add    $0xc,%esp
8010382e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010382f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80103831:	ff 75 dc             	push   -0x24(%ebp)
80103834:	50                   	push   %eax
80103835:	e8 d6 2a 00 00       	call   80106310 <memmove>
    log_write(bp);
8010383a:	89 34 24             	mov    %esi,(%esp)
8010383d:	e8 be 12 00 00       	call   80104b00 <log_write>
    brelse(bp);
80103842:	89 34 24             	mov    %esi,(%esp)
80103845:	e8 a6 c9 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010384a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010384d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103856:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103859:	39 d8                	cmp    %ebx,%eax
8010385b:	72 93                	jb     801037f0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010385d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103860:	39 78 58             	cmp    %edi,0x58(%eax)
80103863:	72 33                	jb     80103898 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103865:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386b:	5b                   	pop    %ebx
8010386c:	5e                   	pop    %esi
8010386d:	5f                   	pop    %edi
8010386e:	5d                   	pop    %ebp
8010386f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103870:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103874:	66 83 f8 09          	cmp    $0x9,%ax
80103878:	77 2f                	ja     801038a9 <writei+0x119>
8010387a:	8b 04 c5 a4 21 11 80 	mov    -0x7feede5c(,%eax,8),%eax
80103881:	85 c0                	test   %eax,%eax
80103883:	74 24                	je     801038a9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80103885:	89 75 10             	mov    %esi,0x10(%ebp)
}
80103888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010388b:	5b                   	pop    %ebx
8010388c:	5e                   	pop    %esi
8010388d:	5f                   	pop    %edi
8010388e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010388f:	ff e0                	jmp    *%eax
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80103898:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010389b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010389e:	50                   	push   %eax
8010389f:	e8 2c fa ff ff       	call   801032d0 <iupdate>
801038a4:	83 c4 10             	add    $0x10,%esp
801038a7:	eb bc                	jmp    80103865 <writei+0xd5>
      return -1;
801038a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038ae:	eb b8                	jmp    80103868 <writei+0xd8>

801038b0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801038b6:	6a 0e                	push   $0xe
801038b8:	ff 75 0c             	push   0xc(%ebp)
801038bb:	ff 75 08             	push   0x8(%ebp)
801038be:	e8 bd 2a 00 00       	call   80106380 <strncmp>
}
801038c3:	c9                   	leave
801038c4:	c3                   	ret
801038c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038cc:	00 
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 1c             	sub    $0x1c,%esp
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801038dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801038e1:	0f 85 85 00 00 00    	jne    8010396c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801038e7:	8b 53 58             	mov    0x58(%ebx),%edx
801038ea:	31 ff                	xor    %edi,%edi
801038ec:	8d 75 d8             	lea    -0x28(%ebp),%esi
801038ef:	85 d2                	test   %edx,%edx
801038f1:	74 3e                	je     80103931 <dirlookup+0x61>
801038f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801038f8:	6a 10                	push   $0x10
801038fa:	57                   	push   %edi
801038fb:	56                   	push   %esi
801038fc:	53                   	push   %ebx
801038fd:	e8 8e fd ff ff       	call   80103690 <readi>
80103902:	83 c4 10             	add    $0x10,%esp
80103905:	83 f8 10             	cmp    $0x10,%eax
80103908:	75 55                	jne    8010395f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010390a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010390f:	74 18                	je     80103929 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103911:	83 ec 04             	sub    $0x4,%esp
80103914:	8d 45 da             	lea    -0x26(%ebp),%eax
80103917:	6a 0e                	push   $0xe
80103919:	50                   	push   %eax
8010391a:	ff 75 0c             	push   0xc(%ebp)
8010391d:	e8 5e 2a 00 00       	call   80106380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103922:	83 c4 10             	add    $0x10,%esp
80103925:	85 c0                	test   %eax,%eax
80103927:	74 17                	je     80103940 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103929:	83 c7 10             	add    $0x10,%edi
8010392c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010392f:	72 c7                	jb     801038f8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103931:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103934:	31 c0                	xor    %eax,%eax
}
80103936:	5b                   	pop    %ebx
80103937:	5e                   	pop    %esi
80103938:	5f                   	pop    %edi
80103939:	5d                   	pop    %ebp
8010393a:	c3                   	ret
8010393b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80103940:	8b 45 10             	mov    0x10(%ebp),%eax
80103943:	85 c0                	test   %eax,%eax
80103945:	74 05                	je     8010394c <dirlookup+0x7c>
        *poff = off;
80103947:	8b 45 10             	mov    0x10(%ebp),%eax
8010394a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010394c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103950:	8b 03                	mov    (%ebx),%eax
80103952:	e8 79 f5 ff ff       	call   80102ed0 <iget>
}
80103957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010395a:	5b                   	pop    %ebx
8010395b:	5e                   	pop    %esi
8010395c:	5f                   	pop    %edi
8010395d:	5d                   	pop    %ebp
8010395e:	c3                   	ret
      panic("dirlookup read");
8010395f:	83 ec 0c             	sub    $0xc,%esp
80103962:	68 eb 90 10 80       	push   $0x801090eb
80103967:	e8 14 ca ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	68 d9 90 10 80       	push   $0x801090d9
80103974:	e8 07 ca ff ff       	call   80100380 <panic>
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	89 c3                	mov    %eax,%ebx
80103988:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010398b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010398e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103994:	0f 84 9e 01 00 00    	je     80103b38 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010399a:	e8 a1 1b 00 00       	call   80105540 <myproc>
  acquire(&icache.lock);
8010399f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801039a2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801039a5:	68 00 22 11 80       	push   $0x80112200
801039aa:	e8 d1 27 00 00       	call   80106180 <acquire>
  ip->ref++;
801039af:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801039b3:	c7 04 24 00 22 11 80 	movl   $0x80112200,(%esp)
801039ba:	e8 61 27 00 00       	call   80106120 <release>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	eb 07                	jmp    801039cb <namex+0x4b>
801039c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801039c8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801039cb:	0f b6 03             	movzbl (%ebx),%eax
801039ce:	3c 2f                	cmp    $0x2f,%al
801039d0:	74 f6                	je     801039c8 <namex+0x48>
  if(*path == 0)
801039d2:	84 c0                	test   %al,%al
801039d4:	0f 84 06 01 00 00    	je     80103ae0 <namex+0x160>
  while(*path != '/' && *path != 0)
801039da:	0f b6 03             	movzbl (%ebx),%eax
801039dd:	84 c0                	test   %al,%al
801039df:	0f 84 10 01 00 00    	je     80103af5 <namex+0x175>
801039e5:	89 df                	mov    %ebx,%edi
801039e7:	3c 2f                	cmp    $0x2f,%al
801039e9:	0f 84 06 01 00 00    	je     80103af5 <namex+0x175>
801039ef:	90                   	nop
801039f0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801039f4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801039f7:	3c 2f                	cmp    $0x2f,%al
801039f9:	74 04                	je     801039ff <namex+0x7f>
801039fb:	84 c0                	test   %al,%al
801039fd:	75 f1                	jne    801039f0 <namex+0x70>
  len = path - s;
801039ff:	89 f8                	mov    %edi,%eax
80103a01:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103a03:	83 f8 0d             	cmp    $0xd,%eax
80103a06:	0f 8e ac 00 00 00    	jle    80103ab8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80103a0c:	83 ec 04             	sub    $0x4,%esp
80103a0f:	6a 0e                	push   $0xe
80103a11:	53                   	push   %ebx
80103a12:	89 fb                	mov    %edi,%ebx
80103a14:	ff 75 e4             	push   -0x1c(%ebp)
80103a17:	e8 f4 28 00 00       	call   80106310 <memmove>
80103a1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103a1f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103a22:	75 0c                	jne    80103a30 <namex+0xb0>
80103a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103a28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80103a2b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80103a2e:	74 f8                	je     80103a28 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	56                   	push   %esi
80103a34:	e8 47 f9 ff ff       	call   80103380 <ilock>
    if(ip->type != T_DIR){
80103a39:	83 c4 10             	add    $0x10,%esp
80103a3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103a41:	0f 85 b7 00 00 00    	jne    80103afe <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103a4a:	85 c0                	test   %eax,%eax
80103a4c:	74 09                	je     80103a57 <namex+0xd7>
80103a4e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103a51:	0f 84 f7 00 00 00    	je     80103b4e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103a57:	83 ec 04             	sub    $0x4,%esp
80103a5a:	6a 00                	push   $0x0
80103a5c:	ff 75 e4             	push   -0x1c(%ebp)
80103a5f:	56                   	push   %esi
80103a60:	e8 6b fe ff ff       	call   801038d0 <dirlookup>
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	89 c7                	mov    %eax,%edi
80103a6a:	85 c0                	test   %eax,%eax
80103a6c:	0f 84 8c 00 00 00    	je     80103afe <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103a72:	83 ec 0c             	sub    $0xc,%esp
80103a75:	8d 4e 0c             	lea    0xc(%esi),%ecx
80103a78:	51                   	push   %ecx
80103a79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103a7c:	e8 bf 24 00 00       	call   80105f40 <holdingsleep>
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	85 c0                	test   %eax,%eax
80103a86:	0f 84 02 01 00 00    	je     80103b8e <namex+0x20e>
80103a8c:	8b 56 08             	mov    0x8(%esi),%edx
80103a8f:	85 d2                	test   %edx,%edx
80103a91:	0f 8e f7 00 00 00    	jle    80103b8e <namex+0x20e>
  releasesleep(&ip->lock);
80103a97:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	51                   	push   %ecx
80103a9e:	e8 5d 24 00 00       	call   80105f00 <releasesleep>
  iput(ip);
80103aa3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103aa6:	89 fe                	mov    %edi,%esi
  iput(ip);
80103aa8:	e8 03 fa ff ff       	call   801034b0 <iput>
80103aad:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103ab0:	e9 16 ff ff ff       	jmp    801039cb <namex+0x4b>
80103ab5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80103ab8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103abb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80103abe:	83 ec 04             	sub    $0x4,%esp
80103ac1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103ac4:	50                   	push   %eax
80103ac5:	53                   	push   %ebx
    name[len] = 0;
80103ac6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103ac8:	ff 75 e4             	push   -0x1c(%ebp)
80103acb:	e8 40 28 00 00       	call   80106310 <memmove>
    name[len] = 0;
80103ad0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	c6 01 00             	movb   $0x0,(%ecx)
80103ad9:	e9 41 ff ff ff       	jmp    80103a1f <namex+0x9f>
80103ade:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80103ae0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	0f 85 93 00 00 00    	jne    80103b7e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80103aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aee:	89 f0                	mov    %esi,%eax
80103af0:	5b                   	pop    %ebx
80103af1:	5e                   	pop    %esi
80103af2:	5f                   	pop    %edi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret
  while(*path != '/' && *path != 0)
80103af5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103af8:	89 df                	mov    %ebx,%edi
80103afa:	31 c0                	xor    %eax,%eax
80103afc:	eb c0                	jmp    80103abe <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103afe:	83 ec 0c             	sub    $0xc,%esp
80103b01:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103b04:	53                   	push   %ebx
80103b05:	e8 36 24 00 00       	call   80105f40 <holdingsleep>
80103b0a:	83 c4 10             	add    $0x10,%esp
80103b0d:	85 c0                	test   %eax,%eax
80103b0f:	74 7d                	je     80103b8e <namex+0x20e>
80103b11:	8b 4e 08             	mov    0x8(%esi),%ecx
80103b14:	85 c9                	test   %ecx,%ecx
80103b16:	7e 76                	jle    80103b8e <namex+0x20e>
  releasesleep(&ip->lock);
80103b18:	83 ec 0c             	sub    $0xc,%esp
80103b1b:	53                   	push   %ebx
80103b1c:	e8 df 23 00 00       	call   80105f00 <releasesleep>
  iput(ip);
80103b21:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103b24:	31 f6                	xor    %esi,%esi
  iput(ip);
80103b26:	e8 85 f9 ff ff       	call   801034b0 <iput>
      return 0;
80103b2b:	83 c4 10             	add    $0x10,%esp
}
80103b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b31:	89 f0                	mov    %esi,%eax
80103b33:	5b                   	pop    %ebx
80103b34:	5e                   	pop    %esi
80103b35:	5f                   	pop    %edi
80103b36:	5d                   	pop    %ebp
80103b37:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80103b38:	ba 01 00 00 00       	mov    $0x1,%edx
80103b3d:	b8 01 00 00 00       	mov    $0x1,%eax
80103b42:	e8 89 f3 ff ff       	call   80102ed0 <iget>
80103b47:	89 c6                	mov    %eax,%esi
80103b49:	e9 7d fe ff ff       	jmp    801039cb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103b54:	53                   	push   %ebx
80103b55:	e8 e6 23 00 00       	call   80105f40 <holdingsleep>
80103b5a:	83 c4 10             	add    $0x10,%esp
80103b5d:	85 c0                	test   %eax,%eax
80103b5f:	74 2d                	je     80103b8e <namex+0x20e>
80103b61:	8b 7e 08             	mov    0x8(%esi),%edi
80103b64:	85 ff                	test   %edi,%edi
80103b66:	7e 26                	jle    80103b8e <namex+0x20e>
  releasesleep(&ip->lock);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	53                   	push   %ebx
80103b6c:	e8 8f 23 00 00       	call   80105f00 <releasesleep>
}
80103b71:	83 c4 10             	add    $0x10,%esp
}
80103b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b77:	89 f0                	mov    %esi,%eax
80103b79:	5b                   	pop    %ebx
80103b7a:	5e                   	pop    %esi
80103b7b:	5f                   	pop    %edi
80103b7c:	5d                   	pop    %ebp
80103b7d:	c3                   	ret
    iput(ip);
80103b7e:	83 ec 0c             	sub    $0xc,%esp
80103b81:	56                   	push   %esi
      return 0;
80103b82:	31 f6                	xor    %esi,%esi
    iput(ip);
80103b84:	e8 27 f9 ff ff       	call   801034b0 <iput>
    return 0;
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	eb a0                	jmp    80103b2e <namex+0x1ae>
    panic("iunlock");
80103b8e:	83 ec 0c             	sub    $0xc,%esp
80103b91:	68 d1 90 10 80       	push   $0x801090d1
80103b96:	e8 e5 c7 ff ff       	call   80100380 <panic>
80103b9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ba0 <dirlink>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 20             	sub    $0x20,%esp
80103ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80103bac:	6a 00                	push   $0x0
80103bae:	ff 75 0c             	push   0xc(%ebp)
80103bb1:	53                   	push   %ebx
80103bb2:	e8 19 fd ff ff       	call   801038d0 <dirlookup>
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	75 67                	jne    80103c25 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103bbe:	8b 7b 58             	mov    0x58(%ebx),%edi
80103bc1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103bc4:	85 ff                	test   %edi,%edi
80103bc6:	74 29                	je     80103bf1 <dirlink+0x51>
80103bc8:	31 ff                	xor    %edi,%edi
80103bca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103bcd:	eb 09                	jmp    80103bd8 <dirlink+0x38>
80103bcf:	90                   	nop
80103bd0:	83 c7 10             	add    $0x10,%edi
80103bd3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103bd6:	73 19                	jae    80103bf1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103bd8:	6a 10                	push   $0x10
80103bda:	57                   	push   %edi
80103bdb:	56                   	push   %esi
80103bdc:	53                   	push   %ebx
80103bdd:	e8 ae fa ff ff       	call   80103690 <readi>
80103be2:	83 c4 10             	add    $0x10,%esp
80103be5:	83 f8 10             	cmp    $0x10,%eax
80103be8:	75 4e                	jne    80103c38 <dirlink+0x98>
    if(de.inum == 0)
80103bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80103bef:	75 df                	jne    80103bd0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103bf1:	83 ec 04             	sub    $0x4,%esp
80103bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80103bf7:	6a 0e                	push   $0xe
80103bf9:	ff 75 0c             	push   0xc(%ebp)
80103bfc:	50                   	push   %eax
80103bfd:	e8 ce 27 00 00       	call   801063d0 <strncpy>
  de.inum = inum;
80103c02:	8b 45 10             	mov    0x10(%ebp),%eax
80103c05:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103c09:	6a 10                	push   $0x10
80103c0b:	57                   	push   %edi
80103c0c:	56                   	push   %esi
80103c0d:	53                   	push   %ebx
80103c0e:	e8 7d fb ff ff       	call   80103790 <writei>
80103c13:	83 c4 20             	add    $0x20,%esp
80103c16:	83 f8 10             	cmp    $0x10,%eax
80103c19:	75 2a                	jne    80103c45 <dirlink+0xa5>
  return 0;
80103c1b:	31 c0                	xor    %eax,%eax
}
80103c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c20:	5b                   	pop    %ebx
80103c21:	5e                   	pop    %esi
80103c22:	5f                   	pop    %edi
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret
    iput(ip);
80103c25:	83 ec 0c             	sub    $0xc,%esp
80103c28:	50                   	push   %eax
80103c29:	e8 82 f8 ff ff       	call   801034b0 <iput>
    return -1;
80103c2e:	83 c4 10             	add    $0x10,%esp
80103c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c36:	eb e5                	jmp    80103c1d <dirlink+0x7d>
      panic("dirlink read");
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	68 fa 90 10 80       	push   $0x801090fa
80103c40:	e8 3b c7 ff ff       	call   80100380 <panic>
    panic("dirlink");
80103c45:	83 ec 0c             	sub    $0xc,%esp
80103c48:	68 4f 93 10 80       	push   $0x8010934f
80103c4d:	e8 2e c7 ff ff       	call   80100380 <panic>
80103c52:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c59:	00 
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c60 <namei>:

struct inode*
namei(char *path)
{
80103c60:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103c61:	31 d2                	xor    %edx,%edx
{
80103c63:	89 e5                	mov    %esp,%ebp
80103c65:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103c68:	8b 45 08             	mov    0x8(%ebp),%eax
80103c6b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80103c6e:	e8 0d fd ff ff       	call   80103980 <namex>
}
80103c73:	c9                   	leave
80103c74:	c3                   	ret
80103c75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c7c:	00 
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi

80103c80 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103c80:	55                   	push   %ebp
  return namex(path, 1, name);
80103c81:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103c86:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103c8e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80103c8f:	e9 ec fc ff ff       	jmp    80103980 <namex>
80103c94:	66 90                	xchg   %ax,%ax
80103c96:	66 90                	xchg   %ax,%ax
80103c98:	66 90                	xchg   %ax,%ax
80103c9a:	66 90                	xchg   %ax,%ax
80103c9c:	66 90                	xchg   %ax,%ax
80103c9e:	66 90                	xchg   %ax,%ax

80103ca0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103ca9:	85 c0                	test   %eax,%eax
80103cab:	0f 84 b4 00 00 00    	je     80103d65 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103cb1:	8b 70 08             	mov    0x8(%eax),%esi
80103cb4:	89 c3                	mov    %eax,%ebx
80103cb6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80103cbc:	0f 87 96 00 00 00    	ja     80103d58 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cc2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cce:	00 
80103ccf:	90                   	nop
80103cd0:	89 ca                	mov    %ecx,%edx
80103cd2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103cd3:	83 e0 c0             	and    $0xffffffc0,%eax
80103cd6:	3c 40                	cmp    $0x40,%al
80103cd8:	75 f6                	jne    80103cd0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cda:	31 ff                	xor    %edi,%edi
80103cdc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103ce1:	89 f8                	mov    %edi,%eax
80103ce3:	ee                   	out    %al,(%dx)
80103ce4:	b8 01 00 00 00       	mov    $0x1,%eax
80103ce9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80103cee:	ee                   	out    %al,(%dx)
80103cef:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103cf4:	89 f0                	mov    %esi,%eax
80103cf6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103cf7:	89 f0                	mov    %esi,%eax
80103cf9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80103cfe:	c1 f8 08             	sar    $0x8,%eax
80103d01:	ee                   	out    %al,(%dx)
80103d02:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103d07:	89 f8                	mov    %edi,%eax
80103d09:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80103d0a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80103d0e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103d13:	c1 e0 04             	shl    $0x4,%eax
80103d16:	83 e0 10             	and    $0x10,%eax
80103d19:	83 c8 e0             	or     $0xffffffe0,%eax
80103d1c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80103d1d:	f6 03 04             	testb  $0x4,(%ebx)
80103d20:	75 16                	jne    80103d38 <idestart+0x98>
80103d22:	b8 20 00 00 00       	mov    $0x20,%eax
80103d27:	89 ca                	mov    %ecx,%edx
80103d29:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80103d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2d:	5b                   	pop    %ebx
80103d2e:	5e                   	pop    %esi
80103d2f:	5f                   	pop    %edi
80103d30:	5d                   	pop    %ebp
80103d31:	c3                   	ret
80103d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d38:	b8 30 00 00 00       	mov    $0x30,%eax
80103d3d:	89 ca                	mov    %ecx,%edx
80103d3f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103d40:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103d45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103d48:	ba f0 01 00 00       	mov    $0x1f0,%edx
80103d4d:	fc                   	cld
80103d4e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d53:	5b                   	pop    %ebx
80103d54:	5e                   	pop    %esi
80103d55:	5f                   	pop    %edi
80103d56:	5d                   	pop    %ebp
80103d57:	c3                   	ret
    panic("incorrect blockno");
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	68 10 91 10 80       	push   $0x80109110
80103d60:	e8 1b c6 ff ff       	call   80100380 <panic>
    panic("idestart");
80103d65:	83 ec 0c             	sub    $0xc,%esp
80103d68:	68 07 91 10 80       	push   $0x80109107
80103d6d:	e8 0e c6 ff ff       	call   80100380 <panic>
80103d72:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d79:	00 
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <ideinit>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80103d86:	68 22 91 10 80       	push   $0x80109122
80103d8b:	68 a0 3e 11 80       	push   $0x80113ea0
80103d90:	e8 fb 21 00 00       	call   80105f90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80103d95:	58                   	pop    %eax
80103d96:	a1 24 40 11 80       	mov    0x80114024,%eax
80103d9b:	5a                   	pop    %edx
80103d9c:	83 e8 01             	sub    $0x1,%eax
80103d9f:	50                   	push   %eax
80103da0:	6a 0e                	push   $0xe
80103da2:	e8 99 02 00 00       	call   80104040 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103da7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103daa:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103daf:	90                   	nop
80103db0:	89 ca                	mov    %ecx,%edx
80103db2:	ec                   	in     (%dx),%al
80103db3:	83 e0 c0             	and    $0xffffffc0,%eax
80103db6:	3c 40                	cmp    $0x40,%al
80103db8:	75 f6                	jne    80103db0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80103dbf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103dc4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dc5:	89 ca                	mov    %ecx,%edx
80103dc7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103dc8:	84 c0                	test   %al,%al
80103dca:	75 1e                	jne    80103dea <ideinit+0x6a>
80103dcc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80103dd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ddd:	00 
80103dde:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80103de0:	83 e9 01             	sub    $0x1,%ecx
80103de3:	74 0f                	je     80103df4 <ideinit+0x74>
80103de5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103de6:	84 c0                	test   %al,%al
80103de8:	74 f6                	je     80103de0 <ideinit+0x60>
      havedisk1 = 1;
80103dea:	c7 05 80 3e 11 80 01 	movl   $0x1,0x80113e80
80103df1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103df4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103df9:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103dfe:	ee                   	out    %al,(%dx)
}
80103dff:	c9                   	leave
80103e00:	c3                   	ret
80103e01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e08:	00 
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103e19:	68 a0 3e 11 80       	push   $0x80113ea0
80103e1e:	e8 5d 23 00 00       	call   80106180 <acquire>

  if((b = idequeue) == 0){
80103e23:	8b 1d 84 3e 11 80    	mov    0x80113e84,%ebx
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	85 db                	test   %ebx,%ebx
80103e2e:	74 63                	je     80103e93 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103e30:	8b 43 58             	mov    0x58(%ebx),%eax
80103e33:	a3 84 3e 11 80       	mov    %eax,0x80113e84

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103e38:	8b 33                	mov    (%ebx),%esi
80103e3a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103e40:	75 2f                	jne    80103e71 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e42:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103e47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e4e:	00 
80103e4f:	90                   	nop
80103e50:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103e51:	89 c1                	mov    %eax,%ecx
80103e53:	83 e1 c0             	and    $0xffffffc0,%ecx
80103e56:	80 f9 40             	cmp    $0x40,%cl
80103e59:	75 f5                	jne    80103e50 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80103e5b:	a8 21                	test   $0x21,%al
80103e5d:	75 12                	jne    80103e71 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80103e5f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103e62:	b9 80 00 00 00       	mov    $0x80,%ecx
80103e67:	ba f0 01 00 00       	mov    $0x1f0,%edx
80103e6c:	fc                   	cld
80103e6d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80103e6f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80103e71:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80103e74:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80103e77:	83 ce 02             	or     $0x2,%esi
80103e7a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80103e7c:	53                   	push   %ebx
80103e7d:	e8 3e 1e 00 00       	call   80105cc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103e82:	a1 84 3e 11 80       	mov    0x80113e84,%eax
80103e87:	83 c4 10             	add    $0x10,%esp
80103e8a:	85 c0                	test   %eax,%eax
80103e8c:	74 05                	je     80103e93 <ideintr+0x83>
    idestart(idequeue);
80103e8e:	e8 0d fe ff ff       	call   80103ca0 <idestart>
    release(&idelock);
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	68 a0 3e 11 80       	push   $0x80113ea0
80103e9b:	e8 80 22 00 00       	call   80106120 <release>

  release(&idelock);
}
80103ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea3:	5b                   	pop    %ebx
80103ea4:	5e                   	pop    %esi
80103ea5:	5f                   	pop    %edi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret
80103ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eaf:	00 

80103eb0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 10             	sub    $0x10,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80103eba:	8d 43 0c             	lea    0xc(%ebx),%eax
80103ebd:	50                   	push   %eax
80103ebe:	e8 7d 20 00 00       	call   80105f40 <holdingsleep>
80103ec3:	83 c4 10             	add    $0x10,%esp
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	0f 84 c3 00 00 00    	je     80103f91 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80103ece:	8b 03                	mov    (%ebx),%eax
80103ed0:	83 e0 06             	and    $0x6,%eax
80103ed3:	83 f8 02             	cmp    $0x2,%eax
80103ed6:	0f 84 a8 00 00 00    	je     80103f84 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80103edc:	8b 53 04             	mov    0x4(%ebx),%edx
80103edf:	85 d2                	test   %edx,%edx
80103ee1:	74 0d                	je     80103ef0 <iderw+0x40>
80103ee3:	a1 80 3e 11 80       	mov    0x80113e80,%eax
80103ee8:	85 c0                	test   %eax,%eax
80103eea:	0f 84 87 00 00 00    	je     80103f77 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	68 a0 3e 11 80       	push   $0x80113ea0
80103ef8:	e8 83 22 00 00       	call   80106180 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103efd:	a1 84 3e 11 80       	mov    0x80113e84,%eax
  b->qnext = 0;
80103f02:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103f09:	83 c4 10             	add    $0x10,%esp
80103f0c:	85 c0                	test   %eax,%eax
80103f0e:	74 60                	je     80103f70 <iderw+0xc0>
80103f10:	89 c2                	mov    %eax,%edx
80103f12:	8b 40 58             	mov    0x58(%eax),%eax
80103f15:	85 c0                	test   %eax,%eax
80103f17:	75 f7                	jne    80103f10 <iderw+0x60>
80103f19:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80103f1c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80103f1e:	39 1d 84 3e 11 80    	cmp    %ebx,0x80113e84
80103f24:	74 3a                	je     80103f60 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103f26:	8b 03                	mov    (%ebx),%eax
80103f28:	83 e0 06             	and    $0x6,%eax
80103f2b:	83 f8 02             	cmp    $0x2,%eax
80103f2e:	74 1b                	je     80103f4b <iderw+0x9b>
    sleep(b, &idelock);
80103f30:	83 ec 08             	sub    $0x8,%esp
80103f33:	68 a0 3e 11 80       	push   $0x80113ea0
80103f38:	53                   	push   %ebx
80103f39:	e8 c2 1c 00 00       	call   80105c00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103f3e:	8b 03                	mov    (%ebx),%eax
80103f40:	83 c4 10             	add    $0x10,%esp
80103f43:	83 e0 06             	and    $0x6,%eax
80103f46:	83 f8 02             	cmp    $0x2,%eax
80103f49:	75 e5                	jne    80103f30 <iderw+0x80>
  }


  release(&idelock);
80103f4b:	c7 45 08 a0 3e 11 80 	movl   $0x80113ea0,0x8(%ebp)
}
80103f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f55:	c9                   	leave
  release(&idelock);
80103f56:	e9 c5 21 00 00       	jmp    80106120 <release>
80103f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80103f60:	89 d8                	mov    %ebx,%eax
80103f62:	e8 39 fd ff ff       	call   80103ca0 <idestart>
80103f67:	eb bd                	jmp    80103f26 <iderw+0x76>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103f70:	ba 84 3e 11 80       	mov    $0x80113e84,%edx
80103f75:	eb a5                	jmp    80103f1c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 51 91 10 80       	push   $0x80109151
80103f7f:	e8 fc c3 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 3c 91 10 80       	push   $0x8010913c
80103f8c:	e8 ef c3 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80103f91:	83 ec 0c             	sub    $0xc,%esp
80103f94:	68 26 91 10 80       	push   $0x80109126
80103f99:	e8 e2 c3 ff ff       	call   80100380 <panic>
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103fa5:	c7 05 d4 3e 11 80 00 	movl   $0xfec00000,0x80113ed4
80103fac:	00 c0 fe 
  ioapic->reg = reg;
80103faf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80103fb6:	00 00 00 
  return ioapic->data;
80103fb9:	8b 15 d4 3e 11 80    	mov    0x80113ed4,%edx
80103fbf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103fc2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103fc8:	8b 1d d4 3e 11 80    	mov    0x80113ed4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80103fce:	0f b6 15 20 40 11 80 	movzbl 0x80114020,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103fd5:	c1 ee 10             	shr    $0x10,%esi
80103fd8:	89 f0                	mov    %esi,%eax
80103fda:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80103fdd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80103fe0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103fe3:	39 c2                	cmp    %eax,%edx
80103fe5:	74 16                	je     80103ffd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 70 95 10 80       	push   $0x80109570
80103fef:	e8 dc c7 ff ff       	call   801007d0 <cprintf>
  ioapic->reg = reg;
80103ff4:	8b 1d d4 3e 11 80    	mov    0x80113ed4,%ebx
80103ffa:	83 c4 10             	add    $0x10,%esp
{
80103ffd:	ba 10 00 00 00       	mov    $0x10,%edx
80104002:	31 c0                	xor    %eax,%eax
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80104008:	89 13                	mov    %edx,(%ebx)
8010400a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010400d:	8b 1d d4 3e 11 80    	mov    0x80113ed4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80104013:	83 c0 01             	add    $0x1,%eax
80104016:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010401c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010401f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80104022:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80104025:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80104027:	8b 1d d4 3e 11 80    	mov    0x80113ed4,%ebx
8010402d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80104034:	39 c6                	cmp    %eax,%esi
80104036:	7d d0                	jge    80104008 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80104038:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010403b:	5b                   	pop    %ebx
8010403c:	5e                   	pop    %esi
8010403d:	5d                   	pop    %ebp
8010403e:	c3                   	ret
8010403f:	90                   	nop

80104040 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80104040:	55                   	push   %ebp
  ioapic->reg = reg;
80104041:	8b 0d d4 3e 11 80    	mov    0x80113ed4,%ecx
{
80104047:	89 e5                	mov    %esp,%ebp
80104049:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010404c:	8d 50 20             	lea    0x20(%eax),%edx
8010404f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80104053:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104055:	8b 0d d4 3e 11 80    	mov    0x80113ed4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010405b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010405e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80104061:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80104064:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104066:	a1 d4 3e 11 80       	mov    0x80113ed4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010406b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010406e:	89 50 10             	mov    %edx,0x10(%eax)
}
80104071:	5d                   	pop    %ebp
80104072:	c3                   	ret
80104073:	66 90                	xchg   %ax,%ax
80104075:	66 90                	xchg   %ax,%ax
80104077:	66 90                	xchg   %ax,%ax
80104079:	66 90                	xchg   %ax,%ax
8010407b:	66 90                	xchg   %ax,%ax
8010407d:	66 90                	xchg   %ax,%ax
8010407f:	90                   	nop

80104080 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 04             	sub    $0x4,%esp
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010408a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80104090:	75 76                	jne    80104108 <kfree+0x88>
80104092:	81 fb 70 7d 11 80    	cmp    $0x80117d70,%ebx
80104098:	72 6e                	jb     80104108 <kfree+0x88>
8010409a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801040a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801040a5:	77 61                	ja     80104108 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801040a7:	83 ec 04             	sub    $0x4,%esp
801040aa:	68 00 10 00 00       	push   $0x1000
801040af:	6a 01                	push   $0x1
801040b1:	53                   	push   %ebx
801040b2:	e8 c9 21 00 00       	call   80106280 <memset>

  if(kmem.use_lock)
801040b7:	8b 15 14 3f 11 80    	mov    0x80113f14,%edx
801040bd:	83 c4 10             	add    $0x10,%esp
801040c0:	85 d2                	test   %edx,%edx
801040c2:	75 1c                	jne    801040e0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801040c4:	a1 18 3f 11 80       	mov    0x80113f18,%eax
801040c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801040cb:	a1 14 3f 11 80       	mov    0x80113f14,%eax
  kmem.freelist = r;
801040d0:	89 1d 18 3f 11 80    	mov    %ebx,0x80113f18
  if(kmem.use_lock)
801040d6:	85 c0                	test   %eax,%eax
801040d8:	75 1e                	jne    801040f8 <kfree+0x78>
    release(&kmem.lock);
}
801040da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040dd:	c9                   	leave
801040de:	c3                   	ret
801040df:	90                   	nop
    acquire(&kmem.lock);
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	68 e0 3e 11 80       	push   $0x80113ee0
801040e8:	e8 93 20 00 00       	call   80106180 <acquire>
801040ed:	83 c4 10             	add    $0x10,%esp
801040f0:	eb d2                	jmp    801040c4 <kfree+0x44>
801040f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801040f8:	c7 45 08 e0 3e 11 80 	movl   $0x80113ee0,0x8(%ebp)
}
801040ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104102:	c9                   	leave
    release(&kmem.lock);
80104103:	e9 18 20 00 00       	jmp    80106120 <release>
    panic("kfree");
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 6f 91 10 80       	push   $0x8010916f
80104110:	e8 6b c2 ff ff       	call   80100380 <panic>
80104115:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010411c:	00 
8010411d:	8d 76 00             	lea    0x0(%esi),%esi

80104120 <freerange>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80104125:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104128:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010412b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104131:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104137:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010413d:	39 de                	cmp    %ebx,%esi
8010413f:	72 23                	jb     80104164 <freerange+0x44>
80104141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104151:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80104157:	50                   	push   %eax
80104158:	e8 23 ff ff ff       	call   80104080 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010415d:	83 c4 10             	add    $0x10,%esp
80104160:	39 de                	cmp    %ebx,%esi
80104162:	73 e4                	jae    80104148 <freerange+0x28>
}
80104164:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104167:	5b                   	pop    %ebx
80104168:	5e                   	pop    %esi
80104169:	5d                   	pop    %ebp
8010416a:	c3                   	ret
8010416b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104170 <kinit2>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104178:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010417b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104181:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104187:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010418d:	39 de                	cmp    %ebx,%esi
8010418f:	72 23                	jb     801041b4 <kinit2+0x44>
80104191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801041a7:	50                   	push   %eax
801041a8:	e8 d3 fe ff ff       	call   80104080 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041ad:	83 c4 10             	add    $0x10,%esp
801041b0:	39 de                	cmp    %ebx,%esi
801041b2:	73 e4                	jae    80104198 <kinit2+0x28>
  kmem.use_lock = 1;
801041b4:	c7 05 14 3f 11 80 01 	movl   $0x1,0x80113f14
801041bb:	00 00 00 
}
801041be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5d                   	pop    %ebp
801041c4:	c3                   	ret
801041c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041cc:	00 
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <kinit1>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
801041d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801041d8:	83 ec 08             	sub    $0x8,%esp
801041db:	68 75 91 10 80       	push   $0x80109175
801041e0:	68 e0 3e 11 80       	push   $0x80113ee0
801041e5:	e8 a6 1d 00 00       	call   80105f90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801041f0:	c7 05 14 3f 11 80 00 	movl   $0x0,0x80113f14
801041f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801041fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104200:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104206:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010420c:	39 de                	cmp    %ebx,%esi
8010420e:	72 1c                	jb     8010422c <kinit1+0x5c>
    kfree(p);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104219:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010421f:	50                   	push   %eax
80104220:	e8 5b fe ff ff       	call   80104080 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104225:	83 c4 10             	add    $0x10,%esp
80104228:	39 de                	cmp    %ebx,%esi
8010422a:	73 e4                	jae    80104210 <kinit1+0x40>
}
8010422c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010422f:	5b                   	pop    %ebx
80104230:	5e                   	pop    %esi
80104231:	5d                   	pop    %ebp
80104232:	c3                   	ret
80104233:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010423a:	00 
8010423b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104240 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80104247:	a1 14 3f 11 80       	mov    0x80113f14,%eax
8010424c:	85 c0                	test   %eax,%eax
8010424e:	75 20                	jne    80104270 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80104250:	8b 1d 18 3f 11 80    	mov    0x80113f18,%ebx
  if(r)
80104256:	85 db                	test   %ebx,%ebx
80104258:	74 07                	je     80104261 <kalloc+0x21>
    kmem.freelist = r->next;
8010425a:	8b 03                	mov    (%ebx),%eax
8010425c:	a3 18 3f 11 80       	mov    %eax,0x80113f18
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80104261:	89 d8                	mov    %ebx,%eax
80104263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104266:	c9                   	leave
80104267:	c3                   	ret
80104268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010426f:	00 
    acquire(&kmem.lock);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 e0 3e 11 80       	push   $0x80113ee0
80104278:	e8 03 1f 00 00       	call   80106180 <acquire>
  r = kmem.freelist;
8010427d:	8b 1d 18 3f 11 80    	mov    0x80113f18,%ebx
  if(kmem.use_lock)
80104283:	a1 14 3f 11 80       	mov    0x80113f14,%eax
  if(r)
80104288:	83 c4 10             	add    $0x10,%esp
8010428b:	85 db                	test   %ebx,%ebx
8010428d:	74 08                	je     80104297 <kalloc+0x57>
    kmem.freelist = r->next;
8010428f:	8b 13                	mov    (%ebx),%edx
80104291:	89 15 18 3f 11 80    	mov    %edx,0x80113f18
  if(kmem.use_lock)
80104297:	85 c0                	test   %eax,%eax
80104299:	74 c6                	je     80104261 <kalloc+0x21>
    release(&kmem.lock);
8010429b:	83 ec 0c             	sub    $0xc,%esp
8010429e:	68 e0 3e 11 80       	push   $0x80113ee0
801042a3:	e8 78 1e 00 00       	call   80106120 <release>
}
801042a8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801042aa:	83 c4 10             	add    $0x10,%esp
}
801042ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b0:	c9                   	leave
801042b1:	c3                   	ret
801042b2:	66 90                	xchg   %ax,%ax
801042b4:	66 90                	xchg   %ax,%ax
801042b6:	66 90                	xchg   %ax,%ax
801042b8:	66 90                	xchg   %ax,%ax
801042ba:	66 90                	xchg   %ax,%ax
801042bc:	66 90                	xchg   %ax,%ax
801042be:	66 90                	xchg   %ax,%ax

801042c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801042c0:	ba 64 00 00 00       	mov    $0x64,%edx
801042c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801042c6:	a8 01                	test   $0x1,%al
801042c8:	0f 84 c2 00 00 00    	je     80104390 <kbdgetc+0xd0>
{
801042ce:	55                   	push   %ebp
801042cf:	ba 60 00 00 00       	mov    $0x60,%edx
801042d4:	89 e5                	mov    %esp,%ebp
801042d6:	53                   	push   %ebx
801042d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801042d8:	8b 1d 1c 3f 11 80    	mov    0x80113f1c,%ebx
  data = inb(KBDATAP);
801042de:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801042e1:	3c e0                	cmp    $0xe0,%al
801042e3:	74 5b                	je     80104340 <kbdgetc+0x80>

    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801042e5:	89 da                	mov    %ebx,%edx
801042e7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801042ea:	84 c0                	test   %al,%al
801042ec:	78 62                	js     80104350 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801042ee:	85 d2                	test   %edx,%edx
801042f0:	74 09                	je     801042fb <kbdgetc+0x3b>
    //     return KEY_LEFT;
    //   case 0x4D:  
    //     shift &= ~E0ESC;
    //     return KEY_RIGHT;
    // }
    data |= 0x80;
801042f2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801042f5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801042f8:	0f b6 c8             	movzbl %al,%ecx
    
  }

  shift |= shiftcode[data];
801042fb:	0f b6 91 20 98 10 80 	movzbl -0x7fef67e0(%ecx),%edx
  shift ^= togglecode[data];
80104302:	0f b6 81 20 97 10 80 	movzbl -0x7fef68e0(%ecx),%eax
  shift |= shiftcode[data];
80104309:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010430b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010430d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010430f:	89 15 1c 3f 11 80    	mov    %edx,0x80113f1c
  c = charcode[shift & (CTL | SHIFT)][data];
80104315:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80104318:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010431b:	8b 04 85 00 97 10 80 	mov    -0x7fef6900(,%eax,4),%eax
80104322:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80104326:	74 0b                	je     80104333 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80104328:	8d 50 9f             	lea    -0x61(%eax),%edx
8010432b:	83 fa 19             	cmp    $0x19,%edx
8010432e:	77 48                	ja     80104378 <kbdgetc+0xb8>
      c += 'A' - 'a';
80104330:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80104333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104336:	c9                   	leave
80104337:	c3                   	ret
80104338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010433f:	00 
    shift |= E0ESC;
80104340:	83 cb 40             	or     $0x40,%ebx
    return 0;
80104343:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80104345:	89 1d 1c 3f 11 80    	mov    %ebx,0x80113f1c
}
8010434b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434e:	c9                   	leave
8010434f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80104350:	83 e0 7f             	and    $0x7f,%eax
80104353:	85 d2                	test   %edx,%edx
80104355:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80104358:	0f b6 81 20 98 10 80 	movzbl -0x7fef67e0(%ecx),%eax
8010435f:	83 c8 40             	or     $0x40,%eax
80104362:	0f b6 c0             	movzbl %al,%eax
80104365:	f7 d0                	not    %eax
80104367:	21 d8                	and    %ebx,%eax
80104369:	a3 1c 3f 11 80       	mov    %eax,0x80113f1c
    return 0;
8010436e:	31 c0                	xor    %eax,%eax
80104370:	eb d9                	jmp    8010434b <kbdgetc+0x8b>
80104372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80104378:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010437b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010437e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104381:	c9                   	leave
      c += 'a' - 'A';
80104382:	83 f9 1a             	cmp    $0x1a,%ecx
80104385:	0f 42 c2             	cmovb  %edx,%eax
}
80104388:	c3                   	ret
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104395:	c3                   	ret
80104396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010439d:	00 
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <kbdintr>:

void
kbdintr(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801043a6:	68 c0 42 10 80       	push   $0x801042c0
801043ab:	e8 60 d2 ff ff       	call   80101610 <consoleintr>
}
801043b0:	83 c4 10             	add    $0x10,%esp
801043b3:	c9                   	leave
801043b4:	c3                   	ret
801043b5:	66 90                	xchg   %ax,%ax
801043b7:	66 90                	xchg   %ax,%ax
801043b9:	66 90                	xchg   %ax,%ax
801043bb:	66 90                	xchg   %ax,%ax
801043bd:	66 90                	xchg   %ax,%ax
801043bf:	90                   	nop

801043c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801043c0:	a1 20 3f 11 80       	mov    0x80113f20,%eax
801043c5:	85 c0                	test   %eax,%eax
801043c7:	0f 84 c3 00 00 00    	je     80104490 <lapicinit+0xd0>
  lapic[index] = value;
801043cd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801043d4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801043d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043da:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801043e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801043e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043e7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801043ee:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801043f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043f4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801043fb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801043fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104401:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80104408:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010440b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010440e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80104415:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80104418:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010441b:	8b 50 30             	mov    0x30(%eax),%edx
8010441e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80104424:	75 72                	jne    80104498 <lapicinit+0xd8>
  lapic[index] = value;
80104426:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010442d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104430:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104433:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010443a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010443d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104440:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80104447:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010444a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010444d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104454:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104457:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010445a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80104461:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104464:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104467:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010446e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80104471:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104478:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010447e:	80 e6 10             	and    $0x10,%dh
80104481:	75 f5                	jne    80104478 <lapicinit+0xb8>
  lapic[index] = value;
80104483:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010448a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010448d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80104490:	c3                   	ret
80104491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80104498:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010449f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801044a2:	8b 50 20             	mov    0x20(%eax),%edx
}
801044a5:	e9 7c ff ff ff       	jmp    80104426 <lapicinit+0x66>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801044b0:	a1 20 3f 11 80       	mov    0x80113f20,%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	74 07                	je     801044c0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801044b9:	8b 40 20             	mov    0x20(%eax),%eax
801044bc:	c1 e8 18             	shr    $0x18,%eax
801044bf:	c3                   	ret
    return 0;
801044c0:	31 c0                	xor    %eax,%eax
}
801044c2:	c3                   	ret
801044c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ca:	00 
801044cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801044d0:	a1 20 3f 11 80       	mov    0x80113f20,%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	74 0d                	je     801044e6 <lapiceoi+0x16>
  lapic[index] = value;
801044d9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801044e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801044e3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801044e6:	c3                   	ret
801044e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ee:	00 
801044ef:	90                   	nop

801044f0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801044f0:	c3                   	ret
801044f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044f8:	00 
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104500 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80104500:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104501:	b8 0f 00 00 00       	mov    $0xf,%eax
80104506:	ba 70 00 00 00       	mov    $0x70,%edx
8010450b:	89 e5                	mov    %esp,%ebp
8010450d:	53                   	push   %ebx
8010450e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104511:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104514:	ee                   	out    %al,(%dx)
80104515:	b8 0a 00 00 00       	mov    $0xa,%eax
8010451a:	ba 71 00 00 00       	mov    $0x71,%edx
8010451f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80104520:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80104522:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80104525:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010452b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010452d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80104530:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80104532:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80104535:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80104538:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010453e:	a1 20 3f 11 80       	mov    0x80113f20,%eax
80104543:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104549:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010454c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80104553:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104556:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104559:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80104560:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104563:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104566:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010456c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010456f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104575:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104578:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010457e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104581:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104587:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010458a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010458d:	c9                   	leave
8010458e:	c3                   	ret
8010458f:	90                   	nop

80104590 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80104590:	55                   	push   %ebp
80104591:	b8 0b 00 00 00       	mov    $0xb,%eax
80104596:	ba 70 00 00 00       	mov    $0x70,%edx
8010459b:	89 e5                	mov    %esp,%ebp
8010459d:	57                   	push   %edi
8010459e:	56                   	push   %esi
8010459f:	53                   	push   %ebx
801045a0:	83 ec 4c             	sub    $0x4c,%esp
801045a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045a4:	ba 71 00 00 00       	mov    $0x71,%edx
801045a9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801045aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045ad:	bf 70 00 00 00       	mov    $0x70,%edi
801045b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
801045b8:	31 c0                	xor    %eax,%eax
801045ba:	89 fa                	mov    %edi,%edx
801045bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801045c2:	89 ca                	mov    %ecx,%edx
801045c4:	ec                   	in     (%dx),%al
801045c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045c8:	89 fa                	mov    %edi,%edx
801045ca:	b8 02 00 00 00       	mov    $0x2,%eax
801045cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045d0:	89 ca                	mov    %ecx,%edx
801045d2:	ec                   	in     (%dx),%al
801045d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045d6:	89 fa                	mov    %edi,%edx
801045d8:	b8 04 00 00 00       	mov    $0x4,%eax
801045dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045de:	89 ca                	mov    %ecx,%edx
801045e0:	ec                   	in     (%dx),%al
801045e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045e4:	89 fa                	mov    %edi,%edx
801045e6:	b8 07 00 00 00       	mov    $0x7,%eax
801045eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045ec:	89 ca                	mov    %ecx,%edx
801045ee:	ec                   	in     (%dx),%al
801045ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045f2:	89 fa                	mov    %edi,%edx
801045f4:	b8 08 00 00 00       	mov    $0x8,%eax
801045f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045fa:	89 ca                	mov    %ecx,%edx
801045fc:	ec                   	in     (%dx),%al
801045fd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045ff:	89 fa                	mov    %edi,%edx
80104601:	b8 09 00 00 00       	mov    $0x9,%eax
80104606:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104607:	89 ca                	mov    %ecx,%edx
80104609:	ec                   	in     (%dx),%al
8010460a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010460d:	89 fa                	mov    %edi,%edx
8010460f:	b8 0a 00 00 00       	mov    $0xa,%eax
80104614:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104615:	89 ca                	mov    %ecx,%edx
80104617:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80104618:	84 c0                	test   %al,%al
8010461a:	78 9c                	js     801045b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010461c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80104620:	89 f2                	mov    %esi,%edx
80104622:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80104625:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104628:	89 fa                	mov    %edi,%edx
8010462a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010462d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80104631:	89 75 c8             	mov    %esi,-0x38(%ebp)
80104634:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104637:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010463b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010463e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80104642:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80104645:	31 c0                	xor    %eax,%eax
80104647:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104648:	89 ca                	mov    %ecx,%edx
8010464a:	ec                   	in     (%dx),%al
8010464b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010464e:	89 fa                	mov    %edi,%edx
80104650:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104653:	b8 02 00 00 00       	mov    $0x2,%eax
80104658:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104659:	89 ca                	mov    %ecx,%edx
8010465b:	ec                   	in     (%dx),%al
8010465c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010465f:	89 fa                	mov    %edi,%edx
80104661:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104664:	b8 04 00 00 00       	mov    $0x4,%eax
80104669:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010466a:	89 ca                	mov    %ecx,%edx
8010466c:	ec                   	in     (%dx),%al
8010466d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104670:	89 fa                	mov    %edi,%edx
80104672:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104675:	b8 07 00 00 00       	mov    $0x7,%eax
8010467a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010467b:	89 ca                	mov    %ecx,%edx
8010467d:	ec                   	in     (%dx),%al
8010467e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104681:	89 fa                	mov    %edi,%edx
80104683:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104686:	b8 08 00 00 00       	mov    $0x8,%eax
8010468b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010468c:	89 ca                	mov    %ecx,%edx
8010468e:	ec                   	in     (%dx),%al
8010468f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104692:	89 fa                	mov    %edi,%edx
80104694:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104697:	b8 09 00 00 00       	mov    $0x9,%eax
8010469c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010469d:	89 ca                	mov    %ecx,%edx
8010469f:	ec                   	in     (%dx),%al
801046a0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801046a3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801046a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801046a9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801046ac:	6a 18                	push   $0x18
801046ae:	50                   	push   %eax
801046af:	8d 45 b8             	lea    -0x48(%ebp),%eax
801046b2:	50                   	push   %eax
801046b3:	e8 08 1c 00 00       	call   801062c0 <memcmp>
801046b8:	83 c4 10             	add    $0x10,%esp
801046bb:	85 c0                	test   %eax,%eax
801046bd:	0f 85 f5 fe ff ff    	jne    801045b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801046c3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801046c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046ca:	89 f0                	mov    %esi,%eax
801046cc:	84 c0                	test   %al,%al
801046ce:	75 78                	jne    80104748 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801046d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801046d3:	89 c2                	mov    %eax,%edx
801046d5:	83 e0 0f             	and    $0xf,%eax
801046d8:	c1 ea 04             	shr    $0x4,%edx
801046db:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046de:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801046e4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801046e7:	89 c2                	mov    %eax,%edx
801046e9:	83 e0 0f             	and    $0xf,%eax
801046ec:	c1 ea 04             	shr    $0x4,%edx
801046ef:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046f2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046f5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801046f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801046fb:	89 c2                	mov    %eax,%edx
801046fd:	83 e0 0f             	and    $0xf,%eax
80104700:	c1 ea 04             	shr    $0x4,%edx
80104703:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104706:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104709:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010470c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010470f:	89 c2                	mov    %eax,%edx
80104711:	83 e0 0f             	and    $0xf,%eax
80104714:	c1 ea 04             	shr    $0x4,%edx
80104717:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010471a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010471d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80104720:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104723:	89 c2                	mov    %eax,%edx
80104725:	83 e0 0f             	and    $0xf,%eax
80104728:	c1 ea 04             	shr    $0x4,%edx
8010472b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010472e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104731:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80104734:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104737:	89 c2                	mov    %eax,%edx
80104739:	83 e0 0f             	and    $0xf,%eax
8010473c:	c1 ea 04             	shr    $0x4,%edx
8010473f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104742:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104745:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80104748:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010474b:	89 03                	mov    %eax,(%ebx)
8010474d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104750:	89 43 04             	mov    %eax,0x4(%ebx)
80104753:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104756:	89 43 08             	mov    %eax,0x8(%ebx)
80104759:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010475c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010475f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104762:	89 43 10             	mov    %eax,0x10(%ebx)
80104765:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104768:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010476b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80104772:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104775:	5b                   	pop    %ebx
80104776:	5e                   	pop    %esi
80104777:	5f                   	pop    %edi
80104778:	5d                   	pop    %ebp
80104779:	c3                   	ret
8010477a:	66 90                	xchg   %ax,%ax
8010477c:	66 90                	xchg   %ax,%ax
8010477e:	66 90                	xchg   %ax,%ax

80104780 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80104780:	8b 0d 88 3f 11 80    	mov    0x80113f88,%ecx
80104786:	85 c9                	test   %ecx,%ecx
80104788:	0f 8e 8a 00 00 00    	jle    80104818 <install_trans+0x98>
{
8010478e:	55                   	push   %ebp
8010478f:	89 e5                	mov    %esp,%ebp
80104791:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80104792:	31 ff                	xor    %edi,%edi
{
80104794:	56                   	push   %esi
80104795:	53                   	push   %ebx
80104796:	83 ec 0c             	sub    $0xc,%esp
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801047a0:	a1 74 3f 11 80       	mov    0x80113f74,%eax
801047a5:	83 ec 08             	sub    $0x8,%esp
801047a8:	01 f8                	add    %edi,%eax
801047aa:	83 c0 01             	add    $0x1,%eax
801047ad:	50                   	push   %eax
801047ae:	ff 35 84 3f 11 80    	push   0x80113f84
801047b4:	e8 17 b9 ff ff       	call   801000d0 <bread>
801047b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801047bb:	58                   	pop    %eax
801047bc:	5a                   	pop    %edx
801047bd:	ff 34 bd 8c 3f 11 80 	push   -0x7feec074(,%edi,4)
801047c4:	ff 35 84 3f 11 80    	push   0x80113f84
  for (tail = 0; tail < log.lh.n; tail++) {
801047ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801047cd:	e8 fe b8 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801047d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801047d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801047d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801047da:	68 00 02 00 00       	push   $0x200
801047df:	50                   	push   %eax
801047e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801047e3:	50                   	push   %eax
801047e4:	e8 27 1b 00 00       	call   80106310 <memmove>
    bwrite(dbuf);  // write dst to disk
801047e9:	89 1c 24             	mov    %ebx,(%esp)
801047ec:	e8 bf b9 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801047f1:	89 34 24             	mov    %esi,(%esp)
801047f4:	e8 f7 b9 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801047f9:	89 1c 24             	mov    %ebx,(%esp)
801047fc:	e8 ef b9 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104801:	83 c4 10             	add    $0x10,%esp
80104804:	39 3d 88 3f 11 80    	cmp    %edi,0x80113f88
8010480a:	7f 94                	jg     801047a0 <install_trans+0x20>
  }
}
8010480c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480f:	5b                   	pop    %ebx
80104810:	5e                   	pop    %esi
80104811:	5f                   	pop    %edi
80104812:	5d                   	pop    %ebp
80104813:	c3                   	ret
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104818:	c3                   	ret
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104820 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104827:	ff 35 74 3f 11 80    	push   0x80113f74
8010482d:	ff 35 84 3f 11 80    	push   0x80113f84
80104833:	e8 98 b8 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104838:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010483b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010483d:	a1 88 3f 11 80       	mov    0x80113f88,%eax
80104842:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104845:	85 c0                	test   %eax,%eax
80104847:	7e 19                	jle    80104862 <write_head+0x42>
80104849:	31 d2                	xor    %edx,%edx
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80104850:	8b 0c 95 8c 3f 11 80 	mov    -0x7feec074(,%edx,4),%ecx
80104857:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010485b:	83 c2 01             	add    $0x1,%edx
8010485e:	39 d0                	cmp    %edx,%eax
80104860:	75 ee                	jne    80104850 <write_head+0x30>
  }
  bwrite(buf);
80104862:	83 ec 0c             	sub    $0xc,%esp
80104865:	53                   	push   %ebx
80104866:	e8 45 b9 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010486b:	89 1c 24             	mov    %ebx,(%esp)
8010486e:	e8 7d b9 ff ff       	call   801001f0 <brelse>
}
80104873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104876:	83 c4 10             	add    $0x10,%esp
80104879:	c9                   	leave
8010487a:	c3                   	ret
8010487b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104880 <initlog>:
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	83 ec 2c             	sub    $0x2c,%esp
80104887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010488a:	68 7a 91 10 80       	push   $0x8010917a
8010488f:	68 40 3f 11 80       	push   $0x80113f40
80104894:	e8 f7 16 00 00       	call   80105f90 <initlock>
  readsb(dev, &sb);
80104899:	58                   	pop    %eax
8010489a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010489d:	5a                   	pop    %edx
8010489e:	50                   	push   %eax
8010489f:	53                   	push   %ebx
801048a0:	e8 7b e8 ff ff       	call   80103120 <readsb>
  log.start = sb.logstart;
801048a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801048a8:	59                   	pop    %ecx
  log.dev = dev;
801048a9:	89 1d 84 3f 11 80    	mov    %ebx,0x80113f84
  log.size = sb.nlog;
801048af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801048b2:	a3 74 3f 11 80       	mov    %eax,0x80113f74
  log.size = sb.nlog;
801048b7:	89 15 78 3f 11 80    	mov    %edx,0x80113f78
  struct buf *buf = bread(log.dev, log.start);
801048bd:	5a                   	pop    %edx
801048be:	50                   	push   %eax
801048bf:	53                   	push   %ebx
801048c0:	e8 0b b8 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801048c5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801048c8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801048cb:	89 1d 88 3f 11 80    	mov    %ebx,0x80113f88
  for (i = 0; i < log.lh.n; i++) {
801048d1:	85 db                	test   %ebx,%ebx
801048d3:	7e 1d                	jle    801048f2 <initlog+0x72>
801048d5:	31 d2                	xor    %edx,%edx
801048d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048de:	00 
801048df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801048e0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801048e4:	89 0c 95 8c 3f 11 80 	mov    %ecx,-0x7feec074(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801048eb:	83 c2 01             	add    $0x1,%edx
801048ee:	39 d3                	cmp    %edx,%ebx
801048f0:	75 ee                	jne    801048e0 <initlog+0x60>
  brelse(buf);
801048f2:	83 ec 0c             	sub    $0xc,%esp
801048f5:	50                   	push   %eax
801048f6:	e8 f5 b8 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801048fb:	e8 80 fe ff ff       	call   80104780 <install_trans>
  log.lh.n = 0;
80104900:	c7 05 88 3f 11 80 00 	movl   $0x0,0x80113f88
80104907:	00 00 00 
  write_head(); // clear the log
8010490a:	e8 11 ff ff ff       	call   80104820 <write_head>
}
8010490f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104912:	83 c4 10             	add    $0x10,%esp
80104915:	c9                   	leave
80104916:	c3                   	ret
80104917:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491e:	00 
8010491f:	90                   	nop

80104920 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104926:	68 40 3f 11 80       	push   $0x80113f40
8010492b:	e8 50 18 00 00       	call   80106180 <acquire>
80104930:	83 c4 10             	add    $0x10,%esp
80104933:	eb 18                	jmp    8010494d <begin_op+0x2d>
80104935:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104938:	83 ec 08             	sub    $0x8,%esp
8010493b:	68 40 3f 11 80       	push   $0x80113f40
80104940:	68 40 3f 11 80       	push   $0x80113f40
80104945:	e8 b6 12 00 00       	call   80105c00 <sleep>
8010494a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010494d:	a1 80 3f 11 80       	mov    0x80113f80,%eax
80104952:	85 c0                	test   %eax,%eax
80104954:	75 e2                	jne    80104938 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104956:	a1 7c 3f 11 80       	mov    0x80113f7c,%eax
8010495b:	8b 15 88 3f 11 80    	mov    0x80113f88,%edx
80104961:	83 c0 01             	add    $0x1,%eax
80104964:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104967:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010496a:	83 fa 1e             	cmp    $0x1e,%edx
8010496d:	7f c9                	jg     80104938 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010496f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104972:	a3 7c 3f 11 80       	mov    %eax,0x80113f7c
      release(&log.lock);
80104977:	68 40 3f 11 80       	push   $0x80113f40
8010497c:	e8 9f 17 00 00       	call   80106120 <release>
      break;
    }
  }
}
80104981:	83 c4 10             	add    $0x10,%esp
80104984:	c9                   	leave
80104985:	c3                   	ret
80104986:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010498d:	00 
8010498e:	66 90                	xchg   %ax,%ax

80104990 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80104999:	68 40 3f 11 80       	push   $0x80113f40
8010499e:	e8 dd 17 00 00       	call   80106180 <acquire>
  log.outstanding -= 1;
801049a3:	a1 7c 3f 11 80       	mov    0x80113f7c,%eax
  if(log.committing)
801049a8:	8b 35 80 3f 11 80    	mov    0x80113f80,%esi
801049ae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801049b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801049b4:	89 1d 7c 3f 11 80    	mov    %ebx,0x80113f7c
  if(log.committing)
801049ba:	85 f6                	test   %esi,%esi
801049bc:	0f 85 22 01 00 00    	jne    80104ae4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801049c2:	85 db                	test   %ebx,%ebx
801049c4:	0f 85 f6 00 00 00    	jne    80104ac0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801049ca:	c7 05 80 3f 11 80 01 	movl   $0x1,0x80113f80
801049d1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801049d4:	83 ec 0c             	sub    $0xc,%esp
801049d7:	68 40 3f 11 80       	push   $0x80113f40
801049dc:	e8 3f 17 00 00       	call   80106120 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801049e1:	8b 0d 88 3f 11 80    	mov    0x80113f88,%ecx
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	85 c9                	test   %ecx,%ecx
801049ec:	7f 42                	jg     80104a30 <end_op+0xa0>
    acquire(&log.lock);
801049ee:	83 ec 0c             	sub    $0xc,%esp
801049f1:	68 40 3f 11 80       	push   $0x80113f40
801049f6:	e8 85 17 00 00       	call   80106180 <acquire>
    log.committing = 0;
801049fb:	c7 05 80 3f 11 80 00 	movl   $0x0,0x80113f80
80104a02:	00 00 00 
    wakeup(&log);
80104a05:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104a0c:	e8 af 12 00 00       	call   80105cc0 <wakeup>
    release(&log.lock);
80104a11:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104a18:	e8 03 17 00 00       	call   80106120 <release>
80104a1d:	83 c4 10             	add    $0x10,%esp
}
80104a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5f                   	pop    %edi
80104a26:	5d                   	pop    %ebp
80104a27:	c3                   	ret
80104a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a2f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104a30:	a1 74 3f 11 80       	mov    0x80113f74,%eax
80104a35:	83 ec 08             	sub    $0x8,%esp
80104a38:	01 d8                	add    %ebx,%eax
80104a3a:	83 c0 01             	add    $0x1,%eax
80104a3d:	50                   	push   %eax
80104a3e:	ff 35 84 3f 11 80    	push   0x80113f84
80104a44:	e8 87 b6 ff ff       	call   801000d0 <bread>
80104a49:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a4b:	58                   	pop    %eax
80104a4c:	5a                   	pop    %edx
80104a4d:	ff 34 9d 8c 3f 11 80 	push   -0x7feec074(,%ebx,4)
80104a54:	ff 35 84 3f 11 80    	push   0x80113f84
  for (tail = 0; tail < log.lh.n; tail++) {
80104a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a5d:	e8 6e b6 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104a62:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a65:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104a67:	8d 40 5c             	lea    0x5c(%eax),%eax
80104a6a:	68 00 02 00 00       	push   $0x200
80104a6f:	50                   	push   %eax
80104a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80104a73:	50                   	push   %eax
80104a74:	e8 97 18 00 00       	call   80106310 <memmove>
    bwrite(to);  // write the log
80104a79:	89 34 24             	mov    %esi,(%esp)
80104a7c:	e8 2f b7 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80104a81:	89 3c 24             	mov    %edi,(%esp)
80104a84:	e8 67 b7 ff ff       	call   801001f0 <brelse>
    brelse(to);
80104a89:	89 34 24             	mov    %esi,(%esp)
80104a8c:	e8 5f b7 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104a91:	83 c4 10             	add    $0x10,%esp
80104a94:	3b 1d 88 3f 11 80    	cmp    0x80113f88,%ebx
80104a9a:	7c 94                	jl     80104a30 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80104a9c:	e8 7f fd ff ff       	call   80104820 <write_head>
    install_trans(); // Now install writes to home locations
80104aa1:	e8 da fc ff ff       	call   80104780 <install_trans>
    log.lh.n = 0;
80104aa6:	c7 05 88 3f 11 80 00 	movl   $0x0,0x80113f88
80104aad:	00 00 00 
    write_head();    // Erase the transaction from the log
80104ab0:	e8 6b fd ff ff       	call   80104820 <write_head>
80104ab5:	e9 34 ff ff ff       	jmp    801049ee <end_op+0x5e>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	68 40 3f 11 80       	push   $0x80113f40
80104ac8:	e8 f3 11 00 00       	call   80105cc0 <wakeup>
  release(&log.lock);
80104acd:	c7 04 24 40 3f 11 80 	movl   $0x80113f40,(%esp)
80104ad4:	e8 47 16 00 00       	call   80106120 <release>
80104ad9:	83 c4 10             	add    $0x10,%esp
}
80104adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104adf:	5b                   	pop    %ebx
80104ae0:	5e                   	pop    %esi
80104ae1:	5f                   	pop    %edi
80104ae2:	5d                   	pop    %ebp
80104ae3:	c3                   	ret
    panic("log.committing");
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	68 7e 91 10 80       	push   $0x8010917e
80104aec:	e8 8f b8 ff ff       	call   80100380 <panic>
80104af1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104af8:	00 
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104b07:	8b 15 88 3f 11 80    	mov    0x80113f88,%edx
{
80104b0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104b10:	83 fa 1d             	cmp    $0x1d,%edx
80104b13:	7f 7d                	jg     80104b92 <log_write+0x92>
80104b15:	a1 78 3f 11 80       	mov    0x80113f78,%eax
80104b1a:	83 e8 01             	sub    $0x1,%eax
80104b1d:	39 c2                	cmp    %eax,%edx
80104b1f:	7d 71                	jge    80104b92 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104b21:	a1 7c 3f 11 80       	mov    0x80113f7c,%eax
80104b26:	85 c0                	test   %eax,%eax
80104b28:	7e 75                	jle    80104b9f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	68 40 3f 11 80       	push   $0x80113f40
80104b32:	e8 49 16 00 00       	call   80106180 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104b37:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	31 c0                	xor    %eax,%eax
80104b3f:	8b 15 88 3f 11 80    	mov    0x80113f88,%edx
80104b45:	85 d2                	test   %edx,%edx
80104b47:	7f 0e                	jg     80104b57 <log_write+0x57>
80104b49:	eb 15                	jmp    80104b60 <log_write+0x60>
80104b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	39 c2                	cmp    %eax,%edx
80104b55:	74 29                	je     80104b80 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104b57:	39 0c 85 8c 3f 11 80 	cmp    %ecx,-0x7feec074(,%eax,4)
80104b5e:	75 f0                	jne    80104b50 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104b60:	89 0c 85 8c 3f 11 80 	mov    %ecx,-0x7feec074(,%eax,4)
  if (i == log.lh.n)
80104b67:	39 c2                	cmp    %eax,%edx
80104b69:	74 1c                	je     80104b87 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80104b6b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80104b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80104b71:	c7 45 08 40 3f 11 80 	movl   $0x80113f40,0x8(%ebp)
}
80104b78:	c9                   	leave
  release(&log.lock);
80104b79:	e9 a2 15 00 00       	jmp    80106120 <release>
80104b7e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104b80:	89 0c 95 8c 3f 11 80 	mov    %ecx,-0x7feec074(,%edx,4)
    log.lh.n++;
80104b87:	83 c2 01             	add    $0x1,%edx
80104b8a:	89 15 88 3f 11 80    	mov    %edx,0x80113f88
80104b90:	eb d9                	jmp    80104b6b <log_write+0x6b>
    panic("too big a transaction");
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	68 8d 91 10 80       	push   $0x8010918d
80104b9a:	e8 e1 b7 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 a3 91 10 80       	push   $0x801091a3
80104ba7:	e8 d4 b7 ff ff       	call   80100380 <panic>
80104bac:	66 90                	xchg   %ax,%ax
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104bb7:	e8 64 09 00 00       	call   80105520 <cpuid>
80104bbc:	89 c3                	mov    %eax,%ebx
80104bbe:	e8 5d 09 00 00       	call   80105520 <cpuid>
80104bc3:	83 ec 04             	sub    $0x4,%esp
80104bc6:	53                   	push   %ebx
80104bc7:	50                   	push   %eax
80104bc8:	68 be 91 10 80       	push   $0x801091be
80104bcd:	e8 fe bb ff ff       	call   801007d0 <cprintf>
  idtinit();       // load idt register
80104bd2:	e8 e9 2a 00 00       	call   801076c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104bd7:	e8 e4 08 00 00       	call   801054c0 <mycpu>
80104bdc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104bde:	b8 01 00 00 00       	mov    $0x1,%eax
80104be3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80104bea:	e8 01 0c 00 00       	call   801057f0 <scheduler>
80104bef:	90                   	nop

80104bf0 <mpenter>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104bf6:	e8 c5 3b 00 00       	call   801087c0 <switchkvm>
  seginit();
80104bfb:	e8 30 3b 00 00       	call   80108730 <seginit>
  lapicinit();
80104c00:	e8 bb f7 ff ff       	call   801043c0 <lapicinit>
  mpmain();
80104c05:	e8 a6 ff ff ff       	call   80104bb0 <mpmain>
80104c0a:	66 90                	xchg   %ax,%ax
80104c0c:	66 90                	xchg   %ax,%ax
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <main>:
{
80104c10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104c14:	83 e4 f0             	and    $0xfffffff0,%esp
80104c17:	ff 71 fc             	push   -0x4(%ecx)
80104c1a:	55                   	push   %ebp
80104c1b:	89 e5                	mov    %esp,%ebp
80104c1d:	53                   	push   %ebx
80104c1e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80104c1f:	83 ec 08             	sub    $0x8,%esp
80104c22:	68 00 00 40 80       	push   $0x80400000
80104c27:	68 70 7d 11 80       	push   $0x80117d70
80104c2c:	e8 9f f5 ff ff       	call   801041d0 <kinit1>
  kvmalloc();      // kernel page table
80104c31:	e8 4a 40 00 00       	call   80108c80 <kvmalloc>
  mpinit();        // detect other processors
80104c36:	e8 85 01 00 00       	call   80104dc0 <mpinit>
  lapicinit();     // interrupt controller
80104c3b:	e8 80 f7 ff ff       	call   801043c0 <lapicinit>
  seginit();       // segment descriptors
80104c40:	e8 eb 3a 00 00       	call   80108730 <seginit>
  picinit();       // disable pic
80104c45:	e8 86 03 00 00       	call   80104fd0 <picinit>
  ioapicinit();    // another interrupt controller
80104c4a:	e8 51 f3 ff ff       	call   80103fa0 <ioapicinit>
  consoleinit();   // console hardware
80104c4f:	e8 ec d9 ff ff       	call   80102640 <consoleinit>
  uartinit();      // serial port
80104c54:	e8 47 2d 00 00       	call   801079a0 <uartinit>
  pinit();         // process table
80104c59:	e8 42 08 00 00       	call   801054a0 <pinit>
  tvinit();        // trap vectors
80104c5e:	e8 dd 29 00 00       	call   80107640 <tvinit>
  binit();         // buffer cache
80104c63:	e8 d8 b3 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104c68:	e8 a3 dd ff ff       	call   80102a10 <fileinit>
  ideinit();       // disk 
80104c6d:	e8 0e f1 ff ff       	call   80103d80 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104c72:	83 c4 0c             	add    $0xc,%esp
80104c75:	68 8a 00 00 00       	push   $0x8a
80104c7a:	68 8c c4 10 80       	push   $0x8010c48c
80104c7f:	68 00 70 00 80       	push   $0x80007000
80104c84:	e8 87 16 00 00       	call   80106310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104c89:	83 c4 10             	add    $0x10,%esp
80104c8c:	69 05 24 40 11 80 b0 	imul   $0xb0,0x80114024,%eax
80104c93:	00 00 00 
80104c96:	05 40 40 11 80       	add    $0x80114040,%eax
80104c9b:	3d 40 40 11 80       	cmp    $0x80114040,%eax
80104ca0:	76 7e                	jbe    80104d20 <main+0x110>
80104ca2:	bb 40 40 11 80       	mov    $0x80114040,%ebx
80104ca7:	eb 20                	jmp    80104cc9 <main+0xb9>
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	69 05 24 40 11 80 b0 	imul   $0xb0,0x80114024,%eax
80104cb7:	00 00 00 
80104cba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104cc0:	05 40 40 11 80       	add    $0x80114040,%eax
80104cc5:	39 c3                	cmp    %eax,%ebx
80104cc7:	73 57                	jae    80104d20 <main+0x110>
    if(c == mycpu())  // We've started already.
80104cc9:	e8 f2 07 00 00       	call   801054c0 <mycpu>
80104cce:	39 c3                	cmp    %eax,%ebx
80104cd0:	74 de                	je     80104cb0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104cd2:	e8 69 f5 ff ff       	call   80104240 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104cd7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80104cda:	c7 05 f8 6f 00 80 f0 	movl   $0x80104bf0,0x80006ff8
80104ce1:	4b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104ce4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80104ceb:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80104cee:	05 00 10 00 00       	add    $0x1000,%eax
80104cf3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104cf8:	0f b6 03             	movzbl (%ebx),%eax
80104cfb:	68 00 70 00 00       	push   $0x7000
80104d00:	50                   	push   %eax
80104d01:	e8 fa f7 ff ff       	call   80104500 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104d06:	83 c4 10             	add    $0x10,%esp
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d10:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104d16:	85 c0                	test   %eax,%eax
80104d18:	74 f6                	je     80104d10 <main+0x100>
80104d1a:	eb 94                	jmp    80104cb0 <main+0xa0>
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104d20:	83 ec 08             	sub    $0x8,%esp
80104d23:	68 00 00 00 8e       	push   $0x8e000000
80104d28:	68 00 00 40 80       	push   $0x80400000
80104d2d:	e8 3e f4 ff ff       	call   80104170 <kinit2>
  userinit();      // first user process
80104d32:	e8 39 08 00 00       	call   80105570 <userinit>
  mpmain();        // finish this processor's setup
80104d37:	e8 74 fe ff ff       	call   80104bb0 <mpmain>
80104d3c:	66 90                	xchg   %ax,%ax
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104d45:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80104d4b:	53                   	push   %ebx
  e = addr+len;
80104d4c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80104d4f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80104d52:	39 de                	cmp    %ebx,%esi
80104d54:	72 10                	jb     80104d66 <mpsearch1+0x26>
80104d56:	eb 50                	jmp    80104da8 <mpsearch1+0x68>
80104d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d5f:	00 
80104d60:	89 fe                	mov    %edi,%esi
80104d62:	39 df                	cmp    %ebx,%edi
80104d64:	73 42                	jae    80104da8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104d66:	83 ec 04             	sub    $0x4,%esp
80104d69:	8d 7e 10             	lea    0x10(%esi),%edi
80104d6c:	6a 04                	push   $0x4
80104d6e:	68 d2 91 10 80       	push   $0x801091d2
80104d73:	56                   	push   %esi
80104d74:	e8 47 15 00 00       	call   801062c0 <memcmp>
80104d79:	83 c4 10             	add    $0x10,%esp
80104d7c:	85 c0                	test   %eax,%eax
80104d7e:	75 e0                	jne    80104d60 <mpsearch1+0x20>
80104d80:	89 f2                	mov    %esi,%edx
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80104d88:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104d8b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104d8e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104d90:	39 fa                	cmp    %edi,%edx
80104d92:	75 f4                	jne    80104d88 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104d94:	84 c0                	test   %al,%al
80104d96:	75 c8                	jne    80104d60 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80104d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d9b:	89 f0                	mov    %esi,%eax
80104d9d:	5b                   	pop    %ebx
80104d9e:	5e                   	pop    %esi
80104d9f:	5f                   	pop    %edi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104dab:	31 f6                	xor    %esi,%esi
}
80104dad:	5b                   	pop    %ebx
80104dae:	89 f0                	mov    %esi,%eax
80104db0:	5e                   	pop    %esi
80104db1:	5f                   	pop    %edi
80104db2:	5d                   	pop    %ebp
80104db3:	c3                   	ret
80104db4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dbb:	00 
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	53                   	push   %ebx
80104dc6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104dc9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104dd0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104dd7:	c1 e0 08             	shl    $0x8,%eax
80104dda:	09 d0                	or     %edx,%eax
80104ddc:	c1 e0 04             	shl    $0x4,%eax
80104ddf:	75 1b                	jne    80104dfc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104de1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104de8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80104def:	c1 e0 08             	shl    $0x8,%eax
80104df2:	09 d0                	or     %edx,%eax
80104df4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104df7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80104dfc:	ba 00 04 00 00       	mov    $0x400,%edx
80104e01:	e8 3a ff ff ff       	call   80104d40 <mpsearch1>
80104e06:	89 c3                	mov    %eax,%ebx
80104e08:	85 c0                	test   %eax,%eax
80104e0a:	0f 84 58 01 00 00    	je     80104f68 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104e10:	8b 73 04             	mov    0x4(%ebx),%esi
80104e13:	85 f6                	test   %esi,%esi
80104e15:	0f 84 3d 01 00 00    	je     80104f58 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
80104e1b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104e1e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80104e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104e27:	6a 04                	push   $0x4
80104e29:	68 d7 91 10 80       	push   $0x801091d7
80104e2e:	50                   	push   %eax
80104e2f:	e8 8c 14 00 00       	call   801062c0 <memcmp>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	0f 85 19 01 00 00    	jne    80104f58 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
80104e3f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104e46:	3c 01                	cmp    $0x1,%al
80104e48:	74 08                	je     80104e52 <mpinit+0x92>
80104e4a:	3c 04                	cmp    $0x4,%al
80104e4c:	0f 85 06 01 00 00    	jne    80104f58 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80104e52:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80104e59:	66 85 d2             	test   %dx,%dx
80104e5c:	74 22                	je     80104e80 <mpinit+0xc0>
80104e5e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80104e61:	89 f0                	mov    %esi,%eax
  sum = 0;
80104e63:	31 d2                	xor    %edx,%edx
80104e65:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104e68:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80104e6f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80104e72:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80104e74:	39 f8                	cmp    %edi,%eax
80104e76:	75 f0                	jne    80104e68 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80104e78:	84 d2                	test   %dl,%dl
80104e7a:	0f 85 d8 00 00 00    	jne    80104f58 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80104e80:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104e86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104e89:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
80104e8c:	a3 20 3f 11 80       	mov    %eax,0x80113f20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104e91:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80104e98:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80104e9e:	01 d7                	add    %edx,%edi
80104ea0:	89 fa                	mov    %edi,%edx
  ismp = 1;
80104ea2:	bf 01 00 00 00       	mov    $0x1,%edi
80104ea7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eae:	00 
80104eaf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104eb0:	39 d0                	cmp    %edx,%eax
80104eb2:	73 19                	jae    80104ecd <mpinit+0x10d>
    switch(*p){
80104eb4:	0f b6 08             	movzbl (%eax),%ecx
80104eb7:	80 f9 02             	cmp    $0x2,%cl
80104eba:	0f 84 80 00 00 00    	je     80104f40 <mpinit+0x180>
80104ec0:	77 6e                	ja     80104f30 <mpinit+0x170>
80104ec2:	84 c9                	test   %cl,%cl
80104ec4:	74 3a                	je     80104f00 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104ec6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104ec9:	39 d0                	cmp    %edx,%eax
80104ecb:	72 e7                	jb     80104eb4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104ecd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104ed0:	85 ff                	test   %edi,%edi
80104ed2:	0f 84 dd 00 00 00    	je     80104fb5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104ed8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104edc:	74 15                	je     80104ef3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104ede:	b8 70 00 00 00       	mov    $0x70,%eax
80104ee3:	ba 22 00 00 00       	mov    $0x22,%edx
80104ee8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104ee9:	ba 23 00 00 00       	mov    $0x23,%edx
80104eee:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104eef:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104ef2:	ee                   	out    %al,(%dx)
  }
}
80104ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef6:	5b                   	pop    %ebx
80104ef7:	5e                   	pop    %esi
80104ef8:	5f                   	pop    %edi
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret
80104efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80104f00:	8b 0d 24 40 11 80    	mov    0x80114024,%ecx
80104f06:	83 f9 07             	cmp    $0x7,%ecx
80104f09:	7f 19                	jg     80104f24 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80104f0b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80104f11:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104f15:	83 c1 01             	add    $0x1,%ecx
80104f18:	89 0d 24 40 11 80    	mov    %ecx,0x80114024
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80104f1e:	88 9e 40 40 11 80    	mov    %bl,-0x7feebfc0(%esi)
      p += sizeof(struct mpproc);
80104f24:	83 c0 14             	add    $0x14,%eax
      continue;
80104f27:	eb 87                	jmp    80104eb0 <mpinit+0xf0>
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80104f30:	83 e9 03             	sub    $0x3,%ecx
80104f33:	80 f9 01             	cmp    $0x1,%cl
80104f36:	76 8e                	jbe    80104ec6 <mpinit+0x106>
80104f38:	31 ff                	xor    %edi,%edi
80104f3a:	e9 71 ff ff ff       	jmp    80104eb0 <mpinit+0xf0>
80104f3f:	90                   	nop
      ioapicid = ioapic->apicno;
80104f40:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104f44:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104f47:	88 0d 20 40 11 80    	mov    %cl,0x80114020
      continue;
80104f4d:	e9 5e ff ff ff       	jmp    80104eb0 <mpinit+0xf0>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80104f58:	83 ec 0c             	sub    $0xc,%esp
80104f5b:	68 dc 91 10 80       	push   $0x801091dc
80104f60:	e8 1b b4 ff ff       	call   80100380 <panic>
80104f65:	8d 76 00             	lea    0x0(%esi),%esi
{
80104f68:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80104f6d:	eb 0b                	jmp    80104f7a <mpinit+0x1ba>
80104f6f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80104f70:	89 f3                	mov    %esi,%ebx
80104f72:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80104f78:	74 de                	je     80104f58 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	8d 73 10             	lea    0x10(%ebx),%esi
80104f80:	6a 04                	push   $0x4
80104f82:	68 d2 91 10 80       	push   $0x801091d2
80104f87:	53                   	push   %ebx
80104f88:	e8 33 13 00 00       	call   801062c0 <memcmp>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	75 dc                	jne    80104f70 <mpinit+0x1b0>
80104f94:	89 da                	mov    %ebx,%edx
80104f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f9d:	00 
80104f9e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80104fa0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104fa3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104fa6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104fa8:	39 d6                	cmp    %edx,%esi
80104faa:	75 f4                	jne    80104fa0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104fac:	84 c0                	test   %al,%al
80104fae:	75 c0                	jne    80104f70 <mpinit+0x1b0>
80104fb0:	e9 5b fe ff ff       	jmp    80104e10 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	68 a4 95 10 80       	push   $0x801095a4
80104fbd:	e8 be b3 ff ff       	call   80100380 <panic>
80104fc2:	66 90                	xchg   %ax,%ax
80104fc4:	66 90                	xchg   %ax,%ax
80104fc6:	66 90                	xchg   %ax,%ax
80104fc8:	66 90                	xchg   %ax,%ax
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <picinit>:
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	ba 21 00 00 00       	mov    $0x21,%edx
80104fda:	ee                   	out    %al,(%dx)
80104fdb:	ba a1 00 00 00       	mov    $0xa1,%edx
80104fe0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104fe1:	c3                   	ret
80104fe2:	66 90                	xchg   %ax,%ax
80104fe4:	66 90                	xchg   %ax,%ax
80104fe6:	66 90                	xchg   %ax,%ax
80104fe8:	66 90                	xchg   %ax,%ax
80104fea:	66 90                	xchg   %ax,%ax
80104fec:	66 90                	xchg   %ax,%ax
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	83 ec 0c             	sub    $0xc,%esp
80104ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80104fff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80105005:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010500b:	e8 20 da ff ff       	call   80102a30 <filealloc>
80105010:	89 06                	mov    %eax,(%esi)
80105012:	85 c0                	test   %eax,%eax
80105014:	0f 84 a5 00 00 00    	je     801050bf <pipealloc+0xcf>
8010501a:	e8 11 da ff ff       	call   80102a30 <filealloc>
8010501f:	89 07                	mov    %eax,(%edi)
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 84 00 00 00    	je     801050ad <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80105029:	e8 12 f2 ff ff       	call   80104240 <kalloc>
8010502e:	89 c3                	mov    %eax,%ebx
80105030:	85 c0                	test   %eax,%eax
80105032:	0f 84 a0 00 00 00    	je     801050d8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80105038:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010503f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80105042:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80105045:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010504c:	00 00 00 
  p->nwrite = 0;
8010504f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80105056:	00 00 00 
  p->nread = 0;
80105059:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80105060:	00 00 00 
  initlock(&p->lock, "pipe");
80105063:	68 f4 91 10 80       	push   $0x801091f4
80105068:	50                   	push   %eax
80105069:	e8 22 0f 00 00       	call   80105f90 <initlock>
  (*f0)->type = FD_PIPE;
8010506e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80105070:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80105073:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80105079:	8b 06                	mov    (%esi),%eax
8010507b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010507f:	8b 06                	mov    (%esi),%eax
80105081:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80105085:	8b 06                	mov    (%esi),%eax
80105087:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010508a:	8b 07                	mov    (%edi),%eax
8010508c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80105092:	8b 07                	mov    (%edi),%eax
80105094:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80105098:	8b 07                	mov    (%edi),%eax
8010509a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010509e:	8b 07                	mov    (%edi),%eax
801050a0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801050a3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801050a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a8:	5b                   	pop    %ebx
801050a9:	5e                   	pop    %esi
801050aa:	5f                   	pop    %edi
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret
  if(*f0)
801050ad:	8b 06                	mov    (%esi),%eax
801050af:	85 c0                	test   %eax,%eax
801050b1:	74 1e                	je     801050d1 <pipealloc+0xe1>
    fileclose(*f0);
801050b3:	83 ec 0c             	sub    $0xc,%esp
801050b6:	50                   	push   %eax
801050b7:	e8 34 da ff ff       	call   80102af0 <fileclose>
801050bc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801050bf:	8b 07                	mov    (%edi),%eax
801050c1:	85 c0                	test   %eax,%eax
801050c3:	74 0c                	je     801050d1 <pipealloc+0xe1>
    fileclose(*f1);
801050c5:	83 ec 0c             	sub    $0xc,%esp
801050c8:	50                   	push   %eax
801050c9:	e8 22 da ff ff       	call   80102af0 <fileclose>
801050ce:	83 c4 10             	add    $0x10,%esp
  return -1;
801050d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d6:	eb cd                	jmp    801050a5 <pipealloc+0xb5>
  if(*f0)
801050d8:	8b 06                	mov    (%esi),%eax
801050da:	85 c0                	test   %eax,%eax
801050dc:	75 d5                	jne    801050b3 <pipealloc+0xc3>
801050de:	eb df                	jmp    801050bf <pipealloc+0xcf>

801050e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801050eb:	83 ec 0c             	sub    $0xc,%esp
801050ee:	53                   	push   %ebx
801050ef:	e8 8c 10 00 00       	call   80106180 <acquire>
  if(writable){
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 f6                	test   %esi,%esi
801050f9:	74 65                	je     80105160 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801050fb:	83 ec 0c             	sub    $0xc,%esp
801050fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80105104:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010510b:	00 00 00 
    wakeup(&p->nread);
8010510e:	50                   	push   %eax
8010510f:	e8 ac 0b 00 00       	call   80105cc0 <wakeup>
80105114:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80105117:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010511d:	85 d2                	test   %edx,%edx
8010511f:	75 0a                	jne    8010512b <pipeclose+0x4b>
80105121:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80105127:	85 c0                	test   %eax,%eax
80105129:	74 15                	je     80105140 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010512b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010512e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5d                   	pop    %ebp
    release(&p->lock);
80105134:	e9 e7 0f 00 00       	jmp    80106120 <release>
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	53                   	push   %ebx
80105144:	e8 d7 0f 00 00       	call   80106120 <release>
    kfree((char*)p);
80105149:	83 c4 10             	add    $0x10,%esp
8010514c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010514f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
    kfree((char*)p);
80105155:	e9 26 ef ff ff       	jmp    80104080 <kfree>
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80105169:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80105170:	00 00 00 
    wakeup(&p->nwrite);
80105173:	50                   	push   %eax
80105174:	e8 47 0b 00 00       	call   80105cc0 <wakeup>
80105179:	83 c4 10             	add    $0x10,%esp
8010517c:	eb 99                	jmp    80105117 <pipeclose+0x37>
8010517e:	66 90                	xchg   %ax,%ax

80105180 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	53                   	push   %ebx
80105186:	83 ec 28             	sub    $0x28,%esp
80105189:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010518c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010518f:	53                   	push   %ebx
80105190:	e8 eb 0f 00 00       	call   80106180 <acquire>
  for(i = 0; i < n; i++){
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	85 ff                	test   %edi,%edi
8010519a:	0f 8e ce 00 00 00    	jle    8010526e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801051a0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801051a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051a9:	89 7d 10             	mov    %edi,0x10(%ebp)
801051ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801051af:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801051b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801051b5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801051bb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801051c1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801051c7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801051cd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801051d0:	0f 85 b6 00 00 00    	jne    8010528c <pipewrite+0x10c>
801051d6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801051d9:	eb 3b                	jmp    80105216 <pipewrite+0x96>
801051db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801051e0:	e8 5b 03 00 00       	call   80105540 <myproc>
801051e5:	8b 48 24             	mov    0x24(%eax),%ecx
801051e8:	85 c9                	test   %ecx,%ecx
801051ea:	75 34                	jne    80105220 <pipewrite+0xa0>
      wakeup(&p->nread);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	56                   	push   %esi
801051f0:	e8 cb 0a 00 00       	call   80105cc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	53                   	push   %ebx
801051f8:	57                   	push   %edi
801051f9:	e8 02 0a 00 00       	call   80105c00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801051fe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80105204:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	05 00 02 00 00       	add    $0x200,%eax
80105212:	39 c2                	cmp    %eax,%edx
80105214:	75 2a                	jne    80105240 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80105216:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010521c:	85 c0                	test   %eax,%eax
8010521e:	75 c0                	jne    801051e0 <pipewrite+0x60>
        release(&p->lock);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	53                   	push   %ebx
80105224:	e8 f7 0e 00 00       	call   80106120 <release>
        return -1;
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80105231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105234:	5b                   	pop    %ebx
80105235:	5e                   	pop    %esi
80105236:	5f                   	pop    %edi
80105237:	5d                   	pop    %ebp
80105238:	c3                   	ret
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105240:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80105243:	8d 42 01             	lea    0x1(%edx),%eax
80105246:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010524c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010524f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80105255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105258:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010525c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80105260:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105263:	39 c1                	cmp    %eax,%ecx
80105265:	0f 85 50 ff ff ff    	jne    801051bb <pipewrite+0x3b>
8010526b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80105277:	50                   	push   %eax
80105278:	e8 43 0a 00 00       	call   80105cc0 <wakeup>
  release(&p->lock);
8010527d:	89 1c 24             	mov    %ebx,(%esp)
80105280:	e8 9b 0e 00 00       	call   80106120 <release>
  return n;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	89 f8                	mov    %edi,%eax
8010528a:	eb a5                	jmp    80105231 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010528c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010528f:	eb b2                	jmp    80105243 <pipewrite+0xc3>
80105291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105298:	00 
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
801052a6:	83 ec 18             	sub    $0x18,%esp
801052a9:	8b 75 08             	mov    0x8(%ebp),%esi
801052ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801052af:	56                   	push   %esi
801052b0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801052b6:	e8 c5 0e 00 00       	call   80106180 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801052bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801052ca:	74 2f                	je     801052fb <piperead+0x5b>
801052cc:	eb 37                	jmp    80105305 <piperead+0x65>
801052ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801052d0:	e8 6b 02 00 00       	call   80105540 <myproc>
801052d5:	8b 40 24             	mov    0x24(%eax),%eax
801052d8:	85 c0                	test   %eax,%eax
801052da:	0f 85 80 00 00 00    	jne    80105360 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801052e0:	83 ec 08             	sub    $0x8,%esp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
801052e5:	e8 16 09 00 00       	call   80105c00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801052ea:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801052f0:	83 c4 10             	add    $0x10,%esp
801052f3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801052f9:	75 0a                	jne    80105305 <piperead+0x65>
801052fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80105301:	85 d2                	test   %edx,%edx
80105303:	75 cb                	jne    801052d0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80105305:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105308:	31 db                	xor    %ebx,%ebx
8010530a:	85 c9                	test   %ecx,%ecx
8010530c:	7f 26                	jg     80105334 <piperead+0x94>
8010530e:	eb 2c                	jmp    8010533c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80105310:	8d 48 01             	lea    0x1(%eax),%ecx
80105313:	25 ff 01 00 00       	and    $0x1ff,%eax
80105318:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010531e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80105323:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80105326:	83 c3 01             	add    $0x1,%ebx
80105329:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010532c:	74 0e                	je     8010533c <piperead+0x9c>
8010532e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80105334:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010533a:	75 d4                	jne    80105310 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80105345:	50                   	push   %eax
80105346:	e8 75 09 00 00       	call   80105cc0 <wakeup>
  release(&p->lock);
8010534b:	89 34 24             	mov    %esi,(%esp)
8010534e:	e8 cd 0d 00 00       	call   80106120 <release>
  return i;
80105353:	83 c4 10             	add    $0x10,%esp
}
80105356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105359:	89 d8                	mov    %ebx,%eax
8010535b:	5b                   	pop    %ebx
8010535c:	5e                   	pop    %esi
8010535d:	5f                   	pop    %edi
8010535e:	5d                   	pop    %ebp
8010535f:	c3                   	ret
      release(&p->lock);
80105360:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105363:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80105368:	56                   	push   %esi
80105369:	e8 b2 0d 00 00       	call   80106120 <release>
      return -1;
8010536e:	83 c4 10             	add    $0x10,%esp
}
80105371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105374:	89 d8                	mov    %ebx,%eax
80105376:	5b                   	pop    %ebx
80105377:	5e                   	pop    %esi
80105378:	5f                   	pop    %edi
80105379:	5d                   	pop    %ebp
8010537a:	c3                   	ret
8010537b:	66 90                	xchg   %ax,%ax
8010537d:	66 90                	xchg   %ax,%ax
8010537f:	90                   	nop

80105380 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105384:	bb f4 45 11 80       	mov    $0x801145f4,%ebx
{
80105389:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010538c:	68 c0 45 11 80       	push   $0x801145c0
80105391:	e8 ea 0d 00 00       	call   80106180 <acquire>
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	eb 10                	jmp    801053ab <allocproc+0x2b>
8010539b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053a0:	83 c3 7c             	add    $0x7c,%ebx
801053a3:	81 fb f4 64 11 80    	cmp    $0x801164f4,%ebx
801053a9:	74 75                	je     80105420 <allocproc+0xa0>
    if(p->state == UNUSED)
801053ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801053ae:	85 c0                	test   %eax,%eax
801053b0:	75 ee                	jne    801053a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801053b2:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
801053b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801053ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801053c1:	89 43 10             	mov    %eax,0x10(%ebx)
801053c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801053c7:	68 c0 45 11 80       	push   $0x801145c0
  p->pid = nextpid++;
801053cc:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
801053d2:	e8 49 0d 00 00       	call   80106120 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801053d7:	e8 64 ee ff ff       	call   80104240 <kalloc>
801053dc:	83 c4 10             	add    $0x10,%esp
801053df:	89 43 08             	mov    %eax,0x8(%ebx)
801053e2:	85 c0                	test   %eax,%eax
801053e4:	74 53                	je     80105439 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801053e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801053ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801053ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801053f4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801053f7:	c7 40 14 2b 76 10 80 	movl   $0x8010762b,0x14(%eax)
  p->context = (struct context*)sp;
801053fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80105401:	6a 14                	push   $0x14
80105403:	6a 00                	push   $0x0
80105405:	50                   	push   %eax
80105406:	e8 75 0e 00 00       	call   80106280 <memset>
  p->context->eip = (uint)forkret;
8010540b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010540e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80105411:	c7 40 10 50 54 10 80 	movl   $0x80105450,0x10(%eax)
}
80105418:	89 d8                	mov    %ebx,%eax
8010541a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010541d:	c9                   	leave
8010541e:	c3                   	ret
8010541f:	90                   	nop
  release(&ptable.lock);
80105420:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80105423:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80105425:	68 c0 45 11 80       	push   $0x801145c0
8010542a:	e8 f1 0c 00 00       	call   80106120 <release>
  return 0;
8010542f:	83 c4 10             	add    $0x10,%esp
}
80105432:	89 d8                	mov    %ebx,%eax
80105434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105437:	c9                   	leave
80105438:	c3                   	ret
    p->state = UNUSED;
80105439:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80105440:	31 db                	xor    %ebx,%ebx
80105442:	eb ee                	jmp    80105432 <allocproc+0xb2>
80105444:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010544b:	00 
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105456:	68 c0 45 11 80       	push   $0x801145c0
8010545b:	e8 c0 0c 00 00       	call   80106120 <release>

  if (first) {
80105460:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	85 c0                	test   %eax,%eax
8010546a:	75 04                	jne    80105470 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010546c:	c9                   	leave
8010546d:	c3                   	ret
8010546e:	66 90                	xchg   %ax,%ax
    first = 0;
80105470:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80105477:	00 00 00 
    iinit(ROOTDEV);
8010547a:	83 ec 0c             	sub    $0xc,%esp
8010547d:	6a 01                	push   $0x1
8010547f:	e8 dc dc ff ff       	call   80103160 <iinit>
    initlog(ROOTDEV);
80105484:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010548b:	e8 f0 f3 ff ff       	call   80104880 <initlog>
}
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	c9                   	leave
80105494:	c3                   	ret
80105495:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010549c:	00 
8010549d:	8d 76 00             	lea    0x0(%esi),%esi

801054a0 <pinit>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801054a6:	68 f9 91 10 80       	push   $0x801091f9
801054ab:	68 c0 45 11 80       	push   $0x801145c0
801054b0:	e8 db 0a 00 00       	call   80105f90 <initlock>
}
801054b5:	83 c4 10             	add    $0x10,%esp
801054b8:	c9                   	leave
801054b9:	c3                   	ret
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054c0 <mycpu>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801054c5:	9c                   	pushf
801054c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801054c7:	f6 c4 02             	test   $0x2,%ah
801054ca:	75 46                	jne    80105512 <mycpu+0x52>
  apicid = lapicid();
801054cc:	e8 df ef ff ff       	call   801044b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801054d1:	8b 35 24 40 11 80    	mov    0x80114024,%esi
801054d7:	85 f6                	test   %esi,%esi
801054d9:	7e 2a                	jle    80105505 <mycpu+0x45>
801054db:	31 d2                	xor    %edx,%edx
801054dd:	eb 08                	jmp    801054e7 <mycpu+0x27>
801054df:	90                   	nop
801054e0:	83 c2 01             	add    $0x1,%edx
801054e3:	39 f2                	cmp    %esi,%edx
801054e5:	74 1e                	je     80105505 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801054e7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801054ed:	0f b6 99 40 40 11 80 	movzbl -0x7feebfc0(%ecx),%ebx
801054f4:	39 c3                	cmp    %eax,%ebx
801054f6:	75 e8                	jne    801054e0 <mycpu+0x20>
}
801054f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801054fb:	8d 81 40 40 11 80    	lea    -0x7feebfc0(%ecx),%eax
}
80105501:	5b                   	pop    %ebx
80105502:	5e                   	pop    %esi
80105503:	5d                   	pop    %ebp
80105504:	c3                   	ret
  panic("unknown apicid\n");
80105505:	83 ec 0c             	sub    $0xc,%esp
80105508:	68 00 92 10 80       	push   $0x80109200
8010550d:	e8 6e ae ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80105512:	83 ec 0c             	sub    $0xc,%esp
80105515:	68 c4 95 10 80       	push   $0x801095c4
8010551a:	e8 61 ae ff ff       	call   80100380 <panic>
8010551f:	90                   	nop

80105520 <cpuid>:
cpuid() {
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80105526:	e8 95 ff ff ff       	call   801054c0 <mycpu>
}
8010552b:	c9                   	leave
  return mycpu()-cpus;
8010552c:	2d 40 40 11 80       	sub    $0x80114040,%eax
80105531:	c1 f8 04             	sar    $0x4,%eax
80105534:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010553a:	c3                   	ret
8010553b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105540 <myproc>:
myproc(void) {
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
80105544:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80105547:	e8 e4 0a 00 00       	call   80106030 <pushcli>
  c = mycpu();
8010554c:	e8 6f ff ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105551:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105557:	e8 24 0b 00 00       	call   80106080 <popcli>
}
8010555c:	89 d8                	mov    %ebx,%eax
8010555e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105561:	c9                   	leave
80105562:	c3                   	ret
80105563:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556a:	00 
8010556b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105570 <userinit>:
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
80105574:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80105577:	e8 04 fe ff ff       	call   80105380 <allocproc>
8010557c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010557e:	a3 f4 64 11 80       	mov    %eax,0x801164f4
  if((p->pgdir = setupkvm()) == 0)
80105583:	e8 78 36 00 00       	call   80108c00 <setupkvm>
80105588:	89 43 04             	mov    %eax,0x4(%ebx)
8010558b:	85 c0                	test   %eax,%eax
8010558d:	0f 84 bd 00 00 00    	je     80105650 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80105593:	83 ec 04             	sub    $0x4,%esp
80105596:	68 2c 00 00 00       	push   $0x2c
8010559b:	68 60 c4 10 80       	push   $0x8010c460
801055a0:	50                   	push   %eax
801055a1:	e8 3a 33 00 00       	call   801088e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801055a6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801055a9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801055af:	6a 4c                	push   $0x4c
801055b1:	6a 00                	push   $0x0
801055b3:	ff 73 18             	push   0x18(%ebx)
801055b6:	e8 c5 0c 00 00       	call   80106280 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801055bb:	8b 43 18             	mov    0x18(%ebx),%eax
801055be:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801055c3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801055c6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801055cb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801055cf:	8b 43 18             	mov    0x18(%ebx),%eax
801055d2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801055d6:	8b 43 18             	mov    0x18(%ebx),%eax
801055d9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801055dd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801055e1:	8b 43 18             	mov    0x18(%ebx),%eax
801055e4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801055e8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801055ec:	8b 43 18             	mov    0x18(%ebx),%eax
801055ef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801055f6:	8b 43 18             	mov    0x18(%ebx),%eax
801055f9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80105600:	8b 43 18             	mov    0x18(%ebx),%eax
80105603:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010560a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010560d:	6a 10                	push   $0x10
8010560f:	68 29 92 10 80       	push   $0x80109229
80105614:	50                   	push   %eax
80105615:	e8 16 0e 00 00       	call   80106430 <safestrcpy>
  p->cwd = namei("/");
8010561a:	c7 04 24 32 92 10 80 	movl   $0x80109232,(%esp)
80105621:	e8 3a e6 ff ff       	call   80103c60 <namei>
80105626:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80105629:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
80105630:	e8 4b 0b 00 00       	call   80106180 <acquire>
  p->state = RUNNABLE;
80105635:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010563c:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
80105643:	e8 d8 0a 00 00       	call   80106120 <release>
}
80105648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010564b:	83 c4 10             	add    $0x10,%esp
8010564e:	c9                   	leave
8010564f:	c3                   	ret
    panic("userinit: out of memory?");
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	68 10 92 10 80       	push   $0x80109210
80105658:	e8 23 ad ff ff       	call   80100380 <panic>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi

80105660 <growproc>:
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
80105665:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105668:	e8 c3 09 00 00       	call   80106030 <pushcli>
  c = mycpu();
8010566d:	e8 4e fe ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105672:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105678:	e8 03 0a 00 00       	call   80106080 <popcli>
  sz = curproc->sz;
8010567d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010567f:	85 f6                	test   %esi,%esi
80105681:	7f 1d                	jg     801056a0 <growproc+0x40>
  } else if(n < 0){
80105683:	75 3b                	jne    801056c0 <growproc+0x60>
  switchuvm(curproc);
80105685:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80105688:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010568a:	53                   	push   %ebx
8010568b:	e8 40 31 00 00       	call   801087d0 <switchuvm>
  return 0;
80105690:	83 c4 10             	add    $0x10,%esp
80105693:	31 c0                	xor    %eax,%eax
}
80105695:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105698:	5b                   	pop    %ebx
80105699:	5e                   	pop    %esi
8010569a:	5d                   	pop    %ebp
8010569b:	c3                   	ret
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801056a0:	83 ec 04             	sub    $0x4,%esp
801056a3:	01 c6                	add    %eax,%esi
801056a5:	56                   	push   %esi
801056a6:	50                   	push   %eax
801056a7:	ff 73 04             	push   0x4(%ebx)
801056aa:	e8 81 33 00 00       	call   80108a30 <allocuvm>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	75 cf                	jne    80105685 <growproc+0x25>
      return -1;
801056b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bb:	eb d8                	jmp    80105695 <growproc+0x35>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801056c0:	83 ec 04             	sub    $0x4,%esp
801056c3:	01 c6                	add    %eax,%esi
801056c5:	56                   	push   %esi
801056c6:	50                   	push   %eax
801056c7:	ff 73 04             	push   0x4(%ebx)
801056ca:	e8 81 34 00 00       	call   80108b50 <deallocuvm>
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	85 c0                	test   %eax,%eax
801056d4:	75 af                	jne    80105685 <growproc+0x25>
801056d6:	eb de                	jmp    801056b6 <growproc+0x56>
801056d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056df:	00 

801056e0 <fork>:
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
801056e6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801056e9:	e8 42 09 00 00       	call   80106030 <pushcli>
  c = mycpu();
801056ee:	e8 cd fd ff ff       	call   801054c0 <mycpu>
  p = c->proc;
801056f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801056f9:	e8 82 09 00 00       	call   80106080 <popcli>
  if((np = allocproc()) == 0){
801056fe:	e8 7d fc ff ff       	call   80105380 <allocproc>
80105703:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105706:	85 c0                	test   %eax,%eax
80105708:	0f 84 d6 00 00 00    	je     801057e4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010570e:	83 ec 08             	sub    $0x8,%esp
80105711:	ff 33                	push   (%ebx)
80105713:	89 c7                	mov    %eax,%edi
80105715:	ff 73 04             	push   0x4(%ebx)
80105718:	e8 d3 35 00 00       	call   80108cf0 <copyuvm>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	89 47 04             	mov    %eax,0x4(%edi)
80105723:	85 c0                	test   %eax,%eax
80105725:	0f 84 9a 00 00 00    	je     801057c5 <fork+0xe5>
  np->sz = curproc->sz;
8010572b:	8b 03                	mov    (%ebx),%eax
8010572d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105730:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80105732:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80105735:	89 c8                	mov    %ecx,%eax
80105737:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010573a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010573f:	8b 73 18             	mov    0x18(%ebx),%esi
80105742:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80105744:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80105746:	8b 40 18             	mov    0x18(%eax),%eax
80105749:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80105750:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105754:	85 c0                	test   %eax,%eax
80105756:	74 13                	je     8010576b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	50                   	push   %eax
8010575c:	e8 3f d3 ff ff       	call   80102aa0 <filedup>
80105761:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010576b:	83 c6 01             	add    $0x1,%esi
8010576e:	83 fe 10             	cmp    $0x10,%esi
80105771:	75 dd                	jne    80105750 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80105773:	83 ec 0c             	sub    $0xc,%esp
80105776:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105779:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010577c:	e8 cf db ff ff       	call   80103350 <idup>
80105781:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105784:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105787:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010578a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010578d:	6a 10                	push   $0x10
8010578f:	53                   	push   %ebx
80105790:	50                   	push   %eax
80105791:	e8 9a 0c 00 00       	call   80106430 <safestrcpy>
  pid = np->pid;
80105796:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80105799:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
801057a0:	e8 db 09 00 00       	call   80106180 <acquire>
  np->state = RUNNABLE;
801057a5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801057ac:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
801057b3:	e8 68 09 00 00       	call   80106120 <release>
  return pid;
801057b8:	83 c4 10             	add    $0x10,%esp
}
801057bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057be:	89 d8                	mov    %ebx,%eax
801057c0:	5b                   	pop    %ebx
801057c1:	5e                   	pop    %esi
801057c2:	5f                   	pop    %edi
801057c3:	5d                   	pop    %ebp
801057c4:	c3                   	ret
    kfree(np->kstack);
801057c5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	ff 73 08             	push   0x8(%ebx)
801057ce:	e8 ad e8 ff ff       	call   80104080 <kfree>
    np->kstack = 0;
801057d3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801057da:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801057dd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801057e4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e9:	eb d0                	jmp    801057bb <fork+0xdb>
801057eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801057f0 <scheduler>:
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
801057f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801057f9:	e8 c2 fc ff ff       	call   801054c0 <mycpu>
  c->proc = 0;
801057fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105805:	00 00 00 
  struct cpu *c = mycpu();
80105808:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010580a:	8d 78 04             	lea    0x4(%eax),%edi
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105810:	fb                   	sti
    acquire(&ptable.lock);
80105811:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105814:	bb f4 45 11 80       	mov    $0x801145f4,%ebx
    acquire(&ptable.lock);
80105819:	68 c0 45 11 80       	push   $0x801145c0
8010581e:	e8 5d 09 00 00       	call   80106180 <acquire>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010582d:	00 
8010582e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80105830:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105834:	75 33                	jne    80105869 <scheduler+0x79>
      switchuvm(p);
80105836:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80105839:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010583f:	53                   	push   %ebx
80105840:	e8 8b 2f 00 00       	call   801087d0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80105845:	58                   	pop    %eax
80105846:	5a                   	pop    %edx
80105847:	ff 73 1c             	push   0x1c(%ebx)
8010584a:	57                   	push   %edi
      p->state = RUNNING;
8010584b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80105852:	e8 34 0c 00 00       	call   8010648b <swtch>
      switchkvm();
80105857:	e8 64 2f 00 00       	call   801087c0 <switchkvm>
      c->proc = 0;
8010585c:	83 c4 10             	add    $0x10,%esp
8010585f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80105866:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105869:	83 c3 7c             	add    $0x7c,%ebx
8010586c:	81 fb f4 64 11 80    	cmp    $0x801164f4,%ebx
80105872:	75 bc                	jne    80105830 <scheduler+0x40>
    release(&ptable.lock);
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	68 c0 45 11 80       	push   $0x801145c0
8010587c:	e8 9f 08 00 00       	call   80106120 <release>
    sti();
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	eb 8a                	jmp    80105810 <scheduler+0x20>
80105886:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010588d:	00 
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sched>:
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	56                   	push   %esi
80105894:	53                   	push   %ebx
  pushcli();
80105895:	e8 96 07 00 00       	call   80106030 <pushcli>
  c = mycpu();
8010589a:	e8 21 fc ff ff       	call   801054c0 <mycpu>
  p = c->proc;
8010589f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801058a5:	e8 d6 07 00 00       	call   80106080 <popcli>
  if(!holding(&ptable.lock))
801058aa:	83 ec 0c             	sub    $0xc,%esp
801058ad:	68 c0 45 11 80       	push   $0x801145c0
801058b2:	e8 29 08 00 00       	call   801060e0 <holding>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	85 c0                	test   %eax,%eax
801058bc:	74 4f                	je     8010590d <sched+0x7d>
  if(mycpu()->ncli != 1)
801058be:	e8 fd fb ff ff       	call   801054c0 <mycpu>
801058c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801058ca:	75 68                	jne    80105934 <sched+0xa4>
  if(p->state == RUNNING)
801058cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801058d0:	74 55                	je     80105927 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801058d2:	9c                   	pushf
801058d3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801058d4:	f6 c4 02             	test   $0x2,%ah
801058d7:	75 41                	jne    8010591a <sched+0x8a>
  intena = mycpu()->intena;
801058d9:	e8 e2 fb ff ff       	call   801054c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801058de:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801058e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801058e7:	e8 d4 fb ff ff       	call   801054c0 <mycpu>
801058ec:	83 ec 08             	sub    $0x8,%esp
801058ef:	ff 70 04             	push   0x4(%eax)
801058f2:	53                   	push   %ebx
801058f3:	e8 93 0b 00 00       	call   8010648b <swtch>
  mycpu()->intena = intena;
801058f8:	e8 c3 fb ff ff       	call   801054c0 <mycpu>
}
801058fd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105900:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105909:	5b                   	pop    %ebx
8010590a:	5e                   	pop    %esi
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret
    panic("sched ptable.lock");
8010590d:	83 ec 0c             	sub    $0xc,%esp
80105910:	68 34 92 10 80       	push   $0x80109234
80105915:	e8 66 aa ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010591a:	83 ec 0c             	sub    $0xc,%esp
8010591d:	68 60 92 10 80       	push   $0x80109260
80105922:	e8 59 aa ff ff       	call   80100380 <panic>
    panic("sched running");
80105927:	83 ec 0c             	sub    $0xc,%esp
8010592a:	68 52 92 10 80       	push   $0x80109252
8010592f:	e8 4c aa ff ff       	call   80100380 <panic>
    panic("sched locks");
80105934:	83 ec 0c             	sub    $0xc,%esp
80105937:	68 46 92 10 80       	push   $0x80109246
8010593c:	e8 3f aa ff ff       	call   80100380 <panic>
80105941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105948:	00 
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105950 <exit>:
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	57                   	push   %edi
80105954:	56                   	push   %esi
80105955:	53                   	push   %ebx
80105956:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105959:	e8 e2 fb ff ff       	call   80105540 <myproc>
  if(curproc == initproc)
8010595e:	39 05 f4 64 11 80    	cmp    %eax,0x801164f4
80105964:	0f 84 fd 00 00 00    	je     80105a67 <exit+0x117>
8010596a:	89 c3                	mov    %eax,%ebx
8010596c:	8d 70 28             	lea    0x28(%eax),%esi
8010596f:	8d 78 68             	lea    0x68(%eax),%edi
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105978:	8b 06                	mov    (%esi),%eax
8010597a:	85 c0                	test   %eax,%eax
8010597c:	74 12                	je     80105990 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010597e:	83 ec 0c             	sub    $0xc,%esp
80105981:	50                   	push   %eax
80105982:	e8 69 d1 ff ff       	call   80102af0 <fileclose>
      curproc->ofile[fd] = 0;
80105987:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010598d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105990:	83 c6 04             	add    $0x4,%esi
80105993:	39 f7                	cmp    %esi,%edi
80105995:	75 e1                	jne    80105978 <exit+0x28>
  begin_op();
80105997:	e8 84 ef ff ff       	call   80104920 <begin_op>
  iput(curproc->cwd);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	ff 73 68             	push   0x68(%ebx)
801059a2:	e8 09 db ff ff       	call   801034b0 <iput>
  end_op();
801059a7:	e8 e4 ef ff ff       	call   80104990 <end_op>
  curproc->cwd = 0;
801059ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801059b3:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
801059ba:	e8 c1 07 00 00       	call   80106180 <acquire>
  wakeup1(curproc->parent);
801059bf:	8b 53 14             	mov    0x14(%ebx),%edx
801059c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801059c5:	b8 f4 45 11 80       	mov    $0x801145f4,%eax
801059ca:	eb 0e                	jmp    801059da <exit+0x8a>
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059d0:	83 c0 7c             	add    $0x7c,%eax
801059d3:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
801059d8:	74 1c                	je     801059f6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801059da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801059de:	75 f0                	jne    801059d0 <exit+0x80>
801059e0:	3b 50 20             	cmp    0x20(%eax),%edx
801059e3:	75 eb                	jne    801059d0 <exit+0x80>
      p->state = RUNNABLE;
801059e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801059ec:	83 c0 7c             	add    $0x7c,%eax
801059ef:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
801059f4:	75 e4                	jne    801059da <exit+0x8a>
      p->parent = initproc;
801059f6:	8b 0d f4 64 11 80    	mov    0x801164f4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059fc:	ba f4 45 11 80       	mov    $0x801145f4,%edx
80105a01:	eb 10                	jmp    80105a13 <exit+0xc3>
80105a03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a08:	83 c2 7c             	add    $0x7c,%edx
80105a0b:	81 fa f4 64 11 80    	cmp    $0x801164f4,%edx
80105a11:	74 3b                	je     80105a4e <exit+0xfe>
    if(p->parent == curproc){
80105a13:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105a16:	75 f0                	jne    80105a08 <exit+0xb8>
      if(p->state == ZOMBIE)
80105a18:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105a1c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80105a1f:	75 e7                	jne    80105a08 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a21:	b8 f4 45 11 80       	mov    $0x801145f4,%eax
80105a26:	eb 12                	jmp    80105a3a <exit+0xea>
80105a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a2f:	00 
80105a30:	83 c0 7c             	add    $0x7c,%eax
80105a33:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
80105a38:	74 ce                	je     80105a08 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80105a3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105a3e:	75 f0                	jne    80105a30 <exit+0xe0>
80105a40:	3b 48 20             	cmp    0x20(%eax),%ecx
80105a43:	75 eb                	jne    80105a30 <exit+0xe0>
      p->state = RUNNABLE;
80105a45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105a4c:	eb e2                	jmp    80105a30 <exit+0xe0>
  curproc->state = ZOMBIE;
80105a4e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105a55:	e8 36 fe ff ff       	call   80105890 <sched>
  panic("zombie exit");
80105a5a:	83 ec 0c             	sub    $0xc,%esp
80105a5d:	68 81 92 10 80       	push   $0x80109281
80105a62:	e8 19 a9 ff ff       	call   80100380 <panic>
    panic("init exiting");
80105a67:	83 ec 0c             	sub    $0xc,%esp
80105a6a:	68 74 92 10 80       	push   $0x80109274
80105a6f:	e8 0c a9 ff ff       	call   80100380 <panic>
80105a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a7b:	00 
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <wait>:
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	56                   	push   %esi
80105a84:	53                   	push   %ebx
  pushcli();
80105a85:	e8 a6 05 00 00       	call   80106030 <pushcli>
  c = mycpu();
80105a8a:	e8 31 fa ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105a8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105a95:	e8 e6 05 00 00       	call   80106080 <popcli>
  acquire(&ptable.lock);
80105a9a:	83 ec 0c             	sub    $0xc,%esp
80105a9d:	68 c0 45 11 80       	push   $0x801145c0
80105aa2:	e8 d9 06 00 00       	call   80106180 <acquire>
80105aa7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80105aaa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105aac:	bb f4 45 11 80       	mov    $0x801145f4,%ebx
80105ab1:	eb 10                	jmp    80105ac3 <wait+0x43>
80105ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ab8:	83 c3 7c             	add    $0x7c,%ebx
80105abb:	81 fb f4 64 11 80    	cmp    $0x801164f4,%ebx
80105ac1:	74 1b                	je     80105ade <wait+0x5e>
      if(p->parent != curproc)
80105ac3:	39 73 14             	cmp    %esi,0x14(%ebx)
80105ac6:	75 f0                	jne    80105ab8 <wait+0x38>
      if(p->state == ZOMBIE){
80105ac8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105acc:	74 62                	je     80105b30 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105ace:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80105ad1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105ad6:	81 fb f4 64 11 80    	cmp    $0x801164f4,%ebx
80105adc:	75 e5                	jne    80105ac3 <wait+0x43>
    if(!havekids || curproc->killed){
80105ade:	85 c0                	test   %eax,%eax
80105ae0:	0f 84 a0 00 00 00    	je     80105b86 <wait+0x106>
80105ae6:	8b 46 24             	mov    0x24(%esi),%eax
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	0f 85 95 00 00 00    	jne    80105b86 <wait+0x106>
  pushcli();
80105af1:	e8 3a 05 00 00       	call   80106030 <pushcli>
  c = mycpu();
80105af6:	e8 c5 f9 ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105afb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105b01:	e8 7a 05 00 00       	call   80106080 <popcli>
  if(p == 0)
80105b06:	85 db                	test   %ebx,%ebx
80105b08:	0f 84 8f 00 00 00    	je     80105b9d <wait+0x11d>
  p->chan = chan;
80105b0e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105b11:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105b18:	e8 73 fd ff ff       	call   80105890 <sched>
  p->chan = 0;
80105b1d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105b24:	eb 84                	jmp    80105aaa <wait+0x2a>
80105b26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b2d:	00 
80105b2e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80105b30:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105b33:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105b36:	ff 73 08             	push   0x8(%ebx)
80105b39:	e8 42 e5 ff ff       	call   80104080 <kfree>
        p->kstack = 0;
80105b3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105b45:	5a                   	pop    %edx
80105b46:	ff 73 04             	push   0x4(%ebx)
80105b49:	e8 32 30 00 00       	call   80108b80 <freevm>
        p->pid = 0;
80105b4e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105b55:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80105b5c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105b60:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105b67:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80105b6e:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
80105b75:	e8 a6 05 00 00       	call   80106120 <release>
        return pid;
80105b7a:	83 c4 10             	add    $0x10,%esp
}
80105b7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b80:	89 f0                	mov    %esi,%eax
80105b82:	5b                   	pop    %ebx
80105b83:	5e                   	pop    %esi
80105b84:	5d                   	pop    %ebp
80105b85:	c3                   	ret
      release(&ptable.lock);
80105b86:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105b89:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80105b8e:	68 c0 45 11 80       	push   $0x801145c0
80105b93:	e8 88 05 00 00       	call   80106120 <release>
      return -1;
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	eb e0                	jmp    80105b7d <wait+0xfd>
    panic("sleep");
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 8d 92 10 80       	push   $0x8010928d
80105ba5:	e8 d6 a7 ff ff       	call   80100380 <panic>
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bb0 <yield>:
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	53                   	push   %ebx
80105bb4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105bb7:	68 c0 45 11 80       	push   $0x801145c0
80105bbc:	e8 bf 05 00 00       	call   80106180 <acquire>
  pushcli();
80105bc1:	e8 6a 04 00 00       	call   80106030 <pushcli>
  c = mycpu();
80105bc6:	e8 f5 f8 ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105bcb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105bd1:	e8 aa 04 00 00       	call   80106080 <popcli>
  myproc()->state = RUNNABLE;
80105bd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80105bdd:	e8 ae fc ff ff       	call   80105890 <sched>
  release(&ptable.lock);
80105be2:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
80105be9:	e8 32 05 00 00       	call   80106120 <release>
}
80105bee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	c9                   	leave
80105bf5:	c3                   	ret
80105bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bfd:	00 
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <sleep>:
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
80105c05:	53                   	push   %ebx
80105c06:	83 ec 0c             	sub    $0xc,%esp
80105c09:	8b 7d 08             	mov    0x8(%ebp),%edi
80105c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80105c0f:	e8 1c 04 00 00       	call   80106030 <pushcli>
  c = mycpu();
80105c14:	e8 a7 f8 ff ff       	call   801054c0 <mycpu>
  p = c->proc;
80105c19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105c1f:	e8 5c 04 00 00       	call   80106080 <popcli>
  if(p == 0)
80105c24:	85 db                	test   %ebx,%ebx
80105c26:	0f 84 87 00 00 00    	je     80105cb3 <sleep+0xb3>
  if(lk == 0)
80105c2c:	85 f6                	test   %esi,%esi
80105c2e:	74 76                	je     80105ca6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105c30:	81 fe c0 45 11 80    	cmp    $0x801145c0,%esi
80105c36:	74 50                	je     80105c88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	68 c0 45 11 80       	push   $0x801145c0
80105c40:	e8 3b 05 00 00       	call   80106180 <acquire>
    release(lk);
80105c45:	89 34 24             	mov    %esi,(%esp)
80105c48:	e8 d3 04 00 00       	call   80106120 <release>
  p->chan = chan;
80105c4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105c50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105c57:	e8 34 fc ff ff       	call   80105890 <sched>
  p->chan = 0;
80105c5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105c63:	c7 04 24 c0 45 11 80 	movl   $0x801145c0,(%esp)
80105c6a:	e8 b1 04 00 00       	call   80106120 <release>
    acquire(lk);
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105c75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c78:	5b                   	pop    %ebx
80105c79:	5e                   	pop    %esi
80105c7a:	5f                   	pop    %edi
80105c7b:	5d                   	pop    %ebp
    acquire(lk);
80105c7c:	e9 ff 04 00 00       	jmp    80106180 <acquire>
80105c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105c88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105c8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105c92:	e8 f9 fb ff ff       	call   80105890 <sched>
  p->chan = 0;
80105c97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca1:	5b                   	pop    %ebx
80105ca2:	5e                   	pop    %esi
80105ca3:	5f                   	pop    %edi
80105ca4:	5d                   	pop    %ebp
80105ca5:	c3                   	ret
    panic("sleep without lk");
80105ca6:	83 ec 0c             	sub    $0xc,%esp
80105ca9:	68 93 92 10 80       	push   $0x80109293
80105cae:	e8 cd a6 ff ff       	call   80100380 <panic>
    panic("sleep");
80105cb3:	83 ec 0c             	sub    $0xc,%esp
80105cb6:	68 8d 92 10 80       	push   $0x8010928d
80105cbb:	e8 c0 a6 ff ff       	call   80100380 <panic>

80105cc0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
80105cc4:	83 ec 10             	sub    $0x10,%esp
80105cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80105cca:	68 c0 45 11 80       	push   $0x801145c0
80105ccf:	e8 ac 04 00 00       	call   80106180 <acquire>
80105cd4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105cd7:	b8 f4 45 11 80       	mov    $0x801145f4,%eax
80105cdc:	eb 0c                	jmp    80105cea <wakeup+0x2a>
80105cde:	66 90                	xchg   %ax,%ax
80105ce0:	83 c0 7c             	add    $0x7c,%eax
80105ce3:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
80105ce8:	74 1c                	je     80105d06 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80105cea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105cee:	75 f0                	jne    80105ce0 <wakeup+0x20>
80105cf0:	3b 58 20             	cmp    0x20(%eax),%ebx
80105cf3:	75 eb                	jne    80105ce0 <wakeup+0x20>
      p->state = RUNNABLE;
80105cf5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105cfc:	83 c0 7c             	add    $0x7c,%eax
80105cff:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
80105d04:	75 e4                	jne    80105cea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80105d06:	c7 45 08 c0 45 11 80 	movl   $0x801145c0,0x8(%ebp)
}
80105d0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d10:	c9                   	leave
  release(&ptable.lock);
80105d11:	e9 0a 04 00 00       	jmp    80106120 <release>
80105d16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d1d:	00 
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
80105d24:	83 ec 10             	sub    $0x10,%esp
80105d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80105d2a:	68 c0 45 11 80       	push   $0x801145c0
80105d2f:	e8 4c 04 00 00       	call   80106180 <acquire>
80105d34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d37:	b8 f4 45 11 80       	mov    $0x801145f4,%eax
80105d3c:	eb 0c                	jmp    80105d4a <kill+0x2a>
80105d3e:	66 90                	xchg   %ax,%ax
80105d40:	83 c0 7c             	add    $0x7c,%eax
80105d43:	3d f4 64 11 80       	cmp    $0x801164f4,%eax
80105d48:	74 36                	je     80105d80 <kill+0x60>
    if(p->pid == pid){
80105d4a:	39 58 10             	cmp    %ebx,0x10(%eax)
80105d4d:	75 f1                	jne    80105d40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105d4f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105d53:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80105d5a:	75 07                	jne    80105d63 <kill+0x43>
        p->state = RUNNABLE;
80105d5c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105d63:	83 ec 0c             	sub    $0xc,%esp
80105d66:	68 c0 45 11 80       	push   $0x801145c0
80105d6b:	e8 b0 03 00 00       	call   80106120 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105d73:	83 c4 10             	add    $0x10,%esp
80105d76:	31 c0                	xor    %eax,%eax
}
80105d78:	c9                   	leave
80105d79:	c3                   	ret
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	68 c0 45 11 80       	push   $0x801145c0
80105d88:	e8 93 03 00 00       	call   80106120 <release>
}
80105d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d98:	c9                   	leave
80105d99:	c3                   	ret
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105da0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105da8:	53                   	push   %ebx
80105da9:	bb 60 46 11 80       	mov    $0x80114660,%ebx
80105dae:	83 ec 3c             	sub    $0x3c,%esp
80105db1:	eb 24                	jmp    80105dd7 <procdump+0x37>
80105db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	68 4b 94 10 80       	push   $0x8010944b
80105dc0:	e8 0b aa ff ff       	call   801007d0 <cprintf>
80105dc5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105dc8:	83 c3 7c             	add    $0x7c,%ebx
80105dcb:	81 fb 60 65 11 80    	cmp    $0x80116560,%ebx
80105dd1:	0f 84 81 00 00 00    	je     80105e58 <procdump+0xb8>
    if(p->state == UNUSED)
80105dd7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105dda:	85 c0                	test   %eax,%eax
80105ddc:	74 ea                	je     80105dc8 <procdump+0x28>
      state = "???";
80105dde:	ba a4 92 10 80       	mov    $0x801092a4,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105de3:	83 f8 05             	cmp    $0x5,%eax
80105de6:	77 11                	ja     80105df9 <procdump+0x59>
80105de8:	8b 14 85 20 99 10 80 	mov    -0x7fef66e0(,%eax,4),%edx
      state = "???";
80105def:	b8 a4 92 10 80       	mov    $0x801092a4,%eax
80105df4:	85 d2                	test   %edx,%edx
80105df6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105df9:	53                   	push   %ebx
80105dfa:	52                   	push   %edx
80105dfb:	ff 73 a4             	push   -0x5c(%ebx)
80105dfe:	68 a8 92 10 80       	push   $0x801092a8
80105e03:	e8 c8 a9 ff ff       	call   801007d0 <cprintf>
    if(p->state == SLEEPING){
80105e08:	83 c4 10             	add    $0x10,%esp
80105e0b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105e0f:	75 a7                	jne    80105db8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105e11:	83 ec 08             	sub    $0x8,%esp
80105e14:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105e17:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105e1a:	50                   	push   %eax
80105e1b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105e1e:	8b 40 0c             	mov    0xc(%eax),%eax
80105e21:	83 c0 08             	add    $0x8,%eax
80105e24:	50                   	push   %eax
80105e25:	e8 86 01 00 00       	call   80105fb0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
80105e30:	8b 17                	mov    (%edi),%edx
80105e32:	85 d2                	test   %edx,%edx
80105e34:	74 82                	je     80105db8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105e36:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105e39:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80105e3c:	52                   	push   %edx
80105e3d:	68 81 8f 10 80       	push   $0x80108f81
80105e42:	e8 89 a9 ff ff       	call   801007d0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105e47:	83 c4 10             	add    $0x10,%esp
80105e4a:	39 f7                	cmp    %esi,%edi
80105e4c:	75 e2                	jne    80105e30 <procdump+0x90>
80105e4e:	e9 65 ff ff ff       	jmp    80105db8 <procdump+0x18>
80105e53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80105e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e5b:	5b                   	pop    %ebx
80105e5c:	5e                   	pop    %esi
80105e5d:	5f                   	pop    %edi
80105e5e:	5d                   	pop    %ebp
80105e5f:	c3                   	ret

80105e60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	53                   	push   %ebx
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80105e6a:	68 d4 92 10 80       	push   $0x801092d4
80105e6f:	8d 43 04             	lea    0x4(%ebx),%eax
80105e72:	50                   	push   %eax
80105e73:	e8 18 01 00 00       	call   80105f90 <initlock>
  lk->name = name;
80105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105e7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105e81:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105e84:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80105e8b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e91:	c9                   	leave
80105e92:	c3                   	ret
80105e93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e9a:	00 
80105e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105ea0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	56                   	push   %esi
80105ea4:	53                   	push   %ebx
80105ea5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105ea8:	8d 73 04             	lea    0x4(%ebx),%esi
80105eab:	83 ec 0c             	sub    $0xc,%esp
80105eae:	56                   	push   %esi
80105eaf:	e8 cc 02 00 00       	call   80106180 <acquire>
  while (lk->locked) {
80105eb4:	8b 13                	mov    (%ebx),%edx
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	85 d2                	test   %edx,%edx
80105ebb:	74 16                	je     80105ed3 <acquiresleep+0x33>
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105ec0:	83 ec 08             	sub    $0x8,%esp
80105ec3:	56                   	push   %esi
80105ec4:	53                   	push   %ebx
80105ec5:	e8 36 fd ff ff       	call   80105c00 <sleep>
  while (lk->locked) {
80105eca:	8b 03                	mov    (%ebx),%eax
80105ecc:	83 c4 10             	add    $0x10,%esp
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	75 ed                	jne    80105ec0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105ed3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105ed9:	e8 62 f6 ff ff       	call   80105540 <myproc>
80105ede:	8b 40 10             	mov    0x10(%eax),%eax
80105ee1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105ee4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105ee7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105eea:	5b                   	pop    %ebx
80105eeb:	5e                   	pop    %esi
80105eec:	5d                   	pop    %ebp
  release(&lk->lk);
80105eed:	e9 2e 02 00 00       	jmp    80106120 <release>
80105ef2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ef9:	00 
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	56                   	push   %esi
80105f04:	53                   	push   %ebx
80105f05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105f08:	8d 73 04             	lea    0x4(%ebx),%esi
80105f0b:	83 ec 0c             	sub    $0xc,%esp
80105f0e:	56                   	push   %esi
80105f0f:	e8 6c 02 00 00       	call   80106180 <acquire>
  lk->locked = 0;
80105f14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105f1a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105f21:	89 1c 24             	mov    %ebx,(%esp)
80105f24:	e8 97 fd ff ff       	call   80105cc0 <wakeup>
  release(&lk->lk);
80105f29:	83 c4 10             	add    $0x10,%esp
80105f2c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105f2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f32:	5b                   	pop    %ebx
80105f33:	5e                   	pop    %esi
80105f34:	5d                   	pop    %ebp
  release(&lk->lk);
80105f35:	e9 e6 01 00 00       	jmp    80106120 <release>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	31 ff                	xor    %edi,%edi
80105f46:	56                   	push   %esi
80105f47:	53                   	push   %ebx
80105f48:	83 ec 18             	sub    $0x18,%esp
80105f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105f4e:	8d 73 04             	lea    0x4(%ebx),%esi
80105f51:	56                   	push   %esi
80105f52:	e8 29 02 00 00       	call   80106180 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105f57:	8b 03                	mov    (%ebx),%eax
80105f59:	83 c4 10             	add    $0x10,%esp
80105f5c:	85 c0                	test   %eax,%eax
80105f5e:	75 18                	jne    80105f78 <holdingsleep+0x38>
  release(&lk->lk);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	56                   	push   %esi
80105f64:	e8 b7 01 00 00       	call   80106120 <release>
  return r;
}
80105f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f6c:	89 f8                	mov    %edi,%eax
80105f6e:	5b                   	pop    %ebx
80105f6f:	5e                   	pop    %esi
80105f70:	5f                   	pop    %edi
80105f71:	5d                   	pop    %ebp
80105f72:	c3                   	ret
80105f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80105f78:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105f7b:	e8 c0 f5 ff ff       	call   80105540 <myproc>
80105f80:	39 58 10             	cmp    %ebx,0x10(%eax)
80105f83:	0f 94 c0             	sete   %al
80105f86:	0f b6 c0             	movzbl %al,%eax
80105f89:	89 c7                	mov    %eax,%edi
80105f8b:	eb d3                	jmp    80105f60 <holdingsleep+0x20>
80105f8d:	66 90                	xchg   %ax,%ax
80105f8f:	90                   	nop

80105f90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105f9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105fa9:	5d                   	pop    %ebp
80105faa:	c3                   	ret
80105fab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105fb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	53                   	push   %ebx
80105fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105fba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105fbd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80105fc2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80105fc7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105fcc:	76 10                	jbe    80105fde <getcallerpcs+0x2e>
80105fce:	eb 28                	jmp    80105ff8 <getcallerpcs+0x48>
80105fd0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105fd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105fdc:	77 1a                	ja     80105ff8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105fde:	8b 5a 04             	mov    0x4(%edx),%ebx
80105fe1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105fe4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105fe7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105fe9:	83 f8 0a             	cmp    $0xa,%eax
80105fec:	75 e2                	jne    80105fd0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff1:	c9                   	leave
80105ff2:	c3                   	ret
80105ff3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ff8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80105ffb:	83 c1 28             	add    $0x28,%ecx
80105ffe:	89 ca                	mov    %ecx,%edx
80106000:	29 c2                	sub    %eax,%edx
80106002:	83 e2 04             	and    $0x4,%edx
80106005:	74 11                	je     80106018 <getcallerpcs+0x68>
    pcs[i] = 0;
80106007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010600d:	83 c0 04             	add    $0x4,%eax
80106010:	39 c1                	cmp    %eax,%ecx
80106012:	74 da                	je     80105fee <getcallerpcs+0x3e>
80106014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80106018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010601e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106021:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106028:	39 c1                	cmp    %eax,%ecx
8010602a:	75 ec                	jne    80106018 <getcallerpcs+0x68>
8010602c:	eb c0                	jmp    80105fee <getcallerpcs+0x3e>
8010602e:	66 90                	xchg   %ax,%ax

80106030 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	53                   	push   %ebx
80106034:	83 ec 04             	sub    $0x4,%esp
80106037:	9c                   	pushf
80106038:	5b                   	pop    %ebx
  asm volatile("cli");
80106039:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010603a:	e8 81 f4 ff ff       	call   801054c0 <mycpu>
8010603f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106045:	85 c0                	test   %eax,%eax
80106047:	74 17                	je     80106060 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80106049:	e8 72 f4 ff ff       	call   801054c0 <mycpu>
8010604e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80106055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106058:	c9                   	leave
80106059:	c3                   	ret
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80106060:	e8 5b f4 ff ff       	call   801054c0 <mycpu>
80106065:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010606b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80106071:	eb d6                	jmp    80106049 <pushcli+0x19>
80106073:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010607a:	00 
8010607b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106080 <popcli>:

void
popcli(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106086:	9c                   	pushf
80106087:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80106088:	f6 c4 02             	test   $0x2,%ah
8010608b:	75 35                	jne    801060c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010608d:	e8 2e f4 ff ff       	call   801054c0 <mycpu>
80106092:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106099:	78 34                	js     801060cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010609b:	e8 20 f4 ff ff       	call   801054c0 <mycpu>
801060a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801060a6:	85 d2                	test   %edx,%edx
801060a8:	74 06                	je     801060b0 <popcli+0x30>
    sti();
}
801060aa:	c9                   	leave
801060ab:	c3                   	ret
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801060b0:	e8 0b f4 ff ff       	call   801054c0 <mycpu>
801060b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801060bb:	85 c0                	test   %eax,%eax
801060bd:	74 eb                	je     801060aa <popcli+0x2a>
  asm volatile("sti");
801060bf:	fb                   	sti
}
801060c0:	c9                   	leave
801060c1:	c3                   	ret
    panic("popcli - interruptible");
801060c2:	83 ec 0c             	sub    $0xc,%esp
801060c5:	68 df 92 10 80       	push   $0x801092df
801060ca:	e8 b1 a2 ff ff       	call   80100380 <panic>
    panic("popcli");
801060cf:	83 ec 0c             	sub    $0xc,%esp
801060d2:	68 f6 92 10 80       	push   $0x801092f6
801060d7:	e8 a4 a2 ff ff       	call   80100380 <panic>
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060e0 <holding>:
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	56                   	push   %esi
801060e4:	53                   	push   %ebx
801060e5:	8b 75 08             	mov    0x8(%ebp),%esi
801060e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801060ea:	e8 41 ff ff ff       	call   80106030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801060ef:	8b 06                	mov    (%esi),%eax
801060f1:	85 c0                	test   %eax,%eax
801060f3:	75 0b                	jne    80106100 <holding+0x20>
  popcli();
801060f5:	e8 86 ff ff ff       	call   80106080 <popcli>
}
801060fa:	89 d8                	mov    %ebx,%eax
801060fc:	5b                   	pop    %ebx
801060fd:	5e                   	pop    %esi
801060fe:	5d                   	pop    %ebp
801060ff:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80106100:	8b 5e 08             	mov    0x8(%esi),%ebx
80106103:	e8 b8 f3 ff ff       	call   801054c0 <mycpu>
80106108:	39 c3                	cmp    %eax,%ebx
8010610a:	0f 94 c3             	sete   %bl
  popcli();
8010610d:	e8 6e ff ff ff       	call   80106080 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80106112:	0f b6 db             	movzbl %bl,%ebx
}
80106115:	89 d8                	mov    %ebx,%eax
80106117:	5b                   	pop    %ebx
80106118:	5e                   	pop    %esi
80106119:	5d                   	pop    %ebp
8010611a:	c3                   	ret
8010611b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106120 <release>:
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	56                   	push   %esi
80106124:	53                   	push   %ebx
80106125:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106128:	e8 03 ff ff ff       	call   80106030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010612d:	8b 03                	mov    (%ebx),%eax
8010612f:	85 c0                	test   %eax,%eax
80106131:	75 15                	jne    80106148 <release+0x28>
  popcli();
80106133:	e8 48 ff ff ff       	call   80106080 <popcli>
    panic("release");
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	68 fd 92 10 80       	push   $0x801092fd
80106140:	e8 3b a2 ff ff       	call   80100380 <panic>
80106145:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80106148:	8b 73 08             	mov    0x8(%ebx),%esi
8010614b:	e8 70 f3 ff ff       	call   801054c0 <mycpu>
80106150:	39 c6                	cmp    %eax,%esi
80106152:	75 df                	jne    80106133 <release+0x13>
  popcli();
80106154:	e8 27 ff ff ff       	call   80106080 <popcli>
  lk->pcs[0] = 0;
80106159:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80106160:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80106167:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010616c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80106172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106175:	5b                   	pop    %ebx
80106176:	5e                   	pop    %esi
80106177:	5d                   	pop    %ebp
  popcli();
80106178:	e9 03 ff ff ff       	jmp    80106080 <popcli>
8010617d:	8d 76 00             	lea    0x0(%esi),%esi

80106180 <acquire>:
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	53                   	push   %ebx
80106184:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106187:	e8 a4 fe ff ff       	call   80106030 <pushcli>
  if(holding(lk))
8010618c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010618f:	e8 9c fe ff ff       	call   80106030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106194:	8b 03                	mov    (%ebx),%eax
80106196:	85 c0                	test   %eax,%eax
80106198:	0f 85 b2 00 00 00    	jne    80106250 <acquire+0xd0>
  popcli();
8010619e:	e8 dd fe ff ff       	call   80106080 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801061a3:	b9 01 00 00 00       	mov    $0x1,%ecx
801061a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061af:	00 
  while(xchg(&lk->locked, 1) != 0)
801061b0:	8b 55 08             	mov    0x8(%ebp),%edx
801061b3:	89 c8                	mov    %ecx,%eax
801061b5:	f0 87 02             	lock xchg %eax,(%edx)
801061b8:	85 c0                	test   %eax,%eax
801061ba:	75 f4                	jne    801061b0 <acquire+0x30>
  __sync_synchronize();
801061bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801061c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801061c4:	e8 f7 f2 ff ff       	call   801054c0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801061c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801061cc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801061ce:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801061d1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801061d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801061dc:	77 32                	ja     80106210 <acquire+0x90>
  ebp = (uint*)v - 2;
801061de:	89 e8                	mov    %ebp,%eax
801061e0:	eb 14                	jmp    801061f6 <acquire+0x76>
801061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801061e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801061ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801061f4:	77 1a                	ja     80106210 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801061f6:	8b 58 04             	mov    0x4(%eax),%ebx
801061f9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801061fd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80106200:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80106202:	83 fa 0a             	cmp    $0xa,%edx
80106205:	75 e1                	jne    801061e8 <acquire+0x68>
}
80106207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010620a:	c9                   	leave
8010620b:	c3                   	ret
8010620c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106210:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80106214:	83 c1 34             	add    $0x34,%ecx
80106217:	89 ca                	mov    %ecx,%edx
80106219:	29 c2                	sub    %eax,%edx
8010621b:	83 e2 04             	and    $0x4,%edx
8010621e:	74 10                	je     80106230 <acquire+0xb0>
    pcs[i] = 0;
80106220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106226:	83 c0 04             	add    $0x4,%eax
80106229:	39 c1                	cmp    %eax,%ecx
8010622b:	74 da                	je     80106207 <acquire+0x87>
8010622d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80106230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106236:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106239:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106240:	39 c1                	cmp    %eax,%ecx
80106242:	75 ec                	jne    80106230 <acquire+0xb0>
80106244:	eb c1                	jmp    80106207 <acquire+0x87>
80106246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010624d:	00 
8010624e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80106250:	8b 5b 08             	mov    0x8(%ebx),%ebx
80106253:	e8 68 f2 ff ff       	call   801054c0 <mycpu>
80106258:	39 c3                	cmp    %eax,%ebx
8010625a:	0f 85 3e ff ff ff    	jne    8010619e <acquire+0x1e>
  popcli();
80106260:	e8 1b fe ff ff       	call   80106080 <popcli>
    panic("acquire");
80106265:	83 ec 0c             	sub    $0xc,%esp
80106268:	68 05 93 10 80       	push   $0x80109305
8010626d:	e8 0e a1 ff ff       	call   80100380 <panic>
80106272:	66 90                	xchg   %ax,%ax
80106274:	66 90                	xchg   %ax,%ax
80106276:	66 90                	xchg   %ax,%ax
80106278:	66 90                	xchg   %ax,%ax
8010627a:	66 90                	xchg   %ax,%ax
8010627c:	66 90                	xchg   %ax,%ax
8010627e:	66 90                	xchg   %ax,%ax

80106280 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	8b 55 08             	mov    0x8(%ebp),%edx
80106287:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010628a:	89 d0                	mov    %edx,%eax
8010628c:	09 c8                	or     %ecx,%eax
8010628e:	a8 03                	test   $0x3,%al
80106290:	75 1e                	jne    801062b0 <memset+0x30>
    c &= 0xFF;
80106292:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106296:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80106299:	89 d7                	mov    %edx,%edi
8010629b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801062a1:	fc                   	cld
801062a2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801062a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801062a7:	89 d0                	mov    %edx,%eax
801062a9:	c9                   	leave
801062aa:	c3                   	ret
801062ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801062b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801062b3:	89 d7                	mov    %edx,%edi
801062b5:	fc                   	cld
801062b6:	f3 aa                	rep stos %al,%es:(%edi)
801062b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801062bb:	89 d0                	mov    %edx,%eax
801062bd:	c9                   	leave
801062be:	c3                   	ret
801062bf:	90                   	nop

801062c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	56                   	push   %esi
801062c4:	8b 75 10             	mov    0x10(%ebp),%esi
801062c7:	8b 45 08             	mov    0x8(%ebp),%eax
801062ca:	53                   	push   %ebx
801062cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801062ce:	85 f6                	test   %esi,%esi
801062d0:	74 2e                	je     80106300 <memcmp+0x40>
801062d2:	01 c6                	add    %eax,%esi
801062d4:	eb 14                	jmp    801062ea <memcmp+0x2a>
801062d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062dd:	00 
801062de:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801062e0:	83 c0 01             	add    $0x1,%eax
801062e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801062e6:	39 f0                	cmp    %esi,%eax
801062e8:	74 16                	je     80106300 <memcmp+0x40>
    if(*s1 != *s2)
801062ea:	0f b6 08             	movzbl (%eax),%ecx
801062ed:	0f b6 1a             	movzbl (%edx),%ebx
801062f0:	38 d9                	cmp    %bl,%cl
801062f2:	74 ec                	je     801062e0 <memcmp+0x20>
      return *s1 - *s2;
801062f4:	0f b6 c1             	movzbl %cl,%eax
801062f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801062f9:	5b                   	pop    %ebx
801062fa:	5e                   	pop    %esi
801062fb:	5d                   	pop    %ebp
801062fc:	c3                   	ret
801062fd:	8d 76 00             	lea    0x0(%esi),%esi
80106300:	5b                   	pop    %ebx
  return 0;
80106301:	31 c0                	xor    %eax,%eax
}
80106303:	5e                   	pop    %esi
80106304:	5d                   	pop    %ebp
80106305:	c3                   	ret
80106306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010630d:	00 
8010630e:	66 90                	xchg   %ax,%ax

80106310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	57                   	push   %edi
80106314:	8b 55 08             	mov    0x8(%ebp),%edx
80106317:	8b 45 10             	mov    0x10(%ebp),%eax
8010631a:	56                   	push   %esi
8010631b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010631e:	39 d6                	cmp    %edx,%esi
80106320:	73 26                	jae    80106348 <memmove+0x38>
80106322:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80106325:	39 ca                	cmp    %ecx,%edx
80106327:	73 1f                	jae    80106348 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80106329:	85 c0                	test   %eax,%eax
8010632b:	74 0f                	je     8010633c <memmove+0x2c>
8010632d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80106330:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80106334:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80106337:	83 e8 01             	sub    $0x1,%eax
8010633a:	73 f4                	jae    80106330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010633c:	5e                   	pop    %esi
8010633d:	89 d0                	mov    %edx,%eax
8010633f:	5f                   	pop    %edi
80106340:	5d                   	pop    %ebp
80106341:	c3                   	ret
80106342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80106348:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010634b:	89 d7                	mov    %edx,%edi
8010634d:	85 c0                	test   %eax,%eax
8010634f:	74 eb                	je     8010633c <memmove+0x2c>
80106351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80106358:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80106359:	39 ce                	cmp    %ecx,%esi
8010635b:	75 fb                	jne    80106358 <memmove+0x48>
}
8010635d:	5e                   	pop    %esi
8010635e:	89 d0                	mov    %edx,%eax
80106360:	5f                   	pop    %edi
80106361:	5d                   	pop    %ebp
80106362:	c3                   	ret
80106363:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010636a:	00 
8010636b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80106370:	eb 9e                	jmp    80106310 <memmove>
80106372:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106379:	00 
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106380 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	53                   	push   %ebx
80106384:	8b 55 10             	mov    0x10(%ebp),%edx
80106387:	8b 45 08             	mov    0x8(%ebp),%eax
8010638a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010638d:	85 d2                	test   %edx,%edx
8010638f:	75 16                	jne    801063a7 <strncmp+0x27>
80106391:	eb 2d                	jmp    801063c0 <strncmp+0x40>
80106393:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106398:	3a 19                	cmp    (%ecx),%bl
8010639a:	75 12                	jne    801063ae <strncmp+0x2e>
    n--, p++, q++;
8010639c:	83 c0 01             	add    $0x1,%eax
8010639f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801063a2:	83 ea 01             	sub    $0x1,%edx
801063a5:	74 19                	je     801063c0 <strncmp+0x40>
801063a7:	0f b6 18             	movzbl (%eax),%ebx
801063aa:	84 db                	test   %bl,%bl
801063ac:	75 ea                	jne    80106398 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801063ae:	0f b6 00             	movzbl (%eax),%eax
801063b1:	0f b6 11             	movzbl (%ecx),%edx
}
801063b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063b7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801063b8:	29 d0                	sub    %edx,%eax
}
801063ba:	c3                   	ret
801063bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801063c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801063c3:	31 c0                	xor    %eax,%eax
}
801063c5:	c9                   	leave
801063c6:	c3                   	ret
801063c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ce:	00 
801063cf:	90                   	nop

801063d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	57                   	push   %edi
801063d4:	56                   	push   %esi
801063d5:	8b 75 08             	mov    0x8(%ebp),%esi
801063d8:	53                   	push   %ebx
801063d9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801063dc:	89 f0                	mov    %esi,%eax
801063de:	eb 15                	jmp    801063f5 <strncpy+0x25>
801063e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801063e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801063e7:	83 c0 01             	add    $0x1,%eax
801063ea:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801063ee:	88 48 ff             	mov    %cl,-0x1(%eax)
801063f1:	84 c9                	test   %cl,%cl
801063f3:	74 13                	je     80106408 <strncpy+0x38>
801063f5:	89 d3                	mov    %edx,%ebx
801063f7:	83 ea 01             	sub    $0x1,%edx
801063fa:	85 db                	test   %ebx,%ebx
801063fc:	7f e2                	jg     801063e0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801063fe:	5b                   	pop    %ebx
801063ff:	89 f0                	mov    %esi,%eax
80106401:	5e                   	pop    %esi
80106402:	5f                   	pop    %edi
80106403:	5d                   	pop    %ebp
80106404:	c3                   	ret
80106405:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80106408:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010640b:	83 e9 01             	sub    $0x1,%ecx
8010640e:	85 d2                	test   %edx,%edx
80106410:	74 ec                	je     801063fe <strncpy+0x2e>
80106412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80106418:	83 c0 01             	add    $0x1,%eax
8010641b:	89 ca                	mov    %ecx,%edx
8010641d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80106421:	29 c2                	sub    %eax,%edx
80106423:	85 d2                	test   %edx,%edx
80106425:	7f f1                	jg     80106418 <strncpy+0x48>
}
80106427:	5b                   	pop    %ebx
80106428:	89 f0                	mov    %esi,%eax
8010642a:	5e                   	pop    %esi
8010642b:	5f                   	pop    %edi
8010642c:	5d                   	pop    %ebp
8010642d:	c3                   	ret
8010642e:	66 90                	xchg   %ax,%ax

80106430 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	56                   	push   %esi
80106434:	8b 55 10             	mov    0x10(%ebp),%edx
80106437:	8b 75 08             	mov    0x8(%ebp),%esi
8010643a:	53                   	push   %ebx
8010643b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010643e:	85 d2                	test   %edx,%edx
80106440:	7e 25                	jle    80106467 <safestrcpy+0x37>
80106442:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80106446:	89 f2                	mov    %esi,%edx
80106448:	eb 16                	jmp    80106460 <safestrcpy+0x30>
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80106450:	0f b6 08             	movzbl (%eax),%ecx
80106453:	83 c0 01             	add    $0x1,%eax
80106456:	83 c2 01             	add    $0x1,%edx
80106459:	88 4a ff             	mov    %cl,-0x1(%edx)
8010645c:	84 c9                	test   %cl,%cl
8010645e:	74 04                	je     80106464 <safestrcpy+0x34>
80106460:	39 d8                	cmp    %ebx,%eax
80106462:	75 ec                	jne    80106450 <safestrcpy+0x20>
    ;
  *s = 0;
80106464:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80106467:	89 f0                	mov    %esi,%eax
80106469:	5b                   	pop    %ebx
8010646a:	5e                   	pop    %esi
8010646b:	5d                   	pop    %ebp
8010646c:	c3                   	ret
8010646d:	8d 76 00             	lea    0x0(%esi),%esi

80106470 <strlen>:

int
strlen(const char *s)
{
80106470:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80106471:	31 c0                	xor    %eax,%eax
{
80106473:	89 e5                	mov    %esp,%ebp
80106475:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80106478:	80 3a 00             	cmpb   $0x0,(%edx)
8010647b:	74 0c                	je     80106489 <strlen+0x19>
8010647d:	8d 76 00             	lea    0x0(%esi),%esi
80106480:	83 c0 01             	add    $0x1,%eax
80106483:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80106487:	75 f7                	jne    80106480 <strlen+0x10>
    ;
  return n;
}
80106489:	5d                   	pop    %ebp
8010648a:	c3                   	ret

8010648b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010648b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010648f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80106493:	55                   	push   %ebp
  pushl %ebx
80106494:	53                   	push   %ebx
  pushl %esi
80106495:	56                   	push   %esi
  pushl %edi
80106496:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106497:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106499:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010649b:	5f                   	pop    %edi
  popl %esi
8010649c:	5e                   	pop    %esi
  popl %ebx
8010649d:	5b                   	pop    %ebx
  popl %ebp
8010649e:	5d                   	pop    %ebp
  ret
8010649f:	c3                   	ret

801064a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	53                   	push   %ebx
801064a4:	83 ec 04             	sub    $0x4,%esp
801064a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801064aa:	e8 91 f0 ff ff       	call   80105540 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801064af:	8b 00                	mov    (%eax),%eax
801064b1:	39 c3                	cmp    %eax,%ebx
801064b3:	73 1b                	jae    801064d0 <fetchint+0x30>
801064b5:	8d 53 04             	lea    0x4(%ebx),%edx
801064b8:	39 d0                	cmp    %edx,%eax
801064ba:	72 14                	jb     801064d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801064bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801064bf:	8b 13                	mov    (%ebx),%edx
801064c1:	89 10                	mov    %edx,(%eax)
  return 0;
801064c3:	31 c0                	xor    %eax,%eax
}
801064c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c8:	c9                   	leave
801064c9:	c3                   	ret
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801064d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d5:	eb ee                	jmp    801064c5 <fetchint+0x25>
801064d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064de:	00 
801064df:	90                   	nop

801064e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	53                   	push   %ebx
801064e4:	83 ec 04             	sub    $0x4,%esp
801064e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801064ea:	e8 51 f0 ff ff       	call   80105540 <myproc>

  if(addr >= curproc->sz)
801064ef:	3b 18                	cmp    (%eax),%ebx
801064f1:	73 2d                	jae    80106520 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801064f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801064f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801064f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801064fa:	39 d3                	cmp    %edx,%ebx
801064fc:	73 22                	jae    80106520 <fetchstr+0x40>
801064fe:	89 d8                	mov    %ebx,%eax
80106500:	eb 0d                	jmp    8010650f <fetchstr+0x2f>
80106502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106508:	83 c0 01             	add    $0x1,%eax
8010650b:	39 d0                	cmp    %edx,%eax
8010650d:	73 11                	jae    80106520 <fetchstr+0x40>
    if(*s == 0)
8010650f:	80 38 00             	cmpb   $0x0,(%eax)
80106512:	75 f4                	jne    80106508 <fetchstr+0x28>
      return s - *pp;
80106514:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80106516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106519:	c9                   	leave
8010651a:	c3                   	ret
8010651b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106528:	c9                   	leave
80106529:	c3                   	ret
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106530 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	56                   	push   %esi
80106534:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106535:	e8 06 f0 ff ff       	call   80105540 <myproc>
8010653a:	8b 55 08             	mov    0x8(%ebp),%edx
8010653d:	8b 40 18             	mov    0x18(%eax),%eax
80106540:	8b 40 44             	mov    0x44(%eax),%eax
80106543:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106546:	e8 f5 ef ff ff       	call   80105540 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010654b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010654e:	8b 00                	mov    (%eax),%eax
80106550:	39 c6                	cmp    %eax,%esi
80106552:	73 1c                	jae    80106570 <argint+0x40>
80106554:	8d 53 08             	lea    0x8(%ebx),%edx
80106557:	39 d0                	cmp    %edx,%eax
80106559:	72 15                	jb     80106570 <argint+0x40>
  *ip = *(int*)(addr);
8010655b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010655e:	8b 53 04             	mov    0x4(%ebx),%edx
80106561:	89 10                	mov    %edx,(%eax)
  return 0;
80106563:	31 c0                	xor    %eax,%eax
}
80106565:	5b                   	pop    %ebx
80106566:	5e                   	pop    %esi
80106567:	5d                   	pop    %ebp
80106568:	c3                   	ret
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106575:	eb ee                	jmp    80106565 <argint+0x35>
80106577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010657e:	00 
8010657f:	90                   	nop

80106580 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	57                   	push   %edi
80106584:	56                   	push   %esi
80106585:	53                   	push   %ebx
80106586:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106589:	e8 b2 ef ff ff       	call   80105540 <myproc>
8010658e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106590:	e8 ab ef ff ff       	call   80105540 <myproc>
80106595:	8b 55 08             	mov    0x8(%ebp),%edx
80106598:	8b 40 18             	mov    0x18(%eax),%eax
8010659b:	8b 40 44             	mov    0x44(%eax),%eax
8010659e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801065a1:	e8 9a ef ff ff       	call   80105540 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801065a6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801065a9:	8b 00                	mov    (%eax),%eax
801065ab:	39 c7                	cmp    %eax,%edi
801065ad:	73 31                	jae    801065e0 <argptr+0x60>
801065af:	8d 4b 08             	lea    0x8(%ebx),%ecx
801065b2:	39 c8                	cmp    %ecx,%eax
801065b4:	72 2a                	jb     801065e0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801065b6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801065b9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801065bc:	85 d2                	test   %edx,%edx
801065be:	78 20                	js     801065e0 <argptr+0x60>
801065c0:	8b 16                	mov    (%esi),%edx
801065c2:	39 d0                	cmp    %edx,%eax
801065c4:	73 1a                	jae    801065e0 <argptr+0x60>
801065c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801065c9:	01 c3                	add    %eax,%ebx
801065cb:	39 da                	cmp    %ebx,%edx
801065cd:	72 11                	jb     801065e0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801065cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801065d2:	89 02                	mov    %eax,(%edx)
  return 0;
801065d4:	31 c0                	xor    %eax,%eax
}
801065d6:	83 c4 0c             	add    $0xc,%esp
801065d9:	5b                   	pop    %ebx
801065da:	5e                   	pop    %esi
801065db:	5f                   	pop    %edi
801065dc:	5d                   	pop    %ebp
801065dd:	c3                   	ret
801065de:	66 90                	xchg   %ax,%ax
    return -1;
801065e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e5:	eb ef                	jmp    801065d6 <argptr+0x56>
801065e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065ee:	00 
801065ef:	90                   	nop

801065f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	56                   	push   %esi
801065f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801065f5:	e8 46 ef ff ff       	call   80105540 <myproc>
801065fa:	8b 55 08             	mov    0x8(%ebp),%edx
801065fd:	8b 40 18             	mov    0x18(%eax),%eax
80106600:	8b 40 44             	mov    0x44(%eax),%eax
80106603:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106606:	e8 35 ef ff ff       	call   80105540 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010660b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010660e:	8b 00                	mov    (%eax),%eax
80106610:	39 c6                	cmp    %eax,%esi
80106612:	73 44                	jae    80106658 <argstr+0x68>
80106614:	8d 53 08             	lea    0x8(%ebx),%edx
80106617:	39 d0                	cmp    %edx,%eax
80106619:	72 3d                	jb     80106658 <argstr+0x68>
  *ip = *(int*)(addr);
8010661b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010661e:	e8 1d ef ff ff       	call   80105540 <myproc>
  if(addr >= curproc->sz)
80106623:	3b 18                	cmp    (%eax),%ebx
80106625:	73 31                	jae    80106658 <argstr+0x68>
  *pp = (char*)addr;
80106627:	8b 55 0c             	mov    0xc(%ebp),%edx
8010662a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010662c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010662e:	39 d3                	cmp    %edx,%ebx
80106630:	73 26                	jae    80106658 <argstr+0x68>
80106632:	89 d8                	mov    %ebx,%eax
80106634:	eb 11                	jmp    80106647 <argstr+0x57>
80106636:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010663d:	00 
8010663e:	66 90                	xchg   %ax,%ax
80106640:	83 c0 01             	add    $0x1,%eax
80106643:	39 d0                	cmp    %edx,%eax
80106645:	73 11                	jae    80106658 <argstr+0x68>
    if(*s == 0)
80106647:	80 38 00             	cmpb   $0x0,(%eax)
8010664a:	75 f4                	jne    80106640 <argstr+0x50>
      return s - *pp;
8010664c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010664e:	5b                   	pop    %ebx
8010664f:	5e                   	pop    %esi
80106650:	5d                   	pop    %ebp
80106651:	c3                   	ret
80106652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106658:	5b                   	pop    %ebx
    return -1;
80106659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010665e:	5e                   	pop    %esi
8010665f:	5d                   	pop    %ebp
80106660:	c3                   	ret
80106661:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106668:	00 
80106669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106670 <syscall>:
[SYS_simple_arithmetic_syscall] sys_simple_arithmetic_syscall,
};

void
syscall(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	53                   	push   %ebx
80106674:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106677:	e8 c4 ee ff ff       	call   80105540 <myproc>
8010667c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010667e:	8b 40 18             	mov    0x18(%eax),%eax
80106681:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106684:	8d 50 ff             	lea    -0x1(%eax),%edx
80106687:	83 fa 16             	cmp    $0x16,%edx
8010668a:	77 24                	ja     801066b0 <syscall+0x40>
8010668c:	8b 14 85 40 99 10 80 	mov    -0x7fef66c0(,%eax,4),%edx
80106693:	85 d2                	test   %edx,%edx
80106695:	74 19                	je     801066b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80106697:	ff d2                	call   *%edx
80106699:	89 c2                	mov    %eax,%edx
8010669b:	8b 43 18             	mov    0x18(%ebx),%eax
8010669e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801066a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066a4:	c9                   	leave
801066a5:	c3                   	ret
801066a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801066ad:	00 
801066ae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801066b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801066b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801066b4:	50                   	push   %eax
801066b5:	ff 73 10             	push   0x10(%ebx)
801066b8:	68 0d 93 10 80       	push   $0x8010930d
801066bd:	e8 0e a1 ff ff       	call   801007d0 <cprintf>
    curproc->tf->eax = -1;
801066c2:	8b 43 18             	mov    0x18(%ebx),%eax
801066c5:	83 c4 10             	add    $0x10,%esp
801066c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801066cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066d2:	c9                   	leave
801066d3:	c3                   	ret
801066d4:	66 90                	xchg   %ax,%ax
801066d6:	66 90                	xchg   %ax,%ax
801066d8:	66 90                	xchg   %ax,%ax
801066da:	66 90                	xchg   %ax,%ax
801066dc:	66 90                	xchg   %ax,%ax
801066de:	66 90                	xchg   %ax,%ax

801066e0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801066e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801066e8:	53                   	push   %ebx
801066e9:	83 ec 34             	sub    $0x34,%esp
801066ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801066ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801066f2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801066f5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
801066f8:	57                   	push   %edi
801066f9:	50                   	push   %eax
801066fa:	e8 81 d5 ff ff       	call   80103c80 <nameiparent>
801066ff:	83 c4 10             	add    $0x10,%esp
80106702:	85 c0                	test   %eax,%eax
80106704:	74 5e                	je     80106764 <create+0x84>
    return 0;
  ilock(dp);
80106706:	83 ec 0c             	sub    $0xc,%esp
80106709:	89 c3                	mov    %eax,%ebx
8010670b:	50                   	push   %eax
8010670c:	e8 6f cc ff ff       	call   80103380 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80106711:	83 c4 0c             	add    $0xc,%esp
80106714:	6a 00                	push   $0x0
80106716:	57                   	push   %edi
80106717:	53                   	push   %ebx
80106718:	e8 b3 d1 ff ff       	call   801038d0 <dirlookup>
8010671d:	83 c4 10             	add    $0x10,%esp
80106720:	89 c6                	mov    %eax,%esi
80106722:	85 c0                	test   %eax,%eax
80106724:	74 4a                	je     80106770 <create+0x90>
  {
    iunlockput(dp);
80106726:	83 ec 0c             	sub    $0xc,%esp
80106729:	53                   	push   %ebx
8010672a:	e8 e1 ce ff ff       	call   80103610 <iunlockput>
    ilock(ip);
8010672f:	89 34 24             	mov    %esi,(%esp)
80106732:	e8 49 cc ff ff       	call   80103380 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
80106737:	83 c4 10             	add    $0x10,%esp
8010673a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010673f:	75 17                	jne    80106758 <create+0x78>
80106741:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80106746:	75 10                	jne    80106758 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80106748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010674b:	89 f0                	mov    %esi,%eax
8010674d:	5b                   	pop    %ebx
8010674e:	5e                   	pop    %esi
8010674f:	5f                   	pop    %edi
80106750:	5d                   	pop    %ebp
80106751:	c3                   	ret
80106752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106758:	83 ec 0c             	sub    $0xc,%esp
8010675b:	56                   	push   %esi
8010675c:	e8 af ce ff ff       	call   80103610 <iunlockput>
    return 0;
80106761:	83 c4 10             	add    $0x10,%esp
}
80106764:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106767:	31 f6                	xor    %esi,%esi
}
80106769:	5b                   	pop    %ebx
8010676a:	89 f0                	mov    %esi,%eax
8010676c:	5e                   	pop    %esi
8010676d:	5f                   	pop    %edi
8010676e:	5d                   	pop    %ebp
8010676f:	c3                   	ret
  if ((ip = ialloc(dp->dev, type)) == 0)
80106770:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106774:	83 ec 08             	sub    $0x8,%esp
80106777:	50                   	push   %eax
80106778:	ff 33                	push   (%ebx)
8010677a:	e8 91 ca ff ff       	call   80103210 <ialloc>
8010677f:	83 c4 10             	add    $0x10,%esp
80106782:	89 c6                	mov    %eax,%esi
80106784:	85 c0                	test   %eax,%eax
80106786:	0f 84 bc 00 00 00    	je     80106848 <create+0x168>
  ilock(ip);
8010678c:	83 ec 0c             	sub    $0xc,%esp
8010678f:	50                   	push   %eax
80106790:	e8 eb cb ff ff       	call   80103380 <ilock>
  ip->major = major;
80106795:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106799:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010679d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801067a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801067a5:	b8 01 00 00 00       	mov    $0x1,%eax
801067aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801067ae:	89 34 24             	mov    %esi,(%esp)
801067b1:	e8 1a cb ff ff       	call   801032d0 <iupdate>
  if (type == T_DIR)
801067b6:	83 c4 10             	add    $0x10,%esp
801067b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801067be:	74 30                	je     801067f0 <create+0x110>
  if (dirlink(dp, name, ip->inum) < 0)
801067c0:	83 ec 04             	sub    $0x4,%esp
801067c3:	ff 76 04             	push   0x4(%esi)
801067c6:	57                   	push   %edi
801067c7:	53                   	push   %ebx
801067c8:	e8 d3 d3 ff ff       	call   80103ba0 <dirlink>
801067cd:	83 c4 10             	add    $0x10,%esp
801067d0:	85 c0                	test   %eax,%eax
801067d2:	78 67                	js     8010683b <create+0x15b>
  iunlockput(dp);
801067d4:	83 ec 0c             	sub    $0xc,%esp
801067d7:	53                   	push   %ebx
801067d8:	e8 33 ce ff ff       	call   80103610 <iunlockput>
  return ip;
801067dd:	83 c4 10             	add    $0x10,%esp
}
801067e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067e3:	89 f0                	mov    %esi,%eax
801067e5:	5b                   	pop    %ebx
801067e6:	5e                   	pop    %esi
801067e7:	5f                   	pop    %edi
801067e8:	5d                   	pop    %ebp
801067e9:	c3                   	ret
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801067f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
801067f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801067f8:	53                   	push   %ebx
801067f9:	e8 d2 ca ff ff       	call   801032d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801067fe:	83 c4 0c             	add    $0xc,%esp
80106801:	ff 76 04             	push   0x4(%esi)
80106804:	68 45 93 10 80       	push   $0x80109345
80106809:	56                   	push   %esi
8010680a:	e8 91 d3 ff ff       	call   80103ba0 <dirlink>
8010680f:	83 c4 10             	add    $0x10,%esp
80106812:	85 c0                	test   %eax,%eax
80106814:	78 18                	js     8010682e <create+0x14e>
80106816:	83 ec 04             	sub    $0x4,%esp
80106819:	ff 73 04             	push   0x4(%ebx)
8010681c:	68 44 93 10 80       	push   $0x80109344
80106821:	56                   	push   %esi
80106822:	e8 79 d3 ff ff       	call   80103ba0 <dirlink>
80106827:	83 c4 10             	add    $0x10,%esp
8010682a:	85 c0                	test   %eax,%eax
8010682c:	79 92                	jns    801067c0 <create+0xe0>
      panic("create dots");
8010682e:	83 ec 0c             	sub    $0xc,%esp
80106831:	68 38 93 10 80       	push   $0x80109338
80106836:	e8 45 9b ff ff       	call   80100380 <panic>
    panic("create: dirlink");
8010683b:	83 ec 0c             	sub    $0xc,%esp
8010683e:	68 47 93 10 80       	push   $0x80109347
80106843:	e8 38 9b ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80106848:	83 ec 0c             	sub    $0xc,%esp
8010684b:	68 29 93 10 80       	push   $0x80109329
80106850:	e8 2b 9b ff ff       	call   80100380 <panic>
80106855:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010685c:	00 
8010685d:	8d 76 00             	lea    0x0(%esi),%esi

80106860 <sys_dup>:
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	56                   	push   %esi
80106864:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106865:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106868:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010686b:	50                   	push   %eax
8010686c:	6a 00                	push   $0x0
8010686e:	e8 bd fc ff ff       	call   80106530 <argint>
80106873:	83 c4 10             	add    $0x10,%esp
80106876:	85 c0                	test   %eax,%eax
80106878:	78 36                	js     801068b0 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010687a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010687e:	77 30                	ja     801068b0 <sys_dup+0x50>
80106880:	e8 bb ec ff ff       	call   80105540 <myproc>
80106885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106888:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010688c:	85 f6                	test   %esi,%esi
8010688e:	74 20                	je     801068b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106890:	e8 ab ec ff ff       	call   80105540 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106895:	31 db                	xor    %ebx,%ebx
80106897:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010689e:	00 
8010689f:	90                   	nop
    if (curproc->ofile[fd] == 0)
801068a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801068a4:	85 d2                	test   %edx,%edx
801068a6:	74 18                	je     801068c0 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
801068a8:	83 c3 01             	add    $0x1,%ebx
801068ab:	83 fb 10             	cmp    $0x10,%ebx
801068ae:	75 f0                	jne    801068a0 <sys_dup+0x40>
}
801068b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801068b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801068b8:	89 d8                	mov    %ebx,%eax
801068ba:	5b                   	pop    %ebx
801068bb:	5e                   	pop    %esi
801068bc:	5d                   	pop    %ebp
801068bd:	c3                   	ret
801068be:	66 90                	xchg   %ax,%ax
  filedup(f);
801068c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801068c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801068c7:	56                   	push   %esi
801068c8:	e8 d3 c1 ff ff       	call   80102aa0 <filedup>
  return fd;
801068cd:	83 c4 10             	add    $0x10,%esp
}
801068d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068d3:	89 d8                	mov    %ebx,%eax
801068d5:	5b                   	pop    %ebx
801068d6:	5e                   	pop    %esi
801068d7:	5d                   	pop    %ebp
801068d8:	c3                   	ret
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068e0 <sys_read>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	56                   	push   %esi
801068e4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801068e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801068e8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801068eb:	53                   	push   %ebx
801068ec:	6a 00                	push   $0x0
801068ee:	e8 3d fc ff ff       	call   80106530 <argint>
801068f3:	83 c4 10             	add    $0x10,%esp
801068f6:	85 c0                	test   %eax,%eax
801068f8:	78 5e                	js     80106958 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801068fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801068fe:	77 58                	ja     80106958 <sys_read+0x78>
80106900:	e8 3b ec ff ff       	call   80105540 <myproc>
80106905:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106908:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010690c:	85 f6                	test   %esi,%esi
8010690e:	74 48                	je     80106958 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106910:	83 ec 08             	sub    $0x8,%esp
80106913:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106916:	50                   	push   %eax
80106917:	6a 02                	push   $0x2
80106919:	e8 12 fc ff ff       	call   80106530 <argint>
8010691e:	83 c4 10             	add    $0x10,%esp
80106921:	85 c0                	test   %eax,%eax
80106923:	78 33                	js     80106958 <sys_read+0x78>
80106925:	83 ec 04             	sub    $0x4,%esp
80106928:	ff 75 f0             	push   -0x10(%ebp)
8010692b:	53                   	push   %ebx
8010692c:	6a 01                	push   $0x1
8010692e:	e8 4d fc ff ff       	call   80106580 <argptr>
80106933:	83 c4 10             	add    $0x10,%esp
80106936:	85 c0                	test   %eax,%eax
80106938:	78 1e                	js     80106958 <sys_read+0x78>
  return fileread(f, p, n);
8010693a:	83 ec 04             	sub    $0x4,%esp
8010693d:	ff 75 f0             	push   -0x10(%ebp)
80106940:	ff 75 f4             	push   -0xc(%ebp)
80106943:	56                   	push   %esi
80106944:	e8 d7 c2 ff ff       	call   80102c20 <fileread>
80106949:	83 c4 10             	add    $0x10,%esp
}
8010694c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010694f:	5b                   	pop    %ebx
80106950:	5e                   	pop    %esi
80106951:	5d                   	pop    %ebp
80106952:	c3                   	ret
80106953:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695d:	eb ed                	jmp    8010694c <sys_read+0x6c>
8010695f:	90                   	nop

80106960 <sys_write>:
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	56                   	push   %esi
80106964:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106965:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106968:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010696b:	53                   	push   %ebx
8010696c:	6a 00                	push   $0x0
8010696e:	e8 bd fb ff ff       	call   80106530 <argint>
80106973:	83 c4 10             	add    $0x10,%esp
80106976:	85 c0                	test   %eax,%eax
80106978:	78 5e                	js     801069d8 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010697a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010697e:	77 58                	ja     801069d8 <sys_write+0x78>
80106980:	e8 bb eb ff ff       	call   80105540 <myproc>
80106985:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106988:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010698c:	85 f6                	test   %esi,%esi
8010698e:	74 48                	je     801069d8 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106990:	83 ec 08             	sub    $0x8,%esp
80106993:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106996:	50                   	push   %eax
80106997:	6a 02                	push   $0x2
80106999:	e8 92 fb ff ff       	call   80106530 <argint>
8010699e:	83 c4 10             	add    $0x10,%esp
801069a1:	85 c0                	test   %eax,%eax
801069a3:	78 33                	js     801069d8 <sys_write+0x78>
801069a5:	83 ec 04             	sub    $0x4,%esp
801069a8:	ff 75 f0             	push   -0x10(%ebp)
801069ab:	53                   	push   %ebx
801069ac:	6a 01                	push   $0x1
801069ae:	e8 cd fb ff ff       	call   80106580 <argptr>
801069b3:	83 c4 10             	add    $0x10,%esp
801069b6:	85 c0                	test   %eax,%eax
801069b8:	78 1e                	js     801069d8 <sys_write+0x78>
  return filewrite(f, p, n);
801069ba:	83 ec 04             	sub    $0x4,%esp
801069bd:	ff 75 f0             	push   -0x10(%ebp)
801069c0:	ff 75 f4             	push   -0xc(%ebp)
801069c3:	56                   	push   %esi
801069c4:	e8 e7 c2 ff ff       	call   80102cb0 <filewrite>
801069c9:	83 c4 10             	add    $0x10,%esp
}
801069cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069cf:	5b                   	pop    %ebx
801069d0:	5e                   	pop    %esi
801069d1:	5d                   	pop    %ebp
801069d2:	c3                   	ret
801069d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801069d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069dd:	eb ed                	jmp    801069cc <sys_write+0x6c>
801069df:	90                   	nop

801069e0 <sys_close>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	56                   	push   %esi
801069e4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801069e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069e8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801069eb:	50                   	push   %eax
801069ec:	6a 00                	push   $0x0
801069ee:	e8 3d fb ff ff       	call   80106530 <argint>
801069f3:	83 c4 10             	add    $0x10,%esp
801069f6:	85 c0                	test   %eax,%eax
801069f8:	78 3e                	js     80106a38 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801069fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801069fe:	77 38                	ja     80106a38 <sys_close+0x58>
80106a00:	e8 3b eb ff ff       	call   80105540 <myproc>
80106a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a08:	8d 5a 08             	lea    0x8(%edx),%ebx
80106a0b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106a0f:	85 f6                	test   %esi,%esi
80106a11:	74 25                	je     80106a38 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106a13:	e8 28 eb ff ff       	call   80105540 <myproc>
  fileclose(f);
80106a18:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106a1b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106a22:	00 
  fileclose(f);
80106a23:	56                   	push   %esi
80106a24:	e8 c7 c0 ff ff       	call   80102af0 <fileclose>
  return 0;
80106a29:	83 c4 10             	add    $0x10,%esp
80106a2c:	31 c0                	xor    %eax,%eax
}
80106a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a31:	5b                   	pop    %ebx
80106a32:	5e                   	pop    %esi
80106a33:	5d                   	pop    %ebp
80106a34:	c3                   	ret
80106a35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3d:	eb ef                	jmp    80106a2e <sys_close+0x4e>
80106a3f:	90                   	nop

80106a40 <sys_fstat>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	56                   	push   %esi
80106a44:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106a45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106a48:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106a4b:	53                   	push   %ebx
80106a4c:	6a 00                	push   $0x0
80106a4e:	e8 dd fa ff ff       	call   80106530 <argint>
80106a53:	83 c4 10             	add    $0x10,%esp
80106a56:	85 c0                	test   %eax,%eax
80106a58:	78 46                	js     80106aa0 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106a5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a5e:	77 40                	ja     80106aa0 <sys_fstat+0x60>
80106a60:	e8 db ea ff ff       	call   80105540 <myproc>
80106a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a6c:	85 f6                	test   %esi,%esi
80106a6e:	74 30                	je     80106aa0 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80106a70:	83 ec 04             	sub    $0x4,%esp
80106a73:	6a 14                	push   $0x14
80106a75:	53                   	push   %ebx
80106a76:	6a 01                	push   $0x1
80106a78:	e8 03 fb ff ff       	call   80106580 <argptr>
80106a7d:	83 c4 10             	add    $0x10,%esp
80106a80:	85 c0                	test   %eax,%eax
80106a82:	78 1c                	js     80106aa0 <sys_fstat+0x60>
  return filestat(f, st);
80106a84:	83 ec 08             	sub    $0x8,%esp
80106a87:	ff 75 f4             	push   -0xc(%ebp)
80106a8a:	56                   	push   %esi
80106a8b:	e8 40 c1 ff ff       	call   80102bd0 <filestat>
80106a90:	83 c4 10             	add    $0x10,%esp
}
80106a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a96:	5b                   	pop    %ebx
80106a97:	5e                   	pop    %esi
80106a98:	5d                   	pop    %ebp
80106a99:	c3                   	ret
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa5:	eb ec                	jmp    80106a93 <sys_fstat+0x53>
80106aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106aae:	00 
80106aaf:	90                   	nop

80106ab0 <sys_link>:
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106ab5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106ab8:	53                   	push   %ebx
80106ab9:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106abc:	50                   	push   %eax
80106abd:	6a 00                	push   $0x0
80106abf:	e8 2c fb ff ff       	call   801065f0 <argstr>
80106ac4:	83 c4 10             	add    $0x10,%esp
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	0f 88 fb 00 00 00    	js     80106bca <sys_link+0x11a>
80106acf:	83 ec 08             	sub    $0x8,%esp
80106ad2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106ad5:	50                   	push   %eax
80106ad6:	6a 01                	push   $0x1
80106ad8:	e8 13 fb ff ff       	call   801065f0 <argstr>
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	85 c0                	test   %eax,%eax
80106ae2:	0f 88 e2 00 00 00    	js     80106bca <sys_link+0x11a>
  begin_op();
80106ae8:	e8 33 de ff ff       	call   80104920 <begin_op>
  if ((ip = namei(old)) == 0)
80106aed:	83 ec 0c             	sub    $0xc,%esp
80106af0:	ff 75 d4             	push   -0x2c(%ebp)
80106af3:	e8 68 d1 ff ff       	call   80103c60 <namei>
80106af8:	83 c4 10             	add    $0x10,%esp
80106afb:	89 c3                	mov    %eax,%ebx
80106afd:	85 c0                	test   %eax,%eax
80106aff:	0f 84 df 00 00 00    	je     80106be4 <sys_link+0x134>
  ilock(ip);
80106b05:	83 ec 0c             	sub    $0xc,%esp
80106b08:	50                   	push   %eax
80106b09:	e8 72 c8 ff ff       	call   80103380 <ilock>
  if (ip->type == T_DIR)
80106b0e:	83 c4 10             	add    $0x10,%esp
80106b11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106b16:	0f 84 b5 00 00 00    	je     80106bd1 <sys_link+0x121>
  iupdate(ip);
80106b1c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106b1f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80106b24:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106b27:	53                   	push   %ebx
80106b28:	e8 a3 c7 ff ff       	call   801032d0 <iupdate>
  iunlock(ip);
80106b2d:	89 1c 24             	mov    %ebx,(%esp)
80106b30:	e8 2b c9 ff ff       	call   80103460 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80106b35:	58                   	pop    %eax
80106b36:	5a                   	pop    %edx
80106b37:	57                   	push   %edi
80106b38:	ff 75 d0             	push   -0x30(%ebp)
80106b3b:	e8 40 d1 ff ff       	call   80103c80 <nameiparent>
80106b40:	83 c4 10             	add    $0x10,%esp
80106b43:	89 c6                	mov    %eax,%esi
80106b45:	85 c0                	test   %eax,%eax
80106b47:	74 5b                	je     80106ba4 <sys_link+0xf4>
  ilock(dp);
80106b49:	83 ec 0c             	sub    $0xc,%esp
80106b4c:	50                   	push   %eax
80106b4d:	e8 2e c8 ff ff       	call   80103380 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80106b52:	8b 03                	mov    (%ebx),%eax
80106b54:	83 c4 10             	add    $0x10,%esp
80106b57:	39 06                	cmp    %eax,(%esi)
80106b59:	75 3d                	jne    80106b98 <sys_link+0xe8>
80106b5b:	83 ec 04             	sub    $0x4,%esp
80106b5e:	ff 73 04             	push   0x4(%ebx)
80106b61:	57                   	push   %edi
80106b62:	56                   	push   %esi
80106b63:	e8 38 d0 ff ff       	call   80103ba0 <dirlink>
80106b68:	83 c4 10             	add    $0x10,%esp
80106b6b:	85 c0                	test   %eax,%eax
80106b6d:	78 29                	js     80106b98 <sys_link+0xe8>
  iunlockput(dp);
80106b6f:	83 ec 0c             	sub    $0xc,%esp
80106b72:	56                   	push   %esi
80106b73:	e8 98 ca ff ff       	call   80103610 <iunlockput>
  iput(ip);
80106b78:	89 1c 24             	mov    %ebx,(%esp)
80106b7b:	e8 30 c9 ff ff       	call   801034b0 <iput>
  end_op();
80106b80:	e8 0b de ff ff       	call   80104990 <end_op>
  return 0;
80106b85:	83 c4 10             	add    $0x10,%esp
80106b88:	31 c0                	xor    %eax,%eax
}
80106b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b8d:	5b                   	pop    %ebx
80106b8e:	5e                   	pop    %esi
80106b8f:	5f                   	pop    %edi
80106b90:	5d                   	pop    %ebp
80106b91:	c3                   	ret
80106b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106b98:	83 ec 0c             	sub    $0xc,%esp
80106b9b:	56                   	push   %esi
80106b9c:	e8 6f ca ff ff       	call   80103610 <iunlockput>
    goto bad;
80106ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106ba4:	83 ec 0c             	sub    $0xc,%esp
80106ba7:	53                   	push   %ebx
80106ba8:	e8 d3 c7 ff ff       	call   80103380 <ilock>
  ip->nlink--;
80106bad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106bb2:	89 1c 24             	mov    %ebx,(%esp)
80106bb5:	e8 16 c7 ff ff       	call   801032d0 <iupdate>
  iunlockput(ip);
80106bba:	89 1c 24             	mov    %ebx,(%esp)
80106bbd:	e8 4e ca ff ff       	call   80103610 <iunlockput>
  end_op();
80106bc2:	e8 c9 dd ff ff       	call   80104990 <end_op>
  return -1;
80106bc7:	83 c4 10             	add    $0x10,%esp
    return -1;
80106bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bcf:	eb b9                	jmp    80106b8a <sys_link+0xda>
    iunlockput(ip);
80106bd1:	83 ec 0c             	sub    $0xc,%esp
80106bd4:	53                   	push   %ebx
80106bd5:	e8 36 ca ff ff       	call   80103610 <iunlockput>
    end_op();
80106bda:	e8 b1 dd ff ff       	call   80104990 <end_op>
    return -1;
80106bdf:	83 c4 10             	add    $0x10,%esp
80106be2:	eb e6                	jmp    80106bca <sys_link+0x11a>
    end_op();
80106be4:	e8 a7 dd ff ff       	call   80104990 <end_op>
    return -1;
80106be9:	eb df                	jmp    80106bca <sys_link+0x11a>
80106beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106bf0 <sys_unlink>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80106bf5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106bf8:	53                   	push   %ebx
80106bf9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80106bfc:	50                   	push   %eax
80106bfd:	6a 00                	push   $0x0
80106bff:	e8 ec f9 ff ff       	call   801065f0 <argstr>
80106c04:	83 c4 10             	add    $0x10,%esp
80106c07:	85 c0                	test   %eax,%eax
80106c09:	0f 88 54 01 00 00    	js     80106d63 <sys_unlink+0x173>
  begin_op();
80106c0f:	e8 0c dd ff ff       	call   80104920 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80106c14:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106c17:	83 ec 08             	sub    $0x8,%esp
80106c1a:	53                   	push   %ebx
80106c1b:	ff 75 c0             	push   -0x40(%ebp)
80106c1e:	e8 5d d0 ff ff       	call   80103c80 <nameiparent>
80106c23:	83 c4 10             	add    $0x10,%esp
80106c26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106c29:	85 c0                	test   %eax,%eax
80106c2b:	0f 84 58 01 00 00    	je     80106d89 <sys_unlink+0x199>
  ilock(dp);
80106c31:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106c34:	83 ec 0c             	sub    $0xc,%esp
80106c37:	57                   	push   %edi
80106c38:	e8 43 c7 ff ff       	call   80103380 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106c3d:	58                   	pop    %eax
80106c3e:	5a                   	pop    %edx
80106c3f:	68 45 93 10 80       	push   $0x80109345
80106c44:	53                   	push   %ebx
80106c45:	e8 66 cc ff ff       	call   801038b0 <namecmp>
80106c4a:	83 c4 10             	add    $0x10,%esp
80106c4d:	85 c0                	test   %eax,%eax
80106c4f:	0f 84 fb 00 00 00    	je     80106d50 <sys_unlink+0x160>
80106c55:	83 ec 08             	sub    $0x8,%esp
80106c58:	68 44 93 10 80       	push   $0x80109344
80106c5d:	53                   	push   %ebx
80106c5e:	e8 4d cc ff ff       	call   801038b0 <namecmp>
80106c63:	83 c4 10             	add    $0x10,%esp
80106c66:	85 c0                	test   %eax,%eax
80106c68:	0f 84 e2 00 00 00    	je     80106d50 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80106c6e:	83 ec 04             	sub    $0x4,%esp
80106c71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106c74:	50                   	push   %eax
80106c75:	53                   	push   %ebx
80106c76:	57                   	push   %edi
80106c77:	e8 54 cc ff ff       	call   801038d0 <dirlookup>
80106c7c:	83 c4 10             	add    $0x10,%esp
80106c7f:	89 c3                	mov    %eax,%ebx
80106c81:	85 c0                	test   %eax,%eax
80106c83:	0f 84 c7 00 00 00    	je     80106d50 <sys_unlink+0x160>
  ilock(ip);
80106c89:	83 ec 0c             	sub    $0xc,%esp
80106c8c:	50                   	push   %eax
80106c8d:	e8 ee c6 ff ff       	call   80103380 <ilock>
  if (ip->nlink < 1)
80106c92:	83 c4 10             	add    $0x10,%esp
80106c95:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106c9a:	0f 8e 0a 01 00 00    	jle    80106daa <sys_unlink+0x1ba>
  if (ip->type == T_DIR && !isdirempty(ip))
80106ca0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106ca5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106ca8:	74 66                	je     80106d10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106caa:	83 ec 04             	sub    $0x4,%esp
80106cad:	6a 10                	push   $0x10
80106caf:	6a 00                	push   $0x0
80106cb1:	57                   	push   %edi
80106cb2:	e8 c9 f5 ff ff       	call   80106280 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80106cb7:	6a 10                	push   $0x10
80106cb9:	ff 75 c4             	push   -0x3c(%ebp)
80106cbc:	57                   	push   %edi
80106cbd:	ff 75 b4             	push   -0x4c(%ebp)
80106cc0:	e8 cb ca ff ff       	call   80103790 <writei>
80106cc5:	83 c4 20             	add    $0x20,%esp
80106cc8:	83 f8 10             	cmp    $0x10,%eax
80106ccb:	0f 85 cc 00 00 00    	jne    80106d9d <sys_unlink+0x1ad>
  if (ip->type == T_DIR)
80106cd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106cd6:	0f 84 94 00 00 00    	je     80106d70 <sys_unlink+0x180>
  iunlockput(dp);
80106cdc:	83 ec 0c             	sub    $0xc,%esp
80106cdf:	ff 75 b4             	push   -0x4c(%ebp)
80106ce2:	e8 29 c9 ff ff       	call   80103610 <iunlockput>
  ip->nlink--;
80106ce7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106cec:	89 1c 24             	mov    %ebx,(%esp)
80106cef:	e8 dc c5 ff ff       	call   801032d0 <iupdate>
  iunlockput(ip);
80106cf4:	89 1c 24             	mov    %ebx,(%esp)
80106cf7:	e8 14 c9 ff ff       	call   80103610 <iunlockput>
  end_op();
80106cfc:	e8 8f dc ff ff       	call   80104990 <end_op>
  return 0;
80106d01:	83 c4 10             	add    $0x10,%esp
80106d04:	31 c0                	xor    %eax,%eax
}
80106d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d09:	5b                   	pop    %ebx
80106d0a:	5e                   	pop    %esi
80106d0b:	5f                   	pop    %edi
80106d0c:	5d                   	pop    %ebp
80106d0d:	c3                   	ret
80106d0e:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80106d10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106d14:	76 94                	jbe    80106caa <sys_unlink+0xba>
80106d16:	be 20 00 00 00       	mov    $0x20,%esi
80106d1b:	eb 0b                	jmp    80106d28 <sys_unlink+0x138>
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi
80106d20:	83 c6 10             	add    $0x10,%esi
80106d23:	3b 73 58             	cmp    0x58(%ebx),%esi
80106d26:	73 82                	jae    80106caa <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80106d28:	6a 10                	push   $0x10
80106d2a:	56                   	push   %esi
80106d2b:	57                   	push   %edi
80106d2c:	53                   	push   %ebx
80106d2d:	e8 5e c9 ff ff       	call   80103690 <readi>
80106d32:	83 c4 10             	add    $0x10,%esp
80106d35:	83 f8 10             	cmp    $0x10,%eax
80106d38:	75 56                	jne    80106d90 <sys_unlink+0x1a0>
    if (de.inum != 0)
80106d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106d3f:	74 df                	je     80106d20 <sys_unlink+0x130>
    iunlockput(ip);
80106d41:	83 ec 0c             	sub    $0xc,%esp
80106d44:	53                   	push   %ebx
80106d45:	e8 c6 c8 ff ff       	call   80103610 <iunlockput>
    goto bad;
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106d50:	83 ec 0c             	sub    $0xc,%esp
80106d53:	ff 75 b4             	push   -0x4c(%ebp)
80106d56:	e8 b5 c8 ff ff       	call   80103610 <iunlockput>
  end_op();
80106d5b:	e8 30 dc ff ff       	call   80104990 <end_op>
  return -1;
80106d60:	83 c4 10             	add    $0x10,%esp
    return -1;
80106d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d68:	eb 9c                	jmp    80106d06 <sys_unlink+0x116>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106d70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106d73:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106d76:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106d7b:	50                   	push   %eax
80106d7c:	e8 4f c5 ff ff       	call   801032d0 <iupdate>
80106d81:	83 c4 10             	add    $0x10,%esp
80106d84:	e9 53 ff ff ff       	jmp    80106cdc <sys_unlink+0xec>
    end_op();
80106d89:	e8 02 dc ff ff       	call   80104990 <end_op>
    return -1;
80106d8e:	eb d3                	jmp    80106d63 <sys_unlink+0x173>
      panic("isdirempty: readi");
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	68 69 93 10 80       	push   $0x80109369
80106d98:	e8 e3 95 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80106d9d:	83 ec 0c             	sub    $0xc,%esp
80106da0:	68 7b 93 10 80       	push   $0x8010937b
80106da5:	e8 d6 95 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80106daa:	83 ec 0c             	sub    $0xc,%esp
80106dad:	68 57 93 10 80       	push   $0x80109357
80106db2:	e8 c9 95 ff ff       	call   80100380 <panic>
80106db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dbe:	00 
80106dbf:	90                   	nop

80106dc0 <sys_open>:

int sys_open(void)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106dc5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106dc8:	53                   	push   %ebx
80106dc9:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106dcc:	50                   	push   %eax
80106dcd:	6a 00                	push   $0x0
80106dcf:	e8 1c f8 ff ff       	call   801065f0 <argstr>
80106dd4:	83 c4 10             	add    $0x10,%esp
80106dd7:	85 c0                	test   %eax,%eax
80106dd9:	0f 88 8e 00 00 00    	js     80106e6d <sys_open+0xad>
80106ddf:	83 ec 08             	sub    $0x8,%esp
80106de2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106de5:	50                   	push   %eax
80106de6:	6a 01                	push   $0x1
80106de8:	e8 43 f7 ff ff       	call   80106530 <argint>
80106ded:	83 c4 10             	add    $0x10,%esp
80106df0:	85 c0                	test   %eax,%eax
80106df2:	78 79                	js     80106e6d <sys_open+0xad>
    return -1;

  begin_op();
80106df4:	e8 27 db ff ff       	call   80104920 <begin_op>

  if (omode & O_CREATE)
80106df9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106dfd:	75 79                	jne    80106e78 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80106dff:	83 ec 0c             	sub    $0xc,%esp
80106e02:	ff 75 e0             	push   -0x20(%ebp)
80106e05:	e8 56 ce ff ff       	call   80103c60 <namei>
80106e0a:	83 c4 10             	add    $0x10,%esp
80106e0d:	89 c6                	mov    %eax,%esi
80106e0f:	85 c0                	test   %eax,%eax
80106e11:	0f 84 7e 00 00 00    	je     80106e95 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80106e17:	83 ec 0c             	sub    $0xc,%esp
80106e1a:	50                   	push   %eax
80106e1b:	e8 60 c5 ff ff       	call   80103380 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80106e20:	83 c4 10             	add    $0x10,%esp
80106e23:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106e28:	0f 84 ba 00 00 00    	je     80106ee8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80106e2e:	e8 fd bb ff ff       	call   80102a30 <filealloc>
80106e33:	89 c7                	mov    %eax,%edi
80106e35:	85 c0                	test   %eax,%eax
80106e37:	74 23                	je     80106e5c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106e39:	e8 02 e7 ff ff       	call   80105540 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106e3e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80106e40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106e44:	85 d2                	test   %edx,%edx
80106e46:	74 58                	je     80106ea0 <sys_open+0xe0>
  for (fd = 0; fd < NOFILE; fd++)
80106e48:	83 c3 01             	add    $0x1,%ebx
80106e4b:	83 fb 10             	cmp    $0x10,%ebx
80106e4e:	75 f0                	jne    80106e40 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	57                   	push   %edi
80106e54:	e8 97 bc ff ff       	call   80102af0 <fileclose>
80106e59:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106e5c:	83 ec 0c             	sub    $0xc,%esp
80106e5f:	56                   	push   %esi
80106e60:	e8 ab c7 ff ff       	call   80103610 <iunlockput>
    end_op();
80106e65:	e8 26 db ff ff       	call   80104990 <end_op>
    return -1;
80106e6a:	83 c4 10             	add    $0x10,%esp
    return -1;
80106e6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106e72:	eb 65                	jmp    80106ed9 <sys_open+0x119>
80106e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106e78:	83 ec 0c             	sub    $0xc,%esp
80106e7b:	31 c9                	xor    %ecx,%ecx
80106e7d:	ba 02 00 00 00       	mov    $0x2,%edx
80106e82:	6a 00                	push   $0x0
80106e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e87:	e8 54 f8 ff ff       	call   801066e0 <create>
    if (ip == 0)
80106e8c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106e8f:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80106e91:	85 c0                	test   %eax,%eax
80106e93:	75 99                	jne    80106e2e <sys_open+0x6e>
      end_op();
80106e95:	e8 f6 da ff ff       	call   80104990 <end_op>
      return -1;
80106e9a:	eb d1                	jmp    80106e6d <sys_open+0xad>
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106ea0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106ea3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106ea7:	56                   	push   %esi
80106ea8:	e8 b3 c5 ff ff       	call   80103460 <iunlock>
  end_op();
80106ead:	e8 de da ff ff       	call   80104990 <end_op>

  f->type = FD_INODE;
80106eb2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ebb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106ebe:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106ec1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106ec3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106eca:	f7 d0                	not    %eax
80106ecc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ecf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106ed2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ed5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106edc:	89 d8                	mov    %ebx,%eax
80106ede:	5b                   	pop    %ebx
80106edf:	5e                   	pop    %esi
80106ee0:	5f                   	pop    %edi
80106ee1:	5d                   	pop    %ebp
80106ee2:	c3                   	ret
80106ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (ip->type == T_DIR && omode != O_RDONLY)
80106ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106eeb:	85 c9                	test   %ecx,%ecx
80106eed:	0f 84 3b ff ff ff    	je     80106e2e <sys_open+0x6e>
80106ef3:	e9 64 ff ff ff       	jmp    80106e5c <sys_open+0x9c>
80106ef8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eff:	00 

80106f00 <sys_mkdir>:

int sys_mkdir(void)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106f06:	e8 15 da ff ff       	call   80104920 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80106f0b:	83 ec 08             	sub    $0x8,%esp
80106f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f11:	50                   	push   %eax
80106f12:	6a 00                	push   $0x0
80106f14:	e8 d7 f6 ff ff       	call   801065f0 <argstr>
80106f19:	83 c4 10             	add    $0x10,%esp
80106f1c:	85 c0                	test   %eax,%eax
80106f1e:	78 30                	js     80106f50 <sys_mkdir+0x50>
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f26:	31 c9                	xor    %ecx,%ecx
80106f28:	ba 01 00 00 00       	mov    $0x1,%edx
80106f2d:	6a 00                	push   $0x0
80106f2f:	e8 ac f7 ff ff       	call   801066e0 <create>
80106f34:	83 c4 10             	add    $0x10,%esp
80106f37:	85 c0                	test   %eax,%eax
80106f39:	74 15                	je     80106f50 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80106f3b:	83 ec 0c             	sub    $0xc,%esp
80106f3e:	50                   	push   %eax
80106f3f:	e8 cc c6 ff ff       	call   80103610 <iunlockput>
  end_op();
80106f44:	e8 47 da ff ff       	call   80104990 <end_op>
  return 0;
80106f49:	83 c4 10             	add    $0x10,%esp
80106f4c:	31 c0                	xor    %eax,%eax
}
80106f4e:	c9                   	leave
80106f4f:	c3                   	ret
    end_op();
80106f50:	e8 3b da ff ff       	call   80104990 <end_op>
    return -1;
80106f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f5a:	c9                   	leave
80106f5b:	c3                   	ret
80106f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f60 <sys_mknod>:

int sys_mknod(void)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106f66:	e8 b5 d9 ff ff       	call   80104920 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80106f6b:	83 ec 08             	sub    $0x8,%esp
80106f6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106f71:	50                   	push   %eax
80106f72:	6a 00                	push   $0x0
80106f74:	e8 77 f6 ff ff       	call   801065f0 <argstr>
80106f79:	83 c4 10             	add    $0x10,%esp
80106f7c:	85 c0                	test   %eax,%eax
80106f7e:	78 60                	js     80106fe0 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80106f80:	83 ec 08             	sub    $0x8,%esp
80106f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f86:	50                   	push   %eax
80106f87:	6a 01                	push   $0x1
80106f89:	e8 a2 f5 ff ff       	call   80106530 <argint>
  if ((argstr(0, &path)) < 0 ||
80106f8e:	83 c4 10             	add    $0x10,%esp
80106f91:	85 c0                	test   %eax,%eax
80106f93:	78 4b                	js     80106fe0 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80106f95:	83 ec 08             	sub    $0x8,%esp
80106f98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f9b:	50                   	push   %eax
80106f9c:	6a 02                	push   $0x2
80106f9e:	e8 8d f5 ff ff       	call   80106530 <argint>
      argint(1, &major) < 0 ||
80106fa3:	83 c4 10             	add    $0x10,%esp
80106fa6:	85 c0                	test   %eax,%eax
80106fa8:	78 36                	js     80106fe0 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80106faa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106fae:	83 ec 0c             	sub    $0xc,%esp
80106fb1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106fb5:	ba 03 00 00 00       	mov    $0x3,%edx
80106fba:	50                   	push   %eax
80106fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106fbe:	e8 1d f7 ff ff       	call   801066e0 <create>
      argint(2, &minor) < 0 ||
80106fc3:	83 c4 10             	add    $0x10,%esp
80106fc6:	85 c0                	test   %eax,%eax
80106fc8:	74 16                	je     80106fe0 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80106fca:	83 ec 0c             	sub    $0xc,%esp
80106fcd:	50                   	push   %eax
80106fce:	e8 3d c6 ff ff       	call   80103610 <iunlockput>
  end_op();
80106fd3:	e8 b8 d9 ff ff       	call   80104990 <end_op>
  return 0;
80106fd8:	83 c4 10             	add    $0x10,%esp
80106fdb:	31 c0                	xor    %eax,%eax
}
80106fdd:	c9                   	leave
80106fde:	c3                   	ret
80106fdf:	90                   	nop
    end_op();
80106fe0:	e8 ab d9 ff ff       	call   80104990 <end_op>
    return -1;
80106fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fea:	c9                   	leave
80106feb:	c3                   	ret
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <sys_chdir>:

int sys_chdir(void)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	56                   	push   %esi
80106ff4:	53                   	push   %ebx
80106ff5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106ff8:	e8 43 e5 ff ff       	call   80105540 <myproc>
80106ffd:	89 c6                	mov    %eax,%esi

  begin_op();
80106fff:	e8 1c d9 ff ff       	call   80104920 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80107004:	83 ec 08             	sub    $0x8,%esp
80107007:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010700a:	50                   	push   %eax
8010700b:	6a 00                	push   $0x0
8010700d:	e8 de f5 ff ff       	call   801065f0 <argstr>
80107012:	83 c4 10             	add    $0x10,%esp
80107015:	85 c0                	test   %eax,%eax
80107017:	78 77                	js     80107090 <sys_chdir+0xa0>
80107019:	83 ec 0c             	sub    $0xc,%esp
8010701c:	ff 75 f4             	push   -0xc(%ebp)
8010701f:	e8 3c cc ff ff       	call   80103c60 <namei>
80107024:	83 c4 10             	add    $0x10,%esp
80107027:	89 c3                	mov    %eax,%ebx
80107029:	85 c0                	test   %eax,%eax
8010702b:	74 63                	je     80107090 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
8010702d:	83 ec 0c             	sub    $0xc,%esp
80107030:	50                   	push   %eax
80107031:	e8 4a c3 ff ff       	call   80103380 <ilock>
  if (ip->type != T_DIR)
80107036:	83 c4 10             	add    $0x10,%esp
80107039:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010703e:	75 30                	jne    80107070 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	53                   	push   %ebx
80107044:	e8 17 c4 ff ff       	call   80103460 <iunlock>
  iput(curproc->cwd);
80107049:	58                   	pop    %eax
8010704a:	ff 76 68             	push   0x68(%esi)
8010704d:	e8 5e c4 ff ff       	call   801034b0 <iput>
  end_op();
80107052:	e8 39 d9 ff ff       	call   80104990 <end_op>
  curproc->cwd = ip;
80107057:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010705a:	83 c4 10             	add    $0x10,%esp
8010705d:	31 c0                	xor    %eax,%eax
}
8010705f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107062:	5b                   	pop    %ebx
80107063:	5e                   	pop    %esi
80107064:	5d                   	pop    %ebp
80107065:	c3                   	ret
80107066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706d:	00 
8010706e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80107070:	83 ec 0c             	sub    $0xc,%esp
80107073:	53                   	push   %ebx
80107074:	e8 97 c5 ff ff       	call   80103610 <iunlockput>
    end_op();
80107079:	e8 12 d9 ff ff       	call   80104990 <end_op>
    return -1;
8010707e:	83 c4 10             	add    $0x10,%esp
    return -1;
80107081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107086:	eb d7                	jmp    8010705f <sys_chdir+0x6f>
80107088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010708f:	00 
    end_op();
80107090:	e8 fb d8 ff ff       	call   80104990 <end_op>
    return -1;
80107095:	eb ea                	jmp    80107081 <sys_chdir+0x91>
80107097:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010709e:	00 
8010709f:	90                   	nop

801070a0 <sys_exec>:

int sys_exec(void)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
801070a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801070ab:	53                   	push   %ebx
801070ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
801070b2:	50                   	push   %eax
801070b3:	6a 00                	push   $0x0
801070b5:	e8 36 f5 ff ff       	call   801065f0 <argstr>
801070ba:	83 c4 10             	add    $0x10,%esp
801070bd:	85 c0                	test   %eax,%eax
801070bf:	0f 88 87 00 00 00    	js     8010714c <sys_exec+0xac>
801070c5:	83 ec 08             	sub    $0x8,%esp
801070c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801070ce:	50                   	push   %eax
801070cf:	6a 01                	push   $0x1
801070d1:	e8 5a f4 ff ff       	call   80106530 <argint>
801070d6:	83 c4 10             	add    $0x10,%esp
801070d9:	85 c0                	test   %eax,%eax
801070db:	78 6f                	js     8010714c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801070dd:	83 ec 04             	sub    $0x4,%esp
801070e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
801070e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801070e8:	68 80 00 00 00       	push   $0x80
801070ed:	6a 00                	push   $0x0
801070ef:	56                   	push   %esi
801070f0:	e8 8b f1 ff ff       	call   80106280 <memset>
801070f5:	83 c4 10             	add    $0x10,%esp
801070f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ff:	00 
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80107100:	83 ec 08             	sub    $0x8,%esp
80107103:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107109:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80107110:	50                   	push   %eax
80107111:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80107117:	01 f8                	add    %edi,%eax
80107119:	50                   	push   %eax
8010711a:	e8 81 f3 ff ff       	call   801064a0 <fetchint>
8010711f:	83 c4 10             	add    $0x10,%esp
80107122:	85 c0                	test   %eax,%eax
80107124:	78 26                	js     8010714c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80107126:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010712c:	85 c0                	test   %eax,%eax
8010712e:	74 30                	je     80107160 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80107130:	83 ec 08             	sub    $0x8,%esp
80107133:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80107136:	52                   	push   %edx
80107137:	50                   	push   %eax
80107138:	e8 a3 f3 ff ff       	call   801064e0 <fetchstr>
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	85 c0                	test   %eax,%eax
80107142:	78 08                	js     8010714c <sys_exec+0xac>
  for (i = 0;; i++)
80107144:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80107147:	83 fb 20             	cmp    $0x20,%ebx
8010714a:	75 b4                	jne    80107100 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010714c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010714f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107154:	5b                   	pop    %ebx
80107155:	5e                   	pop    %esi
80107156:	5f                   	pop    %edi
80107157:	5d                   	pop    %ebp
80107158:	c3                   	ret
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80107160:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80107167:	00 00 00 00 
  return exec(path, argv);
8010716b:	83 ec 08             	sub    $0x8,%esp
8010716e:	56                   	push   %esi
8010716f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80107175:	e8 16 b5 ff ff       	call   80102690 <exec>
8010717a:	83 c4 10             	add    $0x10,%esp
}
8010717d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107180:	5b                   	pop    %ebx
80107181:	5e                   	pop    %esi
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
80107184:	c3                   	ret
80107185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010718c:	00 
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <sys_pipe>:

int sys_pipe(void)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80107195:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80107198:	53                   	push   %ebx
80107199:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
8010719c:	6a 08                	push   $0x8
8010719e:	50                   	push   %eax
8010719f:	6a 00                	push   $0x0
801071a1:	e8 da f3 ff ff       	call   80106580 <argptr>
801071a6:	83 c4 10             	add    $0x10,%esp
801071a9:	85 c0                	test   %eax,%eax
801071ab:	0f 88 8b 00 00 00    	js     8010723c <sys_pipe+0xac>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
801071b1:	83 ec 08             	sub    $0x8,%esp
801071b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801071b7:	50                   	push   %eax
801071b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801071bb:	50                   	push   %eax
801071bc:	e8 2f de ff ff       	call   80104ff0 <pipealloc>
801071c1:	83 c4 10             	add    $0x10,%esp
801071c4:	85 c0                	test   %eax,%eax
801071c6:	78 74                	js     8010723c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
801071c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
801071cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801071cd:	e8 6e e3 ff ff       	call   80105540 <myproc>
    if (curproc->ofile[fd] == 0)
801071d2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801071d6:	85 f6                	test   %esi,%esi
801071d8:	74 16                	je     801071f0 <sys_pipe+0x60>
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (fd = 0; fd < NOFILE; fd++)
801071e0:	83 c3 01             	add    $0x1,%ebx
801071e3:	83 fb 10             	cmp    $0x10,%ebx
801071e6:	74 3d                	je     80107225 <sys_pipe+0x95>
    if (curproc->ofile[fd] == 0)
801071e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801071ec:	85 f6                	test   %esi,%esi
801071ee:	75 f0                	jne    801071e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801071f0:	8d 73 08             	lea    0x8(%ebx),%esi
801071f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
801071f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801071fa:	e8 41 e3 ff ff       	call   80105540 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801071ff:	31 d2                	xor    %edx,%edx
80107201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80107208:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010720c:	85 c9                	test   %ecx,%ecx
8010720e:	74 38                	je     80107248 <sys_pipe+0xb8>
  for (fd = 0; fd < NOFILE; fd++)
80107210:	83 c2 01             	add    $0x1,%edx
80107213:	83 fa 10             	cmp    $0x10,%edx
80107216:	75 f0                	jne    80107208 <sys_pipe+0x78>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80107218:	e8 23 e3 ff ff       	call   80105540 <myproc>
8010721d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107224:	00 
    fileclose(rf);
80107225:	83 ec 0c             	sub    $0xc,%esp
80107228:	ff 75 e0             	push   -0x20(%ebp)
8010722b:	e8 c0 b8 ff ff       	call   80102af0 <fileclose>
    fileclose(wf);
80107230:	58                   	pop    %eax
80107231:	ff 75 e4             	push   -0x1c(%ebp)
80107234:	e8 b7 b8 ff ff       	call   80102af0 <fileclose>
    return -1;
80107239:	83 c4 10             	add    $0x10,%esp
    return -1;
8010723c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107241:	eb 16                	jmp    80107259 <sys_pipe+0xc9>
80107243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80107248:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010724c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010724f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80107251:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107254:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80107257:	31 c0                	xor    %eax,%eax
}
80107259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010725c:	5b                   	pop    %ebx
8010725d:	5e                   	pop    %esi
8010725e:	5f                   	pop    %edi
8010725f:	5d                   	pop    %ebp
80107260:	c3                   	ret
80107261:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107268:	00 
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107270 <sys_make_duplicate>:

///////////////rashid


int sys_make_duplicate(void)
{
80107270:	55                   	push   %ebp
    char *src_name;
    char suffix[] = "_copy";
80107271:	b8 79 00 00 00       	mov    $0x79,%eax
{
80107276:	89 e5                	mov    %esp,%ebp
80107278:	57                   	push   %edi
80107279:	56                   	push   %esi
8010727a:	53                   	push   %ebx
8010727b:	81 ec b4 02 00 00    	sub    $0x2b4,%esp
    char suffix[] = "_copy";
80107281:	66 89 85 66 fd ff ff 	mov    %ax,-0x29a(%ebp)

    int n;
    char buf[512];


    if (argstr(0, &src_name) < 0)
80107288:	8d 85 5c fd ff ff    	lea    -0x2a4(%ebp),%eax
    char suffix[] = "_copy";
8010728e:	c7 85 62 fd ff ff 5f 	movl   $0x706f635f,-0x29e(%ebp)
80107295:	63 6f 70 
    if (argstr(0, &src_name) < 0)
80107298:	50                   	push   %eax
80107299:	6a 00                	push   $0x0
8010729b:	e8 50 f3 ff ff       	call   801065f0 <argstr>
801072a0:	83 c4 10             	add    $0x10,%esp
801072a3:	85 c0                	test   %eax,%eax
801072a5:	0f 88 4a 01 00 00    	js     801073f5 <sys_make_duplicate+0x185>
        return -1;

    int i = 0, j = 0;
    while (src_name[i] != '\0')
801072ab:	8b 8d 5c fd ff ff    	mov    -0x2a4(%ebp),%ecx
    int i = 0, j = 0;
801072b1:	31 c0                	xor    %eax,%eax
801072b3:	8d 9d 68 fd ff ff    	lea    -0x298(%ebp),%ebx
    while (src_name[i] != '\0')
801072b9:	0f b6 11             	movzbl (%ecx),%edx
801072bc:	84 d2                	test   %dl,%dl
801072be:	74 0e                	je     801072ce <sys_make_duplicate+0x5e>
    {    
     
        new_name[i] = src_name[i];
801072c0:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        i++;
801072c3:	83 c0 01             	add    $0x1,%eax
    while (src_name[i] != '\0')
801072c6:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801072ca:	84 d2                	test   %dl,%dl
801072cc:	75 f2                	jne    801072c0 <sys_make_duplicate+0x50>
    }
    while (suffix[j] != '\0')
801072ce:	8d 8d 62 fd ff ff    	lea    -0x29e(%ebp),%ecx
801072d4:	ba 5f 00 00 00       	mov    $0x5f,%edx
801072d9:	29 c1                	sub    %eax,%ecx
801072db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    
    {
      
        new_name[i] = suffix[j];
801072e0:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        i++;
801072e3:	83 c0 01             	add    $0x1,%eax
    while (suffix[j] != '\0')
801072e6:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801072ea:	84 d2                	test   %dl,%dl
801072ec:	75 f2                	jne    801072e0 <sys_make_duplicate+0x70>
        j++;
    }
    new_name[i] = '\0';
801072ee:	c6 84 05 68 fd ff ff 	movb   $0x0,-0x298(%ebp,%eax,1)
801072f5:	00 

    begin_op();
801072f6:	e8 25 d6 ff ff       	call   80104920 <begin_op>

    ip_src = namei(src_name);
801072fb:	83 ec 0c             	sub    $0xc,%esp
801072fe:	ff b5 5c fd ff ff    	push   -0x2a4(%ebp)
80107304:	e8 57 c9 ff ff       	call   80103c60 <namei>
 
    if (!ip_src)
80107309:	83 c4 10             	add    $0x10,%esp
    ip_src = namei(src_name);
8010730c:	89 c6                	mov    %eax,%esi
    if (!ip_src)
8010730e:	85 c0                	test   %eax,%eax
80107310:	0f 84 da 00 00 00    	je     801073f0 <sys_make_duplicate+0x180>
    {
        end_op();
        return -1; 
    }
    ilock(ip_src);
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	50                   	push   %eax
8010731a:	e8 61 c0 ff ff       	call   80103380 <ilock>


    ip_dest = create(new_name, T_FILE, 0, 0);
8010731f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107326:	31 c9                	xor    %ecx,%ecx
80107328:	89 d8                	mov    %ebx,%eax
8010732a:	ba 02 00 00 00       	mov    $0x2,%edx
8010732f:	e8 ac f3 ff ff       	call   801066e0 <create>
   
    if (!ip_dest)
80107334:	83 c4 10             	add    $0x10,%esp
    ip_dest = create(new_name, T_FILE, 0, 0);
80107337:	89 85 50 fd ff ff    	mov    %eax,-0x2b0(%ebp)
    if (!ip_dest)
8010733d:	85 c0                	test   %eax,%eax
8010733f:	0f 84 bd 00 00 00    	je     80107402 <sys_make_duplicate+0x192>
        return 1; 
    }
   

    j = 0;
    while (j < ip_src->size)
80107345:	8b 46 58             	mov    0x58(%esi),%eax
    j = 0;
80107348:	31 db                	xor    %ebx,%ebx
    while (j < ip_src->size)
8010734a:	31 c9                	xor    %ecx,%ecx
8010734c:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
80107352:	85 c0                	test   %eax,%eax
80107354:	75 32                	jne    80107388 <sys_make_duplicate+0x118>
80107356:	eb 53                	jmp    801073ab <sys_make_duplicate+0x13b>
80107358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010735f:	00 
    { 
        n = readi(ip_src, buf,j, sizeof(buf));
        if (n <= 0){
            break;
        }
        writei(ip_dest, buf,j, n);
80107360:	50                   	push   %eax
80107361:	89 85 54 fd ff ff    	mov    %eax,-0x2ac(%ebp)
80107367:	51                   	push   %ecx
80107368:	57                   	push   %edi
80107369:	ff b5 50 fd ff ff    	push   -0x2b0(%ebp)
8010736f:	e8 1c c4 ff ff       	call   80103790 <writei>
        j+= n;
80107374:	8b 95 54 fd ff ff    	mov    -0x2ac(%ebp),%edx
    while (j < ip_src->size)
8010737a:	8b 46 58             	mov    0x58(%esi),%eax
8010737d:	83 c4 10             	add    $0x10,%esp
        j+= n;
80107380:	01 d3                	add    %edx,%ebx
    while (j < ip_src->size)
80107382:	89 d9                	mov    %ebx,%ecx
80107384:	39 c3                	cmp    %eax,%ebx
80107386:	73 23                	jae    801073ab <sys_make_duplicate+0x13b>
        n = readi(ip_src, buf,j, sizeof(buf));
80107388:	68 00 02 00 00       	push   $0x200
8010738d:	51                   	push   %ecx
8010738e:	89 8d 54 fd ff ff    	mov    %ecx,-0x2ac(%ebp)
80107394:	57                   	push   %edi
80107395:	56                   	push   %esi
80107396:	e8 f5 c2 ff ff       	call   80103690 <readi>
        if (n <= 0){
8010739b:	83 c4 10             	add    $0x10,%esp
8010739e:	8b 8d 54 fd ff ff    	mov    -0x2ac(%ebp),%ecx
801073a4:	85 c0                	test   %eax,%eax
801073a6:	7f b8                	jg     80107360 <sys_make_duplicate+0xf0>
    }
    ip_dest->size = ip_src->size;
801073a8:	8b 46 58             	mov    0x58(%esi),%eax
801073ab:	8b bd 50 fd ff ff    	mov    -0x2b0(%ebp),%edi
    iupdate(ip_dest);
801073b1:	83 ec 0c             	sub    $0xc,%esp
    ip_dest->size = ip_src->size;
801073b4:	89 47 58             	mov    %eax,0x58(%edi)
    iupdate(ip_dest);
801073b7:	57                   	push   %edi
801073b8:	e8 13 bf ff ff       	call   801032d0 <iupdate>
    iunlock(ip_src);
801073bd:	89 34 24             	mov    %esi,(%esp)
801073c0:	e8 9b c0 ff ff       	call   80103460 <iunlock>
    iunlock(ip_dest);
801073c5:	89 3c 24             	mov    %edi,(%esp)
801073c8:	e8 93 c0 ff ff       	call   80103460 <iunlock>
    iput(ip_src);
801073cd:	89 34 24             	mov    %esi,(%esp)
801073d0:	e8 db c0 ff ff       	call   801034b0 <iput>
    iput(ip_dest);
801073d5:	89 3c 24             	mov    %edi,(%esp)
801073d8:	e8 d3 c0 ff ff       	call   801034b0 <iput>

    end_op();
801073dd:	e8 ae d5 ff ff       	call   80104990 <end_op>

    return 0; 
801073e2:	83 c4 10             	add    $0x10,%esp
801073e5:	31 c0                	xor    %eax,%eax
801073e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ea:	5b                   	pop    %ebx
801073eb:	5e                   	pop    %esi
801073ec:	5f                   	pop    %edi
801073ed:	5d                   	pop    %ebp
801073ee:	c3                   	ret
801073ef:	90                   	nop
        end_op();
801073f0:	e8 9b d5 ff ff       	call   80104990 <end_op>
801073f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801073f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073fd:	5b                   	pop    %ebx
801073fe:	5e                   	pop    %esi
801073ff:	5f                   	pop    %edi
80107400:	5d                   	pop    %ebp
80107401:	c3                   	ret
        iunlock(ip_src);
80107402:	83 ec 0c             	sub    $0xc,%esp
80107405:	56                   	push   %esi
80107406:	e8 55 c0 ff ff       	call   80103460 <iunlock>
        iput(ip_src);
8010740b:	89 34 24             	mov    %esi,(%esp)
8010740e:	e8 9d c0 ff ff       	call   801034b0 <iput>
        end_op();
80107413:	e8 78 d5 ff ff       	call   80104990 <end_op>
        return 1; 
80107418:	83 c4 10             	add    $0x10,%esp
8010741b:	b8 01 00 00 00       	mov    $0x1,%eax
80107420:	eb c5                	jmp    801073e7 <sys_make_duplicate+0x177>
80107422:	66 90                	xchg   %ax,%ax
80107424:	66 90                	xchg   %ax,%ax
80107426:	66 90                	xchg   %ax,%ax
80107428:	66 90                	xchg   %ax,%ax
8010742a:	66 90                	xchg   %ax,%ax
8010742c:	66 90                	xchg   %ax,%ax
8010742e:	66 90                	xchg   %ax,%ax

80107430 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80107430:	e9 ab e2 ff ff       	jmp    801056e0 <fork>
80107435:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010743c:	00 
8010743d:	8d 76 00             	lea    0x0(%esi),%esi

80107440 <sys_exit>:
}

int
sys_exit(void)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	83 ec 08             	sub    $0x8,%esp
  exit();
80107446:	e8 05 e5 ff ff       	call   80105950 <exit>
  return 0;  // not reached
}
8010744b:	31 c0                	xor    %eax,%eax
8010744d:	c9                   	leave
8010744e:	c3                   	ret
8010744f:	90                   	nop

80107450 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80107450:	e9 2b e6 ff ff       	jmp    80105a80 <wait>
80107455:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010745c:	00 
8010745d:	8d 76 00             	lea    0x0(%esi),%esi

80107460 <sys_kill>:
}

int
sys_kill(void)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107466:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107469:	50                   	push   %eax
8010746a:	6a 00                	push   $0x0
8010746c:	e8 bf f0 ff ff       	call   80106530 <argint>
80107471:	83 c4 10             	add    $0x10,%esp
80107474:	85 c0                	test   %eax,%eax
80107476:	78 18                	js     80107490 <sys_kill+0x30>
    return -1;
  return kill(pid);
80107478:	83 ec 0c             	sub    $0xc,%esp
8010747b:	ff 75 f4             	push   -0xc(%ebp)
8010747e:	e8 9d e8 ff ff       	call   80105d20 <kill>
80107483:	83 c4 10             	add    $0x10,%esp
}
80107486:	c9                   	leave
80107487:	c3                   	ret
80107488:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010748f:	00 
80107490:	c9                   	leave
    return -1;
80107491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107496:	c3                   	ret
80107497:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010749e:	00 
8010749f:	90                   	nop

801074a0 <sys_getpid>:

int
sys_getpid(void)
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801074a6:	e8 95 e0 ff ff       	call   80105540 <myproc>
801074ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801074ae:	c9                   	leave
801074af:	c3                   	ret

801074b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801074b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801074b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801074ba:	50                   	push   %eax
801074bb:	6a 00                	push   $0x0
801074bd:	e8 6e f0 ff ff       	call   80106530 <argint>
801074c2:	83 c4 10             	add    $0x10,%esp
801074c5:	85 c0                	test   %eax,%eax
801074c7:	78 27                	js     801074f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801074c9:	e8 72 e0 ff ff       	call   80105540 <myproc>
  if(growproc(n) < 0)
801074ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801074d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801074d3:	ff 75 f4             	push   -0xc(%ebp)
801074d6:	e8 85 e1 ff ff       	call   80105660 <growproc>
801074db:	83 c4 10             	add    $0x10,%esp
801074de:	85 c0                	test   %eax,%eax
801074e0:	78 0e                	js     801074f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801074e2:	89 d8                	mov    %ebx,%eax
801074e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801074e7:	c9                   	leave
801074e8:	c3                   	ret
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801074f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801074f5:	eb eb                	jmp    801074e2 <sys_sbrk+0x32>
801074f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074fe:	00 
801074ff:	90                   	nop

80107500 <sys_sleep>:

int
sys_sleep(void)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80107504:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107507:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010750a:	50                   	push   %eax
8010750b:	6a 00                	push   $0x0
8010750d:	e8 1e f0 ff ff       	call   80106530 <argint>
80107512:	83 c4 10             	add    $0x10,%esp
80107515:	85 c0                	test   %eax,%eax
80107517:	78 64                	js     8010757d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80107519:	83 ec 0c             	sub    $0xc,%esp
8010751c:	68 20 65 11 80       	push   $0x80116520
80107521:	e8 5a ec ff ff       	call   80106180 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107529:	8b 1d 00 65 11 80    	mov    0x80116500,%ebx
  while(ticks - ticks0 < n){
8010752f:	83 c4 10             	add    $0x10,%esp
80107532:	85 d2                	test   %edx,%edx
80107534:	75 2b                	jne    80107561 <sys_sleep+0x61>
80107536:	eb 58                	jmp    80107590 <sys_sleep+0x90>
80107538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010753f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107540:	83 ec 08             	sub    $0x8,%esp
80107543:	68 20 65 11 80       	push   $0x80116520
80107548:	68 00 65 11 80       	push   $0x80116500
8010754d:	e8 ae e6 ff ff       	call   80105c00 <sleep>
  while(ticks - ticks0 < n){
80107552:	a1 00 65 11 80       	mov    0x80116500,%eax
80107557:	83 c4 10             	add    $0x10,%esp
8010755a:	29 d8                	sub    %ebx,%eax
8010755c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010755f:	73 2f                	jae    80107590 <sys_sleep+0x90>
    if(myproc()->killed){
80107561:	e8 da df ff ff       	call   80105540 <myproc>
80107566:	8b 40 24             	mov    0x24(%eax),%eax
80107569:	85 c0                	test   %eax,%eax
8010756b:	74 d3                	je     80107540 <sys_sleep+0x40>
      release(&tickslock);
8010756d:	83 ec 0c             	sub    $0xc,%esp
80107570:	68 20 65 11 80       	push   $0x80116520
80107575:	e8 a6 eb ff ff       	call   80106120 <release>
      return -1;
8010757a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010757d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80107580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107585:	c9                   	leave
80107586:	c3                   	ret
80107587:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010758e:	00 
8010758f:	90                   	nop
  release(&tickslock);
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	68 20 65 11 80       	push   $0x80116520
80107598:	e8 83 eb ff ff       	call   80106120 <release>
}
8010759d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801075a0:	83 c4 10             	add    $0x10,%esp
801075a3:	31 c0                	xor    %eax,%eax
}
801075a5:	c9                   	leave
801075a6:	c3                   	ret
801075a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ae:	00 
801075af:	90                   	nop

801075b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	53                   	push   %ebx
801075b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801075b7:	68 20 65 11 80       	push   $0x80116520
801075bc:	e8 bf eb ff ff       	call   80106180 <acquire>
  xticks = ticks;
801075c1:	8b 1d 00 65 11 80    	mov    0x80116500,%ebx
  release(&tickslock);
801075c7:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
801075ce:	e8 4d eb ff ff       	call   80106120 <release>
  return xticks;
}
801075d3:	89 d8                	mov    %ebx,%eax
801075d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075d8:	c9                   	leave
801075d9:	c3                   	ret
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <sys_simple_arithmetic_syscall>:

int
sys_simple_arithmetic_syscall(void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	53                   	push   %ebx
801075e4:	83 ec 04             	sub    $0x4,%esp
  int a, b, result;
  struct proc *curproc = myproc();
801075e7:	e8 54 df ff ff       	call   80105540 <myproc>

  a = curproc->tf->ebx;
801075ec:	8b 50 18             	mov    0x18(%eax),%edx
801075ef:	8b 42 10             	mov    0x10(%edx),%eax
  b = curproc->tf->ecx;
801075f2:	8b 52 18             	mov    0x18(%edx),%edx

  result = (a - b) * (a + b);
801075f5:	89 c3                	mov    %eax,%ebx
801075f7:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801075fa:	29 d3                	sub    %edx,%ebx
801075fc:	0f af d9             	imul   %ecx,%ebx

  cprintf("\nsimple_arithmetic_syscall: a = %d, b = %d, result = %d\n", a, b, result);
801075ff:	53                   	push   %ebx
80107600:	52                   	push   %edx
80107601:	50                   	push   %eax
80107602:	68 ec 95 10 80       	push   $0x801095ec
80107607:	e8 c4 91 ff ff       	call   801007d0 <cprintf>

  return result;
8010760c:	89 d8                	mov    %ebx,%eax
8010760e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107611:	c9                   	leave
80107612:	c3                   	ret

80107613 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107613:	1e                   	push   %ds
  pushl %es
80107614:	06                   	push   %es
  pushl %fs
80107615:	0f a0                	push   %fs
  pushl %gs
80107617:	0f a8                	push   %gs
  pushal
80107619:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010761a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010761e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107620:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107622:	54                   	push   %esp
  call trap
80107623:	e8 c8 00 00 00       	call   801076f0 <trap>
  addl $4, %esp
80107628:	83 c4 04             	add    $0x4,%esp

8010762b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010762b:	61                   	popa
  popl %gs
8010762c:	0f a9                	pop    %gs
  popl %fs
8010762e:	0f a1                	pop    %fs
  popl %es
80107630:	07                   	pop    %es
  popl %ds
80107631:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107632:	83 c4 08             	add    $0x8,%esp
  iret
80107635:	cf                   	iret
80107636:	66 90                	xchg   %ax,%ax
80107638:	66 90                	xchg   %ax,%ax
8010763a:	66 90                	xchg   %ax,%ax
8010763c:	66 90                	xchg   %ax,%ax
8010763e:	66 90                	xchg   %ax,%ax

80107640 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107640:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107641:	31 c0                	xor    %eax,%eax
{
80107643:	89 e5                	mov    %esp,%ebp
80107645:	83 ec 08             	sub    $0x8,%esp
80107648:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010764f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107650:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107657:	c7 04 c5 62 65 11 80 	movl   $0x8e000008,-0x7fee9a9e(,%eax,8)
8010765e:	08 00 00 8e 
80107662:	66 89 14 c5 60 65 11 	mov    %dx,-0x7fee9aa0(,%eax,8)
80107669:	80 
8010766a:	c1 ea 10             	shr    $0x10,%edx
8010766d:	66 89 14 c5 66 65 11 	mov    %dx,-0x7fee9a9a(,%eax,8)
80107674:	80 
  for(i = 0; i < 256; i++)
80107675:	83 c0 01             	add    $0x1,%eax
80107678:	3d 00 01 00 00       	cmp    $0x100,%eax
8010767d:	75 d1                	jne    80107650 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010767f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107682:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107687:	c7 05 62 67 11 80 08 	movl   $0xef000008,0x80116762
8010768e:	00 00 ef 
  initlock(&tickslock, "time");
80107691:	68 8a 93 10 80       	push   $0x8010938a
80107696:	68 20 65 11 80       	push   $0x80116520
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010769b:	66 a3 60 67 11 80    	mov    %ax,0x80116760
801076a1:	c1 e8 10             	shr    $0x10,%eax
801076a4:	66 a3 66 67 11 80    	mov    %ax,0x80116766
  initlock(&tickslock, "time");
801076aa:	e8 e1 e8 ff ff       	call   80105f90 <initlock>
}
801076af:	83 c4 10             	add    $0x10,%esp
801076b2:	c9                   	leave
801076b3:	c3                   	ret
801076b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076bb:	00 
801076bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076c0 <idtinit>:

void
idtinit(void)
{
801076c0:	55                   	push   %ebp
  pd[0] = size-1;
801076c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801076c6:	89 e5                	mov    %esp,%ebp
801076c8:	83 ec 10             	sub    $0x10,%esp
801076cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076cf:	b8 60 65 11 80       	mov    $0x80116560,%eax
801076d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076d8:	c1 e8 10             	shr    $0x10,%eax
801076db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801076df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801076e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801076e5:	c9                   	leave
801076e6:	c3                   	ret
801076e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076ee:	00 
801076ef:	90                   	nop

801076f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
801076f6:	83 ec 1c             	sub    $0x1c,%esp
801076f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801076fc:	8b 43 30             	mov    0x30(%ebx),%eax
801076ff:	83 f8 40             	cmp    $0x40,%eax
80107702:	0f 84 58 01 00 00    	je     80107860 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80107708:	83 e8 20             	sub    $0x20,%eax
8010770b:	83 f8 1f             	cmp    $0x1f,%eax
8010770e:	0f 87 7c 00 00 00    	ja     80107790 <trap+0xa0>
80107714:	ff 24 85 a0 99 10 80 	jmp    *-0x7fef6660(,%eax,4)
8010771b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107720:	e8 eb c6 ff ff       	call   80103e10 <ideintr>
    lapiceoi();
80107725:	e8 a6 cd ff ff       	call   801044d0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010772a:	e8 11 de ff ff       	call   80105540 <myproc>
8010772f:	85 c0                	test   %eax,%eax
80107731:	74 1a                	je     8010774d <trap+0x5d>
80107733:	e8 08 de ff ff       	call   80105540 <myproc>
80107738:	8b 50 24             	mov    0x24(%eax),%edx
8010773b:	85 d2                	test   %edx,%edx
8010773d:	74 0e                	je     8010774d <trap+0x5d>
8010773f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107743:	f7 d0                	not    %eax
80107745:	a8 03                	test   $0x3,%al
80107747:	0f 84 db 01 00 00    	je     80107928 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010774d:	e8 ee dd ff ff       	call   80105540 <myproc>
80107752:	85 c0                	test   %eax,%eax
80107754:	74 0f                	je     80107765 <trap+0x75>
80107756:	e8 e5 dd ff ff       	call   80105540 <myproc>
8010775b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010775f:	0f 84 ab 00 00 00    	je     80107810 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107765:	e8 d6 dd ff ff       	call   80105540 <myproc>
8010776a:	85 c0                	test   %eax,%eax
8010776c:	74 1a                	je     80107788 <trap+0x98>
8010776e:	e8 cd dd ff ff       	call   80105540 <myproc>
80107773:	8b 40 24             	mov    0x24(%eax),%eax
80107776:	85 c0                	test   %eax,%eax
80107778:	74 0e                	je     80107788 <trap+0x98>
8010777a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010777e:	f7 d0                	not    %eax
80107780:	a8 03                	test   $0x3,%al
80107782:	0f 84 05 01 00 00    	je     8010788d <trap+0x19d>
    exit();
}
80107788:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778b:	5b                   	pop    %ebx
8010778c:	5e                   	pop    %esi
8010778d:	5f                   	pop    %edi
8010778e:	5d                   	pop    %ebp
8010778f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80107790:	e8 ab dd ff ff       	call   80105540 <myproc>
80107795:	8b 7b 38             	mov    0x38(%ebx),%edi
80107798:	85 c0                	test   %eax,%eax
8010779a:	0f 84 a2 01 00 00    	je     80107942 <trap+0x252>
801077a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801077a4:	0f 84 98 01 00 00    	je     80107942 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801077aa:	0f 20 d1             	mov    %cr2,%ecx
801077ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801077b0:	e8 6b dd ff ff       	call   80105520 <cpuid>
801077b5:	8b 73 30             	mov    0x30(%ebx),%esi
801077b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801077bb:	8b 43 34             	mov    0x34(%ebx),%eax
801077be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801077c1:	e8 7a dd ff ff       	call   80105540 <myproc>
801077c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077c9:	e8 72 dd ff ff       	call   80105540 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801077ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801077d1:	51                   	push   %ecx
801077d2:	57                   	push   %edi
801077d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801077d6:	52                   	push   %edx
801077d7:	ff 75 e4             	push   -0x1c(%ebp)
801077da:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801077db:	8b 75 e0             	mov    -0x20(%ebp),%esi
801077de:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801077e1:	56                   	push   %esi
801077e2:	ff 70 10             	push   0x10(%eax)
801077e5:	68 80 96 10 80       	push   $0x80109680
801077ea:	e8 e1 8f ff ff       	call   801007d0 <cprintf>
    myproc()->killed = 1;
801077ef:	83 c4 20             	add    $0x20,%esp
801077f2:	e8 49 dd ff ff       	call   80105540 <myproc>
801077f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801077fe:	e8 3d dd ff ff       	call   80105540 <myproc>
80107803:	85 c0                	test   %eax,%eax
80107805:	0f 85 28 ff ff ff    	jne    80107733 <trap+0x43>
8010780b:	e9 3d ff ff ff       	jmp    8010774d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80107810:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107814:	0f 85 4b ff ff ff    	jne    80107765 <trap+0x75>
    yield();
8010781a:	e8 91 e3 ff ff       	call   80105bb0 <yield>
8010781f:	e9 41 ff ff ff       	jmp    80107765 <trap+0x75>
80107824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107828:	8b 7b 38             	mov    0x38(%ebx),%edi
8010782b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010782f:	e8 ec dc ff ff       	call   80105520 <cpuid>
80107834:	57                   	push   %edi
80107835:	56                   	push   %esi
80107836:	50                   	push   %eax
80107837:	68 28 96 10 80       	push   $0x80109628
8010783c:	e8 8f 8f ff ff       	call   801007d0 <cprintf>
    lapiceoi();
80107841:	e8 8a cc ff ff       	call   801044d0 <lapiceoi>
    break;
80107846:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107849:	e8 f2 dc ff ff       	call   80105540 <myproc>
8010784e:	85 c0                	test   %eax,%eax
80107850:	0f 85 dd fe ff ff    	jne    80107733 <trap+0x43>
80107856:	e9 f2 fe ff ff       	jmp    8010774d <trap+0x5d>
8010785b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80107860:	e8 db dc ff ff       	call   80105540 <myproc>
80107865:	8b 70 24             	mov    0x24(%eax),%esi
80107868:	85 f6                	test   %esi,%esi
8010786a:	0f 85 c8 00 00 00    	jne    80107938 <trap+0x248>
    myproc()->tf = tf;
80107870:	e8 cb dc ff ff       	call   80105540 <myproc>
80107875:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107878:	e8 f3 ed ff ff       	call   80106670 <syscall>
    if(myproc()->killed)
8010787d:	e8 be dc ff ff       	call   80105540 <myproc>
80107882:	8b 48 24             	mov    0x24(%eax),%ecx
80107885:	85 c9                	test   %ecx,%ecx
80107887:	0f 84 fb fe ff ff    	je     80107788 <trap+0x98>
}
8010788d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107890:	5b                   	pop    %ebx
80107891:	5e                   	pop    %esi
80107892:	5f                   	pop    %edi
80107893:	5d                   	pop    %ebp
      exit();
80107894:	e9 b7 e0 ff ff       	jmp    80105950 <exit>
80107899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801078a0:	e8 4b 02 00 00       	call   80107af0 <uartintr>
    lapiceoi();
801078a5:	e8 26 cc ff ff       	call   801044d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801078aa:	e8 91 dc ff ff       	call   80105540 <myproc>
801078af:	85 c0                	test   %eax,%eax
801078b1:	0f 85 7c fe ff ff    	jne    80107733 <trap+0x43>
801078b7:	e9 91 fe ff ff       	jmp    8010774d <trap+0x5d>
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801078c0:	e8 db ca ff ff       	call   801043a0 <kbdintr>
    lapiceoi();
801078c5:	e8 06 cc ff ff       	call   801044d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801078ca:	e8 71 dc ff ff       	call   80105540 <myproc>
801078cf:	85 c0                	test   %eax,%eax
801078d1:	0f 85 5c fe ff ff    	jne    80107733 <trap+0x43>
801078d7:	e9 71 fe ff ff       	jmp    8010774d <trap+0x5d>
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801078e0:	e8 3b dc ff ff       	call   80105520 <cpuid>
801078e5:	85 c0                	test   %eax,%eax
801078e7:	0f 85 38 fe ff ff    	jne    80107725 <trap+0x35>
      acquire(&tickslock);
801078ed:	83 ec 0c             	sub    $0xc,%esp
801078f0:	68 20 65 11 80       	push   $0x80116520
801078f5:	e8 86 e8 ff ff       	call   80106180 <acquire>
      ticks++;
801078fa:	83 05 00 65 11 80 01 	addl   $0x1,0x80116500
      wakeup(&ticks);
80107901:	c7 04 24 00 65 11 80 	movl   $0x80116500,(%esp)
80107908:	e8 b3 e3 ff ff       	call   80105cc0 <wakeup>
      release(&tickslock);
8010790d:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
80107914:	e8 07 e8 ff ff       	call   80106120 <release>
80107919:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010791c:	e9 04 fe ff ff       	jmp    80107725 <trap+0x35>
80107921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107928:	e8 23 e0 ff ff       	call   80105950 <exit>
8010792d:	e9 1b fe ff ff       	jmp    8010774d <trap+0x5d>
80107932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107938:	e8 13 e0 ff ff       	call   80105950 <exit>
8010793d:	e9 2e ff ff ff       	jmp    80107870 <trap+0x180>
80107942:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107945:	e8 d6 db ff ff       	call   80105520 <cpuid>
8010794a:	83 ec 0c             	sub    $0xc,%esp
8010794d:	56                   	push   %esi
8010794e:	57                   	push   %edi
8010794f:	50                   	push   %eax
80107950:	ff 73 30             	push   0x30(%ebx)
80107953:	68 4c 96 10 80       	push   $0x8010964c
80107958:	e8 73 8e ff ff       	call   801007d0 <cprintf>
      panic("trap");
8010795d:	83 c4 14             	add    $0x14,%esp
80107960:	68 8f 93 10 80       	push   $0x8010938f
80107965:	e8 16 8a ff ff       	call   80100380 <panic>
8010796a:	66 90                	xchg   %ax,%ax
8010796c:	66 90                	xchg   %ax,%ax
8010796e:	66 90                	xchg   %ax,%ax

80107970 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107970:	a1 60 6d 11 80       	mov    0x80116d60,%eax
80107975:	85 c0                	test   %eax,%eax
80107977:	74 17                	je     80107990 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107979:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010797e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010797f:	a8 01                	test   $0x1,%al
80107981:	74 0d                	je     80107990 <uartgetc+0x20>
80107983:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107988:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107989:	0f b6 c0             	movzbl %al,%eax
8010798c:	c3                   	ret
8010798d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107995:	c3                   	ret
80107996:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010799d:	00 
8010799e:	66 90                	xchg   %ax,%ax

801079a0 <uartinit>:
{
801079a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801079a1:	31 c9                	xor    %ecx,%ecx
801079a3:	89 c8                	mov    %ecx,%eax
801079a5:	89 e5                	mov    %esp,%ebp
801079a7:	57                   	push   %edi
801079a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801079ad:	56                   	push   %esi
801079ae:	89 fa                	mov    %edi,%edx
801079b0:	53                   	push   %ebx
801079b1:	83 ec 1c             	sub    $0x1c,%esp
801079b4:	ee                   	out    %al,(%dx)
801079b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801079ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801079bf:	89 f2                	mov    %esi,%edx
801079c1:	ee                   	out    %al,(%dx)
801079c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801079c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801079cc:	ee                   	out    %al,(%dx)
801079cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801079d2:	89 c8                	mov    %ecx,%eax
801079d4:	89 da                	mov    %ebx,%edx
801079d6:	ee                   	out    %al,(%dx)
801079d7:	b8 03 00 00 00       	mov    $0x3,%eax
801079dc:	89 f2                	mov    %esi,%edx
801079de:	ee                   	out    %al,(%dx)
801079df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801079e4:	89 c8                	mov    %ecx,%eax
801079e6:	ee                   	out    %al,(%dx)
801079e7:	b8 01 00 00 00       	mov    $0x1,%eax
801079ec:	89 da                	mov    %ebx,%edx
801079ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801079ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801079f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801079f5:	3c ff                	cmp    $0xff,%al
801079f7:	0f 84 7c 00 00 00    	je     80107a79 <uartinit+0xd9>
  uart = 1;
801079fd:	c7 05 60 6d 11 80 01 	movl   $0x1,0x80116d60
80107a04:	00 00 00 
80107a07:	89 fa                	mov    %edi,%edx
80107a09:	ec                   	in     (%dx),%al
80107a0a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107a0f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107a10:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80107a13:	bf 94 93 10 80       	mov    $0x80109394,%edi
80107a18:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107a1d:	6a 00                	push   $0x0
80107a1f:	6a 04                	push   $0x4
80107a21:	e8 1a c6 ff ff       	call   80104040 <ioapicenable>
80107a26:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107a29:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80107a2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80107a30:	a1 60 6d 11 80       	mov    0x80116d60,%eax
80107a35:	85 c0                	test   %eax,%eax
80107a37:	74 32                	je     80107a6b <uartinit+0xcb>
80107a39:	89 f2                	mov    %esi,%edx
80107a3b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107a3c:	a8 20                	test   $0x20,%al
80107a3e:	75 21                	jne    80107a61 <uartinit+0xc1>
80107a40:	bb 80 00 00 00       	mov    $0x80,%ebx
80107a45:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80107a48:	83 ec 0c             	sub    $0xc,%esp
80107a4b:	6a 0a                	push   $0xa
80107a4d:	e8 9e ca ff ff       	call   801044f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107a52:	83 c4 10             	add    $0x10,%esp
80107a55:	83 eb 01             	sub    $0x1,%ebx
80107a58:	74 07                	je     80107a61 <uartinit+0xc1>
80107a5a:	89 f2                	mov    %esi,%edx
80107a5c:	ec                   	in     (%dx),%al
80107a5d:	a8 20                	test   $0x20,%al
80107a5f:	74 e7                	je     80107a48 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a61:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107a66:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80107a6a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107a6b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107a6f:	83 c7 01             	add    $0x1,%edi
80107a72:	88 45 e7             	mov    %al,-0x19(%ebp)
80107a75:	84 c0                	test   %al,%al
80107a77:	75 b7                	jne    80107a30 <uartinit+0x90>
}
80107a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a7c:	5b                   	pop    %ebx
80107a7d:	5e                   	pop    %esi
80107a7e:	5f                   	pop    %edi
80107a7f:	5d                   	pop    %ebp
80107a80:	c3                   	ret
80107a81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a88:	00 
80107a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a90 <uartputc>:
  if(!uart)
80107a90:	a1 60 6d 11 80       	mov    0x80116d60,%eax
80107a95:	85 c0                	test   %eax,%eax
80107a97:	74 4f                	je     80107ae8 <uartputc+0x58>
{
80107a99:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107a9a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107a9f:	89 e5                	mov    %esp,%ebp
80107aa1:	56                   	push   %esi
80107aa2:	53                   	push   %ebx
80107aa3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107aa4:	a8 20                	test   $0x20,%al
80107aa6:	75 29                	jne    80107ad1 <uartputc+0x41>
80107aa8:	bb 80 00 00 00       	mov    $0x80,%ebx
80107aad:	be fd 03 00 00       	mov    $0x3fd,%esi
80107ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107ab8:	83 ec 0c             	sub    $0xc,%esp
80107abb:	6a 0a                	push   $0xa
80107abd:	e8 2e ca ff ff       	call   801044f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107ac2:	83 c4 10             	add    $0x10,%esp
80107ac5:	83 eb 01             	sub    $0x1,%ebx
80107ac8:	74 07                	je     80107ad1 <uartputc+0x41>
80107aca:	89 f2                	mov    %esi,%edx
80107acc:	ec                   	in     (%dx),%al
80107acd:	a8 20                	test   $0x20,%al
80107acf:	74 e7                	je     80107ab8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107ad9:	ee                   	out    %al,(%dx)
}
80107ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107add:	5b                   	pop    %ebx
80107ade:	5e                   	pop    %esi
80107adf:	5d                   	pop    %ebp
80107ae0:	c3                   	ret
80107ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ae8:	c3                   	ret
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107af0 <uartintr>:

void
uartintr(void)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107af6:	68 70 79 10 80       	push   $0x80107970
80107afb:	e8 10 9b ff ff       	call   80101610 <consoleintr>
}
80107b00:	83 c4 10             	add    $0x10,%esp
80107b03:	c9                   	leave
80107b04:	c3                   	ret

80107b05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107b05:	6a 00                	push   $0x0
  pushl $0
80107b07:	6a 00                	push   $0x0
  jmp alltraps
80107b09:	e9 05 fb ff ff       	jmp    80107613 <alltraps>

80107b0e <vector1>:
.globl vector1
vector1:
  pushl $0
80107b0e:	6a 00                	push   $0x0
  pushl $1
80107b10:	6a 01                	push   $0x1
  jmp alltraps
80107b12:	e9 fc fa ff ff       	jmp    80107613 <alltraps>

80107b17 <vector2>:
.globl vector2
vector2:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $2
80107b19:	6a 02                	push   $0x2
  jmp alltraps
80107b1b:	e9 f3 fa ff ff       	jmp    80107613 <alltraps>

80107b20 <vector3>:
.globl vector3
vector3:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $3
80107b22:	6a 03                	push   $0x3
  jmp alltraps
80107b24:	e9 ea fa ff ff       	jmp    80107613 <alltraps>

80107b29 <vector4>:
.globl vector4
vector4:
  pushl $0
80107b29:	6a 00                	push   $0x0
  pushl $4
80107b2b:	6a 04                	push   $0x4
  jmp alltraps
80107b2d:	e9 e1 fa ff ff       	jmp    80107613 <alltraps>

80107b32 <vector5>:
.globl vector5
vector5:
  pushl $0
80107b32:	6a 00                	push   $0x0
  pushl $5
80107b34:	6a 05                	push   $0x5
  jmp alltraps
80107b36:	e9 d8 fa ff ff       	jmp    80107613 <alltraps>

80107b3b <vector6>:
.globl vector6
vector6:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $6
80107b3d:	6a 06                	push   $0x6
  jmp alltraps
80107b3f:	e9 cf fa ff ff       	jmp    80107613 <alltraps>

80107b44 <vector7>:
.globl vector7
vector7:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $7
80107b46:	6a 07                	push   $0x7
  jmp alltraps
80107b48:	e9 c6 fa ff ff       	jmp    80107613 <alltraps>

80107b4d <vector8>:
.globl vector8
vector8:
  pushl $8
80107b4d:	6a 08                	push   $0x8
  jmp alltraps
80107b4f:	e9 bf fa ff ff       	jmp    80107613 <alltraps>

80107b54 <vector9>:
.globl vector9
vector9:
  pushl $0
80107b54:	6a 00                	push   $0x0
  pushl $9
80107b56:	6a 09                	push   $0x9
  jmp alltraps
80107b58:	e9 b6 fa ff ff       	jmp    80107613 <alltraps>

80107b5d <vector10>:
.globl vector10
vector10:
  pushl $10
80107b5d:	6a 0a                	push   $0xa
  jmp alltraps
80107b5f:	e9 af fa ff ff       	jmp    80107613 <alltraps>

80107b64 <vector11>:
.globl vector11
vector11:
  pushl $11
80107b64:	6a 0b                	push   $0xb
  jmp alltraps
80107b66:	e9 a8 fa ff ff       	jmp    80107613 <alltraps>

80107b6b <vector12>:
.globl vector12
vector12:
  pushl $12
80107b6b:	6a 0c                	push   $0xc
  jmp alltraps
80107b6d:	e9 a1 fa ff ff       	jmp    80107613 <alltraps>

80107b72 <vector13>:
.globl vector13
vector13:
  pushl $13
80107b72:	6a 0d                	push   $0xd
  jmp alltraps
80107b74:	e9 9a fa ff ff       	jmp    80107613 <alltraps>

80107b79 <vector14>:
.globl vector14
vector14:
  pushl $14
80107b79:	6a 0e                	push   $0xe
  jmp alltraps
80107b7b:	e9 93 fa ff ff       	jmp    80107613 <alltraps>

80107b80 <vector15>:
.globl vector15
vector15:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $15
80107b82:	6a 0f                	push   $0xf
  jmp alltraps
80107b84:	e9 8a fa ff ff       	jmp    80107613 <alltraps>

80107b89 <vector16>:
.globl vector16
vector16:
  pushl $0
80107b89:	6a 00                	push   $0x0
  pushl $16
80107b8b:	6a 10                	push   $0x10
  jmp alltraps
80107b8d:	e9 81 fa ff ff       	jmp    80107613 <alltraps>

80107b92 <vector17>:
.globl vector17
vector17:
  pushl $17
80107b92:	6a 11                	push   $0x11
  jmp alltraps
80107b94:	e9 7a fa ff ff       	jmp    80107613 <alltraps>

80107b99 <vector18>:
.globl vector18
vector18:
  pushl $0
80107b99:	6a 00                	push   $0x0
  pushl $18
80107b9b:	6a 12                	push   $0x12
  jmp alltraps
80107b9d:	e9 71 fa ff ff       	jmp    80107613 <alltraps>

80107ba2 <vector19>:
.globl vector19
vector19:
  pushl $0
80107ba2:	6a 00                	push   $0x0
  pushl $19
80107ba4:	6a 13                	push   $0x13
  jmp alltraps
80107ba6:	e9 68 fa ff ff       	jmp    80107613 <alltraps>

80107bab <vector20>:
.globl vector20
vector20:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $20
80107bad:	6a 14                	push   $0x14
  jmp alltraps
80107baf:	e9 5f fa ff ff       	jmp    80107613 <alltraps>

80107bb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80107bb4:	6a 00                	push   $0x0
  pushl $21
80107bb6:	6a 15                	push   $0x15
  jmp alltraps
80107bb8:	e9 56 fa ff ff       	jmp    80107613 <alltraps>

80107bbd <vector22>:
.globl vector22
vector22:
  pushl $0
80107bbd:	6a 00                	push   $0x0
  pushl $22
80107bbf:	6a 16                	push   $0x16
  jmp alltraps
80107bc1:	e9 4d fa ff ff       	jmp    80107613 <alltraps>

80107bc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80107bc6:	6a 00                	push   $0x0
  pushl $23
80107bc8:	6a 17                	push   $0x17
  jmp alltraps
80107bca:	e9 44 fa ff ff       	jmp    80107613 <alltraps>

80107bcf <vector24>:
.globl vector24
vector24:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $24
80107bd1:	6a 18                	push   $0x18
  jmp alltraps
80107bd3:	e9 3b fa ff ff       	jmp    80107613 <alltraps>

80107bd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80107bd8:	6a 00                	push   $0x0
  pushl $25
80107bda:	6a 19                	push   $0x19
  jmp alltraps
80107bdc:	e9 32 fa ff ff       	jmp    80107613 <alltraps>

80107be1 <vector26>:
.globl vector26
vector26:
  pushl $0
80107be1:	6a 00                	push   $0x0
  pushl $26
80107be3:	6a 1a                	push   $0x1a
  jmp alltraps
80107be5:	e9 29 fa ff ff       	jmp    80107613 <alltraps>

80107bea <vector27>:
.globl vector27
vector27:
  pushl $0
80107bea:	6a 00                	push   $0x0
  pushl $27
80107bec:	6a 1b                	push   $0x1b
  jmp alltraps
80107bee:	e9 20 fa ff ff       	jmp    80107613 <alltraps>

80107bf3 <vector28>:
.globl vector28
vector28:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $28
80107bf5:	6a 1c                	push   $0x1c
  jmp alltraps
80107bf7:	e9 17 fa ff ff       	jmp    80107613 <alltraps>

80107bfc <vector29>:
.globl vector29
vector29:
  pushl $0
80107bfc:	6a 00                	push   $0x0
  pushl $29
80107bfe:	6a 1d                	push   $0x1d
  jmp alltraps
80107c00:	e9 0e fa ff ff       	jmp    80107613 <alltraps>

80107c05 <vector30>:
.globl vector30
vector30:
  pushl $0
80107c05:	6a 00                	push   $0x0
  pushl $30
80107c07:	6a 1e                	push   $0x1e
  jmp alltraps
80107c09:	e9 05 fa ff ff       	jmp    80107613 <alltraps>

80107c0e <vector31>:
.globl vector31
vector31:
  pushl $0
80107c0e:	6a 00                	push   $0x0
  pushl $31
80107c10:	6a 1f                	push   $0x1f
  jmp alltraps
80107c12:	e9 fc f9 ff ff       	jmp    80107613 <alltraps>

80107c17 <vector32>:
.globl vector32
vector32:
  pushl $0
80107c17:	6a 00                	push   $0x0
  pushl $32
80107c19:	6a 20                	push   $0x20
  jmp alltraps
80107c1b:	e9 f3 f9 ff ff       	jmp    80107613 <alltraps>

80107c20 <vector33>:
.globl vector33
vector33:
  pushl $0
80107c20:	6a 00                	push   $0x0
  pushl $33
80107c22:	6a 21                	push   $0x21
  jmp alltraps
80107c24:	e9 ea f9 ff ff       	jmp    80107613 <alltraps>

80107c29 <vector34>:
.globl vector34
vector34:
  pushl $0
80107c29:	6a 00                	push   $0x0
  pushl $34
80107c2b:	6a 22                	push   $0x22
  jmp alltraps
80107c2d:	e9 e1 f9 ff ff       	jmp    80107613 <alltraps>

80107c32 <vector35>:
.globl vector35
vector35:
  pushl $0
80107c32:	6a 00                	push   $0x0
  pushl $35
80107c34:	6a 23                	push   $0x23
  jmp alltraps
80107c36:	e9 d8 f9 ff ff       	jmp    80107613 <alltraps>

80107c3b <vector36>:
.globl vector36
vector36:
  pushl $0
80107c3b:	6a 00                	push   $0x0
  pushl $36
80107c3d:	6a 24                	push   $0x24
  jmp alltraps
80107c3f:	e9 cf f9 ff ff       	jmp    80107613 <alltraps>

80107c44 <vector37>:
.globl vector37
vector37:
  pushl $0
80107c44:	6a 00                	push   $0x0
  pushl $37
80107c46:	6a 25                	push   $0x25
  jmp alltraps
80107c48:	e9 c6 f9 ff ff       	jmp    80107613 <alltraps>

80107c4d <vector38>:
.globl vector38
vector38:
  pushl $0
80107c4d:	6a 00                	push   $0x0
  pushl $38
80107c4f:	6a 26                	push   $0x26
  jmp alltraps
80107c51:	e9 bd f9 ff ff       	jmp    80107613 <alltraps>

80107c56 <vector39>:
.globl vector39
vector39:
  pushl $0
80107c56:	6a 00                	push   $0x0
  pushl $39
80107c58:	6a 27                	push   $0x27
  jmp alltraps
80107c5a:	e9 b4 f9 ff ff       	jmp    80107613 <alltraps>

80107c5f <vector40>:
.globl vector40
vector40:
  pushl $0
80107c5f:	6a 00                	push   $0x0
  pushl $40
80107c61:	6a 28                	push   $0x28
  jmp alltraps
80107c63:	e9 ab f9 ff ff       	jmp    80107613 <alltraps>

80107c68 <vector41>:
.globl vector41
vector41:
  pushl $0
80107c68:	6a 00                	push   $0x0
  pushl $41
80107c6a:	6a 29                	push   $0x29
  jmp alltraps
80107c6c:	e9 a2 f9 ff ff       	jmp    80107613 <alltraps>

80107c71 <vector42>:
.globl vector42
vector42:
  pushl $0
80107c71:	6a 00                	push   $0x0
  pushl $42
80107c73:	6a 2a                	push   $0x2a
  jmp alltraps
80107c75:	e9 99 f9 ff ff       	jmp    80107613 <alltraps>

80107c7a <vector43>:
.globl vector43
vector43:
  pushl $0
80107c7a:	6a 00                	push   $0x0
  pushl $43
80107c7c:	6a 2b                	push   $0x2b
  jmp alltraps
80107c7e:	e9 90 f9 ff ff       	jmp    80107613 <alltraps>

80107c83 <vector44>:
.globl vector44
vector44:
  pushl $0
80107c83:	6a 00                	push   $0x0
  pushl $44
80107c85:	6a 2c                	push   $0x2c
  jmp alltraps
80107c87:	e9 87 f9 ff ff       	jmp    80107613 <alltraps>

80107c8c <vector45>:
.globl vector45
vector45:
  pushl $0
80107c8c:	6a 00                	push   $0x0
  pushl $45
80107c8e:	6a 2d                	push   $0x2d
  jmp alltraps
80107c90:	e9 7e f9 ff ff       	jmp    80107613 <alltraps>

80107c95 <vector46>:
.globl vector46
vector46:
  pushl $0
80107c95:	6a 00                	push   $0x0
  pushl $46
80107c97:	6a 2e                	push   $0x2e
  jmp alltraps
80107c99:	e9 75 f9 ff ff       	jmp    80107613 <alltraps>

80107c9e <vector47>:
.globl vector47
vector47:
  pushl $0
80107c9e:	6a 00                	push   $0x0
  pushl $47
80107ca0:	6a 2f                	push   $0x2f
  jmp alltraps
80107ca2:	e9 6c f9 ff ff       	jmp    80107613 <alltraps>

80107ca7 <vector48>:
.globl vector48
vector48:
  pushl $0
80107ca7:	6a 00                	push   $0x0
  pushl $48
80107ca9:	6a 30                	push   $0x30
  jmp alltraps
80107cab:	e9 63 f9 ff ff       	jmp    80107613 <alltraps>

80107cb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80107cb0:	6a 00                	push   $0x0
  pushl $49
80107cb2:	6a 31                	push   $0x31
  jmp alltraps
80107cb4:	e9 5a f9 ff ff       	jmp    80107613 <alltraps>

80107cb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80107cb9:	6a 00                	push   $0x0
  pushl $50
80107cbb:	6a 32                	push   $0x32
  jmp alltraps
80107cbd:	e9 51 f9 ff ff       	jmp    80107613 <alltraps>

80107cc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80107cc2:	6a 00                	push   $0x0
  pushl $51
80107cc4:	6a 33                	push   $0x33
  jmp alltraps
80107cc6:	e9 48 f9 ff ff       	jmp    80107613 <alltraps>

80107ccb <vector52>:
.globl vector52
vector52:
  pushl $0
80107ccb:	6a 00                	push   $0x0
  pushl $52
80107ccd:	6a 34                	push   $0x34
  jmp alltraps
80107ccf:	e9 3f f9 ff ff       	jmp    80107613 <alltraps>

80107cd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80107cd4:	6a 00                	push   $0x0
  pushl $53
80107cd6:	6a 35                	push   $0x35
  jmp alltraps
80107cd8:	e9 36 f9 ff ff       	jmp    80107613 <alltraps>

80107cdd <vector54>:
.globl vector54
vector54:
  pushl $0
80107cdd:	6a 00                	push   $0x0
  pushl $54
80107cdf:	6a 36                	push   $0x36
  jmp alltraps
80107ce1:	e9 2d f9 ff ff       	jmp    80107613 <alltraps>

80107ce6 <vector55>:
.globl vector55
vector55:
  pushl $0
80107ce6:	6a 00                	push   $0x0
  pushl $55
80107ce8:	6a 37                	push   $0x37
  jmp alltraps
80107cea:	e9 24 f9 ff ff       	jmp    80107613 <alltraps>

80107cef <vector56>:
.globl vector56
vector56:
  pushl $0
80107cef:	6a 00                	push   $0x0
  pushl $56
80107cf1:	6a 38                	push   $0x38
  jmp alltraps
80107cf3:	e9 1b f9 ff ff       	jmp    80107613 <alltraps>

80107cf8 <vector57>:
.globl vector57
vector57:
  pushl $0
80107cf8:	6a 00                	push   $0x0
  pushl $57
80107cfa:	6a 39                	push   $0x39
  jmp alltraps
80107cfc:	e9 12 f9 ff ff       	jmp    80107613 <alltraps>

80107d01 <vector58>:
.globl vector58
vector58:
  pushl $0
80107d01:	6a 00                	push   $0x0
  pushl $58
80107d03:	6a 3a                	push   $0x3a
  jmp alltraps
80107d05:	e9 09 f9 ff ff       	jmp    80107613 <alltraps>

80107d0a <vector59>:
.globl vector59
vector59:
  pushl $0
80107d0a:	6a 00                	push   $0x0
  pushl $59
80107d0c:	6a 3b                	push   $0x3b
  jmp alltraps
80107d0e:	e9 00 f9 ff ff       	jmp    80107613 <alltraps>

80107d13 <vector60>:
.globl vector60
vector60:
  pushl $0
80107d13:	6a 00                	push   $0x0
  pushl $60
80107d15:	6a 3c                	push   $0x3c
  jmp alltraps
80107d17:	e9 f7 f8 ff ff       	jmp    80107613 <alltraps>

80107d1c <vector61>:
.globl vector61
vector61:
  pushl $0
80107d1c:	6a 00                	push   $0x0
  pushl $61
80107d1e:	6a 3d                	push   $0x3d
  jmp alltraps
80107d20:	e9 ee f8 ff ff       	jmp    80107613 <alltraps>

80107d25 <vector62>:
.globl vector62
vector62:
  pushl $0
80107d25:	6a 00                	push   $0x0
  pushl $62
80107d27:	6a 3e                	push   $0x3e
  jmp alltraps
80107d29:	e9 e5 f8 ff ff       	jmp    80107613 <alltraps>

80107d2e <vector63>:
.globl vector63
vector63:
  pushl $0
80107d2e:	6a 00                	push   $0x0
  pushl $63
80107d30:	6a 3f                	push   $0x3f
  jmp alltraps
80107d32:	e9 dc f8 ff ff       	jmp    80107613 <alltraps>

80107d37 <vector64>:
.globl vector64
vector64:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $64
80107d39:	6a 40                	push   $0x40
  jmp alltraps
80107d3b:	e9 d3 f8 ff ff       	jmp    80107613 <alltraps>

80107d40 <vector65>:
.globl vector65
vector65:
  pushl $0
80107d40:	6a 00                	push   $0x0
  pushl $65
80107d42:	6a 41                	push   $0x41
  jmp alltraps
80107d44:	e9 ca f8 ff ff       	jmp    80107613 <alltraps>

80107d49 <vector66>:
.globl vector66
vector66:
  pushl $0
80107d49:	6a 00                	push   $0x0
  pushl $66
80107d4b:	6a 42                	push   $0x42
  jmp alltraps
80107d4d:	e9 c1 f8 ff ff       	jmp    80107613 <alltraps>

80107d52 <vector67>:
.globl vector67
vector67:
  pushl $0
80107d52:	6a 00                	push   $0x0
  pushl $67
80107d54:	6a 43                	push   $0x43
  jmp alltraps
80107d56:	e9 b8 f8 ff ff       	jmp    80107613 <alltraps>

80107d5b <vector68>:
.globl vector68
vector68:
  pushl $0
80107d5b:	6a 00                	push   $0x0
  pushl $68
80107d5d:	6a 44                	push   $0x44
  jmp alltraps
80107d5f:	e9 af f8 ff ff       	jmp    80107613 <alltraps>

80107d64 <vector69>:
.globl vector69
vector69:
  pushl $0
80107d64:	6a 00                	push   $0x0
  pushl $69
80107d66:	6a 45                	push   $0x45
  jmp alltraps
80107d68:	e9 a6 f8 ff ff       	jmp    80107613 <alltraps>

80107d6d <vector70>:
.globl vector70
vector70:
  pushl $0
80107d6d:	6a 00                	push   $0x0
  pushl $70
80107d6f:	6a 46                	push   $0x46
  jmp alltraps
80107d71:	e9 9d f8 ff ff       	jmp    80107613 <alltraps>

80107d76 <vector71>:
.globl vector71
vector71:
  pushl $0
80107d76:	6a 00                	push   $0x0
  pushl $71
80107d78:	6a 47                	push   $0x47
  jmp alltraps
80107d7a:	e9 94 f8 ff ff       	jmp    80107613 <alltraps>

80107d7f <vector72>:
.globl vector72
vector72:
  pushl $0
80107d7f:	6a 00                	push   $0x0
  pushl $72
80107d81:	6a 48                	push   $0x48
  jmp alltraps
80107d83:	e9 8b f8 ff ff       	jmp    80107613 <alltraps>

80107d88 <vector73>:
.globl vector73
vector73:
  pushl $0
80107d88:	6a 00                	push   $0x0
  pushl $73
80107d8a:	6a 49                	push   $0x49
  jmp alltraps
80107d8c:	e9 82 f8 ff ff       	jmp    80107613 <alltraps>

80107d91 <vector74>:
.globl vector74
vector74:
  pushl $0
80107d91:	6a 00                	push   $0x0
  pushl $74
80107d93:	6a 4a                	push   $0x4a
  jmp alltraps
80107d95:	e9 79 f8 ff ff       	jmp    80107613 <alltraps>

80107d9a <vector75>:
.globl vector75
vector75:
  pushl $0
80107d9a:	6a 00                	push   $0x0
  pushl $75
80107d9c:	6a 4b                	push   $0x4b
  jmp alltraps
80107d9e:	e9 70 f8 ff ff       	jmp    80107613 <alltraps>

80107da3 <vector76>:
.globl vector76
vector76:
  pushl $0
80107da3:	6a 00                	push   $0x0
  pushl $76
80107da5:	6a 4c                	push   $0x4c
  jmp alltraps
80107da7:	e9 67 f8 ff ff       	jmp    80107613 <alltraps>

80107dac <vector77>:
.globl vector77
vector77:
  pushl $0
80107dac:	6a 00                	push   $0x0
  pushl $77
80107dae:	6a 4d                	push   $0x4d
  jmp alltraps
80107db0:	e9 5e f8 ff ff       	jmp    80107613 <alltraps>

80107db5 <vector78>:
.globl vector78
vector78:
  pushl $0
80107db5:	6a 00                	push   $0x0
  pushl $78
80107db7:	6a 4e                	push   $0x4e
  jmp alltraps
80107db9:	e9 55 f8 ff ff       	jmp    80107613 <alltraps>

80107dbe <vector79>:
.globl vector79
vector79:
  pushl $0
80107dbe:	6a 00                	push   $0x0
  pushl $79
80107dc0:	6a 4f                	push   $0x4f
  jmp alltraps
80107dc2:	e9 4c f8 ff ff       	jmp    80107613 <alltraps>

80107dc7 <vector80>:
.globl vector80
vector80:
  pushl $0
80107dc7:	6a 00                	push   $0x0
  pushl $80
80107dc9:	6a 50                	push   $0x50
  jmp alltraps
80107dcb:	e9 43 f8 ff ff       	jmp    80107613 <alltraps>

80107dd0 <vector81>:
.globl vector81
vector81:
  pushl $0
80107dd0:	6a 00                	push   $0x0
  pushl $81
80107dd2:	6a 51                	push   $0x51
  jmp alltraps
80107dd4:	e9 3a f8 ff ff       	jmp    80107613 <alltraps>

80107dd9 <vector82>:
.globl vector82
vector82:
  pushl $0
80107dd9:	6a 00                	push   $0x0
  pushl $82
80107ddb:	6a 52                	push   $0x52
  jmp alltraps
80107ddd:	e9 31 f8 ff ff       	jmp    80107613 <alltraps>

80107de2 <vector83>:
.globl vector83
vector83:
  pushl $0
80107de2:	6a 00                	push   $0x0
  pushl $83
80107de4:	6a 53                	push   $0x53
  jmp alltraps
80107de6:	e9 28 f8 ff ff       	jmp    80107613 <alltraps>

80107deb <vector84>:
.globl vector84
vector84:
  pushl $0
80107deb:	6a 00                	push   $0x0
  pushl $84
80107ded:	6a 54                	push   $0x54
  jmp alltraps
80107def:	e9 1f f8 ff ff       	jmp    80107613 <alltraps>

80107df4 <vector85>:
.globl vector85
vector85:
  pushl $0
80107df4:	6a 00                	push   $0x0
  pushl $85
80107df6:	6a 55                	push   $0x55
  jmp alltraps
80107df8:	e9 16 f8 ff ff       	jmp    80107613 <alltraps>

80107dfd <vector86>:
.globl vector86
vector86:
  pushl $0
80107dfd:	6a 00                	push   $0x0
  pushl $86
80107dff:	6a 56                	push   $0x56
  jmp alltraps
80107e01:	e9 0d f8 ff ff       	jmp    80107613 <alltraps>

80107e06 <vector87>:
.globl vector87
vector87:
  pushl $0
80107e06:	6a 00                	push   $0x0
  pushl $87
80107e08:	6a 57                	push   $0x57
  jmp alltraps
80107e0a:	e9 04 f8 ff ff       	jmp    80107613 <alltraps>

80107e0f <vector88>:
.globl vector88
vector88:
  pushl $0
80107e0f:	6a 00                	push   $0x0
  pushl $88
80107e11:	6a 58                	push   $0x58
  jmp alltraps
80107e13:	e9 fb f7 ff ff       	jmp    80107613 <alltraps>

80107e18 <vector89>:
.globl vector89
vector89:
  pushl $0
80107e18:	6a 00                	push   $0x0
  pushl $89
80107e1a:	6a 59                	push   $0x59
  jmp alltraps
80107e1c:	e9 f2 f7 ff ff       	jmp    80107613 <alltraps>

80107e21 <vector90>:
.globl vector90
vector90:
  pushl $0
80107e21:	6a 00                	push   $0x0
  pushl $90
80107e23:	6a 5a                	push   $0x5a
  jmp alltraps
80107e25:	e9 e9 f7 ff ff       	jmp    80107613 <alltraps>

80107e2a <vector91>:
.globl vector91
vector91:
  pushl $0
80107e2a:	6a 00                	push   $0x0
  pushl $91
80107e2c:	6a 5b                	push   $0x5b
  jmp alltraps
80107e2e:	e9 e0 f7 ff ff       	jmp    80107613 <alltraps>

80107e33 <vector92>:
.globl vector92
vector92:
  pushl $0
80107e33:	6a 00                	push   $0x0
  pushl $92
80107e35:	6a 5c                	push   $0x5c
  jmp alltraps
80107e37:	e9 d7 f7 ff ff       	jmp    80107613 <alltraps>

80107e3c <vector93>:
.globl vector93
vector93:
  pushl $0
80107e3c:	6a 00                	push   $0x0
  pushl $93
80107e3e:	6a 5d                	push   $0x5d
  jmp alltraps
80107e40:	e9 ce f7 ff ff       	jmp    80107613 <alltraps>

80107e45 <vector94>:
.globl vector94
vector94:
  pushl $0
80107e45:	6a 00                	push   $0x0
  pushl $94
80107e47:	6a 5e                	push   $0x5e
  jmp alltraps
80107e49:	e9 c5 f7 ff ff       	jmp    80107613 <alltraps>

80107e4e <vector95>:
.globl vector95
vector95:
  pushl $0
80107e4e:	6a 00                	push   $0x0
  pushl $95
80107e50:	6a 5f                	push   $0x5f
  jmp alltraps
80107e52:	e9 bc f7 ff ff       	jmp    80107613 <alltraps>

80107e57 <vector96>:
.globl vector96
vector96:
  pushl $0
80107e57:	6a 00                	push   $0x0
  pushl $96
80107e59:	6a 60                	push   $0x60
  jmp alltraps
80107e5b:	e9 b3 f7 ff ff       	jmp    80107613 <alltraps>

80107e60 <vector97>:
.globl vector97
vector97:
  pushl $0
80107e60:	6a 00                	push   $0x0
  pushl $97
80107e62:	6a 61                	push   $0x61
  jmp alltraps
80107e64:	e9 aa f7 ff ff       	jmp    80107613 <alltraps>

80107e69 <vector98>:
.globl vector98
vector98:
  pushl $0
80107e69:	6a 00                	push   $0x0
  pushl $98
80107e6b:	6a 62                	push   $0x62
  jmp alltraps
80107e6d:	e9 a1 f7 ff ff       	jmp    80107613 <alltraps>

80107e72 <vector99>:
.globl vector99
vector99:
  pushl $0
80107e72:	6a 00                	push   $0x0
  pushl $99
80107e74:	6a 63                	push   $0x63
  jmp alltraps
80107e76:	e9 98 f7 ff ff       	jmp    80107613 <alltraps>

80107e7b <vector100>:
.globl vector100
vector100:
  pushl $0
80107e7b:	6a 00                	push   $0x0
  pushl $100
80107e7d:	6a 64                	push   $0x64
  jmp alltraps
80107e7f:	e9 8f f7 ff ff       	jmp    80107613 <alltraps>

80107e84 <vector101>:
.globl vector101
vector101:
  pushl $0
80107e84:	6a 00                	push   $0x0
  pushl $101
80107e86:	6a 65                	push   $0x65
  jmp alltraps
80107e88:	e9 86 f7 ff ff       	jmp    80107613 <alltraps>

80107e8d <vector102>:
.globl vector102
vector102:
  pushl $0
80107e8d:	6a 00                	push   $0x0
  pushl $102
80107e8f:	6a 66                	push   $0x66
  jmp alltraps
80107e91:	e9 7d f7 ff ff       	jmp    80107613 <alltraps>

80107e96 <vector103>:
.globl vector103
vector103:
  pushl $0
80107e96:	6a 00                	push   $0x0
  pushl $103
80107e98:	6a 67                	push   $0x67
  jmp alltraps
80107e9a:	e9 74 f7 ff ff       	jmp    80107613 <alltraps>

80107e9f <vector104>:
.globl vector104
vector104:
  pushl $0
80107e9f:	6a 00                	push   $0x0
  pushl $104
80107ea1:	6a 68                	push   $0x68
  jmp alltraps
80107ea3:	e9 6b f7 ff ff       	jmp    80107613 <alltraps>

80107ea8 <vector105>:
.globl vector105
vector105:
  pushl $0
80107ea8:	6a 00                	push   $0x0
  pushl $105
80107eaa:	6a 69                	push   $0x69
  jmp alltraps
80107eac:	e9 62 f7 ff ff       	jmp    80107613 <alltraps>

80107eb1 <vector106>:
.globl vector106
vector106:
  pushl $0
80107eb1:	6a 00                	push   $0x0
  pushl $106
80107eb3:	6a 6a                	push   $0x6a
  jmp alltraps
80107eb5:	e9 59 f7 ff ff       	jmp    80107613 <alltraps>

80107eba <vector107>:
.globl vector107
vector107:
  pushl $0
80107eba:	6a 00                	push   $0x0
  pushl $107
80107ebc:	6a 6b                	push   $0x6b
  jmp alltraps
80107ebe:	e9 50 f7 ff ff       	jmp    80107613 <alltraps>

80107ec3 <vector108>:
.globl vector108
vector108:
  pushl $0
80107ec3:	6a 00                	push   $0x0
  pushl $108
80107ec5:	6a 6c                	push   $0x6c
  jmp alltraps
80107ec7:	e9 47 f7 ff ff       	jmp    80107613 <alltraps>

80107ecc <vector109>:
.globl vector109
vector109:
  pushl $0
80107ecc:	6a 00                	push   $0x0
  pushl $109
80107ece:	6a 6d                	push   $0x6d
  jmp alltraps
80107ed0:	e9 3e f7 ff ff       	jmp    80107613 <alltraps>

80107ed5 <vector110>:
.globl vector110
vector110:
  pushl $0
80107ed5:	6a 00                	push   $0x0
  pushl $110
80107ed7:	6a 6e                	push   $0x6e
  jmp alltraps
80107ed9:	e9 35 f7 ff ff       	jmp    80107613 <alltraps>

80107ede <vector111>:
.globl vector111
vector111:
  pushl $0
80107ede:	6a 00                	push   $0x0
  pushl $111
80107ee0:	6a 6f                	push   $0x6f
  jmp alltraps
80107ee2:	e9 2c f7 ff ff       	jmp    80107613 <alltraps>

80107ee7 <vector112>:
.globl vector112
vector112:
  pushl $0
80107ee7:	6a 00                	push   $0x0
  pushl $112
80107ee9:	6a 70                	push   $0x70
  jmp alltraps
80107eeb:	e9 23 f7 ff ff       	jmp    80107613 <alltraps>

80107ef0 <vector113>:
.globl vector113
vector113:
  pushl $0
80107ef0:	6a 00                	push   $0x0
  pushl $113
80107ef2:	6a 71                	push   $0x71
  jmp alltraps
80107ef4:	e9 1a f7 ff ff       	jmp    80107613 <alltraps>

80107ef9 <vector114>:
.globl vector114
vector114:
  pushl $0
80107ef9:	6a 00                	push   $0x0
  pushl $114
80107efb:	6a 72                	push   $0x72
  jmp alltraps
80107efd:	e9 11 f7 ff ff       	jmp    80107613 <alltraps>

80107f02 <vector115>:
.globl vector115
vector115:
  pushl $0
80107f02:	6a 00                	push   $0x0
  pushl $115
80107f04:	6a 73                	push   $0x73
  jmp alltraps
80107f06:	e9 08 f7 ff ff       	jmp    80107613 <alltraps>

80107f0b <vector116>:
.globl vector116
vector116:
  pushl $0
80107f0b:	6a 00                	push   $0x0
  pushl $116
80107f0d:	6a 74                	push   $0x74
  jmp alltraps
80107f0f:	e9 ff f6 ff ff       	jmp    80107613 <alltraps>

80107f14 <vector117>:
.globl vector117
vector117:
  pushl $0
80107f14:	6a 00                	push   $0x0
  pushl $117
80107f16:	6a 75                	push   $0x75
  jmp alltraps
80107f18:	e9 f6 f6 ff ff       	jmp    80107613 <alltraps>

80107f1d <vector118>:
.globl vector118
vector118:
  pushl $0
80107f1d:	6a 00                	push   $0x0
  pushl $118
80107f1f:	6a 76                	push   $0x76
  jmp alltraps
80107f21:	e9 ed f6 ff ff       	jmp    80107613 <alltraps>

80107f26 <vector119>:
.globl vector119
vector119:
  pushl $0
80107f26:	6a 00                	push   $0x0
  pushl $119
80107f28:	6a 77                	push   $0x77
  jmp alltraps
80107f2a:	e9 e4 f6 ff ff       	jmp    80107613 <alltraps>

80107f2f <vector120>:
.globl vector120
vector120:
  pushl $0
80107f2f:	6a 00                	push   $0x0
  pushl $120
80107f31:	6a 78                	push   $0x78
  jmp alltraps
80107f33:	e9 db f6 ff ff       	jmp    80107613 <alltraps>

80107f38 <vector121>:
.globl vector121
vector121:
  pushl $0
80107f38:	6a 00                	push   $0x0
  pushl $121
80107f3a:	6a 79                	push   $0x79
  jmp alltraps
80107f3c:	e9 d2 f6 ff ff       	jmp    80107613 <alltraps>

80107f41 <vector122>:
.globl vector122
vector122:
  pushl $0
80107f41:	6a 00                	push   $0x0
  pushl $122
80107f43:	6a 7a                	push   $0x7a
  jmp alltraps
80107f45:	e9 c9 f6 ff ff       	jmp    80107613 <alltraps>

80107f4a <vector123>:
.globl vector123
vector123:
  pushl $0
80107f4a:	6a 00                	push   $0x0
  pushl $123
80107f4c:	6a 7b                	push   $0x7b
  jmp alltraps
80107f4e:	e9 c0 f6 ff ff       	jmp    80107613 <alltraps>

80107f53 <vector124>:
.globl vector124
vector124:
  pushl $0
80107f53:	6a 00                	push   $0x0
  pushl $124
80107f55:	6a 7c                	push   $0x7c
  jmp alltraps
80107f57:	e9 b7 f6 ff ff       	jmp    80107613 <alltraps>

80107f5c <vector125>:
.globl vector125
vector125:
  pushl $0
80107f5c:	6a 00                	push   $0x0
  pushl $125
80107f5e:	6a 7d                	push   $0x7d
  jmp alltraps
80107f60:	e9 ae f6 ff ff       	jmp    80107613 <alltraps>

80107f65 <vector126>:
.globl vector126
vector126:
  pushl $0
80107f65:	6a 00                	push   $0x0
  pushl $126
80107f67:	6a 7e                	push   $0x7e
  jmp alltraps
80107f69:	e9 a5 f6 ff ff       	jmp    80107613 <alltraps>

80107f6e <vector127>:
.globl vector127
vector127:
  pushl $0
80107f6e:	6a 00                	push   $0x0
  pushl $127
80107f70:	6a 7f                	push   $0x7f
  jmp alltraps
80107f72:	e9 9c f6 ff ff       	jmp    80107613 <alltraps>

80107f77 <vector128>:
.globl vector128
vector128:
  pushl $0
80107f77:	6a 00                	push   $0x0
  pushl $128
80107f79:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107f7e:	e9 90 f6 ff ff       	jmp    80107613 <alltraps>

80107f83 <vector129>:
.globl vector129
vector129:
  pushl $0
80107f83:	6a 00                	push   $0x0
  pushl $129
80107f85:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107f8a:	e9 84 f6 ff ff       	jmp    80107613 <alltraps>

80107f8f <vector130>:
.globl vector130
vector130:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $130
80107f91:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107f96:	e9 78 f6 ff ff       	jmp    80107613 <alltraps>

80107f9b <vector131>:
.globl vector131
vector131:
  pushl $0
80107f9b:	6a 00                	push   $0x0
  pushl $131
80107f9d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107fa2:	e9 6c f6 ff ff       	jmp    80107613 <alltraps>

80107fa7 <vector132>:
.globl vector132
vector132:
  pushl $0
80107fa7:	6a 00                	push   $0x0
  pushl $132
80107fa9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107fae:	e9 60 f6 ff ff       	jmp    80107613 <alltraps>

80107fb3 <vector133>:
.globl vector133
vector133:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $133
80107fb5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107fba:	e9 54 f6 ff ff       	jmp    80107613 <alltraps>

80107fbf <vector134>:
.globl vector134
vector134:
  pushl $0
80107fbf:	6a 00                	push   $0x0
  pushl $134
80107fc1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107fc6:	e9 48 f6 ff ff       	jmp    80107613 <alltraps>

80107fcb <vector135>:
.globl vector135
vector135:
  pushl $0
80107fcb:	6a 00                	push   $0x0
  pushl $135
80107fcd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107fd2:	e9 3c f6 ff ff       	jmp    80107613 <alltraps>

80107fd7 <vector136>:
.globl vector136
vector136:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $136
80107fd9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107fde:	e9 30 f6 ff ff       	jmp    80107613 <alltraps>

80107fe3 <vector137>:
.globl vector137
vector137:
  pushl $0
80107fe3:	6a 00                	push   $0x0
  pushl $137
80107fe5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107fea:	e9 24 f6 ff ff       	jmp    80107613 <alltraps>

80107fef <vector138>:
.globl vector138
vector138:
  pushl $0
80107fef:	6a 00                	push   $0x0
  pushl $138
80107ff1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107ff6:	e9 18 f6 ff ff       	jmp    80107613 <alltraps>

80107ffb <vector139>:
.globl vector139
vector139:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $139
80107ffd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108002:	e9 0c f6 ff ff       	jmp    80107613 <alltraps>

80108007 <vector140>:
.globl vector140
vector140:
  pushl $0
80108007:	6a 00                	push   $0x0
  pushl $140
80108009:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010800e:	e9 00 f6 ff ff       	jmp    80107613 <alltraps>

80108013 <vector141>:
.globl vector141
vector141:
  pushl $0
80108013:	6a 00                	push   $0x0
  pushl $141
80108015:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010801a:	e9 f4 f5 ff ff       	jmp    80107613 <alltraps>

8010801f <vector142>:
.globl vector142
vector142:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $142
80108021:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108026:	e9 e8 f5 ff ff       	jmp    80107613 <alltraps>

8010802b <vector143>:
.globl vector143
vector143:
  pushl $0
8010802b:	6a 00                	push   $0x0
  pushl $143
8010802d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108032:	e9 dc f5 ff ff       	jmp    80107613 <alltraps>

80108037 <vector144>:
.globl vector144
vector144:
  pushl $0
80108037:	6a 00                	push   $0x0
  pushl $144
80108039:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010803e:	e9 d0 f5 ff ff       	jmp    80107613 <alltraps>

80108043 <vector145>:
.globl vector145
vector145:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $145
80108045:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010804a:	e9 c4 f5 ff ff       	jmp    80107613 <alltraps>

8010804f <vector146>:
.globl vector146
vector146:
  pushl $0
8010804f:	6a 00                	push   $0x0
  pushl $146
80108051:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108056:	e9 b8 f5 ff ff       	jmp    80107613 <alltraps>

8010805b <vector147>:
.globl vector147
vector147:
  pushl $0
8010805b:	6a 00                	push   $0x0
  pushl $147
8010805d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108062:	e9 ac f5 ff ff       	jmp    80107613 <alltraps>

80108067 <vector148>:
.globl vector148
vector148:
  pushl $0
80108067:	6a 00                	push   $0x0
  pushl $148
80108069:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010806e:	e9 a0 f5 ff ff       	jmp    80107613 <alltraps>

80108073 <vector149>:
.globl vector149
vector149:
  pushl $0
80108073:	6a 00                	push   $0x0
  pushl $149
80108075:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010807a:	e9 94 f5 ff ff       	jmp    80107613 <alltraps>

8010807f <vector150>:
.globl vector150
vector150:
  pushl $0
8010807f:	6a 00                	push   $0x0
  pushl $150
80108081:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108086:	e9 88 f5 ff ff       	jmp    80107613 <alltraps>

8010808b <vector151>:
.globl vector151
vector151:
  pushl $0
8010808b:	6a 00                	push   $0x0
  pushl $151
8010808d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108092:	e9 7c f5 ff ff       	jmp    80107613 <alltraps>

80108097 <vector152>:
.globl vector152
vector152:
  pushl $0
80108097:	6a 00                	push   $0x0
  pushl $152
80108099:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010809e:	e9 70 f5 ff ff       	jmp    80107613 <alltraps>

801080a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801080a3:	6a 00                	push   $0x0
  pushl $153
801080a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801080aa:	e9 64 f5 ff ff       	jmp    80107613 <alltraps>

801080af <vector154>:
.globl vector154
vector154:
  pushl $0
801080af:	6a 00                	push   $0x0
  pushl $154
801080b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801080b6:	e9 58 f5 ff ff       	jmp    80107613 <alltraps>

801080bb <vector155>:
.globl vector155
vector155:
  pushl $0
801080bb:	6a 00                	push   $0x0
  pushl $155
801080bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801080c2:	e9 4c f5 ff ff       	jmp    80107613 <alltraps>

801080c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801080c7:	6a 00                	push   $0x0
  pushl $156
801080c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801080ce:	e9 40 f5 ff ff       	jmp    80107613 <alltraps>

801080d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801080d3:	6a 00                	push   $0x0
  pushl $157
801080d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801080da:	e9 34 f5 ff ff       	jmp    80107613 <alltraps>

801080df <vector158>:
.globl vector158
vector158:
  pushl $0
801080df:	6a 00                	push   $0x0
  pushl $158
801080e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801080e6:	e9 28 f5 ff ff       	jmp    80107613 <alltraps>

801080eb <vector159>:
.globl vector159
vector159:
  pushl $0
801080eb:	6a 00                	push   $0x0
  pushl $159
801080ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801080f2:	e9 1c f5 ff ff       	jmp    80107613 <alltraps>

801080f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801080f7:	6a 00                	push   $0x0
  pushl $160
801080f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801080fe:	e9 10 f5 ff ff       	jmp    80107613 <alltraps>

80108103 <vector161>:
.globl vector161
vector161:
  pushl $0
80108103:	6a 00                	push   $0x0
  pushl $161
80108105:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010810a:	e9 04 f5 ff ff       	jmp    80107613 <alltraps>

8010810f <vector162>:
.globl vector162
vector162:
  pushl $0
8010810f:	6a 00                	push   $0x0
  pushl $162
80108111:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108116:	e9 f8 f4 ff ff       	jmp    80107613 <alltraps>

8010811b <vector163>:
.globl vector163
vector163:
  pushl $0
8010811b:	6a 00                	push   $0x0
  pushl $163
8010811d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108122:	e9 ec f4 ff ff       	jmp    80107613 <alltraps>

80108127 <vector164>:
.globl vector164
vector164:
  pushl $0
80108127:	6a 00                	push   $0x0
  pushl $164
80108129:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010812e:	e9 e0 f4 ff ff       	jmp    80107613 <alltraps>

80108133 <vector165>:
.globl vector165
vector165:
  pushl $0
80108133:	6a 00                	push   $0x0
  pushl $165
80108135:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010813a:	e9 d4 f4 ff ff       	jmp    80107613 <alltraps>

8010813f <vector166>:
.globl vector166
vector166:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $166
80108141:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108146:	e9 c8 f4 ff ff       	jmp    80107613 <alltraps>

8010814b <vector167>:
.globl vector167
vector167:
  pushl $0
8010814b:	6a 00                	push   $0x0
  pushl $167
8010814d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108152:	e9 bc f4 ff ff       	jmp    80107613 <alltraps>

80108157 <vector168>:
.globl vector168
vector168:
  pushl $0
80108157:	6a 00                	push   $0x0
  pushl $168
80108159:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010815e:	e9 b0 f4 ff ff       	jmp    80107613 <alltraps>

80108163 <vector169>:
.globl vector169
vector169:
  pushl $0
80108163:	6a 00                	push   $0x0
  pushl $169
80108165:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010816a:	e9 a4 f4 ff ff       	jmp    80107613 <alltraps>

8010816f <vector170>:
.globl vector170
vector170:
  pushl $0
8010816f:	6a 00                	push   $0x0
  pushl $170
80108171:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108176:	e9 98 f4 ff ff       	jmp    80107613 <alltraps>

8010817b <vector171>:
.globl vector171
vector171:
  pushl $0
8010817b:	6a 00                	push   $0x0
  pushl $171
8010817d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108182:	e9 8c f4 ff ff       	jmp    80107613 <alltraps>

80108187 <vector172>:
.globl vector172
vector172:
  pushl $0
80108187:	6a 00                	push   $0x0
  pushl $172
80108189:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010818e:	e9 80 f4 ff ff       	jmp    80107613 <alltraps>

80108193 <vector173>:
.globl vector173
vector173:
  pushl $0
80108193:	6a 00                	push   $0x0
  pushl $173
80108195:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010819a:	e9 74 f4 ff ff       	jmp    80107613 <alltraps>

8010819f <vector174>:
.globl vector174
vector174:
  pushl $0
8010819f:	6a 00                	push   $0x0
  pushl $174
801081a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801081a6:	e9 68 f4 ff ff       	jmp    80107613 <alltraps>

801081ab <vector175>:
.globl vector175
vector175:
  pushl $0
801081ab:	6a 00                	push   $0x0
  pushl $175
801081ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801081b2:	e9 5c f4 ff ff       	jmp    80107613 <alltraps>

801081b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801081b7:	6a 00                	push   $0x0
  pushl $176
801081b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801081be:	e9 50 f4 ff ff       	jmp    80107613 <alltraps>

801081c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801081c3:	6a 00                	push   $0x0
  pushl $177
801081c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801081ca:	e9 44 f4 ff ff       	jmp    80107613 <alltraps>

801081cf <vector178>:
.globl vector178
vector178:
  pushl $0
801081cf:	6a 00                	push   $0x0
  pushl $178
801081d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801081d6:	e9 38 f4 ff ff       	jmp    80107613 <alltraps>

801081db <vector179>:
.globl vector179
vector179:
  pushl $0
801081db:	6a 00                	push   $0x0
  pushl $179
801081dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801081e2:	e9 2c f4 ff ff       	jmp    80107613 <alltraps>

801081e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801081e7:	6a 00                	push   $0x0
  pushl $180
801081e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801081ee:	e9 20 f4 ff ff       	jmp    80107613 <alltraps>

801081f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801081f3:	6a 00                	push   $0x0
  pushl $181
801081f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801081fa:	e9 14 f4 ff ff       	jmp    80107613 <alltraps>

801081ff <vector182>:
.globl vector182
vector182:
  pushl $0
801081ff:	6a 00                	push   $0x0
  pushl $182
80108201:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108206:	e9 08 f4 ff ff       	jmp    80107613 <alltraps>

8010820b <vector183>:
.globl vector183
vector183:
  pushl $0
8010820b:	6a 00                	push   $0x0
  pushl $183
8010820d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108212:	e9 fc f3 ff ff       	jmp    80107613 <alltraps>

80108217 <vector184>:
.globl vector184
vector184:
  pushl $0
80108217:	6a 00                	push   $0x0
  pushl $184
80108219:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010821e:	e9 f0 f3 ff ff       	jmp    80107613 <alltraps>

80108223 <vector185>:
.globl vector185
vector185:
  pushl $0
80108223:	6a 00                	push   $0x0
  pushl $185
80108225:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010822a:	e9 e4 f3 ff ff       	jmp    80107613 <alltraps>

8010822f <vector186>:
.globl vector186
vector186:
  pushl $0
8010822f:	6a 00                	push   $0x0
  pushl $186
80108231:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108236:	e9 d8 f3 ff ff       	jmp    80107613 <alltraps>

8010823b <vector187>:
.globl vector187
vector187:
  pushl $0
8010823b:	6a 00                	push   $0x0
  pushl $187
8010823d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108242:	e9 cc f3 ff ff       	jmp    80107613 <alltraps>

80108247 <vector188>:
.globl vector188
vector188:
  pushl $0
80108247:	6a 00                	push   $0x0
  pushl $188
80108249:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010824e:	e9 c0 f3 ff ff       	jmp    80107613 <alltraps>

80108253 <vector189>:
.globl vector189
vector189:
  pushl $0
80108253:	6a 00                	push   $0x0
  pushl $189
80108255:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010825a:	e9 b4 f3 ff ff       	jmp    80107613 <alltraps>

8010825f <vector190>:
.globl vector190
vector190:
  pushl $0
8010825f:	6a 00                	push   $0x0
  pushl $190
80108261:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108266:	e9 a8 f3 ff ff       	jmp    80107613 <alltraps>

8010826b <vector191>:
.globl vector191
vector191:
  pushl $0
8010826b:	6a 00                	push   $0x0
  pushl $191
8010826d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108272:	e9 9c f3 ff ff       	jmp    80107613 <alltraps>

80108277 <vector192>:
.globl vector192
vector192:
  pushl $0
80108277:	6a 00                	push   $0x0
  pushl $192
80108279:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010827e:	e9 90 f3 ff ff       	jmp    80107613 <alltraps>

80108283 <vector193>:
.globl vector193
vector193:
  pushl $0
80108283:	6a 00                	push   $0x0
  pushl $193
80108285:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010828a:	e9 84 f3 ff ff       	jmp    80107613 <alltraps>

8010828f <vector194>:
.globl vector194
vector194:
  pushl $0
8010828f:	6a 00                	push   $0x0
  pushl $194
80108291:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108296:	e9 78 f3 ff ff       	jmp    80107613 <alltraps>

8010829b <vector195>:
.globl vector195
vector195:
  pushl $0
8010829b:	6a 00                	push   $0x0
  pushl $195
8010829d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801082a2:	e9 6c f3 ff ff       	jmp    80107613 <alltraps>

801082a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801082a7:	6a 00                	push   $0x0
  pushl $196
801082a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801082ae:	e9 60 f3 ff ff       	jmp    80107613 <alltraps>

801082b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801082b3:	6a 00                	push   $0x0
  pushl $197
801082b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801082ba:	e9 54 f3 ff ff       	jmp    80107613 <alltraps>

801082bf <vector198>:
.globl vector198
vector198:
  pushl $0
801082bf:	6a 00                	push   $0x0
  pushl $198
801082c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801082c6:	e9 48 f3 ff ff       	jmp    80107613 <alltraps>

801082cb <vector199>:
.globl vector199
vector199:
  pushl $0
801082cb:	6a 00                	push   $0x0
  pushl $199
801082cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801082d2:	e9 3c f3 ff ff       	jmp    80107613 <alltraps>

801082d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801082d7:	6a 00                	push   $0x0
  pushl $200
801082d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801082de:	e9 30 f3 ff ff       	jmp    80107613 <alltraps>

801082e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801082e3:	6a 00                	push   $0x0
  pushl $201
801082e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801082ea:	e9 24 f3 ff ff       	jmp    80107613 <alltraps>

801082ef <vector202>:
.globl vector202
vector202:
  pushl $0
801082ef:	6a 00                	push   $0x0
  pushl $202
801082f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801082f6:	e9 18 f3 ff ff       	jmp    80107613 <alltraps>

801082fb <vector203>:
.globl vector203
vector203:
  pushl $0
801082fb:	6a 00                	push   $0x0
  pushl $203
801082fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108302:	e9 0c f3 ff ff       	jmp    80107613 <alltraps>

80108307 <vector204>:
.globl vector204
vector204:
  pushl $0
80108307:	6a 00                	push   $0x0
  pushl $204
80108309:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010830e:	e9 00 f3 ff ff       	jmp    80107613 <alltraps>

80108313 <vector205>:
.globl vector205
vector205:
  pushl $0
80108313:	6a 00                	push   $0x0
  pushl $205
80108315:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010831a:	e9 f4 f2 ff ff       	jmp    80107613 <alltraps>

8010831f <vector206>:
.globl vector206
vector206:
  pushl $0
8010831f:	6a 00                	push   $0x0
  pushl $206
80108321:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108326:	e9 e8 f2 ff ff       	jmp    80107613 <alltraps>

8010832b <vector207>:
.globl vector207
vector207:
  pushl $0
8010832b:	6a 00                	push   $0x0
  pushl $207
8010832d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108332:	e9 dc f2 ff ff       	jmp    80107613 <alltraps>

80108337 <vector208>:
.globl vector208
vector208:
  pushl $0
80108337:	6a 00                	push   $0x0
  pushl $208
80108339:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010833e:	e9 d0 f2 ff ff       	jmp    80107613 <alltraps>

80108343 <vector209>:
.globl vector209
vector209:
  pushl $0
80108343:	6a 00                	push   $0x0
  pushl $209
80108345:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010834a:	e9 c4 f2 ff ff       	jmp    80107613 <alltraps>

8010834f <vector210>:
.globl vector210
vector210:
  pushl $0
8010834f:	6a 00                	push   $0x0
  pushl $210
80108351:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108356:	e9 b8 f2 ff ff       	jmp    80107613 <alltraps>

8010835b <vector211>:
.globl vector211
vector211:
  pushl $0
8010835b:	6a 00                	push   $0x0
  pushl $211
8010835d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108362:	e9 ac f2 ff ff       	jmp    80107613 <alltraps>

80108367 <vector212>:
.globl vector212
vector212:
  pushl $0
80108367:	6a 00                	push   $0x0
  pushl $212
80108369:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010836e:	e9 a0 f2 ff ff       	jmp    80107613 <alltraps>

80108373 <vector213>:
.globl vector213
vector213:
  pushl $0
80108373:	6a 00                	push   $0x0
  pushl $213
80108375:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010837a:	e9 94 f2 ff ff       	jmp    80107613 <alltraps>

8010837f <vector214>:
.globl vector214
vector214:
  pushl $0
8010837f:	6a 00                	push   $0x0
  pushl $214
80108381:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108386:	e9 88 f2 ff ff       	jmp    80107613 <alltraps>

8010838b <vector215>:
.globl vector215
vector215:
  pushl $0
8010838b:	6a 00                	push   $0x0
  pushl $215
8010838d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108392:	e9 7c f2 ff ff       	jmp    80107613 <alltraps>

80108397 <vector216>:
.globl vector216
vector216:
  pushl $0
80108397:	6a 00                	push   $0x0
  pushl $216
80108399:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010839e:	e9 70 f2 ff ff       	jmp    80107613 <alltraps>

801083a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801083a3:	6a 00                	push   $0x0
  pushl $217
801083a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801083aa:	e9 64 f2 ff ff       	jmp    80107613 <alltraps>

801083af <vector218>:
.globl vector218
vector218:
  pushl $0
801083af:	6a 00                	push   $0x0
  pushl $218
801083b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801083b6:	e9 58 f2 ff ff       	jmp    80107613 <alltraps>

801083bb <vector219>:
.globl vector219
vector219:
  pushl $0
801083bb:	6a 00                	push   $0x0
  pushl $219
801083bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801083c2:	e9 4c f2 ff ff       	jmp    80107613 <alltraps>

801083c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801083c7:	6a 00                	push   $0x0
  pushl $220
801083c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801083ce:	e9 40 f2 ff ff       	jmp    80107613 <alltraps>

801083d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801083d3:	6a 00                	push   $0x0
  pushl $221
801083d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801083da:	e9 34 f2 ff ff       	jmp    80107613 <alltraps>

801083df <vector222>:
.globl vector222
vector222:
  pushl $0
801083df:	6a 00                	push   $0x0
  pushl $222
801083e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801083e6:	e9 28 f2 ff ff       	jmp    80107613 <alltraps>

801083eb <vector223>:
.globl vector223
vector223:
  pushl $0
801083eb:	6a 00                	push   $0x0
  pushl $223
801083ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801083f2:	e9 1c f2 ff ff       	jmp    80107613 <alltraps>

801083f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801083f7:	6a 00                	push   $0x0
  pushl $224
801083f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801083fe:	e9 10 f2 ff ff       	jmp    80107613 <alltraps>

80108403 <vector225>:
.globl vector225
vector225:
  pushl $0
80108403:	6a 00                	push   $0x0
  pushl $225
80108405:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010840a:	e9 04 f2 ff ff       	jmp    80107613 <alltraps>

8010840f <vector226>:
.globl vector226
vector226:
  pushl $0
8010840f:	6a 00                	push   $0x0
  pushl $226
80108411:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108416:	e9 f8 f1 ff ff       	jmp    80107613 <alltraps>

8010841b <vector227>:
.globl vector227
vector227:
  pushl $0
8010841b:	6a 00                	push   $0x0
  pushl $227
8010841d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108422:	e9 ec f1 ff ff       	jmp    80107613 <alltraps>

80108427 <vector228>:
.globl vector228
vector228:
  pushl $0
80108427:	6a 00                	push   $0x0
  pushl $228
80108429:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010842e:	e9 e0 f1 ff ff       	jmp    80107613 <alltraps>

80108433 <vector229>:
.globl vector229
vector229:
  pushl $0
80108433:	6a 00                	push   $0x0
  pushl $229
80108435:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010843a:	e9 d4 f1 ff ff       	jmp    80107613 <alltraps>

8010843f <vector230>:
.globl vector230
vector230:
  pushl $0
8010843f:	6a 00                	push   $0x0
  pushl $230
80108441:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108446:	e9 c8 f1 ff ff       	jmp    80107613 <alltraps>

8010844b <vector231>:
.globl vector231
vector231:
  pushl $0
8010844b:	6a 00                	push   $0x0
  pushl $231
8010844d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108452:	e9 bc f1 ff ff       	jmp    80107613 <alltraps>

80108457 <vector232>:
.globl vector232
vector232:
  pushl $0
80108457:	6a 00                	push   $0x0
  pushl $232
80108459:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010845e:	e9 b0 f1 ff ff       	jmp    80107613 <alltraps>

80108463 <vector233>:
.globl vector233
vector233:
  pushl $0
80108463:	6a 00                	push   $0x0
  pushl $233
80108465:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010846a:	e9 a4 f1 ff ff       	jmp    80107613 <alltraps>

8010846f <vector234>:
.globl vector234
vector234:
  pushl $0
8010846f:	6a 00                	push   $0x0
  pushl $234
80108471:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108476:	e9 98 f1 ff ff       	jmp    80107613 <alltraps>

8010847b <vector235>:
.globl vector235
vector235:
  pushl $0
8010847b:	6a 00                	push   $0x0
  pushl $235
8010847d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108482:	e9 8c f1 ff ff       	jmp    80107613 <alltraps>

80108487 <vector236>:
.globl vector236
vector236:
  pushl $0
80108487:	6a 00                	push   $0x0
  pushl $236
80108489:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010848e:	e9 80 f1 ff ff       	jmp    80107613 <alltraps>

80108493 <vector237>:
.globl vector237
vector237:
  pushl $0
80108493:	6a 00                	push   $0x0
  pushl $237
80108495:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010849a:	e9 74 f1 ff ff       	jmp    80107613 <alltraps>

8010849f <vector238>:
.globl vector238
vector238:
  pushl $0
8010849f:	6a 00                	push   $0x0
  pushl $238
801084a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801084a6:	e9 68 f1 ff ff       	jmp    80107613 <alltraps>

801084ab <vector239>:
.globl vector239
vector239:
  pushl $0
801084ab:	6a 00                	push   $0x0
  pushl $239
801084ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801084b2:	e9 5c f1 ff ff       	jmp    80107613 <alltraps>

801084b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801084b7:	6a 00                	push   $0x0
  pushl $240
801084b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801084be:	e9 50 f1 ff ff       	jmp    80107613 <alltraps>

801084c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801084c3:	6a 00                	push   $0x0
  pushl $241
801084c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801084ca:	e9 44 f1 ff ff       	jmp    80107613 <alltraps>

801084cf <vector242>:
.globl vector242
vector242:
  pushl $0
801084cf:	6a 00                	push   $0x0
  pushl $242
801084d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801084d6:	e9 38 f1 ff ff       	jmp    80107613 <alltraps>

801084db <vector243>:
.globl vector243
vector243:
  pushl $0
801084db:	6a 00                	push   $0x0
  pushl $243
801084dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801084e2:	e9 2c f1 ff ff       	jmp    80107613 <alltraps>

801084e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801084e7:	6a 00                	push   $0x0
  pushl $244
801084e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801084ee:	e9 20 f1 ff ff       	jmp    80107613 <alltraps>

801084f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801084f3:	6a 00                	push   $0x0
  pushl $245
801084f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801084fa:	e9 14 f1 ff ff       	jmp    80107613 <alltraps>

801084ff <vector246>:
.globl vector246
vector246:
  pushl $0
801084ff:	6a 00                	push   $0x0
  pushl $246
80108501:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108506:	e9 08 f1 ff ff       	jmp    80107613 <alltraps>

8010850b <vector247>:
.globl vector247
vector247:
  pushl $0
8010850b:	6a 00                	push   $0x0
  pushl $247
8010850d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108512:	e9 fc f0 ff ff       	jmp    80107613 <alltraps>

80108517 <vector248>:
.globl vector248
vector248:
  pushl $0
80108517:	6a 00                	push   $0x0
  pushl $248
80108519:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010851e:	e9 f0 f0 ff ff       	jmp    80107613 <alltraps>

80108523 <vector249>:
.globl vector249
vector249:
  pushl $0
80108523:	6a 00                	push   $0x0
  pushl $249
80108525:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010852a:	e9 e4 f0 ff ff       	jmp    80107613 <alltraps>

8010852f <vector250>:
.globl vector250
vector250:
  pushl $0
8010852f:	6a 00                	push   $0x0
  pushl $250
80108531:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108536:	e9 d8 f0 ff ff       	jmp    80107613 <alltraps>

8010853b <vector251>:
.globl vector251
vector251:
  pushl $0
8010853b:	6a 00                	push   $0x0
  pushl $251
8010853d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108542:	e9 cc f0 ff ff       	jmp    80107613 <alltraps>

80108547 <vector252>:
.globl vector252
vector252:
  pushl $0
80108547:	6a 00                	push   $0x0
  pushl $252
80108549:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010854e:	e9 c0 f0 ff ff       	jmp    80107613 <alltraps>

80108553 <vector253>:
.globl vector253
vector253:
  pushl $0
80108553:	6a 00                	push   $0x0
  pushl $253
80108555:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010855a:	e9 b4 f0 ff ff       	jmp    80107613 <alltraps>

8010855f <vector254>:
.globl vector254
vector254:
  pushl $0
8010855f:	6a 00                	push   $0x0
  pushl $254
80108561:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108566:	e9 a8 f0 ff ff       	jmp    80107613 <alltraps>

8010856b <vector255>:
.globl vector255
vector255:
  pushl $0
8010856b:	6a 00                	push   $0x0
  pushl $255
8010856d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108572:	e9 9c f0 ff ff       	jmp    80107613 <alltraps>
80108577:	66 90                	xchg   %ax,%ax
80108579:	66 90                	xchg   %ax,%ax
8010857b:	66 90                	xchg   %ax,%ax
8010857d:	66 90                	xchg   %ax,%ax
8010857f:	90                   	nop

80108580 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108580:	55                   	push   %ebp
80108581:	89 e5                	mov    %esp,%ebp
80108583:	57                   	push   %edi
80108584:	56                   	push   %esi
80108585:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108586:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010858c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108592:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80108595:	39 d3                	cmp    %edx,%ebx
80108597:	73 56                	jae    801085ef <deallocuvm.part.0+0x6f>
80108599:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010859c:	89 c6                	mov    %eax,%esi
8010859e:	89 d7                	mov    %edx,%edi
801085a0:	eb 12                	jmp    801085b4 <deallocuvm.part.0+0x34>
801085a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801085a8:	83 c2 01             	add    $0x1,%edx
801085ab:	89 d3                	mov    %edx,%ebx
801085ad:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801085b0:	39 fb                	cmp    %edi,%ebx
801085b2:	73 38                	jae    801085ec <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801085b4:	89 da                	mov    %ebx,%edx
801085b6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801085b9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801085bc:	a8 01                	test   $0x1,%al
801085be:	74 e8                	je     801085a8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801085c0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801085c7:	c1 e9 0a             	shr    $0xa,%ecx
801085ca:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801085d0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801085d7:	85 c0                	test   %eax,%eax
801085d9:	74 cd                	je     801085a8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801085db:	8b 10                	mov    (%eax),%edx
801085dd:	f6 c2 01             	test   $0x1,%dl
801085e0:	75 1e                	jne    80108600 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801085e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801085e8:	39 fb                	cmp    %edi,%ebx
801085ea:	72 c8                	jb     801085b4 <deallocuvm.part.0+0x34>
801085ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801085ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085f2:	89 c8                	mov    %ecx,%eax
801085f4:	5b                   	pop    %ebx
801085f5:	5e                   	pop    %esi
801085f6:	5f                   	pop    %edi
801085f7:	5d                   	pop    %ebp
801085f8:	c3                   	ret
801085f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80108600:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108606:	74 26                	je     8010862e <deallocuvm.part.0+0xae>
      kfree(v);
80108608:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010860b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108614:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010861a:	52                   	push   %edx
8010861b:	e8 60 ba ff ff       	call   80104080 <kfree>
      *pte = 0;
80108620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80108623:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010862c:	eb 82                	jmp    801085b0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010862e:	83 ec 0c             	sub    $0xc,%esp
80108631:	68 6f 91 10 80       	push   $0x8010916f
80108636:	e8 45 7d ff ff       	call   80100380 <panic>
8010863b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108640 <mappages>:
{
80108640:	55                   	push   %ebp
80108641:	89 e5                	mov    %esp,%ebp
80108643:	57                   	push   %edi
80108644:	56                   	push   %esi
80108645:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108646:	89 d3                	mov    %edx,%ebx
80108648:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010864e:	83 ec 1c             	sub    $0x1c,%esp
80108651:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108654:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108658:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010865d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108660:	8b 45 08             	mov    0x8(%ebp),%eax
80108663:	29 d8                	sub    %ebx,%eax
80108665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108668:	eb 3f                	jmp    801086a9 <mappages+0x69>
8010866a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108670:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108672:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108677:	c1 ea 0a             	shr    $0xa,%edx
8010867a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108680:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108687:	85 c0                	test   %eax,%eax
80108689:	74 75                	je     80108700 <mappages+0xc0>
    if(*pte & PTE_P)
8010868b:	f6 00 01             	testb  $0x1,(%eax)
8010868e:	0f 85 86 00 00 00    	jne    8010871a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108694:	0b 75 0c             	or     0xc(%ebp),%esi
80108697:	83 ce 01             	or     $0x1,%esi
8010869a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010869c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010869f:	39 c3                	cmp    %eax,%ebx
801086a1:	74 6d                	je     80108710 <mappages+0xd0>
    a += PGSIZE;
801086a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801086a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801086ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801086af:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801086b2:	89 d8                	mov    %ebx,%eax
801086b4:	c1 e8 16             	shr    $0x16,%eax
801086b7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801086ba:	8b 07                	mov    (%edi),%eax
801086bc:	a8 01                	test   $0x1,%al
801086be:	75 b0                	jne    80108670 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801086c0:	e8 7b bb ff ff       	call   80104240 <kalloc>
801086c5:	85 c0                	test   %eax,%eax
801086c7:	74 37                	je     80108700 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801086c9:	83 ec 04             	sub    $0x4,%esp
801086cc:	68 00 10 00 00       	push   $0x1000
801086d1:	6a 00                	push   $0x0
801086d3:	50                   	push   %eax
801086d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801086d7:	e8 a4 db ff ff       	call   80106280 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801086dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801086df:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801086e2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801086e8:	83 c8 07             	or     $0x7,%eax
801086eb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801086ed:	89 d8                	mov    %ebx,%eax
801086ef:	c1 e8 0a             	shr    $0xa,%eax
801086f2:	25 fc 0f 00 00       	and    $0xffc,%eax
801086f7:	01 d0                	add    %edx,%eax
801086f9:	eb 90                	jmp    8010868b <mappages+0x4b>
801086fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80108700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108708:	5b                   	pop    %ebx
80108709:	5e                   	pop    %esi
8010870a:	5f                   	pop    %edi
8010870b:	5d                   	pop    %ebp
8010870c:	c3                   	ret
8010870d:	8d 76 00             	lea    0x0(%esi),%esi
80108710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108713:	31 c0                	xor    %eax,%eax
}
80108715:	5b                   	pop    %ebx
80108716:	5e                   	pop    %esi
80108717:	5f                   	pop    %edi
80108718:	5d                   	pop    %ebp
80108719:	c3                   	ret
      panic("remap");
8010871a:	83 ec 0c             	sub    $0xc,%esp
8010871d:	68 9c 93 10 80       	push   $0x8010939c
80108722:	e8 59 7c ff ff       	call   80100380 <panic>
80108727:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010872e:	00 
8010872f:	90                   	nop

80108730 <seginit>:
{
80108730:	55                   	push   %ebp
80108731:	89 e5                	mov    %esp,%ebp
80108733:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108736:	e8 e5 cd ff ff       	call   80105520 <cpuid>
  pd[0] = size-1;
8010873b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108740:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108746:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010874a:	c7 80 b8 40 11 80 ff 	movl   $0xffff,-0x7feebf48(%eax)
80108751:	ff 00 00 
80108754:	c7 80 bc 40 11 80 00 	movl   $0xcf9a00,-0x7feebf44(%eax)
8010875b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010875e:	c7 80 c0 40 11 80 ff 	movl   $0xffff,-0x7feebf40(%eax)
80108765:	ff 00 00 
80108768:	c7 80 c4 40 11 80 00 	movl   $0xcf9200,-0x7feebf3c(%eax)
8010876f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108772:	c7 80 c8 40 11 80 ff 	movl   $0xffff,-0x7feebf38(%eax)
80108779:	ff 00 00 
8010877c:	c7 80 cc 40 11 80 00 	movl   $0xcffa00,-0x7feebf34(%eax)
80108783:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108786:	c7 80 d0 40 11 80 ff 	movl   $0xffff,-0x7feebf30(%eax)
8010878d:	ff 00 00 
80108790:	c7 80 d4 40 11 80 00 	movl   $0xcff200,-0x7feebf2c(%eax)
80108797:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010879a:	05 b0 40 11 80       	add    $0x801140b0,%eax
  pd[1] = (uint)p;
8010879f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801087a3:	c1 e8 10             	shr    $0x10,%eax
801087a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801087aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801087ad:	0f 01 10             	lgdtl  (%eax)
}
801087b0:	c9                   	leave
801087b1:	c3                   	ret
801087b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801087b9:	00 
801087ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801087c0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801087c0:	a1 64 6d 11 80       	mov    0x80116d64,%eax
801087c5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801087ca:	0f 22 d8             	mov    %eax,%cr3
}
801087cd:	c3                   	ret
801087ce:	66 90                	xchg   %ax,%ax

801087d0 <switchuvm>:
{
801087d0:	55                   	push   %ebp
801087d1:	89 e5                	mov    %esp,%ebp
801087d3:	57                   	push   %edi
801087d4:	56                   	push   %esi
801087d5:	53                   	push   %ebx
801087d6:	83 ec 1c             	sub    $0x1c,%esp
801087d9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801087dc:	85 f6                	test   %esi,%esi
801087de:	0f 84 cb 00 00 00    	je     801088af <switchuvm+0xdf>
  if(p->kstack == 0)
801087e4:	8b 46 08             	mov    0x8(%esi),%eax
801087e7:	85 c0                	test   %eax,%eax
801087e9:	0f 84 da 00 00 00    	je     801088c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801087ef:	8b 46 04             	mov    0x4(%esi),%eax
801087f2:	85 c0                	test   %eax,%eax
801087f4:	0f 84 c2 00 00 00    	je     801088bc <switchuvm+0xec>
  pushcli();
801087fa:	e8 31 d8 ff ff       	call   80106030 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801087ff:	e8 bc cc ff ff       	call   801054c0 <mycpu>
80108804:	89 c3                	mov    %eax,%ebx
80108806:	e8 b5 cc ff ff       	call   801054c0 <mycpu>
8010880b:	89 c7                	mov    %eax,%edi
8010880d:	e8 ae cc ff ff       	call   801054c0 <mycpu>
80108812:	83 c7 08             	add    $0x8,%edi
80108815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108818:	e8 a3 cc ff ff       	call   801054c0 <mycpu>
8010881d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108820:	ba 67 00 00 00       	mov    $0x67,%edx
80108825:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010882c:	83 c0 08             	add    $0x8,%eax
8010882f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108836:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010883b:	83 c1 08             	add    $0x8,%ecx
8010883e:	c1 e8 18             	shr    $0x18,%eax
80108841:	c1 e9 10             	shr    $0x10,%ecx
80108844:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010884a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108850:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108855:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010885c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108861:	e8 5a cc ff ff       	call   801054c0 <mycpu>
80108866:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010886d:	e8 4e cc ff ff       	call   801054c0 <mycpu>
80108872:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108876:	8b 5e 08             	mov    0x8(%esi),%ebx
80108879:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010887f:	e8 3c cc ff ff       	call   801054c0 <mycpu>
80108884:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108887:	e8 34 cc ff ff       	call   801054c0 <mycpu>
8010888c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108890:	b8 28 00 00 00       	mov    $0x28,%eax
80108895:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108898:	8b 46 04             	mov    0x4(%esi),%eax
8010889b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801088a0:	0f 22 d8             	mov    %eax,%cr3
}
801088a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088a6:	5b                   	pop    %ebx
801088a7:	5e                   	pop    %esi
801088a8:	5f                   	pop    %edi
801088a9:	5d                   	pop    %ebp
  popcli();
801088aa:	e9 d1 d7 ff ff       	jmp    80106080 <popcli>
    panic("switchuvm: no process");
801088af:	83 ec 0c             	sub    $0xc,%esp
801088b2:	68 a2 93 10 80       	push   $0x801093a2
801088b7:	e8 c4 7a ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801088bc:	83 ec 0c             	sub    $0xc,%esp
801088bf:	68 cd 93 10 80       	push   $0x801093cd
801088c4:	e8 b7 7a ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801088c9:	83 ec 0c             	sub    $0xc,%esp
801088cc:	68 b8 93 10 80       	push   $0x801093b8
801088d1:	e8 aa 7a ff ff       	call   80100380 <panic>
801088d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801088dd:	00 
801088de:	66 90                	xchg   %ax,%ax

801088e0 <inituvm>:
{
801088e0:	55                   	push   %ebp
801088e1:	89 e5                	mov    %esp,%ebp
801088e3:	57                   	push   %edi
801088e4:	56                   	push   %esi
801088e5:	53                   	push   %ebx
801088e6:	83 ec 1c             	sub    $0x1c,%esp
801088e9:	8b 45 08             	mov    0x8(%ebp),%eax
801088ec:	8b 75 10             	mov    0x10(%ebp),%esi
801088ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
801088f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801088f5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801088fb:	77 49                	ja     80108946 <inituvm+0x66>
  mem = kalloc();
801088fd:	e8 3e b9 ff ff       	call   80104240 <kalloc>
  memset(mem, 0, PGSIZE);
80108902:	83 ec 04             	sub    $0x4,%esp
80108905:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010890a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010890c:	6a 00                	push   $0x0
8010890e:	50                   	push   %eax
8010890f:	e8 6c d9 ff ff       	call   80106280 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108914:	58                   	pop    %eax
80108915:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010891b:	5a                   	pop    %edx
8010891c:	6a 06                	push   $0x6
8010891e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108923:	31 d2                	xor    %edx,%edx
80108925:	50                   	push   %eax
80108926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108929:	e8 12 fd ff ff       	call   80108640 <mappages>
  memmove(mem, init, sz);
8010892e:	83 c4 10             	add    $0x10,%esp
80108931:	89 75 10             	mov    %esi,0x10(%ebp)
80108934:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108937:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010893a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010893d:	5b                   	pop    %ebx
8010893e:	5e                   	pop    %esi
8010893f:	5f                   	pop    %edi
80108940:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108941:	e9 ca d9 ff ff       	jmp    80106310 <memmove>
    panic("inituvm: more than a page");
80108946:	83 ec 0c             	sub    $0xc,%esp
80108949:	68 e1 93 10 80       	push   $0x801093e1
8010894e:	e8 2d 7a ff ff       	call   80100380 <panic>
80108953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010895a:	00 
8010895b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108960 <loaduvm>:
{
80108960:	55                   	push   %ebp
80108961:	89 e5                	mov    %esp,%ebp
80108963:	57                   	push   %edi
80108964:	56                   	push   %esi
80108965:	53                   	push   %ebx
80108966:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108969:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010896c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010896f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80108975:	0f 85 a2 00 00 00    	jne    80108a1d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010897b:	85 ff                	test   %edi,%edi
8010897d:	74 7d                	je     801089fc <loaduvm+0x9c>
8010897f:	90                   	nop
  pde = &pgdir[PDX(va)];
80108980:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108983:	8b 55 08             	mov    0x8(%ebp),%edx
80108986:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80108988:	89 c1                	mov    %eax,%ecx
8010898a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010898d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80108990:	f6 c1 01             	test   $0x1,%cl
80108993:	75 13                	jne    801089a8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80108995:	83 ec 0c             	sub    $0xc,%esp
80108998:	68 fb 93 10 80       	push   $0x801093fb
8010899d:	e8 de 79 ff ff       	call   80100380 <panic>
801089a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801089a8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801089ab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801089b1:	25 fc 0f 00 00       	and    $0xffc,%eax
801089b6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801089bd:	85 c9                	test   %ecx,%ecx
801089bf:	74 d4                	je     80108995 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801089c1:	89 fb                	mov    %edi,%ebx
801089c3:	b8 00 10 00 00       	mov    $0x1000,%eax
801089c8:	29 f3                	sub    %esi,%ebx
801089ca:	39 c3                	cmp    %eax,%ebx
801089cc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801089cf:	53                   	push   %ebx
801089d0:	8b 45 14             	mov    0x14(%ebp),%eax
801089d3:	01 f0                	add    %esi,%eax
801089d5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801089d6:	8b 01                	mov    (%ecx),%eax
801089d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801089dd:	05 00 00 00 80       	add    $0x80000000,%eax
801089e2:	50                   	push   %eax
801089e3:	ff 75 10             	push   0x10(%ebp)
801089e6:	e8 a5 ac ff ff       	call   80103690 <readi>
801089eb:	83 c4 10             	add    $0x10,%esp
801089ee:	39 d8                	cmp    %ebx,%eax
801089f0:	75 1e                	jne    80108a10 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801089f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801089f8:	39 fe                	cmp    %edi,%esi
801089fa:	72 84                	jb     80108980 <loaduvm+0x20>
}
801089fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801089ff:	31 c0                	xor    %eax,%eax
}
80108a01:	5b                   	pop    %ebx
80108a02:	5e                   	pop    %esi
80108a03:	5f                   	pop    %edi
80108a04:	5d                   	pop    %ebp
80108a05:	c3                   	ret
80108a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108a0d:	00 
80108a0e:	66 90                	xchg   %ax,%ax
80108a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108a18:	5b                   	pop    %ebx
80108a19:	5e                   	pop    %esi
80108a1a:	5f                   	pop    %edi
80108a1b:	5d                   	pop    %ebp
80108a1c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80108a1d:	83 ec 0c             	sub    $0xc,%esp
80108a20:	68 c4 96 10 80       	push   $0x801096c4
80108a25:	e8 56 79 ff ff       	call   80100380 <panic>
80108a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108a30 <allocuvm>:
{
80108a30:	55                   	push   %ebp
80108a31:	89 e5                	mov    %esp,%ebp
80108a33:	57                   	push   %edi
80108a34:	56                   	push   %esi
80108a35:	53                   	push   %ebx
80108a36:	83 ec 1c             	sub    $0x1c,%esp
80108a39:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80108a3c:	85 f6                	test   %esi,%esi
80108a3e:	0f 88 98 00 00 00    	js     80108adc <allocuvm+0xac>
80108a44:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80108a46:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108a49:	0f 82 a1 00 00 00    	jb     80108af0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a52:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a5c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80108a5e:	39 f0                	cmp    %esi,%eax
80108a60:	0f 83 8d 00 00 00    	jae    80108af3 <allocuvm+0xc3>
80108a66:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108a69:	eb 44                	jmp    80108aaf <allocuvm+0x7f>
80108a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108a70:	83 ec 04             	sub    $0x4,%esp
80108a73:	68 00 10 00 00       	push   $0x1000
80108a78:	6a 00                	push   $0x0
80108a7a:	50                   	push   %eax
80108a7b:	e8 00 d8 ff ff       	call   80106280 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108a80:	58                   	pop    %eax
80108a81:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108a87:	5a                   	pop    %edx
80108a88:	6a 06                	push   $0x6
80108a8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108a8f:	89 fa                	mov    %edi,%edx
80108a91:	50                   	push   %eax
80108a92:	8b 45 08             	mov    0x8(%ebp),%eax
80108a95:	e8 a6 fb ff ff       	call   80108640 <mappages>
80108a9a:	83 c4 10             	add    $0x10,%esp
80108a9d:	85 c0                	test   %eax,%eax
80108a9f:	78 5f                	js     80108b00 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80108aa1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108aa7:	39 f7                	cmp    %esi,%edi
80108aa9:	0f 83 89 00 00 00    	jae    80108b38 <allocuvm+0x108>
    mem = kalloc();
80108aaf:	e8 8c b7 ff ff       	call   80104240 <kalloc>
80108ab4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108ab6:	85 c0                	test   %eax,%eax
80108ab8:	75 b6                	jne    80108a70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108aba:	83 ec 0c             	sub    $0xc,%esp
80108abd:	68 19 94 10 80       	push   $0x80109419
80108ac2:	e8 09 7d ff ff       	call   801007d0 <cprintf>
  if(newsz >= oldsz)
80108ac7:	83 c4 10             	add    $0x10,%esp
80108aca:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108acd:	74 0d                	je     80108adc <allocuvm+0xac>
80108acf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ad5:	89 f2                	mov    %esi,%edx
80108ad7:	e8 a4 fa ff ff       	call   80108580 <deallocuvm.part.0>
    return 0;
80108adc:	31 d2                	xor    %edx,%edx
}
80108ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ae1:	89 d0                	mov    %edx,%eax
80108ae3:	5b                   	pop    %ebx
80108ae4:	5e                   	pop    %esi
80108ae5:	5f                   	pop    %edi
80108ae6:	5d                   	pop    %ebp
80108ae7:	c3                   	ret
80108ae8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108aef:	00 
    return oldsz;
80108af0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80108af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108af6:	89 d0                	mov    %edx,%eax
80108af8:	5b                   	pop    %ebx
80108af9:	5e                   	pop    %esi
80108afa:	5f                   	pop    %edi
80108afb:	5d                   	pop    %ebp
80108afc:	c3                   	ret
80108afd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108b00:	83 ec 0c             	sub    $0xc,%esp
80108b03:	68 31 94 10 80       	push   $0x80109431
80108b08:	e8 c3 7c ff ff       	call   801007d0 <cprintf>
  if(newsz >= oldsz)
80108b0d:	83 c4 10             	add    $0x10,%esp
80108b10:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108b13:	74 0d                	je     80108b22 <allocuvm+0xf2>
80108b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108b18:	8b 45 08             	mov    0x8(%ebp),%eax
80108b1b:	89 f2                	mov    %esi,%edx
80108b1d:	e8 5e fa ff ff       	call   80108580 <deallocuvm.part.0>
      kfree(mem);
80108b22:	83 ec 0c             	sub    $0xc,%esp
80108b25:	53                   	push   %ebx
80108b26:	e8 55 b5 ff ff       	call   80104080 <kfree>
      return 0;
80108b2b:	83 c4 10             	add    $0x10,%esp
    return 0;
80108b2e:	31 d2                	xor    %edx,%edx
80108b30:	eb ac                	jmp    80108ade <allocuvm+0xae>
80108b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108b38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80108b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b3e:	5b                   	pop    %ebx
80108b3f:	5e                   	pop    %esi
80108b40:	89 d0                	mov    %edx,%eax
80108b42:	5f                   	pop    %edi
80108b43:	5d                   	pop    %ebp
80108b44:	c3                   	ret
80108b45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108b4c:	00 
80108b4d:	8d 76 00             	lea    0x0(%esi),%esi

80108b50 <deallocuvm>:
{
80108b50:	55                   	push   %ebp
80108b51:	89 e5                	mov    %esp,%ebp
80108b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108b59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108b5c:	39 d1                	cmp    %edx,%ecx
80108b5e:	73 10                	jae    80108b70 <deallocuvm+0x20>
}
80108b60:	5d                   	pop    %ebp
80108b61:	e9 1a fa ff ff       	jmp    80108580 <deallocuvm.part.0>
80108b66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108b6d:	00 
80108b6e:	66 90                	xchg   %ax,%ax
80108b70:	89 d0                	mov    %edx,%eax
80108b72:	5d                   	pop    %ebp
80108b73:	c3                   	ret
80108b74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108b7b:	00 
80108b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108b80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108b80:	55                   	push   %ebp
80108b81:	89 e5                	mov    %esp,%ebp
80108b83:	57                   	push   %edi
80108b84:	56                   	push   %esi
80108b85:	53                   	push   %ebx
80108b86:	83 ec 0c             	sub    $0xc,%esp
80108b89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108b8c:	85 f6                	test   %esi,%esi
80108b8e:	74 59                	je     80108be9 <freevm+0x69>
  if(newsz >= oldsz)
80108b90:	31 c9                	xor    %ecx,%ecx
80108b92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108b97:	89 f0                	mov    %esi,%eax
80108b99:	89 f3                	mov    %esi,%ebx
80108b9b:	e8 e0 f9 ff ff       	call   80108580 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108ba0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108ba6:	eb 0f                	jmp    80108bb7 <freevm+0x37>
80108ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108baf:	00 
80108bb0:	83 c3 04             	add    $0x4,%ebx
80108bb3:	39 fb                	cmp    %edi,%ebx
80108bb5:	74 23                	je     80108bda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108bb7:	8b 03                	mov    (%ebx),%eax
80108bb9:	a8 01                	test   $0x1,%al
80108bbb:	74 f3                	je     80108bb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108bc2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108bc5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108bc8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80108bcd:	50                   	push   %eax
80108bce:	e8 ad b4 ff ff       	call   80104080 <kfree>
80108bd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108bd6:	39 fb                	cmp    %edi,%ebx
80108bd8:	75 dd                	jne    80108bb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108bda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108be0:	5b                   	pop    %ebx
80108be1:	5e                   	pop    %esi
80108be2:	5f                   	pop    %edi
80108be3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108be4:	e9 97 b4 ff ff       	jmp    80104080 <kfree>
    panic("freevm: no pgdir");
80108be9:	83 ec 0c             	sub    $0xc,%esp
80108bec:	68 4d 94 10 80       	push   $0x8010944d
80108bf1:	e8 8a 77 ff ff       	call   80100380 <panic>
80108bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108bfd:	00 
80108bfe:	66 90                	xchg   %ax,%ax

80108c00 <setupkvm>:
{
80108c00:	55                   	push   %ebp
80108c01:	89 e5                	mov    %esp,%ebp
80108c03:	56                   	push   %esi
80108c04:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108c05:	e8 36 b6 ff ff       	call   80104240 <kalloc>
80108c0a:	85 c0                	test   %eax,%eax
80108c0c:	74 5e                	je     80108c6c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80108c0e:	83 ec 04             	sub    $0x4,%esp
80108c11:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108c13:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108c18:	68 00 10 00 00       	push   $0x1000
80108c1d:	6a 00                	push   $0x0
80108c1f:	50                   	push   %eax
80108c20:	e8 5b d6 ff ff       	call   80106280 <memset>
80108c25:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108c28:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108c2b:	83 ec 08             	sub    $0x8,%esp
80108c2e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108c31:	8b 13                	mov    (%ebx),%edx
80108c33:	ff 73 0c             	push   0xc(%ebx)
80108c36:	50                   	push   %eax
80108c37:	29 c1                	sub    %eax,%ecx
80108c39:	89 f0                	mov    %esi,%eax
80108c3b:	e8 00 fa ff ff       	call   80108640 <mappages>
80108c40:	83 c4 10             	add    $0x10,%esp
80108c43:	85 c0                	test   %eax,%eax
80108c45:	78 19                	js     80108c60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108c47:	83 c3 10             	add    $0x10,%ebx
80108c4a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108c50:	75 d6                	jne    80108c28 <setupkvm+0x28>
}
80108c52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108c55:	89 f0                	mov    %esi,%eax
80108c57:	5b                   	pop    %ebx
80108c58:	5e                   	pop    %esi
80108c59:	5d                   	pop    %ebp
80108c5a:	c3                   	ret
80108c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108c60:	83 ec 0c             	sub    $0xc,%esp
80108c63:	56                   	push   %esi
80108c64:	e8 17 ff ff ff       	call   80108b80 <freevm>
      return 0;
80108c69:	83 c4 10             	add    $0x10,%esp
}
80108c6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80108c6f:	31 f6                	xor    %esi,%esi
}
80108c71:	89 f0                	mov    %esi,%eax
80108c73:	5b                   	pop    %ebx
80108c74:	5e                   	pop    %esi
80108c75:	5d                   	pop    %ebp
80108c76:	c3                   	ret
80108c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108c7e:	00 
80108c7f:	90                   	nop

80108c80 <kvmalloc>:
{
80108c80:	55                   	push   %ebp
80108c81:	89 e5                	mov    %esp,%ebp
80108c83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108c86:	e8 75 ff ff ff       	call   80108c00 <setupkvm>
80108c8b:	a3 64 6d 11 80       	mov    %eax,0x80116d64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108c90:	05 00 00 00 80       	add    $0x80000000,%eax
80108c95:	0f 22 d8             	mov    %eax,%cr3
}
80108c98:	c9                   	leave
80108c99:	c3                   	ret
80108c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108ca0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108ca0:	55                   	push   %ebp
80108ca1:	89 e5                	mov    %esp,%ebp
80108ca3:	83 ec 08             	sub    $0x8,%esp
80108ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108cac:	89 c1                	mov    %eax,%ecx
80108cae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108cb1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108cb4:	f6 c2 01             	test   $0x1,%dl
80108cb7:	75 17                	jne    80108cd0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108cb9:	83 ec 0c             	sub    $0xc,%esp
80108cbc:	68 5e 94 10 80       	push   $0x8010945e
80108cc1:	e8 ba 76 ff ff       	call   80100380 <panic>
80108cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108ccd:	00 
80108cce:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80108cd0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108cd3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108cd9:	25 fc 0f 00 00       	and    $0xffc,%eax
80108cde:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108ce5:	85 c0                	test   %eax,%eax
80108ce7:	74 d0                	je     80108cb9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108ce9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108cec:	c9                   	leave
80108ced:	c3                   	ret
80108cee:	66 90                	xchg   %ax,%ax

80108cf0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108cf0:	55                   	push   %ebp
80108cf1:	89 e5                	mov    %esp,%ebp
80108cf3:	57                   	push   %edi
80108cf4:	56                   	push   %esi
80108cf5:	53                   	push   %ebx
80108cf6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108cf9:	e8 02 ff ff ff       	call   80108c00 <setupkvm>
80108cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108d01:	85 c0                	test   %eax,%eax
80108d03:	0f 84 e9 00 00 00    	je     80108df2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108d09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108d0c:	85 c9                	test   %ecx,%ecx
80108d0e:	0f 84 b2 00 00 00    	je     80108dc6 <copyuvm+0xd6>
80108d14:	31 f6                	xor    %esi,%esi
80108d16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108d1d:	00 
80108d1e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80108d20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108d23:	89 f0                	mov    %esi,%eax
80108d25:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108d28:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80108d2b:	a8 01                	test   $0x1,%al
80108d2d:	75 11                	jne    80108d40 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80108d2f:	83 ec 0c             	sub    $0xc,%esp
80108d32:	68 68 94 10 80       	push   $0x80109468
80108d37:	e8 44 76 ff ff       	call   80100380 <panic>
80108d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108d40:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108d47:	c1 ea 0a             	shr    $0xa,%edx
80108d4a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108d50:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108d57:	85 c0                	test   %eax,%eax
80108d59:	74 d4                	je     80108d2f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80108d5b:	8b 00                	mov    (%eax),%eax
80108d5d:	a8 01                	test   $0x1,%al
80108d5f:	0f 84 9f 00 00 00    	je     80108e04 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108d65:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108d67:	25 ff 0f 00 00       	and    $0xfff,%eax
80108d6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108d6f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108d75:	e8 c6 b4 ff ff       	call   80104240 <kalloc>
80108d7a:	89 c3                	mov    %eax,%ebx
80108d7c:	85 c0                	test   %eax,%eax
80108d7e:	74 64                	je     80108de4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108d80:	83 ec 04             	sub    $0x4,%esp
80108d83:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108d89:	68 00 10 00 00       	push   $0x1000
80108d8e:	57                   	push   %edi
80108d8f:	50                   	push   %eax
80108d90:	e8 7b d5 ff ff       	call   80106310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108d95:	58                   	pop    %eax
80108d96:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108d9c:	5a                   	pop    %edx
80108d9d:	ff 75 e4             	push   -0x1c(%ebp)
80108da0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108da5:	89 f2                	mov    %esi,%edx
80108da7:	50                   	push   %eax
80108da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dab:	e8 90 f8 ff ff       	call   80108640 <mappages>
80108db0:	83 c4 10             	add    $0x10,%esp
80108db3:	85 c0                	test   %eax,%eax
80108db5:	78 21                	js     80108dd8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108db7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108dbd:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108dc0:	0f 82 5a ff ff ff    	jb     80108d20 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dcc:	5b                   	pop    %ebx
80108dcd:	5e                   	pop    %esi
80108dce:	5f                   	pop    %edi
80108dcf:	5d                   	pop    %ebp
80108dd0:	c3                   	ret
80108dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108dd8:	83 ec 0c             	sub    $0xc,%esp
80108ddb:	53                   	push   %ebx
80108ddc:	e8 9f b2 ff ff       	call   80104080 <kfree>
      goto bad;
80108de1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108de4:	83 ec 0c             	sub    $0xc,%esp
80108de7:	ff 75 e0             	push   -0x20(%ebp)
80108dea:	e8 91 fd ff ff       	call   80108b80 <freevm>
  return 0;
80108def:	83 c4 10             	add    $0x10,%esp
    return 0;
80108df2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dff:	5b                   	pop    %ebx
80108e00:	5e                   	pop    %esi
80108e01:	5f                   	pop    %edi
80108e02:	5d                   	pop    %ebp
80108e03:	c3                   	ret
      panic("copyuvm: page not present");
80108e04:	83 ec 0c             	sub    $0xc,%esp
80108e07:	68 82 94 10 80       	push   $0x80109482
80108e0c:	e8 6f 75 ff ff       	call   80100380 <panic>
80108e11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e18:	00 
80108e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108e20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108e20:	55                   	push   %ebp
80108e21:	89 e5                	mov    %esp,%ebp
80108e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108e26:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108e29:	89 c1                	mov    %eax,%ecx
80108e2b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108e2e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108e31:	f6 c2 01             	test   $0x1,%dl
80108e34:	0f 84 f8 00 00 00    	je     80108f32 <uva2ka.cold>
  return &pgtab[PTX(va)];
80108e3a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108e3d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108e43:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108e44:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108e49:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108e50:	89 d0                	mov    %edx,%eax
80108e52:	f7 d2                	not    %edx
80108e54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e59:	05 00 00 00 80       	add    $0x80000000,%eax
80108e5e:	83 e2 05             	and    $0x5,%edx
80108e61:	ba 00 00 00 00       	mov    $0x0,%edx
80108e66:	0f 45 c2             	cmovne %edx,%eax
}
80108e69:	c3                   	ret
80108e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108e70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108e70:	55                   	push   %ebp
80108e71:	89 e5                	mov    %esp,%ebp
80108e73:	57                   	push   %edi
80108e74:	56                   	push   %esi
80108e75:	53                   	push   %ebx
80108e76:	83 ec 0c             	sub    $0xc,%esp
80108e79:	8b 75 14             	mov    0x14(%ebp),%esi
80108e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e7f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108e82:	85 f6                	test   %esi,%esi
80108e84:	75 51                	jne    80108ed7 <copyout+0x67>
80108e86:	e9 9d 00 00 00       	jmp    80108f28 <copyout+0xb8>
80108e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80108e90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108e96:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80108e9c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108ea2:	74 74                	je     80108f18 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80108ea4:	89 fb                	mov    %edi,%ebx
80108ea6:	29 c3                	sub    %eax,%ebx
80108ea8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80108eae:	39 f3                	cmp    %esi,%ebx
80108eb0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108eb3:	29 f8                	sub    %edi,%eax
80108eb5:	83 ec 04             	sub    $0x4,%esp
80108eb8:	01 c1                	add    %eax,%ecx
80108eba:	53                   	push   %ebx
80108ebb:	52                   	push   %edx
80108ebc:	89 55 10             	mov    %edx,0x10(%ebp)
80108ebf:	51                   	push   %ecx
80108ec0:	e8 4b d4 ff ff       	call   80106310 <memmove>
    len -= n;
    buf += n;
80108ec5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108ec8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80108ece:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108ed1:	01 da                	add    %ebx,%edx
  while(len > 0){
80108ed3:	29 de                	sub    %ebx,%esi
80108ed5:	74 51                	je     80108f28 <copyout+0xb8>
  if(*pde & PTE_P){
80108ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80108eda:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108edc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80108ede:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108ee1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108ee7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80108eea:	f6 c1 01             	test   $0x1,%cl
80108eed:	0f 84 46 00 00 00    	je     80108f39 <copyout.cold>
  return &pgtab[PTX(va)];
80108ef3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108ef5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108efb:	c1 eb 0c             	shr    $0xc,%ebx
80108efe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108f04:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80108f0b:	89 d9                	mov    %ebx,%ecx
80108f0d:	f7 d1                	not    %ecx
80108f0f:	83 e1 05             	and    $0x5,%ecx
80108f12:	0f 84 78 ff ff ff    	je     80108e90 <copyout+0x20>
  }
  return 0;
}
80108f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108f20:	5b                   	pop    %ebx
80108f21:	5e                   	pop    %esi
80108f22:	5f                   	pop    %edi
80108f23:	5d                   	pop    %ebp
80108f24:	c3                   	ret
80108f25:	8d 76 00             	lea    0x0(%esi),%esi
80108f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108f2b:	31 c0                	xor    %eax,%eax
}
80108f2d:	5b                   	pop    %ebx
80108f2e:	5e                   	pop    %esi
80108f2f:	5f                   	pop    %edi
80108f30:	5d                   	pop    %ebp
80108f31:	c3                   	ret

80108f32 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108f32:	a1 00 00 00 00       	mov    0x0,%eax
80108f37:	0f 0b                	ud2

80108f39 <copyout.cold>:
80108f39:	a1 00 00 00 00       	mov    0x0,%eax
80108f3e:	0f 0b                	ud2
