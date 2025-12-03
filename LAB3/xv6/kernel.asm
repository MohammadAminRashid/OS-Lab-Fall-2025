
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 90 90 11 80       	mov    $0x80119090,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 4b 10 80       	mov    $0x80104bf0,%eax
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
80100044:	bb 54 d5 10 80       	mov    $0x8010d554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 97 10 80       	push   $0x801097a0
80100051:	68 20 d5 10 80       	push   $0x8010d520
80100056:	e8 a5 63 00 00       	call   80106400 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 1c 11 80       	mov    $0x80111c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 1c 11 80 1c 	movl   $0x80111c1c,0x80111c6c
8010006a:	1c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 1c 11 80 1c 	movl   $0x80111c1c,0x80111c70
80100074:	1c 11 80 
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
8010008b:	c7 43 50 1c 1c 11 80 	movl   $0x80111c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 97 10 80       	push   $0x801097a7
80100097:	50                   	push   %eax
80100098:	e8 33 62 00 00       	call   801062d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 1c 11 80       	mov    0x80111c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 1c 11 80    	mov    %ebx,0x80111c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 19 11 80    	cmp    $0x801119c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 d5 10 80       	push   $0x8010d520
801000e4:	e8 07 65 00 00       	call   801065f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 1c 11 80    	mov    0x80111c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
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
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 1c 11 80    	mov    0x80111c6c,%ebx
80100126:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
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
8010015d:	68 20 d5 10 80       	push   $0x8010d520
80100162:	e8 29 64 00 00       	call   80106590 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 61 00 00       	call   80106310 <acquiresleep>
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
8010018c:	e8 ff 3c 00 00       	call   80103e90 <iderw>
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
801001a1:	68 ae 97 10 80       	push   $0x801097ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

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
801001be:	e8 ed 61 00 00       	call   801063b0 <holdingsleep>
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
801001d4:	e9 b7 3c 00 00       	jmp    80103e90 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 97 10 80       	push   $0x801097bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

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
801001ff:	e8 ac 61 00 00       	call   801063b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 61 00 00       	call   80106370 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010021b:	e8 d0 63 00 00       	call   801065f0 <acquire>
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
8010023f:	a1 70 1c 11 80       	mov    0x80111c70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c 1c 11 80 	movl   $0x80111c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 1c 11 80       	mov    0x80111c70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 1c 11 80    	mov    %ebx,0x80111c70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 d5 10 80 	movl   $0x8010d520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 22 63 00 00       	jmp    80106590 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 c6 97 10 80       	push   $0x801097c6
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
8010028f:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 a7 31 00 00       	call   80103440 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 27 11 80 	movl   $0x801127c0,(%esp)
801002a0:	e8 4b 63 00 00       	call   801065f0 <acquire>
  while (n > 0)
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
  {
    while (input.r == input.w)
801002b0:	a1 80 b0 10 80       	mov    0x8010b080,%eax
801002b5:	39 05 84 b0 10 80    	cmp    %eax,0x8010b084
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
801002c3:	68 c0 27 11 80       	push   $0x801127c0
801002c8:	68 80 b0 10 80       	push   $0x8010b080
801002cd:	e8 7e 5b 00 00       	call   80105e50 <sleep>
    while (input.r == input.w)
801002d2:	a1 80 b0 10 80       	mov    0x8010b080,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 84 b0 10 80    	cmp    0x8010b084,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if (myproc()->killed)
801002e2:	e8 79 52 00 00       	call   80105560 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 27 11 80       	push   $0x801127c0
801002f6:	e8 95 62 00 00       	call   80106590 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	pushl  0x8(%ebp)
801002ff:	e8 5c 30 00 00       	call   80103360 <ilock>
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
8010031b:	89 15 80 b0 10 80    	mov    %edx,0x8010b080
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 00 b0 10 80 	movsbl -0x7fef5000(%edx),%ecx
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
80100347:	68 c0 27 11 80       	push   $0x801127c0
8010034c:	e8 3f 62 00 00       	call   80106590 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	pushl  0x8(%ebp)
80100355:	e8 06 30 00 00       	call   80103360 <ilock>
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
8010036d:	a3 80 b0 10 80       	mov    %eax,0x8010b080
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

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
80100389:	c7 05 f4 27 11 80 00 	movl   $0x0,0x801127f4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 40 00 00       	call   80104490 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 97 10 80       	push   $0x801097cd
801003a7:	e8 24 04 00 00       	call   801007d0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 1b 04 00 00       	call   801007d0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4b a3 10 80 	movl   $0x8010a34b,(%esp)
801003bc:	e8 0f 04 00 00       	call   801007d0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 60 00 00       	call   80106420 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
  for (i = 0; i < 10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 97 10 80       	push   $0x801097e1
801003dd:	e8 ee 03 00 00       	call   801007d0 <cprintf>
  for (i = 0; i < 10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 f8 27 11 80 01 	movl   $0x1,0x801127f8
801003f0:	00 00 00 
  for (;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80100465:	80 3d a0 b0 10 80 57 	cmpb   $0x57,0x8010b0a0
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
801004db:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
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
8010051a:	e8 61 62 00 00       	call   80106780 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010051f:	b8 80 07 00 00       	mov    $0x780,%eax
80100524:	83 c4 0c             	add    $0xc,%esp
80100527:	29 d8                	sub    %ebx,%eax
80100529:	01 c0                	add    %eax,%eax
8010052b:	50                   	push   %eax
8010052c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100533:	6a 00                	push   $0x0
80100535:	50                   	push   %eax
80100536:	e8 b5 61 00 00       	call   801066f0 <memset>
  outb(CRTPORT + 1, pos);
8010053b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010053e:	83 c4 10             	add    $0x10,%esp
80100541:	e9 6f ff ff ff       	jmp    801004b5 <cgaputc+0xb5>
80100546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010054d:	8d 76 00             	lea    0x0(%esi),%esi
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
801005a6:	68 e5 97 10 80       	push   $0x801097e5
801005ab:	e8 d0 fd ff ff       	call   80100380 <panic>

801005b0 <consputc>:
  if (panicked)
801005b0:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
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
801005e8:	e8 03 7d 00 00       	call   801082f0 <uartputc>
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
80100603:	e8 e8 7c 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
80100608:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010060f:	e8 dc 7c 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
80100614:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010061b:	e8 d0 7c 00 00       	call   801082f0 <uartputc>
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
8010063d:	e8 ae 7c 00 00       	call   801082f0 <uartputc>
    uartputc('[');
80100642:	c7 04 24 5b 00 00 00 	movl   $0x5b,(%esp)
80100649:	e8 a2 7c 00 00       	call   801082f0 <uartputc>
    uartputc('C');
8010064e:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80100655:	e8 96 7c 00 00       	call   801082f0 <uartputc>
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
80100698:	e8 53 7c 00 00       	call   801082f0 <uartputc>
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
801006dc:	ff 75 08             	pushl  0x8(%ebp)
801006df:	e8 5c 2d 00 00       	call   80103440 <iunlock>
  acquire(&cons.lock);
801006e4:	c7 04 24 c0 27 11 80 	movl   $0x801127c0,(%esp)
801006eb:	e8 00 5f 00 00       	call   801065f0 <acquire>
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
80100712:	68 c0 27 11 80       	push   $0x801127c0
80100717:	e8 74 5e 00 00       	call   80106590 <release>
  ilock(ip);
8010071c:	58                   	pop    %eax
8010071d:	ff 75 08             	pushl  0x8(%ebp)
80100720:	e8 3b 2c 00 00       	call   80103360 <ilock>

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
8010075b:	0f b6 92 e0 98 10 80 	movzbl -0x7fef6720(%edx),%edx
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
80100781:	a1 f8 27 11 80       	mov    0x801127f8,%eax
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
80100794:	e8 57 7b 00 00       	call   801082f0 <uartputc>
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
801007c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801007d0 <cprintf>:
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	57                   	push   %edi
801007d4:	56                   	push   %esi
801007d5:	53                   	push   %ebx
801007d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007d9:	8b 3d f4 27 11 80    	mov    0x801127f4,%edi
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
80100892:	a1 f8 27 11 80       	mov    0x801127f8,%eax
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
801008ce:	8b 0d f8 27 11 80    	mov    0x801127f8,%ecx
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
80100900:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
80100906:	85 d2                	test   %edx,%edx
80100908:	74 3e                	je     80100948 <cprintf+0x178>
8010090a:	fa                   	cli    
    for (;;)
8010090b:	eb fe                	jmp    8010090b <cprintf+0x13b>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&cons.lock);
80100910:	83 ec 0c             	sub    $0xc,%esp
80100913:	68 c0 27 11 80       	push   $0x801127c0
80100918:	e8 d3 5c 00 00       	call   801065f0 <acquire>
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
80100936:	68 c0 27 11 80       	push   $0x801127c0
8010093b:	e8 50 5c 00 00       	call   80106590 <release>
80100940:	83 c4 10             	add    $0x10,%esp
80100943:	e9 14 ff ff ff       	jmp    8010085c <cprintf+0x8c>
    uartputc(c);
80100948:	83 ec 0c             	sub    $0xc,%esp
8010094b:	6a 25                	push   $0x25
8010094d:	e8 9e 79 00 00       	call   801082f0 <uartputc>
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
8010096c:	e8 7f 79 00 00       	call   801082f0 <uartputc>
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
80100990:	bf f8 97 10 80       	mov    $0x801097f8,%edi
80100995:	e9 28 ff ff ff       	jmp    801008c2 <cprintf+0xf2>
    uartputc(c);
8010099a:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010099d:	0f be f0             	movsbl %al,%esi
      for (; *s; s++)
801009a0:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009a3:	56                   	push   %esi
801009a4:	e8 47 79 00 00       	call   801082f0 <uartputc>
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
801009d7:	68 ff 97 10 80       	push   $0x801097ff
801009dc:	e8 9f f9 ff ff       	call   80100380 <panic>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009ef:	90                   	nop

801009f0 <printbuf>:
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	56                   	push   %esi
801009f4:	53                   	push   %ebx
  for (uint i = input.e + 1; i < input.end_pos; i++)
801009f5:	a1 88 b0 10 80       	mov    0x8010b088,%eax
801009fa:	8d 58 01             	lea    0x1(%eax),%ebx
801009fd:	3b 1d 8c b0 10 80    	cmp    0x8010b08c,%ebx
80100a03:	73 3c                	jae    80100a41 <printbuf+0x51>
    consputc(input.buf[i % INPUT_BUF]);
80100a05:	89 d8                	mov    %ebx,%eax
  if (panicked)
80100a07:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
    consputc(input.buf[i % INPUT_BUF]);
80100a0d:	83 e0 7f             	and    $0x7f,%eax
80100a10:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
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
80100a2a:	e8 c1 78 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80100a2f:	89 f0                	mov    %esi,%eax
80100a31:	e8 ca f9 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e + 1; i < input.end_pos; i++)
80100a36:	83 c4 10             	add    $0x10,%esp
80100a39:	3b 1d 8c b0 10 80    	cmp    0x8010b08c,%ebx
80100a3f:	72 c4                	jb     80100a05 <printbuf+0x15>
}
80100a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100a44:	5b                   	pop    %ebx
80100a45:	5e                   	pop    %esi
80100a46:	5d                   	pop    %ebp
80100a47:	c3                   	ret    
80100a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a4f:	90                   	nop

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
80100a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
80100b09:	8b 3d 8c b0 10 80    	mov    0x8010b08c,%edi
80100b0f:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80100b14:	8d 57 ff             	lea    -0x1(%edi),%edx
80100b17:	39 d0                	cmp    %edx,%eax
80100b19:	0f 83 c2 00 00 00    	jae    80100be1 <move_chars_left+0xe1>
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100b1f:	8d 70 01             	lea    0x1(%eax),%esi
80100b22:	83 e0 7f             	and    $0x7f,%eax
80100b25:	89 f2                	mov    %esi,%edx
80100b27:	83 e2 7f             	and    $0x7f,%edx
80100b2a:	0f be 9a 00 b0 10 80 	movsbl -0x7fef5000(%edx),%ebx
80100b31:	88 98 00 b0 10 80    	mov    %bl,-0x7fef5000(%eax)
  if (panicked)
80100b37:	a1 f8 27 11 80       	mov    0x801127f8,%eax
80100b3c:	85 c0                	test   %eax,%eax
80100b3e:	74 08                	je     80100b48 <move_chars_left+0x48>
  asm volatile("cli");
80100b40:	fa                   	cli    
    for (;;)
80100b41:	eb fe                	jmp    80100b41 <move_chars_left+0x41>
80100b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b47:	90                   	nop
    uartputc(c);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	53                   	push   %ebx
80100b4c:	e8 9f 77 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80100b51:	89 d8                	mov    %ebx,%eax
80100b53:	e8 a8 f8 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100b58:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	8d 50 ff             	lea    -0x1(%eax),%edx
80100b63:	39 d6                	cmp    %edx,%esi
80100b65:	73 04                	jae    80100b6b <move_chars_left+0x6b>
80100b67:	89 f0                	mov    %esi,%eax
80100b69:	eb b4                	jmp    80100b1f <move_chars_left+0x1f>
  for (uint i = input.e; i < input.end_pos - 1; i++)
80100b6b:	8b 3d 88 b0 10 80    	mov    0x8010b088,%edi
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
80100bf9:	8b 1d 88 b0 10 80    	mov    0x8010b088,%ebx
80100bff:	39 1d 8c b0 10 80    	cmp    %ebx,0x8010b08c
80100c05:	0f 82 ce 00 00 00    	jb     80100cd9 <move_chars_right+0xe9>
    input.buf[(i) % INPUT_BUF] = copy_buf[(i - 1) % INPUT_BUF];
80100c0b:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100c0e:	89 da                	mov    %ebx,%edx
80100c10:	83 e0 7f             	and    $0x7f,%eax
80100c13:	83 e2 7f             	and    $0x7f,%edx
80100c16:	0f b6 80 20 27 11 80 	movzbl -0x7feed8e0(%eax),%eax
80100c1d:	88 82 00 b0 10 80    	mov    %al,-0x7fef5000(%edx)
  if (panicked)
80100c23:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
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
80100c3a:	e8 b1 76 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80100c3f:	89 f0                	mov    %esi,%eax
80100c41:	e8 ba f7 ff ff       	call   80100400 <cgaputc>
  for (uint i = input.e; i <= input.end_pos; i++)
80100c46:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
80100c4b:	83 c4 10             	add    $0x10,%esp
80100c4e:	39 d8                	cmp    %ebx,%eax
80100c50:	73 b9                	jae    80100c0b <move_chars_right+0x1b>
  for (uint i = input.e; i <= input.end_pos; i++)
80100c52:	8b 35 88 b0 10 80    	mov    0x8010b088,%esi
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
80100cc9:	e8 22 76 00 00       	call   801082f0 <uartputc>
  for (uint i = input.e; i <= input.end_pos; i++)
80100cce:	83 c4 10             	add    $0x10,%esp
80100cd1:	39 35 8c b0 10 80    	cmp    %esi,0x8010b08c
80100cd7:	73 8f                	jae    80100c68 <move_chars_right+0x78>
}
80100cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cdc:	5b                   	pop    %ebx
80100cdd:	5e                   	pop    %esi
80100cde:	5f                   	pop    %edi
80100cdf:	5d                   	pop    %ebp
80100ce0:	c3                   	ret    
80100ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cef:	90                   	nop

80100cf0 <move_to_first_current>:
{
80100cf0:	55                   	push   %ebp
80100cf1:	89 e5                	mov    %esp,%ebp
80100cf3:	57                   	push   %edi
80100cf4:	56                   	push   %esi
80100cf5:	53                   	push   %ebx
80100cf6:	83 ec 08             	sub    $0x8,%esp
  while (j > input.w)
80100cf9:	a1 84 b0 10 80       	mov    0x8010b084,%eax
  int j = input.e;
80100cfe:	8b 35 88 b0 10 80    	mov    0x8010b088,%esi
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
80100d9a:	80 b8 00 b0 10 80 20 	cmpb   $0x20,-0x7fef5000(%eax)
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
80100e0b:	89 1d 88 b0 10 80    	mov    %ebx,0x8010b088
}
80100e11:	83 c4 08             	add    $0x8,%esp
80100e14:	5b                   	pop    %ebx
80100e15:	5e                   	pop    %esi
80100e16:	5f                   	pop    %edi
80100e17:	5d                   	pop    %ebp
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e20:	89 1d 88 b0 10 80    	mov    %ebx,0x8010b088
80100e26:	83 c4 08             	add    $0x8,%esp
80100e29:	5b                   	pop    %ebx
80100e2a:	5e                   	pop    %esi
80100e2b:	5f                   	pop    %edi
80100e2c:	5d                   	pop    %ebp
80100e2d:	c3                   	ret    
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <move_to_first_previous>:
  int j = input.e;
80100e30:	8b 0d 88 b0 10 80    	mov    0x8010b088,%ecx
  while (j > input.w)
80100e36:	8b 15 84 b0 10 80    	mov    0x8010b084,%edx
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
80100e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e67:	90                   	nop
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
80100f04:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
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
80100f7d:	a3 88 b0 10 80       	mov    %eax,0x8010b088
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
80100fb0:	89 3d 88 b0 10 80    	mov    %edi,0x8010b088
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
8010100a:	2b 0d 88 b0 10 80    	sub    0x8010b088,%ecx
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
8010104d:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
    consputc(input.buf[i % INPUT_BUF]);
80101053:	83 e0 7f             	and    $0x7f,%eax
80101056:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
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
80101072:	e8 79 72 00 00       	call   801082f0 <uartputc>
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
80101097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109e:	66 90                	xchg   %ax,%ax
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
80101189:	8b 0d 94 b0 10 80    	mov    0x8010b094,%ecx
8010118f:	8b 35 98 b0 10 80    	mov    0x8010b098,%esi
  input.mode = 0;
80101195:	c7 05 9c b0 10 80 00 	movl   $0x0,0x8010b09c
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
80101203:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80101208:	83 c0 01             	add    $0x1,%eax
8010120b:	a3 88 b0 10 80       	mov    %eax,0x8010b088
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
80101225:	89 0d 98 b0 10 80    	mov    %ecx,0x8010b098
8010122b:	b8 0e 00 00 00       	mov    $0xe,%eax
    move_cursor(1 + (int)(input.s2 - input.s1));
80101230:	29 f1                	sub    %esi,%ecx
    input.s1 = input.s2;
80101232:	89 35 94 b0 10 80    	mov    %esi,0x8010b094
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
80101291:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80101296:	8d 44 01 01          	lea    0x1(%ecx,%eax,1),%eax
{
8010129a:	31 db                	xor    %ebx,%ebx
    if (input.e < input.end_pos)
8010129c:	8b 15 8c b0 10 80    	mov    0x8010b08c,%edx
      input.e--;
801012a2:	8d 70 ff             	lea    -0x1(%eax),%esi
  if (panicked)
801012a5:	8b 0d f8 27 11 80    	mov    0x801127f8,%ecx
      input.e--;
801012ab:	89 35 88 b0 10 80    	mov    %esi,0x8010b088
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
801012c3:	89 15 8c b0 10 80    	mov    %edx,0x8010b08c
  if (panicked)
801012c9:	85 c9                	test   %ecx,%ecx
801012cb:	75 4c                	jne    80101319 <delete_selected+0x199>
    uartputc('\b');
801012cd:	83 ec 0c             	sub    $0xc,%esp
801012d0:	6a 08                	push   $0x8
801012d2:	e8 19 70 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
801012d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801012de:	e8 0d 70 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
801012e3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801012ea:	e8 01 70 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801012ef:	b8 00 01 00 00       	mov    $0x100,%eax
801012f4:	e8 07 f1 ff ff       	call   80100400 <cgaputc>
}
801012f9:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
801012fc:	a1 98 b0 10 80       	mov    0x8010b098,%eax
80101301:	83 c3 01             	add    $0x1,%ebx
80101304:	2b 05 94 b0 10 80    	sub    0x8010b094,%eax
8010130a:	39 d8                	cmp    %ebx,%eax
8010130c:	0f 8c 06 ff ff ff    	jl     80101218 <delete_selected+0x98>
80101312:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80101317:	eb 83                	jmp    8010129c <delete_selected+0x11c>
80101319:	fa                   	cli    
    for (;;)
8010131a:	eb fe                	jmp    8010131a <delete_selected+0x19a>
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80101320:	83 ec 0c             	sub    $0xc,%esp
80101323:	6a 08                	push   $0x8
80101325:	e8 c6 6f 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
8010132a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101331:	e8 ba 6f 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
80101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010133d:	e8 ae 6f 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80101342:	b8 00 01 00 00       	mov    $0x100,%eax
80101347:	e8 b4 f0 ff ff       	call   80100400 <cgaputc>
      move_chars_left();  //NOTE
8010134c:	e8 af f7 ff ff       	call   80100b00 <move_chars_left>
      input.end_pos--;
80101351:	83 2d 8c b0 10 80 01 	subl   $0x1,0x8010b08c
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
80101386:	8b 14 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%edx
8010138d:	8b 04 c5 20 1f 11 80 	mov    -0x7feee0e0(,%eax,8),%eax
80101394:	89 14 dd 24 1f 11 80 	mov    %edx,-0x7feee0dc(,%ebx,8)
8010139b:	89 04 dd 20 1f 11 80 	mov    %eax,-0x7feee0e0(,%ebx,8)
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
801013b8:	8b 14 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%edx
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
801013d5:	8b 14 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%edx
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
80101405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
8010142b:	8b 04 cd 20 1f 11 80 	mov    -0x7feee0e0(,%ecx,8),%eax
80101432:	8b 14 cd 24 1f 11 80 	mov    -0x7feee0dc(,%ecx,8),%edx
80101439:	89 04 cd 18 1f 11 80 	mov    %eax,-0x7feee0e8(,%ecx,8)
80101440:	89 14 cd 1c 1f 11 80 	mov    %edx,-0x7feee0e4(,%ecx,8)
  for (uint i = start_index; i < INPUT_BUF - 1; i++)
80101447:	83 f9 7f             	cmp    $0x7f,%ecx
8010144a:	75 dc                	jne    80101428 <move_timed_chars_left+0x18>
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
8010144c:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
80101451:	83 e8 01             	sub    $0x1,%eax
80101454:	39 c7                	cmp    %eax,%edi
80101456:	0f 83 c5 00 00 00    	jae    80101521 <move_timed_chars_left+0x111>
8010145c:	89 f8                	mov    %edi,%eax
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
8010145e:	8d 58 01             	lea    0x1(%eax),%ebx
80101461:	83 e0 7f             	and    $0x7f,%eax
80101464:	89 da                	mov    %ebx,%edx
80101466:	83 e2 7f             	and    $0x7f,%edx
80101469:	0f b6 92 00 b0 10 80 	movzbl -0x7fef5000(%edx),%edx
80101470:	88 90 00 b0 10 80    	mov    %dl,-0x7fef5000(%eax)
  if (panicked)
80101476:	a1 f8 27 11 80       	mov    0x801127f8,%eax
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
8010148f:	e8 5c 6e 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80101494:	89 f0                	mov    %esi,%eax
80101496:	e8 65 ef ff ff       	call   80100400 <cgaputc>
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
8010149b:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
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
80101538:	c7 04 c5 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%eax,8)
8010153f:	00 00 00 00 
    times_buf[i].c = '\0';
80101543:	c6 04 c5 20 1f 11 80 	movb   $0x0,-0x7feee0e0(,%eax,8)
8010154a:	00 
  for (int i = 0; i < INPUT_BUF; i++)
8010154b:	83 c0 01             	add    $0x1,%eax
8010154e:	3d 80 00 00 00       	cmp    $0x80,%eax
80101553:	75 e3                	jne    80101538 <clear_char_time_array+0x8>
}
80101555:	c3                   	ret    
80101556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155d:	8d 76 00             	lea    0x0(%esi),%esi

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
80101597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010159e:	66 90                	xchg   %ax,%ax

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
801015b3:	8b 14 9d c0 b0 10 80 	mov    -0x7fef4f40(,%ebx,4),%edx
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
80101625:	68 c0 27 11 80       	push   $0x801127c0
8010162a:	e8 c1 4f 00 00       	call   801065f0 <acquire>
  if (input.e > input.end_pos)
8010162f:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80101634:	83 c4 10             	add    $0x10,%esp
80101637:	39 05 8c b0 10 80    	cmp    %eax,0x8010b08c
8010163d:	73 05                	jae    80101644 <consoleintr+0x34>
    input.end_pos = input.e;
8010163f:	a3 8c b0 10 80       	mov    %eax,0x8010b08c
    switch (c)
80101644:	c7 85 60 fe ff ff 00 	movl   $0x0,-0x1a0(%ebp)
8010164b:	00 00 00 
  while ((c = getc()) >= 0)
8010164e:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
80101654:	ff d0                	call   *%eax
80101656:	85 c0                	test   %eax,%eax
80101658:	0f 88 ca 00 00 00    	js     80101728 <consoleintr+0x118>
    if (c == '\n')
8010165e:	83 f8 0a             	cmp    $0xa,%eax
80101661:	74 1d                	je     80101680 <consoleintr+0x70>
    switch (c)
80101663:	83 f8 1a             	cmp    $0x1a,%eax
80101666:	0f 8f e4 00 00 00    	jg     80101750 <consoleintr+0x140>
8010166c:	85 c0                	test   %eax,%eax
8010166e:	74 de                	je     8010164e <consoleintr+0x3e>
80101670:	83 f8 1a             	cmp    $0x1a,%eax
80101673:	0f 87 47 01 00 00    	ja     801017c0 <consoleintr+0x1b0>
80101679:	ff 24 85 74 98 10 80 	jmp    *-0x7fef678c(,%eax,4)
      tab_count = 0;
80101680:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80101687:	00 00 00 
  if (panicked)
8010168a:	8b 1d f8 27 11 80    	mov    0x801127f8,%ebx
80101690:	85 db                	test   %ebx,%ebx
80101692:	0f 85 20 01 00 00    	jne    801017b8 <consoleintr+0x1a8>
    uartputc(c);
80101698:	83 ec 0c             	sub    $0xc,%esp
8010169b:	6a 0a                	push   $0xa
8010169d:	e8 4e 6c 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801016a2:	b8 0a 00 00 00       	mov    $0xa,%eax
801016a7:	e8 54 ed ff ff       	call   80100400 <cgaputc>
  input.buf[input.end_pos++ % INPUT_BUF] = c;
801016ac:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
801016b1:	8d 50 01             	lea    0x1(%eax),%edx
801016b4:	83 e0 7f             	and    $0x7f,%eax
801016b7:	89 15 8c b0 10 80    	mov    %edx,0x8010b08c
801016bd:	c6 80 00 b0 10 80 0a 	movb   $0xa,-0x7fef5000(%eax)
  input.w = input.end_pos;
801016c4:	89 15 84 b0 10 80    	mov    %edx,0x8010b084
  input.e = input.end_pos;
801016ca:	89 15 88 b0 10 80    	mov    %edx,0x8010b088
  wakeup(&input.r);
801016d0:	c7 04 24 80 b0 10 80 	movl   $0x8010b080,(%esp)
801016d7:	e8 34 48 00 00       	call   80105f10 <wakeup>
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	90                   	nop
    times_buf[i].time = 0;
801016e0:	c7 04 dd 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%ebx,8)
801016e7:	00 00 00 00 
    times_buf[i].c = '\0';
801016eb:	c6 04 dd 20 1f 11 80 	movb   $0x0,-0x7feee0e0(,%ebx,8)
801016f2:	00 
  for (int i = 0; i < INPUT_BUF; i++)
801016f3:	83 c3 01             	add    $0x1,%ebx
801016f6:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801016fc:	75 e2                	jne    801016e0 <consoleintr+0xd0>
  input.time = 0;
801016fe:	c7 05 90 b0 10 80 00 	movl   $0x0,0x8010b090
80101705:	00 00 00 
  while ((c = getc()) >= 0)
80101708:	8b 85 64 fe ff ff    	mov    -0x19c(%ebp),%eax
  tab_count = 0;
8010170e:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80101715:	00 00 00 
  while ((c = getc()) >= 0)
80101718:	ff d0                	call   *%eax
8010171a:	85 c0                	test   %eax,%eax
8010171c:	0f 89 3c ff ff ff    	jns    8010165e <consoleintr+0x4e>
80101722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&cons.lock);
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	68 c0 27 11 80       	push   $0x801127c0
80101730:	e8 5b 4e 00 00       	call   80106590 <release>
  if (doprocdump)
80101735:	8b 85 60 fe ff ff    	mov    -0x1a0(%ebp),%eax
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	85 c0                	test   %eax,%eax
80101740:	0f 85 40 07 00 00    	jne    80101e86 <consoleintr+0x876>
}
80101746:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101749:	5b                   	pop    %ebx
8010174a:	5e                   	pop    %esi
8010174b:	5f                   	pop    %edi
8010174c:	5d                   	pop    %ebp
8010174d:	c3                   	ret    
8010174e:	66 90                	xchg   %ax,%ax
    switch (c)
80101750:	3d e4 00 00 00       	cmp    $0xe4,%eax
80101755:	0f 84 15 01 00 00    	je     80101870 <consoleintr+0x260>
8010175b:	3d e5 00 00 00       	cmp    $0xe5,%eax
80101760:	0f 84 3a 01 00 00    	je     801018a0 <consoleintr+0x290>
80101766:	83 f8 7f             	cmp    $0x7f,%eax
80101769:	75 55                	jne    801017c0 <consoleintr+0x1b0>
      if (input.mode == 2)
8010176b:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101772:	0f 84 98 08 00 00    	je     80102010 <consoleintr+0xa00>
      if (input.e != input.w)
80101778:	a1 88 b0 10 80       	mov    0x8010b088,%eax
8010177d:	8b 0d 84 b0 10 80    	mov    0x8010b084,%ecx
80101783:	39 c8                	cmp    %ecx,%eax
80101785:	0f 84 c3 fe ff ff    	je     8010164e <consoleintr+0x3e>
          input.e--;
8010178b:	8d 50 ff             	lea    -0x1(%eax),%edx
        if (input.e < input.end_pos)
8010178e:	3b 05 8c b0 10 80    	cmp    0x8010b08c,%eax
          input.e--;
80101794:	89 15 88 b0 10 80    	mov    %edx,0x8010b088
        if (input.e < input.end_pos)
8010179a:	0f 83 2c 07 00 00    	jae    80101ecc <consoleintr+0x8bc>
  if (panicked)
801017a0:	8b 1d f8 27 11 80    	mov    0x801127f8,%ebx
801017a6:	85 db                	test   %ebx,%ebx
801017a8:	0f 84 d0 07 00 00    	je     80101f7e <consoleintr+0x96e>
  asm volatile("cli");
801017ae:	fa                   	cli    
    for (;;)
801017af:	eb fe                	jmp    801017af <consoleintr+0x19f>
801017b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017b8:	fa                   	cli    
801017b9:	eb fe                	jmp    801017b9 <consoleintr+0x1a9>
801017bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
      if (c != 0 && input.e - input.r < INPUT_BUF)
801017c0:	8b 1d 88 b0 10 80    	mov    0x8010b088,%ebx
801017c6:	89 da                	mov    %ebx,%edx
801017c8:	2b 15 80 b0 10 80    	sub    0x8010b080,%edx
801017ce:	83 fa 7f             	cmp    $0x7f,%edx
801017d1:	0f 87 77 fe ff ff    	ja     8010164e <consoleintr+0x3e>
        if (input.mode == 2)
801017d7:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
801017de:	0f 84 2c 0c 00 00    	je     80102410 <consoleintr+0xe00>
        if ((input.e < input.end_pos) && c != '\n')
801017e4:	8b 15 8c b0 10 80    	mov    0x8010b08c,%edx
801017ea:	39 d3                	cmp    %edx,%ebx
801017ec:	0f 82 5e 0b 00 00    	jb     80102350 <consoleintr+0xd40>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
801017f2:	8b 3d 80 b0 10 80    	mov    0x8010b080,%edi
          input.buf[input.end_pos++ % INPUT_BUF] = c; 
801017f8:	8d 4a 01             	lea    0x1(%edx),%ecx
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
801017fb:	8d b7 80 00 00 00    	lea    0x80(%edi),%esi
80101801:	39 de                	cmp    %ebx,%esi
80101803:	0f 84 5f 0c 00 00    	je     80102468 <consoleintr+0xe58>
        input.buf[input.e++ % INPUT_BUF] = c;
80101809:	8d 73 01             	lea    0x1(%ebx),%esi
8010180c:	89 35 88 b0 10 80    	mov    %esi,0x8010b088
80101812:	89 de                	mov    %ebx,%esi
80101814:	83 e6 7f             	and    $0x7f,%esi
80101817:	88 86 00 b0 10 80    	mov    %al,-0x7fef5000(%esi)
        if (input.e == input.end_pos + 1)
8010181d:	39 da                	cmp    %ebx,%edx
8010181f:	0f 85 29 fe ff ff    	jne    8010164e <consoleintr+0x3e>
          input.end_pos++;
80101825:	89 0d 8c b0 10 80    	mov    %ecx,0x8010b08c
          consputc(c);
8010182b:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
80101831:	e8 7a ed ff ff       	call   801005b0 <consputc>
          uint last_char_time_position_index = input.e - input.w - 1;
80101836:	a1 88 b0 10 80       	mov    0x8010b088,%eax
8010183b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010183e:	2b 15 84 b0 10 80    	sub    0x8010b084,%edx
          times_buf[last_char_time_position_index] = new_char;
80101844:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
          uint last_char_time_position_index = input.e - input.w - 1;
8010184a:	89 d3                	mov    %edx,%ebx
          new_char.time = input.time++;
8010184c:	8b 15 90 b0 10 80    	mov    0x8010b090,%edx
          times_buf[last_char_time_position_index] = new_char;
80101852:	88 04 dd 20 1f 11 80 	mov    %al,-0x7feee0e0(,%ebx,8)
          new_char.time = input.time++;
80101859:	8d 4a 01             	lea    0x1(%edx),%ecx
          times_buf[last_char_time_position_index] = new_char;
8010185c:	89 14 dd 24 1f 11 80 	mov    %edx,-0x7feee0dc(,%ebx,8)
          new_char.time = input.time++;
80101863:	89 0d 90 b0 10 80    	mov    %ecx,0x8010b090
          times_buf[last_char_time_position_index] = new_char;
80101869:	e9 e0 fd ff ff       	jmp    8010164e <consoleintr+0x3e>
8010186e:	66 90                	xchg   %ax,%ax
      if (input.mode == 2)
80101870:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101877:	0f 84 e3 05 00 00    	je     80101e60 <consoleintr+0x850>
      if (input.e > input.w)
8010187d:	a1 88 b0 10 80       	mov    0x8010b088,%eax
80101882:	39 05 84 b0 10 80    	cmp    %eax,0x8010b084
80101888:	0f 83 c0 fd ff ff    	jae    8010164e <consoleintr+0x3e>
  if (panicked)
8010188e:	8b 3d f8 27 11 80    	mov    0x801127f8,%edi
80101894:	85 ff                	test   %edi,%edi
80101896:	0f 84 9a 06 00 00    	je     80101f36 <consoleintr+0x926>
8010189c:	fa                   	cli    
    for (;;)
8010189d:	eb fe                	jmp    8010189d <consoleintr+0x28d>
8010189f:	90                   	nop
      if (input.mode == 2)
801018a0:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
801018a7:	0f 84 b3 05 00 00    	je     80101e60 <consoleintr+0x850>
      if (input.e < input.end_pos)
801018ad:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
801018b2:	39 05 88 b0 10 80    	cmp    %eax,0x8010b088
801018b8:	0f 83 90 fd ff ff    	jae    8010164e <consoleintr+0x3e>
        consputc(KEY_RIGHT);
801018be:	b8 e5 00 00 00       	mov    $0xe5,%eax
801018c3:	e8 e8 ec ff ff       	call   801005b0 <consputc>
        input.e++;
801018c8:	83 05 88 b0 10 80 01 	addl   $0x1,0x8010b088
801018cf:	e9 7a fd ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 2)
801018d4:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
801018db:	0f 84 7f 05 00 00    	je     80101e60 <consoleintr+0x850>
      if (input.e != input.w)
801018e1:	a1 88 b0 10 80       	mov    0x8010b088,%eax
801018e6:	3b 05 84 b0 10 80    	cmp    0x8010b084,%eax
801018ec:	0f 84 5c fd ff ff    	je     8010164e <consoleintr+0x3e>
        if (input.buf[j % INPUT_BUF] == ' ' || input.buf[(j - 1) % INPUT_BUF] == ' ')
801018f2:	89 c1                	mov    %eax,%ecx
801018f4:	c1 f9 1f             	sar    $0x1f,%ecx
801018f7:	c1 e9 19             	shr    $0x19,%ecx
801018fa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
801018fd:	83 e2 7f             	and    $0x7f,%edx
80101900:	29 ca                	sub    %ecx,%edx
80101902:	80 ba 00 b0 10 80 20 	cmpb   $0x20,-0x7fef5000(%edx)
80101909:	74 1b                	je     80101926 <consoleintr+0x316>
8010190b:	83 e8 01             	sub    $0x1,%eax
8010190e:	99                   	cltd   
8010190f:	c1 ea 19             	shr    $0x19,%edx
80101912:	01 d0                	add    %edx,%eax
80101914:	83 e0 7f             	and    $0x7f,%eax
80101917:	29 d0                	sub    %edx,%eax
80101919:	80 b8 00 b0 10 80 20 	cmpb   $0x20,-0x7fef5000(%eax)
80101920:	0f 85 d2 05 00 00    	jne    80101ef8 <consoleintr+0x8e8>
          move_to_first_previous();
80101926:	e8 05 f5 ff ff       	call   80100e30 <move_to_first_previous>
8010192b:	e9 1e fd ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 2)
80101930:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101937:	0f 84 23 05 00 00    	je     80101e60 <consoleintr+0x850>
      int j = input.e;
8010193d:	a1 88 b0 10 80       	mov    0x8010b088,%eax
      while (j <= input.end_pos)
80101942:	8b 3d 8c b0 10 80    	mov    0x8010b08c,%edi
      int j = input.e;
80101948:	89 c1                	mov    %eax,%ecx
      while (j <= input.end_pos)
8010194a:	39 c7                	cmp    %eax,%edi
8010194c:	0f 82 fc fc ff ff    	jb     8010164e <consoleintr+0x3e>
      int flag = 0;
80101952:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
      int step = 0;
80101958:	31 d2                	xor    %edx,%edx
      int flag = 0;
8010195a:	31 f6                	xor    %esi,%esi
8010195c:	eb 1a                	jmp    80101978 <consoleintr+0x368>
8010195e:	66 90                	xchg   %ax,%ax
        if (input.buf[j % INPUT_BUF] == ' ')
80101960:	3c 20                	cmp    $0x20,%al
80101962:	0f 94 c0             	sete   %al
80101965:	0f b6 c0             	movzbl %al,%eax
80101968:	89 c6                	mov    %eax,%esi
        j++;
8010196a:	83 c1 01             	add    $0x1,%ecx
        step++;
8010196d:	83 c2 01             	add    $0x1,%edx
      while (j <= input.end_pos)
80101970:	39 cf                	cmp    %ecx,%edi
80101972:	0f 82 d6 fc ff ff    	jb     8010164e <consoleintr+0x3e>
        if (flag == 1 && input.buf[j % INPUT_BUF] != ' ')
80101978:	89 cb                	mov    %ecx,%ebx
8010197a:	c1 fb 1f             	sar    $0x1f,%ebx
8010197d:	c1 eb 19             	shr    $0x19,%ebx
80101980:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
80101983:	83 e0 7f             	and    $0x7f,%eax
80101986:	29 d8                	sub    %ebx,%eax
80101988:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
8010198f:	83 fe 01             	cmp    $0x1,%esi
80101992:	75 cc                	jne    80101960 <consoleintr+0x350>
80101994:	3c 20                	cmp    $0x20,%al
80101996:	74 d2                	je     8010196a <consoleintr+0x35a>
80101998:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010199e:	be d4 03 00 00       	mov    $0x3d4,%esi
        for (int i = 0; i < step; i++)
801019a3:	c7 85 5c fe ff ff 00 	movl   $0x0,-0x1a4(%ebp)
801019aa:	00 00 00 
801019ad:	85 d2                	test   %edx,%edx
801019af:	0f 84 99 fc ff ff    	je     8010164e <consoleintr+0x3e>
801019b5:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
801019bb:	89 95 54 fe ff ff    	mov    %edx,-0x1ac(%ebp)
801019c1:	b8 0e 00 00 00       	mov    $0xe,%eax
801019c6:	89 f2                	mov    %esi,%edx
801019c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801019c9:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801019ce:	89 da                	mov    %ebx,%edx
801019d0:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801019d1:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
801019d6:	0f b6 c8             	movzbl %al,%ecx
801019d9:	89 f2                	mov    %esi,%edx
801019db:	c1 e1 08             	shl    $0x8,%ecx
801019de:	89 f8                	mov    %edi,%eax
801019e0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801019e1:	89 da                	mov    %ebx,%edx
801019e3:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801019e4:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801019e7:	89 f2                	mov    %esi,%edx
801019e9:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
801019eb:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801019f0:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
801019f3:	39 c1                	cmp    %eax,%ecx
801019f5:	0f 4f c8             	cmovg  %eax,%ecx
801019f8:	b8 0e 00 00 00       	mov    $0xe,%eax
801019fd:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801019fe:	89 c8                	mov    %ecx,%eax
80101a00:	89 da                	mov    %ebx,%edx
80101a02:	c1 f8 08             	sar    $0x8,%eax
80101a05:	ee                   	out    %al,(%dx)
80101a06:	89 f8                	mov    %edi,%eax
80101a08:	89 f2                	mov    %esi,%edx
80101a0a:	ee                   	out    %al,(%dx)
80101a0b:	89 c8                	mov    %ecx,%eax
80101a0d:	89 da                	mov    %ebx,%edx
80101a0f:	ee                   	out    %al,(%dx)
        for (int i = 0; i < step; i++)
80101a10:	83 85 5c fe ff ff 01 	addl   $0x1,-0x1a4(%ebp)
80101a17:	8b bd 54 fe ff ff    	mov    -0x1ac(%ebp),%edi
80101a1d:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80101a23:	39 f8                	cmp    %edi,%eax
80101a25:	75 9a                	jne    801019c1 <consoleintr+0x3b1>
80101a27:	8b 85 50 fe ff ff    	mov    -0x1b0(%ebp),%eax
80101a2d:	8b bd 5c fe ff ff    	mov    -0x1a4(%ebp),%edi
80101a33:	01 c7                	add    %eax,%edi
80101a35:	89 3d 88 b0 10 80    	mov    %edi,0x8010b088
80101a3b:	e9 0e fc ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 2)
80101a40:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101a47:	0f 85 01 fc ff ff    	jne    8010164e <consoleintr+0x3e>
        is_copy = 1;
80101a4d:	c7 05 88 1e 11 80 01 	movl   $0x1,0x80111e88
80101a54:	00 00 00 
80101a57:	31 c0                	xor    %eax,%eax
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          ctrl_c[i] = input.buf[i];
80101a60:	8b 90 00 b0 10 80    	mov    -0x7fef5000(%eax),%edx
80101a66:	83 c0 04             	add    $0x4,%eax
80101a69:	89 90 9c 1e 11 80    	mov    %edx,-0x7feee164(%eax)
        for (int i = 0; i < INPUT_BUF; i++)
80101a6f:	3d 80 00 00 00       	cmp    $0x80,%eax
80101a74:	75 ea                	jne    80101a60 <consoleintr+0x450>
        if (input.s1 <= input.s2)
80101a76:	8b 0d 94 b0 10 80    	mov    0x8010b094,%ecx
80101a7c:	8b 1d 98 b0 10 80    	mov    0x8010b098,%ebx
          inedx_copy1 = input.s1 % INPUT_BUF;
80101a82:	89 c8                	mov    %ecx,%eax
          inedx_copy2 = input.s2 % INPUT_BUF;
80101a84:	89 da                	mov    %ebx,%edx
80101a86:	83 e2 7f             	and    $0x7f,%edx
          inedx_copy1 = input.s1 % INPUT_BUF;
80101a89:	83 e0 7f             	and    $0x7f,%eax
        if (input.s1 <= input.s2)
80101a8c:	39 cb                	cmp    %ecx,%ebx
80101a8e:	0f 82 e4 07 00 00    	jb     80102278 <consoleintr+0xc68>
          inedx_copy1 = input.s1 % INPUT_BUF;
80101a94:	a3 84 1e 11 80       	mov    %eax,0x80111e84
          inedx_copy2 = input.s2 % INPUT_BUF;
80101a99:	89 15 80 1e 11 80    	mov    %edx,0x80111e80
80101a9f:	e9 aa fb ff ff       	jmp    8010164e <consoleintr+0x3e>
80101aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint max_time = 0;
80101aa8:	31 c9                	xor    %ecx,%ecx
  for (uint i = 0; i < INPUT_BUF; i++)
80101aaa:	31 c0                	xor    %eax,%eax
      if (input.mode == 2)
80101aac:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101ab3:	0f 84 a7 03 00 00    	je     80101e60 <consoleintr+0x850>
80101ab9:	8b 9d 58 fe ff ff    	mov    -0x1a8(%ebp),%ebx
80101abf:	90                   	nop
    if (times_buf[i].time >= max_time)
80101ac0:	8b 14 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%edx
80101ac7:	39 ca                	cmp    %ecx,%edx
80101ac9:	72 04                	jb     80101acf <consoleintr+0x4bf>
      max_time = times_buf[i].time;
80101acb:	89 d1                	mov    %edx,%ecx
      max_index = i;
80101acd:	89 c3                	mov    %eax,%ebx
  for (uint i = 0; i < INPUT_BUF; i++)
80101acf:	83 c0 01             	add    $0x1,%eax
80101ad2:	3d 80 00 00 00       	cmp    $0x80,%eax
80101ad7:	75 e7                	jne    80101ac0 <consoleintr+0x4b0>
      uint interval = input.end_pos - input.w;
80101ad9:	a1 84 b0 10 80       	mov    0x8010b084,%eax
80101ade:	8b 15 8c b0 10 80    	mov    0x8010b08c,%edx
80101ae4:	89 9d 58 fe ff ff    	mov    %ebx,-0x1a8(%ebp)
      uint cursor_index = input.e - input.w - 1;
80101aea:	89 c1                	mov    %eax,%ecx
      uint absolute_char_index = input.w + removing_char_index;
80101aec:	01 c3                	add    %eax,%ebx
      uint cursor_index = input.e - input.w - 1;
80101aee:	f7 d1                	not    %ecx
80101af0:	03 0d 88 b0 10 80    	add    0x8010b088,%ecx
80101af6:	89 8d 5c fe ff ff    	mov    %ecx,-0x1a4(%ebp)
      if (input.end_pos == input.w)
80101afc:	39 c2                	cmp    %eax,%edx
80101afe:	0f 84 07 06 00 00    	je     8010210b <consoleintr+0xafb>
  if (panicked)
80101b04:	8b 3d f8 27 11 80    	mov    0x801127f8,%edi
      else if (cursor_index > removing_char_index)
80101b0a:	8b 8d 5c fe ff ff    	mov    -0x1a4(%ebp),%ecx
80101b10:	39 8d 58 fe ff ff    	cmp    %ecx,-0x1a8(%ebp)
80101b16:	0f 82 fe 04 00 00    	jb     8010201a <consoleintr+0xa0a>
      uint interval = input.end_pos - input.w;
80101b1c:	29 c2                	sub    %eax,%edx
      else if (cursor_index < removing_char_index && removing_char_index < interval)
80101b1e:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80101b24:	39 d0                	cmp    %edx,%eax
80101b26:	0f 83 a4 04 00 00    	jae    80101fd0 <consoleintr+0x9c0>
80101b2c:	8b b5 5c fe ff ff    	mov    -0x1a4(%ebp),%esi
80101b32:	39 c6                	cmp    %eax,%esi
80101b34:	0f 83 96 04 00 00    	jae    80101fd0 <consoleintr+0x9c0>
80101b3a:	89 9d 54 fe ff ff    	mov    %ebx,-0x1ac(%ebp)
        for (uint i = cursor_index; i < removing_char_index; i++)
80101b40:	89 f1                	mov    %esi,%ecx
80101b42:	be d4 03 00 00       	mov    $0x3d4,%esi
80101b47:	89 bd 50 fe ff ff    	mov    %edi,-0x1b0(%ebp)
80101b4d:	89 cf                	mov    %ecx,%edi
80101b4f:	b8 0e 00 00 00       	mov    $0xe,%eax
80101b54:	89 f2                	mov    %esi,%edx
80101b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b57:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101b5c:	89 da                	mov    %ebx,%edx
80101b5e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101b5f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b62:	89 f2                	mov    %esi,%edx
80101b64:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b69:	c1 e1 08             	shl    $0x8,%ecx
80101b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b6d:	89 da                	mov    %ebx,%edx
80101b6f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101b70:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101b77:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80101b7c:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80101b7f:	39 c1                	cmp    %eax,%ecx
80101b81:	0f 4f c8             	cmovg  %eax,%ecx
80101b84:	b8 0e 00 00 00       	mov    $0xe,%eax
80101b89:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101b8a:	89 ca                	mov    %ecx,%edx
80101b8c:	c1 fa 08             	sar    $0x8,%edx
80101b8f:	89 d0                	mov    %edx,%eax
80101b91:	89 da                	mov    %ebx,%edx
80101b93:	ee                   	out    %al,(%dx)
80101b94:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b99:	89 f2                	mov    %esi,%edx
80101b9b:	ee                   	out    %al,(%dx)
80101b9c:	89 c8                	mov    %ecx,%eax
80101b9e:	89 da                	mov    %ebx,%edx
80101ba0:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i < removing_char_index; i++)
80101ba1:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
80101ba7:	83 c7 01             	add    $0x1,%edi
80101baa:	39 c7                	cmp    %eax,%edi
80101bac:	72 a1                	jb     80101b4f <consoleintr+0x53f>
  if (panicked)
80101bae:	8b bd 50 fe ff ff    	mov    -0x1b0(%ebp),%edi
80101bb4:	8b 9d 54 fe ff ff    	mov    -0x1ac(%ebp),%ebx
80101bba:	85 ff                	test   %edi,%edi
80101bbc:	0f 84 c6 06 00 00    	je     80102288 <consoleintr+0xc78>
  asm volatile("cli");
80101bc2:	fa                   	cli    
    for (;;)
80101bc3:	eb fe                	jmp    80101bc3 <consoleintr+0x5b3>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
      if (input.e != input.end_pos) {
80101bc8:	8b 0d 88 b0 10 80    	mov    0x8010b088,%ecx
80101bce:	3b 0d 8c b0 10 80    	cmp    0x8010b08c,%ecx
80101bd4:	0f 85 74 fa ff ff    	jne    8010164e <consoleintr+0x3e>
      if (pos < (int)input.w) {
80101bda:	8b 35 84 b0 10 80    	mov    0x8010b084,%esi
      int pos = input.e - 1;
80101be0:	8d 51 ff             	lea    -0x1(%ecx),%edx
      if (pos < (int)input.w) {
80101be3:	39 d6                	cmp    %edx,%esi
80101be5:	7e 11                	jle    80101bf8 <consoleintr+0x5e8>
        tab_count = 0;
80101be7:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80101bee:	00 00 00 
        break;
80101bf1:	e9 58 fa ff ff       	jmp    8010164e <consoleintr+0x3e>
80101bf6:	89 c2                	mov    %eax,%edx
        char ch = input.buf[pos % INPUT_BUF];
80101bf8:	89 d3                	mov    %edx,%ebx
80101bfa:	c1 fb 1f             	sar    $0x1f,%ebx
80101bfd:	c1 eb 19             	shr    $0x19,%ebx
80101c00:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
80101c03:	83 e0 7f             	and    $0x7f,%eax
80101c06:	29 d8                	sub    %ebx,%eax
80101c08:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
        if (ch == ' ' || ch == '\n') 
80101c0f:	3c 20                	cmp    $0x20,%al
80101c11:	0f 84 81 08 00 00    	je     80102498 <consoleintr+0xe88>
80101c17:	3c 0a                	cmp    $0xa,%al
80101c19:	0f 84 79 08 00 00    	je     80102498 <consoleintr+0xe88>
        pos--;
80101c1f:	8d 42 ff             	lea    -0x1(%edx),%eax
      while (pos >= (int)input.w) {
80101c22:	39 c6                	cmp    %eax,%esi
80101c24:	7e d0                	jle    80101bf6 <consoleintr+0x5e6>
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101c26:	39 ca                	cmp    %ecx,%edx
80101c28:	7d bd                	jge    80101be7 <consoleintr+0x5d7>
80101c2a:	29 d1                	sub    %edx,%ecx
      int len = 0;
80101c2c:	31 db                	xor    %ebx,%ebx
80101c2e:	eb 05                	jmp    80101c35 <consoleintr+0x625>
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101c30:	83 fb 7f             	cmp    $0x7f,%ebx
80101c33:	74 27                	je     80101c5c <consoleintr+0x64c>
        user_input[len++] = input.buf[i % INPUT_BUF];
80101c35:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80101c38:	83 c3 01             	add    $0x1,%ebx
80101c3b:	89 c6                	mov    %eax,%esi
80101c3d:	c1 fe 1f             	sar    $0x1f,%esi
80101c40:	c1 ee 19             	shr    $0x19,%esi
80101c43:	01 f0                	add    %esi,%eax
80101c45:	83 e0 7f             	and    $0x7f,%eax
80101c48:	29 f0                	sub    %esi,%eax
80101c4a:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%eax),%eax
80101c51:	88 84 1d 67 fe ff ff 	mov    %al,-0x199(%ebp,%ebx,1)
      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
80101c58:	39 cb                	cmp    %ecx,%ebx
80101c5a:	75 d4                	jne    80101c30 <consoleintr+0x620>
      tab_count++;
80101c5c:	a1 a0 27 11 80       	mov    0x801127a0,%eax
      int m = collect_matches(user_input, cmd_indexes, 64);
80101c61:	83 ec 04             	sub    $0x4,%esp
80101c64:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
      user_input[len] = 0;
80101c6a:	c6 84 1d 68 fe ff ff 	movb   $0x0,-0x198(%ebp,%ebx,1)
80101c71:	00 
      tab_count++;
80101c72:	8d 50 01             	lea    0x1(%eax),%edx
      int m = collect_matches(user_input, cmd_indexes, 64);
80101c75:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
      tab_count++;
80101c7b:	89 15 a0 27 11 80    	mov    %edx,0x801127a0
80101c81:	89 95 54 fe ff ff    	mov    %edx,-0x1ac(%ebp)
      int m = collect_matches(user_input, cmd_indexes, 64);
80101c87:	6a 40                	push   $0x40
80101c89:	56                   	push   %esi
80101c8a:	50                   	push   %eax
80101c8b:	e8 10 f9 ff ff       	call   801015a0 <collect_matches>
      if (m == 0) {
80101c90:	83 c4 10             	add    $0x10,%esp
      int m = collect_matches(user_input, cmd_indexes, 64);
80101c93:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
      if (m == 0) {
80101c99:	85 c0                	test   %eax,%eax
80101c9b:	0f 84 46 ff ff ff    	je     80101be7 <consoleintr+0x5d7>
      else if (m == 1) {
80101ca1:	83 f8 01             	cmp    $0x1,%eax
80101ca4:	8b 95 54 fe ff ff    	mov    -0x1ac(%ebp),%edx
80101caa:	0f 84 fa 07 00 00    	je     801024aa <consoleintr+0xe9a>
        if (tab_count == 1) {
80101cb0:	83 fa 01             	cmp    $0x1,%edx
80101cb3:	0f 84 95 f9 ff ff    	je     8010164e <consoleintr+0x3e>
  if (panicked)
80101cb9:	8b 1d f8 27 11 80    	mov    0x801127f8,%ebx
80101cbf:	85 db                	test   %ebx,%ebx
80101cc1:	0f 84 5e 08 00 00    	je     80102525 <consoleintr+0xf15>
80101cc7:	fa                   	cli    
    for (;;)
80101cc8:	eb fe                	jmp    80101cc8 <consoleintr+0x6b8>
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (input.mode == 0)
80101cd0:	a1 9c b0 10 80       	mov    0x8010b09c,%eax
80101cd5:	85 c0                	test   %eax,%eax
80101cd7:	0f 85 6a 01 00 00    	jne    80101e47 <consoleintr+0x837>
        input.s1 = input.e;
80101cdd:	a1 88 b0 10 80       	mov    0x8010b088,%eax
        input.mode = 1;
80101ce2:	c7 05 9c b0 10 80 01 	movl   $0x1,0x8010b09c
80101ce9:	00 00 00 
        input.s1 = input.e;
80101cec:	a3 94 b0 10 80       	mov    %eax,0x8010b094
        input.mode = 1;
80101cf1:	e9 58 f9 ff ff       	jmp    8010164e <consoleintr+0x3e>
      if (input.mode == 2)
80101cf6:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101cfd:	0f 84 5d 01 00 00    	je     80101e60 <consoleintr+0x850>
      for (uint i = input.e; i < input.end_pos; i++)
80101d03:	8b 3d 88 b0 10 80    	mov    0x8010b088,%edi
80101d09:	8b 15 8c b0 10 80    	mov    0x8010b08c,%edx
80101d0f:	39 d7                	cmp    %edx,%edi
80101d11:	73 6e                	jae    80101d81 <consoleintr+0x771>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d13:	89 95 5c fe ff ff    	mov    %edx,-0x1a4(%ebp)
80101d19:	be d4 03 00 00       	mov    $0x3d4,%esi
80101d1e:	66 90                	xchg   %ax,%ax
80101d20:	b8 0e 00 00 00       	mov    $0xe,%eax
80101d25:	89 f2                	mov    %esi,%edx
80101d27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d28:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101d2d:	89 da                	mov    %ebx,%edx
80101d2f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101d30:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d33:	89 f2                	mov    %esi,%edx
80101d35:	b8 0f 00 00 00       	mov    $0xf,%eax
80101d3a:	c1 e1 08             	shl    $0x8,%ecx
80101d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d3e:	89 da                	mov    %ebx,%edx
80101d40:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101d41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d44:	89 f2                	mov    %esi,%edx
80101d46:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80101d48:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
80101d4d:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
80101d50:	39 c1                	cmp    %eax,%ecx
80101d52:	0f 4f c8             	cmovg  %eax,%ecx
80101d55:	b8 0e 00 00 00       	mov    $0xe,%eax
80101d5a:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80101d5b:	89 ca                	mov    %ecx,%edx
80101d5d:	c1 fa 08             	sar    $0x8,%edx
80101d60:	89 d0                	mov    %edx,%eax
80101d62:	89 da                	mov    %ebx,%edx
80101d64:	ee                   	out    %al,(%dx)
80101d65:	b8 0f 00 00 00       	mov    $0xf,%eax
80101d6a:	89 f2                	mov    %esi,%edx
80101d6c:	ee                   	out    %al,(%dx)
80101d6d:	89 c8                	mov    %ecx,%eax
80101d6f:	89 da                	mov    %ebx,%edx
80101d71:	ee                   	out    %al,(%dx)
      for (uint i = input.e; i < input.end_pos; i++)
80101d72:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80101d78:	83 c7 01             	add    $0x1,%edi
80101d7b:	39 c7                	cmp    %eax,%edi
80101d7d:	75 a1                	jne    80101d20 <consoleintr+0x710>
80101d7f:	89 c2                	mov    %eax,%edx
      while (input.end_pos != input.w &&
80101d81:	3b 15 84 b0 10 80    	cmp    0x8010b084,%edx
80101d87:	0f 84 23 03 00 00    	je     801020b0 <consoleintr+0xaa0>
             input.buf[(input.end_pos - 1) % INPUT_BUF] != '\n')
80101d8d:	8d 42 ff             	lea    -0x1(%edx),%eax
80101d90:	89 c1                	mov    %eax,%ecx
80101d92:	83 e1 7f             	and    $0x7f,%ecx
      while (input.end_pos != input.w &&
80101d95:	80 b9 00 b0 10 80 0a 	cmpb   $0xa,-0x7fef5000(%ecx)
80101d9c:	0f 84 0e 03 00 00    	je     801020b0 <consoleintr+0xaa0>
  if (panicked)
80101da2:	8b 35 f8 27 11 80    	mov    0x801127f8,%esi
        input.end_pos--;
80101da8:	a3 8c b0 10 80       	mov    %eax,0x8010b08c
  if (panicked)
80101dad:	85 f6                	test   %esi,%esi
80101daf:	0f 84 dd 00 00 00    	je     80101e92 <consoleintr+0x882>
  asm volatile("cli");
80101db5:	fa                   	cli    
    for (;;)
80101db6:	eb fe                	jmp    80101db6 <consoleintr+0x7a6>
80101db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop
      if (is_copy == 1)
80101dc0:	83 3d 88 1e 11 80 01 	cmpl   $0x1,0x80111e88
80101dc7:	0f 85 81 f8 ff ff    	jne    8010164e <consoleintr+0x3e>
        if (input.mode == 2)
80101dcd:	83 3d 9c b0 10 80 02 	cmpl   $0x2,0x8010b09c
80101dd4:	0f 84 c6 06 00 00    	je     801024a0 <consoleintr+0xe90>
        for (uint i = inedx_copy1; i <= inedx_copy2; i++)
80101dda:	8b 1d 84 1e 11 80    	mov    0x80111e84,%ebx
80101de0:	39 1d 80 1e 11 80    	cmp    %ebx,0x80111e80
80101de6:	0f 82 62 f8 ff ff    	jb     8010164e <consoleintr+0x3e>
          if ((input.e < input.end_pos) && c != '\n')
80101dec:	a1 88 b0 10 80       	mov    0x8010b088,%eax
          c = ctrl_c[i];
80101df1:	0f be b3 a0 1e 11 80 	movsbl -0x7feee160(%ebx),%esi
          input.buf[input.e++ % INPUT_BUF] = c;
80101df8:	89 c7                	mov    %eax,%edi
          c = ctrl_c[i];
80101dfa:	89 f2                	mov    %esi,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
80101dfc:	8d 48 01             	lea    0x1(%eax),%ecx
80101dff:	83 e7 7f             	and    $0x7f,%edi
          if ((input.e < input.end_pos) && c != '\n')
80101e02:	3b 05 8c b0 10 80    	cmp    0x8010b08c,%eax
80101e08:	0f 83 d2 01 00 00    	jae    80101fe0 <consoleintr+0x9d0>
80101e0e:	83 fe 0a             	cmp    $0xa,%esi
80101e11:	0f 85 12 04 00 00    	jne    80102229 <consoleintr+0xc19>
          input.buf[input.e++ % INPUT_BUF] = c;
80101e17:	89 0d 88 b0 10 80    	mov    %ecx,0x8010b088
80101e1d:	c6 87 00 b0 10 80 0a 	movb   $0xa,-0x7fef5000(%edi)
        for (uint i = inedx_copy1; i <= inedx_copy2; i++)
80101e24:	83 c3 01             	add    $0x1,%ebx
80101e27:	39 1d 80 1e 11 80    	cmp    %ebx,0x80111e80
80101e2d:	73 bd                	jae    80101dec <consoleintr+0x7dc>
80101e2f:	e9 1a f8 ff ff       	jmp    8010164e <consoleintr+0x3e>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80101e38:	c7 85 60 fe ff ff 01 	movl   $0x1,-0x1a0(%ebp)
80101e3f:	00 00 00 
80101e42:	e9 07 f8 ff ff       	jmp    8010164e <consoleintr+0x3e>
      else if (input.mode == 1)
80101e47:	83 f8 01             	cmp    $0x1,%eax
80101e4a:	0f 84 ec 02 00 00    	je     8010213c <consoleintr+0xb2c>
      else if (input.mode == 2)
80101e50:	83 f8 02             	cmp    $0x2,%eax
80101e53:	0f 85 f5 f7 ff ff    	jne    8010164e <consoleintr+0x3e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        print_select(input.s1, input.s2);
80101e60:	83 ec 08             	sub    $0x8,%esp
80101e63:	ff 35 98 b0 10 80    	pushl  0x8010b098
80101e69:	ff 35 94 b0 10 80    	pushl  0x8010b094
80101e6f:	e8 4c f1 ff ff       	call   80100fc0 <print_select>
        input.mode = 0;
80101e74:	83 c4 10             	add    $0x10,%esp
80101e77:	c7 05 9c b0 10 80 00 	movl   $0x0,0x8010b09c
80101e7e:	00 00 00 
80101e81:	e9 c8 f7 ff ff       	jmp    8010164e <consoleintr+0x3e>
}
80101e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e89:	5b                   	pop    %ebx
80101e8a:	5e                   	pop    %esi
80101e8b:	5f                   	pop    %edi
80101e8c:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
80101e8d:	e9 5e 41 00 00       	jmp    80105ff0 <procdump>
    uartputc('\b');
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	6a 08                	push   $0x8
80101e97:	e8 54 64 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
80101e9c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101ea3:	e8 48 64 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
80101ea8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80101eaf:	e8 3c 64 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80101eb4:	b8 00 01 00 00       	mov    $0x100,%eax
80101eb9:	e8 42 e5 ff ff       	call   80100400 <cgaputc>
      while (input.end_pos != input.w &&
80101ebe:	8b 15 8c b0 10 80    	mov    0x8010b08c,%edx
80101ec4:	83 c4 10             	add    $0x10,%esp
80101ec7:	e9 b5 fe ff ff       	jmp    80101d81 <consoleintr+0x771>
          uint cursor_index = input.e - input.w - 1 ;
80101ecc:	89 d0                	mov    %edx,%eax
          move_timed_chars_left(cursor_index, input.e);
80101ece:	83 ec 08             	sub    $0x8,%esp
          uint cursor_index = input.e - input.w - 1 ;
80101ed1:	29 c8                	sub    %ecx,%eax
          move_timed_chars_left(cursor_index, input.e);
80101ed3:	52                   	push   %edx
          uint cursor_index = input.e - input.w - 1 ;
80101ed4:	83 e8 01             	sub    $0x1,%eax
          move_timed_chars_left(cursor_index, input.e);
80101ed7:	50                   	push   %eax
80101ed8:	e8 33 f5 ff ff       	call   80101410 <move_timed_chars_left>
  if (panicked)
80101edd:	8b 3d f8 27 11 80    	mov    0x801127f8,%edi
          input.end_pos--;
80101ee3:	83 2d 8c b0 10 80 01 	subl   $0x1,0x8010b08c
  if (panicked)
80101eea:	83 c4 10             	add    $0x10,%esp
80101eed:	85 ff                	test   %edi,%edi
80101eef:	74 11                	je     80101f02 <consoleintr+0x8f2>
80101ef1:	fa                   	cli    
    for (;;)
80101ef2:	eb fe                	jmp    80101ef2 <consoleintr+0x8e2>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          move_to_first_current();
80101ef8:	e8 f3 ed ff ff       	call   80100cf0 <move_to_first_current>
80101efd:	e9 4c f7 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	6a 08                	push   $0x8
80101f07:	e8 e4 63 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
80101f0c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101f13:	e8 d8 63 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
80101f18:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80101f1f:	e8 cc 63 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80101f24:	b8 00 01 00 00       	mov    $0x100,%eax
80101f29:	e8 d2 e4 ff ff       	call   80100400 <cgaputc>
}
80101f2e:	83 c4 10             	add    $0x10,%esp
80101f31:	e9 18 f7 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80101f36:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f39:	be d4 03 00 00       	mov    $0x3d4,%esi
80101f3e:	6a 08                	push   $0x8
80101f40:	e8 ab 63 00 00       	call   801082f0 <uartputc>
80101f45:	b8 0e 00 00 00       	mov    $0xe,%eax
80101f4a:	89 f2                	mov    %esi,%edx
80101f4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f4d:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101f52:	89 da                	mov    %ebx,%edx
80101f54:	ec                   	in     (%dx),%al
80101f55:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f58:	89 f2                	mov    %esi,%edx
80101f5a:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80101f5f:	c1 e1 08             	shl    $0x8,%ecx
80101f62:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f63:	89 da                	mov    %ebx,%edx
80101f65:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101f66:	0f b6 c0             	movzbl %al,%eax
80101f69:	09 c8                	or     %ecx,%eax
    --pos;
80101f6b:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6e:	ee                   	out    %al,(%dx)
        input.e--;
80101f6f:	83 2d 88 b0 10 80 01 	subl   $0x1,0x8010b088
80101f76:	83 c4 10             	add    $0x10,%esp
80101f79:	e9 d0 f6 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80101f7e:	83 ec 0c             	sub    $0xc,%esp
80101f81:	6a 08                	push   $0x8
80101f83:	e8 68 63 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
80101f88:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101f8f:	e8 5c 63 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
80101f94:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80101f9b:	e8 50 63 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80101fa0:	b8 00 01 00 00       	mov    $0x100,%eax
80101fa5:	e8 56 e4 ff ff       	call   80100400 <cgaputc>
          uint cursor_index = input.e - input.w -1 ;
80101faa:	a1 88 b0 10 80       	mov    0x8010b088,%eax
          move_timed_chars_left(cursor_index, input.e);
80101faf:	5a                   	pop    %edx
80101fb0:	59                   	pop    %ecx
80101fb1:	50                   	push   %eax
          uint cursor_index = input.e - input.w -1 ;
80101fb2:	83 e8 01             	sub    $0x1,%eax
80101fb5:	2b 05 84 b0 10 80    	sub    0x8010b084,%eax
          move_timed_chars_left(cursor_index, input.e);
80101fbb:	50                   	push   %eax
80101fbc:	e8 4f f4 ff ff       	call   80101410 <move_timed_chars_left>
          input.end_pos--;
80101fc1:	83 2d 8c b0 10 80 01 	subl   $0x1,0x8010b08c
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	e9 7e f6 ff ff       	jmp    8010164e <consoleintr+0x3e>
  if (panicked)
80101fd0:	85 ff                	test   %edi,%edi
80101fd2:	0f 84 e3 00 00 00    	je     801020bb <consoleintr+0xaab>
  asm volatile("cli");
80101fd8:	fa                   	cli    
    for (;;)
80101fd9:	eb fe                	jmp    80101fd9 <consoleintr+0x9c9>
80101fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fdf:	90                   	nop
          input.buf[input.e++ % INPUT_BUF] = c;
80101fe0:	89 0d 88 b0 10 80    	mov    %ecx,0x8010b088
80101fe6:	88 97 00 b0 10 80    	mov    %dl,-0x7fef5000(%edi)
          if (input.e == input.end_pos + 1)
80101fec:	0f 85 32 fe ff ff    	jne    80101e24 <consoleintr+0x814>
  if (panicked)
80101ff2:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
          if (input.e == input.end_pos + 1)
80101ff8:	89 0d 8c b0 10 80    	mov    %ecx,0x8010b08c
  if (panicked)
80101ffe:	85 d2                	test   %edx,%edx
80102000:	0f 84 26 04 00 00    	je     8010242c <consoleintr+0xe1c>
80102006:	fa                   	cli    
    for (;;)
80102007:	eb fe                	jmp    80102007 <consoleintr+0x9f7>
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        delete_selected();
80102010:	e8 6b f1 ff ff       	call   80101180 <delete_selected>
        break;
80102015:	e9 34 f6 ff ff       	jmp    8010164e <consoleintr+0x3e>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010201a:	89 9d 54 fe ff ff    	mov    %ebx,-0x1ac(%ebp)
80102020:	be d4 03 00 00       	mov    $0x3d4,%esi
80102025:	89 bd 50 fe ff ff    	mov    %edi,-0x1b0(%ebp)
8010202b:	89 cf                	mov    %ecx,%edi
8010202d:	b8 0e 00 00 00       	mov    $0xe,%eax
80102032:	89 f2                	mov    %esi,%edx
80102034:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102035:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010203a:	89 da                	mov    %ebx,%edx
8010203c:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010203d:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	89 f2                	mov    %esi,%edx
80102042:	b8 0f 00 00 00       	mov    $0xf,%eax
80102047:	c1 e1 08             	shl    $0x8,%ecx
8010204a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010204b:	89 da                	mov    %ebx,%edx
8010204d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010204e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102051:	89 f2                	mov    %esi,%edx
80102053:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
80102055:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
8010205a:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
8010205d:	39 c1                	cmp    %eax,%ecx
8010205f:	0f 4f c8             	cmovg  %eax,%ecx
80102062:	31 c0                	xor    %eax,%eax
80102064:	85 c9                	test   %ecx,%ecx
80102066:	0f 48 c8             	cmovs  %eax,%ecx
80102069:	b8 0e 00 00 00       	mov    $0xe,%eax
8010206e:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
8010206f:	89 ca                	mov    %ecx,%edx
80102071:	c1 fa 08             	sar    $0x8,%edx
80102074:	89 d0                	mov    %edx,%eax
80102076:	89 da                	mov    %ebx,%edx
80102078:	ee                   	out    %al,(%dx)
80102079:	b8 0f 00 00 00       	mov    $0xf,%eax
8010207e:	89 f2                	mov    %esi,%edx
80102080:	ee                   	out    %al,(%dx)
80102081:	89 c8                	mov    %ecx,%eax
80102083:	89 da                	mov    %ebx,%edx
80102085:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i > removing_char_index; i--)
80102086:	8b 85 58 fe ff ff    	mov    -0x1a8(%ebp),%eax
8010208c:	83 ef 01             	sub    $0x1,%edi
8010208f:	39 c7                	cmp    %eax,%edi
80102091:	75 9a                	jne    8010202d <consoleintr+0xa1d>
  if (panicked)
80102093:	8b bd 50 fe ff ff    	mov    -0x1b0(%ebp),%edi
80102099:	8b 9d 54 fe ff ff    	mov    -0x1ac(%ebp),%ebx
8010209f:	85 ff                	test   %edi,%edi
801020a1:	0f 84 ce 00 00 00    	je     80102175 <consoleintr+0xb65>
  asm volatile("cli");
801020a7:	fa                   	cli    
    for (;;)
801020a8:	eb fe                	jmp    801020a8 <consoleintr+0xa98>
801020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      input.e = input.end_pos;
801020b0:	89 15 88 b0 10 80    	mov    %edx,0x8010b088
      break;
801020b6:	e9 93 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
801020bb:	83 ec 0c             	sub    $0xc,%esp
801020be:	6a 08                	push   $0x8
801020c0:	e8 2b 62 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
801020c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801020cc:	e8 1f 62 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
801020d1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801020d8:	e8 13 62 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801020dd:	b8 00 01 00 00       	mov    $0x100,%eax
801020e2:	e8 19 e3 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
801020e7:	5e                   	pop    %esi
801020e8:	5f                   	pop    %edi
801020e9:	53                   	push   %ebx
801020ea:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
801020f0:	e8 1b f3 ff ff       	call   80101410 <move_timed_chars_left>
        input.e--;
801020f5:	83 2d 88 b0 10 80 01 	subl   $0x1,0x8010b088
801020fc:	83 c4 10             	add    $0x10,%esp
      input.end_pos--;
801020ff:	83 2d 8c b0 10 80 01 	subl   $0x1,0x8010b08c
      break;
80102106:	e9 43 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
  for (int i = 0; i < INPUT_BUF; i++)
8010210b:	31 c0                	xor    %eax,%eax
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
    times_buf[i].time = 0;
80102110:	c7 04 c5 24 1f 11 80 	movl   $0x0,-0x7feee0dc(,%eax,8)
80102117:	00 00 00 00 
    times_buf[i].c = '\0';
8010211b:	c6 04 c5 20 1f 11 80 	movb   $0x0,-0x7feee0e0(,%eax,8)
80102122:	00 
  for (int i = 0; i < INPUT_BUF; i++)
80102123:	83 c0 01             	add    $0x1,%eax
80102126:	3d 80 00 00 00       	cmp    $0x80,%eax
8010212b:	75 e3                	jne    80102110 <consoleintr+0xb00>
        input.time = 0;
8010212d:	c7 05 90 b0 10 80 00 	movl   $0x0,0x8010b090
80102134:	00 00 00 
        break;
80102137:	e9 12 f5 ff ff       	jmp    8010164e <consoleintr+0x3e>
        input.s2 = input.e;
8010213c:	a1 88 b0 10 80       	mov    0x8010b088,%eax
        print_select(input.s1, input.s2);
80102141:	83 ec 08             	sub    $0x8,%esp
        input.mode = 2;
80102144:	c7 05 9c b0 10 80 02 	movl   $0x2,0x8010b09c
8010214b:	00 00 00 
        input.color = 'W';
8010214e:	c6 05 a0 b0 10 80 57 	movb   $0x57,0x8010b0a0
        input.s2 = input.e;
80102155:	a3 98 b0 10 80       	mov    %eax,0x8010b098
        print_select(input.s1, input.s2);
8010215a:	50                   	push   %eax
8010215b:	ff 35 94 b0 10 80    	pushl  0x8010b094
80102161:	e8 5a ee ff ff       	call   80100fc0 <print_select>
        input.color = 'B';
80102166:	c6 05 a0 b0 10 80 42 	movb   $0x42,0x8010b0a0
8010216d:	83 c4 10             	add    $0x10,%esp
80102170:	e9 d9 f4 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	6a 08                	push   $0x8
8010217a:	e8 71 61 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
8010217f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102186:	e8 65 61 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
8010218b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80102192:	e8 59 61 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80102197:	b8 00 01 00 00       	mov    $0x100,%eax
8010219c:	e8 5f e2 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
801021a1:	59                   	pop    %ecx
801021a2:	5e                   	pop    %esi
801021a3:	53                   	push   %ebx
801021a4:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021aa:	be d4 03 00 00       	mov    $0x3d4,%esi
801021af:	e8 5c f2 ff ff       	call   80101410 <move_timed_chars_left>
801021b4:	83 c4 10             	add    $0x10,%esp
801021b7:	b8 0e 00 00 00       	mov    $0xe,%eax
801021bc:	89 f2                	mov    %esi,%edx
801021be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021bf:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801021c4:	89 da                	mov    %ebx,%edx
801021c6:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c7:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
801021cc:	0f b6 c8             	movzbl %al,%ecx
801021cf:	89 f2                	mov    %esi,%edx
801021d1:	c1 e1 08             	shl    $0x8,%ecx
801021d4:	89 f8                	mov    %edi,%eax
801021d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d7:	89 da                	mov    %ebx,%edx
801021d9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801021da:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021dd:	89 f2                	mov    %esi,%edx
801021df:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
801021e1:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
801021e6:	83 c1 01             	add    $0x1,%ecx
  if (pos >= 25 * 80)
801021e9:	39 c1                	cmp    %eax,%ecx
801021eb:	0f 4f c8             	cmovg  %eax,%ecx
801021ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801021f3:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
801021f4:	89 c8                	mov    %ecx,%eax
801021f6:	89 da                	mov    %ebx,%edx
801021f8:	c1 f8 08             	sar    $0x8,%eax
801021fb:	ee                   	out    %al,(%dx)
801021fc:	89 f8                	mov    %edi,%eax
801021fe:	89 f2                	mov    %esi,%edx
80102200:	ee                   	out    %al,(%dx)
80102201:	89 c8                	mov    %ecx,%eax
80102203:	89 da                	mov    %ebx,%edx
80102205:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i > removing_char_index; i--)
80102206:	83 ad 5c fe ff ff 01 	subl   $0x1,-0x1a4(%ebp)
8010220d:	8b bd 58 fe ff ff    	mov    -0x1a8(%ebp),%edi
80102213:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80102219:	39 f8                	cmp    %edi,%eax
8010221b:	75 9a                	jne    801021b7 <consoleintr+0xba7>
        input.e--;
8010221d:	83 2d 88 b0 10 80 01 	subl   $0x1,0x8010b088
80102224:	e9 d6 fe ff ff       	jmp    801020ff <consoleintr+0xaef>
          if ((input.e < input.end_pos) && c != '\n')
80102229:	88 95 5c fe ff ff    	mov    %dl,-0x1a4(%ebp)
8010222f:	31 c0                	xor    %eax,%eax
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
              copy_buf[i] = input.buf[i];
80102238:	8b 90 00 b0 10 80    	mov    -0x7fef5000(%eax),%edx
8010223e:	83 c0 04             	add    $0x4,%eax
80102241:	89 90 1c 27 11 80    	mov    %edx,-0x7feed8e4(%eax)
            for (int i = 0; i < INPUT_BUF; i++)
80102247:	3d 80 00 00 00       	cmp    $0x80,%eax
8010224c:	75 ea                	jne    80102238 <consoleintr+0xc28>
            input.buf[input.e++ % INPUT_BUF] = c;
8010224e:	89 0d 88 b0 10 80    	mov    %ecx,0x8010b088
80102254:	0f b6 95 5c fe ff ff 	movzbl -0x1a4(%ebp),%edx
  if (panicked)
8010225b:	8b 0d f8 27 11 80    	mov    0x801127f8,%ecx
            input.buf[input.e++ % INPUT_BUF] = c;
80102261:	88 97 00 b0 10 80    	mov    %dl,-0x7fef5000(%edi)
  if (panicked)
80102267:	85 c9                	test   %ecx,%ecx
80102269:	0f 84 d5 01 00 00    	je     80102444 <consoleintr+0xe34>
  asm volatile("cli");
8010226f:	fa                   	cli    
    for (;;)
80102270:	eb fe                	jmp    80102270 <consoleintr+0xc60>
80102272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          inedx_copy1 = input.s2 % INPUT_BUF;
80102278:	89 15 84 1e 11 80    	mov    %edx,0x80111e84
          inedx_copy2 = input.s1 % INPUT_BUF;
8010227e:	a3 80 1e 11 80       	mov    %eax,0x80111e80
80102283:	e9 c6 f3 ff ff       	jmp    8010164e <consoleintr+0x3e>
    uartputc('\b');
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	6a 08                	push   $0x8
8010228d:	e8 5e 60 00 00       	call   801082f0 <uartputc>
    uartputc(' ');
80102292:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102299:	e8 52 60 00 00       	call   801082f0 <uartputc>
    uartputc('\b');
8010229e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801022a5:	e8 46 60 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801022aa:	b8 00 01 00 00       	mov    $0x100,%eax
801022af:	e8 4c e1 ff ff       	call   80100400 <cgaputc>
        move_timed_chars_left(removing_char_index, absolute_char_index);
801022b4:	58                   	pop    %eax
801022b5:	5a                   	pop    %edx
801022b6:	53                   	push   %ebx
801022b7:	8b bd 58 fe ff ff    	mov    -0x1a8(%ebp),%edi
801022bd:	57                   	push   %edi
801022be:	e8 4d f1 ff ff       	call   80101410 <move_timed_chars_left>
        for (uint i = cursor_index; i < removing_char_index - 1; i++)
801022c3:	8d 57 ff             	lea    -0x1(%edi),%edx
801022c6:	83 c4 10             	add    $0x10,%esp
801022c9:	39 95 5c fe ff ff    	cmp    %edx,-0x1a4(%ebp)
801022cf:	0f 83 2a fe ff ff    	jae    801020ff <consoleintr+0xaef>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d5:	89 95 54 fe ff ff    	mov    %edx,-0x1ac(%ebp)
801022db:	be d4 03 00 00       	mov    $0x3d4,%esi
801022e0:	b8 0e 00 00 00       	mov    $0xe,%eax
801022e5:	89 f2                	mov    %esi,%edx
801022e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801022ed:	89 da                	mov    %ebx,%edx
801022ef:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f0:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT + 1) << 8;
801022f5:	0f b6 c8             	movzbl %al,%ecx
801022f8:	89 f2                	mov    %esi,%edx
801022fa:	c1 e1 08             	shl    $0x8,%ecx
801022fd:	89 f8                	mov    %edi,%eax
801022ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102300:	89 da                	mov    %ebx,%edx
80102302:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80102303:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102306:	89 f2                	mov    %esi,%edx
80102308:	09 c1                	or     %eax,%ecx
  if (pos >= 25 * 80)
8010230a:	b8 cf 07 00 00       	mov    $0x7cf,%eax
  pos += delta;
8010230f:	83 e9 01             	sub    $0x1,%ecx
  if (pos >= 25 * 80)
80102312:	39 c1                	cmp    %eax,%ecx
80102314:	0f 4f c8             	cmovg  %eax,%ecx
80102317:	31 c0                	xor    %eax,%eax
80102319:	85 c9                	test   %ecx,%ecx
8010231b:	0f 48 c8             	cmovs  %eax,%ecx
8010231e:	b8 0e 00 00 00       	mov    $0xe,%eax
80102323:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80102324:	89 c8                	mov    %ecx,%eax
80102326:	89 da                	mov    %ebx,%edx
80102328:	c1 f8 08             	sar    $0x8,%eax
8010232b:	ee                   	out    %al,(%dx)
8010232c:	89 f8                	mov    %edi,%eax
8010232e:	89 f2                	mov    %esi,%edx
80102330:	ee                   	out    %al,(%dx)
80102331:	89 c8                	mov    %ecx,%eax
80102333:	89 da                	mov    %ebx,%edx
80102335:	ee                   	out    %al,(%dx)
        for (uint i = cursor_index; i < removing_char_index - 1; i++)
80102336:	83 85 5c fe ff ff 01 	addl   $0x1,-0x1a4(%ebp)
8010233d:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80102343:	39 85 54 fe ff ff    	cmp    %eax,-0x1ac(%ebp)
80102349:	75 95                	jne    801022e0 <consoleintr+0xcd0>
8010234b:	e9 af fd ff ff       	jmp    801020ff <consoleintr+0xaef>
80102350:	31 d2                	xor    %edx,%edx
            copy_buf[i] = input.buf[i];
80102352:	8b 8a 00 b0 10 80    	mov    -0x7fef5000(%edx),%ecx
80102358:	83 c2 04             	add    $0x4,%edx
8010235b:	89 8a 1c 27 11 80    	mov    %ecx,-0x7feed8e4(%edx)
          for (int i = 0; i < INPUT_BUF; i++)
80102361:	81 fa 80 00 00 00    	cmp    $0x80,%edx
80102367:	75 e9                	jne    80102352 <consoleintr+0xd42>
          input.buf[input.e++ % INPUT_BUF] = c;
80102369:	8d 53 01             	lea    0x1(%ebx),%edx
          consputc(c);
8010236c:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
          input.buf[input.e++ % INPUT_BUF] = c;
80102372:	89 15 88 b0 10 80    	mov    %edx,0x8010b088
80102378:	89 da                	mov    %ebx,%edx
8010237a:	83 e2 7f             	and    $0x7f,%edx
8010237d:	88 82 00 b0 10 80    	mov    %al,-0x7fef5000(%edx)
          consputc(c);
80102383:	e8 28 e2 ff ff       	call   801005b0 <consputc>
          move_chars_right();
80102388:	e8 63 e8 ff ff       	call   80100bf0 <move_chars_right>
          uint new_char_time_position_index = input.e - input.w - 1;
8010238d:	a1 88 b0 10 80       	mov    0x8010b088,%eax
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
80102392:	b9 7e 00 00 00       	mov    $0x7e,%ecx
          uint new_char_time_position_index = input.e - input.w - 1;
80102397:	8d 70 ff             	lea    -0x1(%eax),%esi
8010239a:	2b 35 84 b0 10 80    	sub    0x8010b084,%esi
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
801023a0:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
801023a6:	83 fe 7e             	cmp    $0x7e,%esi
801023a9:	77 3c                	ja     801023e7 <consoleintr+0xdd7>
801023ab:	89 b5 5c fe ff ff    	mov    %esi,-0x1a4(%ebp)
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
801023b1:	89 cb                	mov    %ecx,%ebx
801023b3:	8d 51 01             	lea    0x1(%ecx),%edx
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
801023b6:	83 e9 01             	sub    $0x1,%ecx
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
801023b9:	83 e3 7f             	and    $0x7f,%ebx
801023bc:	83 e2 7f             	and    $0x7f,%edx
801023bf:	8b 3c dd 24 1f 11 80 	mov    -0x7feee0dc(,%ebx,8),%edi
801023c6:	8b 34 dd 20 1f 11 80 	mov    -0x7feee0e0(,%ebx,8),%esi
801023cd:	89 3c d5 24 1f 11 80 	mov    %edi,-0x7feee0dc(,%edx,8)
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
801023d4:	8b bd 5c fe ff ff    	mov    -0x1a4(%ebp),%edi
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
801023da:	89 34 d5 20 1f 11 80 	mov    %esi,-0x7feee0e0(,%edx,8)
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
801023e1:	39 f9                	cmp    %edi,%ecx
801023e3:	73 cc                	jae    801023b1 <consoleintr+0xda1>
801023e5:	89 fe                	mov    %edi,%esi
          new_char.time = input.time++;
801023e7:	8b 0d 90 b0 10 80    	mov    0x8010b090,%ecx
          input.end_pos++;
801023ed:	83 05 8c b0 10 80 01 	addl   $0x1,0x8010b08c
          times_buf[new_char_time_position_index++] = new_char;
801023f4:	88 04 f5 20 1f 11 80 	mov    %al,-0x7feee0e0(,%esi,8)
          new_char.time = input.time++;
801023fb:	8d 51 01             	lea    0x1(%ecx),%edx
          times_buf[new_char_time_position_index++] = new_char;
801023fe:	89 0c f5 24 1f 11 80 	mov    %ecx,-0x7feee0dc(,%esi,8)
          new_char.time = input.time++;
80102405:	89 15 90 b0 10 80    	mov    %edx,0x8010b090
          break;
8010240b:	e9 3e f2 ff ff       	jmp    8010164e <consoleintr+0x3e>
80102410:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
          delete_selected();
80102416:	e8 65 ed ff ff       	call   80101180 <delete_selected>
        if ((input.e < input.end_pos) && c != '\n')
8010241b:	8b 1d 88 b0 10 80    	mov    0x8010b088,%ebx
80102421:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80102427:	e9 b8 f3 ff ff       	jmp    801017e4 <consoleintr+0x1d4>
    uartputc(c);
8010242c:	83 ec 0c             	sub    $0xc,%esp
8010242f:	56                   	push   %esi
80102430:	e8 bb 5e 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80102435:	89 f0                	mov    %esi,%eax
80102437:	e8 c4 df ff ff       	call   80100400 <cgaputc>
}
8010243c:	83 c4 10             	add    $0x10,%esp
8010243f:	e9 e0 f9 ff ff       	jmp    80101e24 <consoleintr+0x814>
    uartputc(c);
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	56                   	push   %esi
80102448:	e8 a3 5e 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
8010244d:	89 f0                	mov    %esi,%eax
8010244f:	e8 ac df ff ff       	call   80100400 <cgaputc>
            move_chars_right();
80102454:	e8 97 e7 ff ff       	call   80100bf0 <move_chars_right>
            input.end_pos++;
80102459:	83 05 8c b0 10 80 01 	addl   $0x1,0x8010b08c
            continue;
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	e9 bc f9 ff ff       	jmp    80101e24 <consoleintr+0x814>
          wakeup(&input.r);
80102468:	83 ec 0c             	sub    $0xc,%esp
          input.buf[input.end_pos++ % INPUT_BUF] = c; 
8010246b:	83 e2 7f             	and    $0x7f,%edx
8010246e:	89 0d 8c b0 10 80    	mov    %ecx,0x8010b08c
80102474:	88 82 00 b0 10 80    	mov    %al,-0x7fef5000(%edx)
          input.w = input.end_pos;
8010247a:	89 0d 84 b0 10 80    	mov    %ecx,0x8010b084
          input.e = input.end_pos;
80102480:	89 0d 88 b0 10 80    	mov    %ecx,0x8010b088
          wakeup(&input.r);
80102486:	68 80 b0 10 80       	push   $0x8010b080
8010248b:	e8 80 3a 00 00       	call   80105f10 <wakeup>
          if (c == '\n')
80102490:	83 c4 10             	add    $0x10,%esp
80102493:	e9 b6 f1 ff ff       	jmp    8010164e <consoleintr+0x3e>
      int start = pos + 1;
80102498:	83 c2 01             	add    $0x1,%edx
8010249b:	e9 86 f7 ff ff       	jmp    80101c26 <consoleintr+0x616>
          delete_selected();
801024a0:	e8 db ec ff ff       	call   80101180 <delete_selected>
801024a5:	e9 30 f9 ff ff       	jmp    80101dda <consoleintr+0x7ca>
        if (tab_count == 1) {
801024aa:	83 fa 01             	cmp    $0x1,%edx
801024ad:	0f 85 34 f7 ff ff    	jne    80101be7 <consoleintr+0x5d7>
          const char *suffix = full + len; 
801024b3:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
801024b9:	03 1c 85 c0 b0 10 80 	add    -0x7fef4f40(,%eax,4),%ebx
          while (*suffix) {
801024c0:	0f b6 13             	movzbl (%ebx),%edx
801024c3:	84 d2                	test   %dl,%dl
801024c5:	0f 84 1c f7 ff ff    	je     80101be7 <consoleintr+0x5d7>
            if (input.end_pos - input.r >= INPUT_BUF) 
801024cb:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
801024d0:	89 c1                	mov    %eax,%ecx
801024d2:	2b 0d 80 b0 10 80    	sub    0x8010b080,%ecx
801024d8:	83 f9 7f             	cmp    $0x7f,%ecx
801024db:	0f 87 06 f7 ff ff    	ja     80101be7 <consoleintr+0x5d7>
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
801024e1:	89 c1                	mov    %eax,%ecx
            input.e++;
801024e3:	83 05 88 b0 10 80 01 	addl   $0x1,0x8010b088
            input.end_pos++;
801024ea:	83 c0 01             	add    $0x1,%eax
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
801024ed:	83 e1 7f             	and    $0x7f,%ecx
  if (panicked)
801024f0:	83 3d f8 27 11 80 00 	cmpl   $0x0,0x801127f8
            input.end_pos++;
801024f7:	a3 8c b0 10 80       	mov    %eax,0x8010b08c
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
801024fc:	88 91 00 b0 10 80    	mov    %dl,-0x7fef5000(%ecx)
            consputc(*suffix);
80102502:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
80102505:	74 03                	je     8010250a <consoleintr+0xefa>
  asm volatile("cli");
80102507:	fa                   	cli    
    for (;;)
80102508:	eb fe                	jmp    80102508 <consoleintr+0xef8>
    uartputc(c);
8010250a:	83 ec 0c             	sub    $0xc,%esp
            consputc(*suffix);
8010250d:	0f be f0             	movsbl %al,%esi
            suffix++;
80102510:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80102513:	56                   	push   %esi
80102514:	e8 d7 5d 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
80102519:	89 f0                	mov    %esi,%eax
8010251b:	e8 e0 de ff ff       	call   80100400 <cgaputc>
            suffix++;
80102520:	83 c4 10             	add    $0x10,%esp
80102523:	eb 9b                	jmp    801024c0 <consoleintr+0xeb0>
    uartputc(c);
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	6a 0a                	push   $0xa
8010252a:	e8 c1 5d 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
8010252f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102534:	e8 c7 de ff ff       	call   80100400 <cgaputc>
}
80102539:	83 c4 10             	add    $0x10,%esp
          for (int k = 0; k < m; k++) {
8010253c:	8b 85 5c fe ff ff    	mov    -0x1a4(%ebp),%eax
80102542:	39 c3                	cmp    %eax,%ebx
80102544:	7d 6a                	jge    801025b0 <consoleintr+0xfa0>
            consputs(cmds[cmd_indexes[k]]);
80102546:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80102549:	89 9d 54 fe ff ff    	mov    %ebx,-0x1ac(%ebp)
8010254f:	8b 14 85 c0 b0 10 80 	mov    -0x7fef4f40(,%eax,4),%edx
  while (*s) consputc(*s++);
80102556:	89 d3                	mov    %edx,%ebx
80102558:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
8010255b:	8b 0d f8 27 11 80    	mov    0x801127f8,%ecx
  while (*s) consputc(*s++);
80102561:	84 c0                	test   %al,%al
80102563:	74 22                	je     80102587 <consoleintr+0xf77>
  if (panicked)
80102565:	85 c9                	test   %ecx,%ecx
80102567:	74 03                	je     8010256c <consoleintr+0xf5c>
80102569:	fa                   	cli    
    for (;;)
8010256a:	eb fe                	jmp    8010256a <consoleintr+0xf5a>
    uartputc(c);
8010256c:	83 ec 0c             	sub    $0xc,%esp
  while (*s) consputc(*s++);
8010256f:	0f be f8             	movsbl %al,%edi
80102572:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80102575:	57                   	push   %edi
80102576:	e8 75 5d 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
8010257b:	89 f8                	mov    %edi,%eax
8010257d:	e8 7e de ff ff       	call   80100400 <cgaputc>
}
80102582:	83 c4 10             	add    $0x10,%esp
80102585:	eb d1                	jmp    80102558 <consoleintr+0xf48>
  if (panicked)
80102587:	8b 9d 54 fe ff ff    	mov    -0x1ac(%ebp),%ebx
8010258d:	85 c9                	test   %ecx,%ecx
8010258f:	74 03                	je     80102594 <consoleintr+0xf84>
80102591:	fa                   	cli    
    for (;;)
80102592:	eb fe                	jmp    80102592 <consoleintr+0xf82>
    uartputc(c);
80102594:	83 ec 0c             	sub    $0xc,%esp
          for (int k = 0; k < m; k++) {
80102597:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
8010259a:	6a 20                	push   $0x20
8010259c:	e8 4f 5d 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801025a1:	b8 20 00 00 00       	mov    $0x20,%eax
801025a6:	e8 55 de ff ff       	call   80100400 <cgaputc>
          for (int k = 0; k < m; k++) {
801025ab:	83 c4 10             	add    $0x10,%esp
801025ae:	eb 8c                	jmp    8010253c <consoleintr+0xf2c>
  if (panicked)
801025b0:	83 3d f8 27 11 80 00 	cmpl   $0x0,0x801127f8
801025b7:	74 03                	je     801025bc <consoleintr+0xfac>
801025b9:	fa                   	cli    
    for (;;)
801025ba:	eb fe                	jmp    801025ba <consoleintr+0xfaa>
    uartputc(c);
801025bc:	83 ec 0c             	sub    $0xc,%esp
801025bf:	6a 0a                	push   $0xa
801025c1:	e8 2a 5d 00 00       	call   801082f0 <uartputc>
    cgaputc(c);
801025c6:	b8 0a 00 00 00       	mov    $0xa,%eax
801025cb:	e8 30 de ff ff       	call   80100400 <cgaputc>
          tab_count = 0;
801025d0:	31 c0                	xor    %eax,%eax
801025d2:	a3 a0 27 11 80       	mov    %eax,0x801127a0
          input.buf[input.end_pos++ % INPUT_BUF] = '\n';
801025d7:	a1 8c b0 10 80       	mov    0x8010b08c,%eax
801025dc:	89 c1                	mov    %eax,%ecx
801025de:	8d 50 01             	lea    0x1(%eax),%edx
          input.r = input.w-1;
801025e1:	a3 80 b0 10 80       	mov    %eax,0x8010b080
          input.buf[input.end_pos++ % INPUT_BUF] = '\n';
801025e6:	83 e1 7f             	and    $0x7f,%ecx
801025e9:	89 15 8c b0 10 80    	mov    %edx,0x8010b08c
801025ef:	c6 81 00 b0 10 80 0a 	movb   $0xa,-0x7fef5000(%ecx)
          input.w = input.end_pos;
801025f6:	89 15 84 b0 10 80    	mov    %edx,0x8010b084
          input.e = input.end_pos;
801025fc:	89 15 88 b0 10 80    	mov    %edx,0x8010b088
          wakeup(&input.r);
80102602:	c7 04 24 80 b0 10 80 	movl   $0x8010b080,(%esp)
80102609:	e8 02 39 00 00       	call   80105f10 <wakeup>
8010260e:	83 c4 10             	add    $0x10,%esp
80102611:	e9 38 f0 ff ff       	jmp    8010164e <consoleintr+0x3e>
80102616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <consoleinit>:

void consoleinit(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80102626:	68 08 98 10 80       	push   $0x80109808
8010262b:	68 c0 27 11 80       	push   $0x801127c0
80102630:	e8 cb 3d 00 00       	call   80106400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80102635:	58                   	pop    %eax
80102636:	5a                   	pop    %edx
80102637:	6a 00                	push   $0x0
80102639:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010263b:	c7 05 ac 31 11 80 d0 	movl   $0x801006d0,0x801131ac
80102642:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80102645:	c7 05 a8 31 11 80 80 	movl   $0x80100280,0x801131a8
8010264c:	02 10 80 
  cons.locking = 1;
8010264f:	c7 05 f4 27 11 80 01 	movl   $0x1,0x801127f4
80102656:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80102659:	e8 c2 19 00 00       	call   80104020 <ioapicenable>
}
8010265e:	83 c4 10             	add    $0x10,%esp
80102661:	c9                   	leave  
80102662:	c3                   	ret    
80102663:	66 90                	xchg   %ax,%ax
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	57                   	push   %edi
80102674:	56                   	push   %esi
80102675:	53                   	push   %ebx
80102676:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010267c:	e8 df 2e 00 00       	call   80105560 <myproc>
80102681:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80102687:	e8 74 22 00 00       	call   80104900 <begin_op>

  if((ip = namei(path)) == 0){
8010268c:	83 ec 0c             	sub    $0xc,%esp
8010268f:	ff 75 08             	pushl  0x8(%ebp)
80102692:	e8 a9 15 00 00       	call   80103c40 <namei>
80102697:	83 c4 10             	add    $0x10,%esp
8010269a:	85 c0                	test   %eax,%eax
8010269c:	0f 84 30 03 00 00    	je     801029d2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801026a2:	83 ec 0c             	sub    $0xc,%esp
801026a5:	89 c7                	mov    %eax,%edi
801026a7:	50                   	push   %eax
801026a8:	e8 b3 0c 00 00       	call   80103360 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801026ad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801026b3:	6a 34                	push   $0x34
801026b5:	6a 00                	push   $0x0
801026b7:	50                   	push   %eax
801026b8:	57                   	push   %edi
801026b9:	e8 b2 0f 00 00       	call   80103670 <readi>
801026be:	83 c4 20             	add    $0x20,%esp
801026c1:	83 f8 34             	cmp    $0x34,%eax
801026c4:	0f 85 01 01 00 00    	jne    801027cb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801026ca:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801026d1:	45 4c 46 
801026d4:	0f 85 f1 00 00 00    	jne    801027cb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801026da:	e8 81 6d 00 00       	call   80109460 <setupkvm>
801026df:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801026e5:	85 c0                	test   %eax,%eax
801026e7:	0f 84 de 00 00 00    	je     801027cb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801026ed:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801026f4:	00 
801026f5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801026fb:	0f 84 a1 02 00 00    	je     801029a2 <exec+0x332>
  sz = 0;
80102701:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80102708:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010270b:	31 db                	xor    %ebx,%ebx
8010270d:	e9 8c 00 00 00       	jmp    8010279e <exec+0x12e>
80102712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80102718:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010271f:	75 6c                	jne    8010278d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80102721:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80102727:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010272d:	0f 82 87 00 00 00    	jb     801027ba <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80102733:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80102739:	72 7f                	jb     801027ba <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010273b:	83 ec 04             	sub    $0x4,%esp
8010273e:	50                   	push   %eax
8010273f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80102745:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010274b:	e8 40 6b 00 00       	call   80109290 <allocuvm>
80102750:	83 c4 10             	add    $0x10,%esp
80102753:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102759:	85 c0                	test   %eax,%eax
8010275b:	74 5d                	je     801027ba <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010275d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80102763:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102768:	75 50                	jne    801027ba <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010276a:	83 ec 0c             	sub    $0xc,%esp
8010276d:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80102773:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80102779:	57                   	push   %edi
8010277a:	50                   	push   %eax
8010277b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80102781:	e8 3a 6a 00 00       	call   801091c0 <loaduvm>
80102786:	83 c4 20             	add    $0x20,%esp
80102789:	85 c0                	test   %eax,%eax
8010278b:	78 2d                	js     801027ba <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010278d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80102794:	83 c3 01             	add    $0x1,%ebx
80102797:	83 c6 20             	add    $0x20,%esi
8010279a:	39 d8                	cmp    %ebx,%eax
8010279c:	7e 52                	jle    801027f0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
8010279e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801027a4:	6a 20                	push   $0x20
801027a6:	56                   	push   %esi
801027a7:	50                   	push   %eax
801027a8:	57                   	push   %edi
801027a9:	e8 c2 0e 00 00       	call   80103670 <readi>
801027ae:	83 c4 10             	add    $0x10,%esp
801027b1:	83 f8 20             	cmp    $0x20,%eax
801027b4:	0f 84 5e ff ff ff    	je     80102718 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801027c3:	e8 18 6c 00 00       	call   801093e0 <freevm>
  if(ip){
801027c8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801027cb:	83 ec 0c             	sub    $0xc,%esp
801027ce:	57                   	push   %edi
801027cf:	e8 1c 0e 00 00       	call   801035f0 <iunlockput>
    end_op();
801027d4:	e8 97 21 00 00       	call   80104970 <end_op>
801027d9:	83 c4 10             	add    $0x10,%esp
    return -1;
801027dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
801027e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027e4:	5b                   	pop    %ebx
801027e5:	5e                   	pop    %esi
801027e6:	5f                   	pop    %edi
801027e7:	5d                   	pop    %ebp
801027e8:	c3                   	ret    
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
801027f0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801027f6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
801027fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102802:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	57                   	push   %edi
8010280c:	e8 df 0d 00 00       	call   801035f0 <iunlockput>
  end_op();
80102811:	e8 5a 21 00 00       	call   80104970 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102816:	83 c4 0c             	add    $0xc,%esp
80102819:	53                   	push   %ebx
8010281a:	56                   	push   %esi
8010281b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80102821:	56                   	push   %esi
80102822:	e8 69 6a 00 00       	call   80109290 <allocuvm>
80102827:	83 c4 10             	add    $0x10,%esp
8010282a:	89 c7                	mov    %eax,%edi
8010282c:	85 c0                	test   %eax,%eax
8010282e:	0f 84 86 00 00 00    	je     801028ba <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102834:	83 ec 08             	sub    $0x8,%esp
80102837:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010283d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010283f:	50                   	push   %eax
80102840:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80102841:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102843:	e8 b8 6c 00 00       	call   80109500 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102848:	8b 45 0c             	mov    0xc(%ebp),%eax
8010284b:	83 c4 10             	add    $0x10,%esp
8010284e:	8b 10                	mov    (%eax),%edx
80102850:	85 d2                	test   %edx,%edx
80102852:	0f 84 56 01 00 00    	je     801029ae <exec+0x33e>
80102858:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010285e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102861:	eb 23                	jmp    80102886 <exec+0x216>
80102863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102867:	90                   	nop
80102868:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010286b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80102872:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80102878:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010287b:	85 d2                	test   %edx,%edx
8010287d:	74 51                	je     801028d0 <exec+0x260>
    if(argc >= MAXARG)
8010287f:	83 f8 20             	cmp    $0x20,%eax
80102882:	74 36                	je     801028ba <exec+0x24a>
80102884:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	52                   	push   %edx
8010288a:	e8 51 40 00 00       	call   801068e0 <strlen>
8010288f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102891:	58                   	pop    %eax
80102892:	ff 34 b7             	pushl  (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102895:	83 eb 01             	sub    $0x1,%ebx
80102898:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010289b:	e8 40 40 00 00       	call   801068e0 <strlen>
801028a0:	83 c0 01             	add    $0x1,%eax
801028a3:	50                   	push   %eax
801028a4:	ff 34 b7             	pushl  (%edi,%esi,4)
801028a7:	53                   	push   %ebx
801028a8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801028ae:	e8 1d 6e 00 00       	call   801096d0 <copyout>
801028b3:	83 c4 20             	add    $0x20,%esp
801028b6:	85 c0                	test   %eax,%eax
801028b8:	79 ae                	jns    80102868 <exec+0x1f8>
    freevm(pgdir);
801028ba:	83 ec 0c             	sub    $0xc,%esp
801028bd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801028c3:	e8 18 6b 00 00       	call   801093e0 <freevm>
801028c8:	83 c4 10             	add    $0x10,%esp
801028cb:	e9 0c ff ff ff       	jmp    801027dc <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801028d0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801028d7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801028dd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801028e3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
801028e6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
801028e9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
801028f0:	00 00 00 00 
  ustack[1] = argc;
801028f4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
801028fa:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80102901:	ff ff ff 
  ustack[1] = argc;
80102904:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010290a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010290c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010290e:	29 d0                	sub    %edx,%eax
80102910:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102916:	56                   	push   %esi
80102917:	51                   	push   %ecx
80102918:	53                   	push   %ebx
80102919:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010291f:	e8 ac 6d 00 00       	call   801096d0 <copyout>
80102924:	83 c4 10             	add    $0x10,%esp
80102927:	85 c0                	test   %eax,%eax
80102929:	78 8f                	js     801028ba <exec+0x24a>
  for(last=s=path; *s; s++)
8010292b:	8b 45 08             	mov    0x8(%ebp),%eax
8010292e:	8b 55 08             	mov    0x8(%ebp),%edx
80102931:	0f b6 00             	movzbl (%eax),%eax
80102934:	84 c0                	test   %al,%al
80102936:	74 17                	je     8010294f <exec+0x2df>
80102938:	89 d1                	mov    %edx,%ecx
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80102940:	83 c1 01             	add    $0x1,%ecx
80102943:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102945:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102948:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010294b:	84 c0                	test   %al,%al
8010294d:	75 f1                	jne    80102940 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010294f:	83 ec 04             	sub    $0x4,%esp
80102952:	6a 10                	push   $0x10
80102954:	52                   	push   %edx
80102955:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010295b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010295e:	50                   	push   %eax
8010295f:	e8 3c 3f 00 00       	call   801068a0 <safestrcpy>
  curproc->pgdir = pgdir;
80102964:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010296a:	89 f0                	mov    %esi,%eax
8010296c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010296f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80102971:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102974:	89 c1                	mov    %eax,%ecx
80102976:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010297c:	8b 40 18             	mov    0x18(%eax),%eax
8010297f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80102982:	8b 41 18             	mov    0x18(%ecx),%eax
80102985:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80102988:	89 0c 24             	mov    %ecx,(%esp)
8010298b:	e8 a0 66 00 00       	call   80109030 <switchuvm>
  freevm(oldpgdir);
80102990:	89 34 24             	mov    %esi,(%esp)
80102993:	e8 48 6a 00 00       	call   801093e0 <freevm>
  return 0;
80102998:	83 c4 10             	add    $0x10,%esp
8010299b:	31 c0                	xor    %eax,%eax
8010299d:	e9 3f fe ff ff       	jmp    801027e1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801029a2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801029a7:	31 f6                	xor    %esi,%esi
801029a9:	e9 5a fe ff ff       	jmp    80102808 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801029ae:	be 10 00 00 00       	mov    $0x10,%esi
801029b3:	ba 04 00 00 00       	mov    $0x4,%edx
801029b8:	b8 03 00 00 00       	mov    $0x3,%eax
801029bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801029c4:	00 00 00 
801029c7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801029cd:	e9 17 ff ff ff       	jmp    801028e9 <exec+0x279>
    end_op();
801029d2:	e8 99 1f 00 00       	call   80104970 <end_op>
    cprintf("exec: fail\n");
801029d7:	83 ec 0c             	sub    $0xc,%esp
801029da:	68 f1 98 10 80       	push   $0x801098f1
801029df:	e8 ec dd ff ff       	call   801007d0 <cprintf>
    return -1;
801029e4:	83 c4 10             	add    $0x10,%esp
801029e7:	e9 f0 fd ff ff       	jmp    801027dc <exec+0x16c>
801029ec:	66 90                	xchg   %ax,%ax
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801029f6:	68 fd 98 10 80       	push   $0x801098fd
801029fb:	68 00 28 11 80       	push   $0x80112800
80102a00:	e8 fb 39 00 00       	call   80106400 <initlock>
}
80102a05:	83 c4 10             	add    $0x10,%esp
80102a08:	c9                   	leave  
80102a09:	c3                   	ret    
80102a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102a14:	bb 34 28 11 80       	mov    $0x80112834,%ebx
{
80102a19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80102a1c:	68 00 28 11 80       	push   $0x80112800
80102a21:	e8 ca 3b 00 00       	call   801065f0 <acquire>
80102a26:	83 c4 10             	add    $0x10,%esp
80102a29:	eb 10                	jmp    80102a3b <filealloc+0x2b>
80102a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102a30:	83 c3 18             	add    $0x18,%ebx
80102a33:	81 fb 94 31 11 80    	cmp    $0x80113194,%ebx
80102a39:	74 25                	je     80102a60 <filealloc+0x50>
    if(f->ref == 0){
80102a3b:	8b 43 04             	mov    0x4(%ebx),%eax
80102a3e:	85 c0                	test   %eax,%eax
80102a40:	75 ee                	jne    80102a30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102a42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102a45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80102a4c:	68 00 28 11 80       	push   $0x80112800
80102a51:	e8 3a 3b 00 00       	call   80106590 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102a56:	89 d8                	mov    %ebx,%eax
      return f;
80102a58:	83 c4 10             	add    $0x10,%esp
}
80102a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a5e:	c9                   	leave  
80102a5f:	c3                   	ret    
  release(&ftable.lock);
80102a60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102a63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102a65:	68 00 28 11 80       	push   $0x80112800
80102a6a:	e8 21 3b 00 00       	call   80106590 <release>
}
80102a6f:	89 d8                	mov    %ebx,%eax
  return 0;
80102a71:	83 c4 10             	add    $0x10,%esp
}
80102a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a77:	c9                   	leave  
80102a78:	c3                   	ret    
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	53                   	push   %ebx
80102a84:	83 ec 10             	sub    $0x10,%esp
80102a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80102a8a:	68 00 28 11 80       	push   $0x80112800
80102a8f:	e8 5c 3b 00 00       	call   801065f0 <acquire>
  if(f->ref < 1)
80102a94:	8b 43 04             	mov    0x4(%ebx),%eax
80102a97:	83 c4 10             	add    $0x10,%esp
80102a9a:	85 c0                	test   %eax,%eax
80102a9c:	7e 1a                	jle    80102ab8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80102a9e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102aa1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102aa4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102aa7:	68 00 28 11 80       	push   $0x80112800
80102aac:	e8 df 3a 00 00       	call   80106590 <release>
  return f;
}
80102ab1:	89 d8                	mov    %ebx,%eax
80102ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab6:	c9                   	leave  
80102ab7:	c3                   	ret    
    panic("filedup");
80102ab8:	83 ec 0c             	sub    $0xc,%esp
80102abb:	68 04 99 10 80       	push   $0x80109904
80102ac0:	e8 bb d8 ff ff       	call   80100380 <panic>
80102ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	57                   	push   %edi
80102ad4:	56                   	push   %esi
80102ad5:	53                   	push   %ebx
80102ad6:	83 ec 28             	sub    $0x28,%esp
80102ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80102adc:	68 00 28 11 80       	push   $0x80112800
80102ae1:	e8 0a 3b 00 00       	call   801065f0 <acquire>
  if(f->ref < 1)
80102ae6:	8b 53 04             	mov    0x4(%ebx),%edx
80102ae9:	83 c4 10             	add    $0x10,%esp
80102aec:	85 d2                	test   %edx,%edx
80102aee:	0f 8e a5 00 00 00    	jle    80102b99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102af4:	83 ea 01             	sub    $0x1,%edx
80102af7:	89 53 04             	mov    %edx,0x4(%ebx)
80102afa:	75 44                	jne    80102b40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80102afc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102b03:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102b05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80102b0b:	8b 73 0c             	mov    0xc(%ebx),%esi
80102b0e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102b11:	8b 43 10             	mov    0x10(%ebx),%eax
80102b14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80102b17:	68 00 28 11 80       	push   $0x80112800
80102b1c:	e8 6f 3a 00 00       	call   80106590 <release>

  if(ff.type == FD_PIPE)
80102b21:	83 c4 10             	add    $0x10,%esp
80102b24:	83 ff 01             	cmp    $0x1,%edi
80102b27:	74 57                	je     80102b80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102b29:	83 ff 02             	cmp    $0x2,%edi
80102b2c:	74 2a                	je     80102b58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80102b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b31:	5b                   	pop    %ebx
80102b32:	5e                   	pop    %esi
80102b33:	5f                   	pop    %edi
80102b34:	5d                   	pop    %ebp
80102b35:	c3                   	ret    
80102b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80102b40:	c7 45 08 00 28 11 80 	movl   $0x80112800,0x8(%ebp)
}
80102b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b4a:	5b                   	pop    %ebx
80102b4b:	5e                   	pop    %esi
80102b4c:	5f                   	pop    %edi
80102b4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80102b4e:	e9 3d 3a 00 00       	jmp    80106590 <release>
80102b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b57:	90                   	nop
    begin_op();
80102b58:	e8 a3 1d 00 00       	call   80104900 <begin_op>
    iput(ff.ip);
80102b5d:	83 ec 0c             	sub    $0xc,%esp
80102b60:	ff 75 e0             	pushl  -0x20(%ebp)
80102b63:	e8 28 09 00 00       	call   80103490 <iput>
    end_op();
80102b68:	83 c4 10             	add    $0x10,%esp
}
80102b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b6e:	5b                   	pop    %ebx
80102b6f:	5e                   	pop    %esi
80102b70:	5f                   	pop    %edi
80102b71:	5d                   	pop    %ebp
    end_op();
80102b72:	e9 f9 1d 00 00       	jmp    80104970 <end_op>
80102b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80102b80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102b84:	83 ec 08             	sub    $0x8,%esp
80102b87:	53                   	push   %ebx
80102b88:	56                   	push   %esi
80102b89:	e8 52 25 00 00       	call   801050e0 <pipeclose>
80102b8e:	83 c4 10             	add    $0x10,%esp
}
80102b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b94:	5b                   	pop    %ebx
80102b95:	5e                   	pop    %esi
80102b96:	5f                   	pop    %edi
80102b97:	5d                   	pop    %ebp
80102b98:	c3                   	ret    
    panic("fileclose");
80102b99:	83 ec 0c             	sub    $0xc,%esp
80102b9c:	68 0c 99 10 80       	push   $0x8010990c
80102ba1:	e8 da d7 ff ff       	call   80100380 <panic>
80102ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	53                   	push   %ebx
80102bb4:	83 ec 04             	sub    $0x4,%esp
80102bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80102bba:	83 3b 02             	cmpl   $0x2,(%ebx)
80102bbd:	75 31                	jne    80102bf0 <filestat+0x40>
    ilock(f->ip);
80102bbf:	83 ec 0c             	sub    $0xc,%esp
80102bc2:	ff 73 10             	pushl  0x10(%ebx)
80102bc5:	e8 96 07 00 00       	call   80103360 <ilock>
    stati(f->ip, st);
80102bca:	58                   	pop    %eax
80102bcb:	5a                   	pop    %edx
80102bcc:	ff 75 0c             	pushl  0xc(%ebp)
80102bcf:	ff 73 10             	pushl  0x10(%ebx)
80102bd2:	e8 69 0a 00 00       	call   80103640 <stati>
    iunlock(f->ip);
80102bd7:	59                   	pop    %ecx
80102bd8:	ff 73 10             	pushl  0x10(%ebx)
80102bdb:	e8 60 08 00 00       	call   80103440 <iunlock>
    return 0;
  }
  return -1;
}
80102be0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102be3:	83 c4 10             	add    $0x10,%esp
80102be6:	31 c0                	xor    %eax,%eax
}
80102be8:	c9                   	leave  
80102be9:	c3                   	ret    
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102bf8:	c9                   	leave  
80102bf9:	c3                   	ret    
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c00 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	57                   	push   %edi
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102c12:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102c16:	74 60                	je     80102c78 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102c18:	8b 03                	mov    (%ebx),%eax
80102c1a:	83 f8 01             	cmp    $0x1,%eax
80102c1d:	74 41                	je     80102c60 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102c1f:	83 f8 02             	cmp    $0x2,%eax
80102c22:	75 5b                	jne    80102c7f <fileread+0x7f>
    ilock(f->ip);
80102c24:	83 ec 0c             	sub    $0xc,%esp
80102c27:	ff 73 10             	pushl  0x10(%ebx)
80102c2a:	e8 31 07 00 00       	call   80103360 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80102c2f:	57                   	push   %edi
80102c30:	ff 73 14             	pushl  0x14(%ebx)
80102c33:	56                   	push   %esi
80102c34:	ff 73 10             	pushl  0x10(%ebx)
80102c37:	e8 34 0a 00 00       	call   80103670 <readi>
80102c3c:	83 c4 20             	add    $0x20,%esp
80102c3f:	89 c6                	mov    %eax,%esi
80102c41:	85 c0                	test   %eax,%eax
80102c43:	7e 03                	jle    80102c48 <fileread+0x48>
      f->off += r;
80102c45:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	ff 73 10             	pushl  0x10(%ebx)
80102c4e:	e8 ed 07 00 00       	call   80103440 <iunlock>
    return r;
80102c53:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c59:	89 f0                	mov    %esi,%eax
80102c5b:	5b                   	pop    %ebx
80102c5c:	5e                   	pop    %esi
80102c5d:	5f                   	pop    %edi
80102c5e:	5d                   	pop    %ebp
80102c5f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80102c60:	8b 43 0c             	mov    0xc(%ebx),%eax
80102c63:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c69:	5b                   	pop    %ebx
80102c6a:	5e                   	pop    %esi
80102c6b:	5f                   	pop    %edi
80102c6c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80102c6d:	e9 2e 26 00 00       	jmp    801052a0 <piperead>
80102c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102c78:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102c7d:	eb d7                	jmp    80102c56 <fileread+0x56>
  panic("fileread");
80102c7f:	83 ec 0c             	sub    $0xc,%esp
80102c82:	68 16 99 10 80       	push   $0x80109916
80102c87:	e8 f4 d6 ff ff       	call   80100380 <panic>
80102c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c90 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 1c             	sub    $0x1c,%esp
80102c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102ca5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80102cac:	0f 84 bb 00 00 00    	je     80102d6d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80102cb2:	8b 03                	mov    (%ebx),%eax
80102cb4:	83 f8 01             	cmp    $0x1,%eax
80102cb7:	0f 84 bf 00 00 00    	je     80102d7c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102cbd:	83 f8 02             	cmp    $0x2,%eax
80102cc0:	0f 85 c8 00 00 00    	jne    80102d8e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80102cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80102cc9:	31 f6                	xor    %esi,%esi
    while(i < n){
80102ccb:	85 c0                	test   %eax,%eax
80102ccd:	7f 30                	jg     80102cff <filewrite+0x6f>
80102ccf:	e9 94 00 00 00       	jmp    80102d68 <filewrite+0xd8>
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102cd8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80102cdb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
80102cde:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102ce1:	ff 73 10             	pushl  0x10(%ebx)
80102ce4:	e8 57 07 00 00       	call   80103440 <iunlock>
      end_op();
80102ce9:	e8 82 1c 00 00       	call   80104970 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80102cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	39 c7                	cmp    %eax,%edi
80102cf6:	75 5c                	jne    80102d54 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102cf8:	01 fe                	add    %edi,%esi
    while(i < n){
80102cfa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102cfd:	7e 69                	jle    80102d68 <filewrite+0xd8>
      int n1 = n - i;
80102cff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80102d02:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80102d07:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80102d09:	39 c7                	cmp    %eax,%edi
80102d0b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80102d0e:	e8 ed 1b 00 00       	call   80104900 <begin_op>
      ilock(f->ip);
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	ff 73 10             	pushl  0x10(%ebx)
80102d19:	e8 42 06 00 00       	call   80103360 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80102d1e:	57                   	push   %edi
80102d1f:	ff 73 14             	pushl  0x14(%ebx)
80102d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d25:	01 f0                	add    %esi,%eax
80102d27:	50                   	push   %eax
80102d28:	ff 73 10             	pushl  0x10(%ebx)
80102d2b:	e8 40 0a 00 00       	call   80103770 <writei>
80102d30:	83 c4 20             	add    $0x20,%esp
80102d33:	85 c0                	test   %eax,%eax
80102d35:	7f a1                	jg     80102cd8 <filewrite+0x48>
80102d37:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102d3a:	83 ec 0c             	sub    $0xc,%esp
80102d3d:	ff 73 10             	pushl  0x10(%ebx)
80102d40:	e8 fb 06 00 00       	call   80103440 <iunlock>
      end_op();
80102d45:	e8 26 1c 00 00       	call   80104970 <end_op>
      if(r < 0)
80102d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	85 c0                	test   %eax,%eax
80102d52:	75 14                	jne    80102d68 <filewrite+0xd8>
        panic("short filewrite");
80102d54:	83 ec 0c             	sub    $0xc,%esp
80102d57:	68 1f 99 10 80       	push   $0x8010991f
80102d5c:	e8 1f d6 ff ff       	call   80100380 <panic>
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102d68:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102d6b:	74 05                	je     80102d72 <filewrite+0xe2>
80102d6d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80102d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d75:	89 f0                	mov    %esi,%eax
80102d77:	5b                   	pop    %ebx
80102d78:	5e                   	pop    %esi
80102d79:	5f                   	pop    %edi
80102d7a:	5d                   	pop    %ebp
80102d7b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80102d7c:	8b 43 0c             	mov    0xc(%ebx),%eax
80102d7f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d85:	5b                   	pop    %ebx
80102d86:	5e                   	pop    %esi
80102d87:	5f                   	pop    %edi
80102d88:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102d89:	e9 f2 23 00 00       	jmp    80105180 <pipewrite>
  panic("filewrite");
80102d8e:	83 ec 0c             	sub    $0xc,%esp
80102d91:	68 25 99 10 80       	push   $0x80109925
80102d96:	e8 e5 d5 ff ff       	call   80100380 <panic>
80102d9b:	66 90                	xchg   %ax,%ax
80102d9d:	66 90                	xchg   %ax,%ax
80102d9f:	90                   	nop

80102da0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	57                   	push   %edi
80102da4:	56                   	push   %esi
80102da5:	53                   	push   %ebx
80102da6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80102da9:	8b 0d 54 4e 11 80    	mov    0x80114e54,%ecx
{
80102daf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102db2:	85 c9                	test   %ecx,%ecx
80102db4:	0f 84 8c 00 00 00    	je     80102e46 <balloc+0xa6>
80102dba:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
80102dbc:	89 f8                	mov    %edi,%eax
80102dbe:	83 ec 08             	sub    $0x8,%esp
80102dc1:	89 fe                	mov    %edi,%esi
80102dc3:	c1 f8 0c             	sar    $0xc,%eax
80102dc6:	03 05 6c 4e 11 80    	add    0x80114e6c,%eax
80102dcc:	50                   	push   %eax
80102dcd:	ff 75 dc             	pushl  -0x24(%ebp)
80102dd0:	e8 fb d2 ff ff       	call   801000d0 <bread>
80102dd5:	89 7d d8             	mov    %edi,-0x28(%ebp)
80102dd8:	83 c4 10             	add    $0x10,%esp
80102ddb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102dde:	a1 54 4e 11 80       	mov    0x80114e54,%eax
80102de3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102de6:	31 c0                	xor    %eax,%eax
80102de8:	eb 32                	jmp    80102e1c <balloc+0x7c>
80102dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102df0:	89 c1                	mov    %eax,%ecx
80102df2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102df7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
80102dfa:	83 e1 07             	and    $0x7,%ecx
80102dfd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102dff:	89 c1                	mov    %eax,%ecx
80102e01:	c1 f9 03             	sar    $0x3,%ecx
80102e04:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80102e09:	89 fa                	mov    %edi,%edx
80102e0b:	85 df                	test   %ebx,%edi
80102e0d:	74 49                	je     80102e58 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102e0f:	83 c0 01             	add    $0x1,%eax
80102e12:	83 c6 01             	add    $0x1,%esi
80102e15:	3d 00 10 00 00       	cmp    $0x1000,%eax
80102e1a:	74 07                	je     80102e23 <balloc+0x83>
80102e1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102e1f:	39 d6                	cmp    %edx,%esi
80102e21:	72 cd                	jb     80102df0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80102e23:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	ff 75 e4             	pushl  -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102e2c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80102e32:	e8 b9 d3 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	3b 3d 54 4e 11 80    	cmp    0x80114e54,%edi
80102e40:	0f 82 76 ff ff ff    	jb     80102dbc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 2f 99 10 80       	push   $0x8010992f
80102e4e:	e8 2d d5 ff ff       	call   80100380 <panic>
80102e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e57:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
80102e58:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80102e5b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80102e5e:	09 da                	or     %ebx,%edx
80102e60:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80102e64:	57                   	push   %edi
80102e65:	e8 76 1c 00 00       	call   80104ae0 <log_write>
        brelse(bp);
80102e6a:	89 3c 24             	mov    %edi,(%esp)
80102e6d:	e8 7e d3 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80102e72:	58                   	pop    %eax
80102e73:	5a                   	pop    %edx
80102e74:	56                   	push   %esi
80102e75:	ff 75 dc             	pushl  -0x24(%ebp)
80102e78:	e8 53 d2 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102e7d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102e80:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80102e82:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e85:	68 00 02 00 00       	push   $0x200
80102e8a:	6a 00                	push   $0x0
80102e8c:	50                   	push   %eax
80102e8d:	e8 5e 38 00 00       	call   801066f0 <memset>
  log_write(bp);
80102e92:	89 1c 24             	mov    %ebx,(%esp)
80102e95:	e8 46 1c 00 00       	call   80104ae0 <log_write>
  brelse(bp);
80102e9a:	89 1c 24             	mov    %ebx,(%esp)
80102e9d:	e8 4e d3 ff ff       	call   801001f0 <brelse>
}
80102ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ea5:	89 f0                	mov    %esi,%eax
80102ea7:	5b                   	pop    %ebx
80102ea8:	5e                   	pop    %esi
80102ea9:	5f                   	pop    %edi
80102eaa:	5d                   	pop    %ebp
80102eab:	c3                   	ret    
80102eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102eb0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102eb4:	31 ff                	xor    %edi,%edi
{
80102eb6:	56                   	push   %esi
80102eb7:	89 c6                	mov    %eax,%esi
80102eb9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102eba:	bb 34 32 11 80       	mov    $0x80113234,%ebx
{
80102ebf:	83 ec 28             	sub    $0x28,%esp
80102ec2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102ec5:	68 00 32 11 80       	push   $0x80113200
80102eca:	e8 21 37 00 00       	call   801065f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102ecf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102ed2:	83 c4 10             	add    $0x10,%esp
80102ed5:	eb 1b                	jmp    80102ef2 <iget+0x42>
80102ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ede:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102ee0:	39 33                	cmp    %esi,(%ebx)
80102ee2:	74 6c                	je     80102f50 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102ee4:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102eea:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80102ef0:	74 26                	je     80102f18 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102ef2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ef5:	85 c0                	test   %eax,%eax
80102ef7:	7f e7                	jg     80102ee0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102ef9:	85 ff                	test   %edi,%edi
80102efb:	75 e7                	jne    80102ee4 <iget+0x34>
80102efd:	85 c0                	test   %eax,%eax
80102eff:	75 76                	jne    80102f77 <iget+0xc7>
      empty = ip;
80102f01:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102f03:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102f09:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80102f0f:	75 e1                	jne    80102ef2 <iget+0x42>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80102f18:	85 ff                	test   %edi,%edi
80102f1a:	74 79                	je     80102f95 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80102f1c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80102f1f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80102f21:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80102f24:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80102f2b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80102f32:	68 00 32 11 80       	push   $0x80113200
80102f37:	e8 54 36 00 00       	call   80106590 <release>

  return ip;
80102f3c:	83 c4 10             	add    $0x10,%esp
}
80102f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f42:	89 f8                	mov    %edi,%eax
80102f44:	5b                   	pop    %ebx
80102f45:	5e                   	pop    %esi
80102f46:	5f                   	pop    %edi
80102f47:	5d                   	pop    %ebp
80102f48:	c3                   	ret    
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102f50:	39 53 04             	cmp    %edx,0x4(%ebx)
80102f53:	75 8f                	jne    80102ee4 <iget+0x34>
      ip->ref++;
80102f55:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80102f58:	83 ec 0c             	sub    $0xc,%esp
      return ip;
80102f5b:	89 df                	mov    %ebx,%edi
      ip->ref++;
80102f5d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102f60:	68 00 32 11 80       	push   $0x80113200
80102f65:	e8 26 36 00 00       	call   80106590 <release>
      return ip;
80102f6a:	83 c4 10             	add    $0x10,%esp
}
80102f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f70:	89 f8                	mov    %edi,%eax
80102f72:	5b                   	pop    %ebx
80102f73:	5e                   	pop    %esi
80102f74:	5f                   	pop    %edi
80102f75:	5d                   	pop    %ebp
80102f76:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102f77:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102f7d:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80102f83:	74 10                	je     80102f95 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102f85:	8b 43 08             	mov    0x8(%ebx),%eax
80102f88:	85 c0                	test   %eax,%eax
80102f8a:	0f 8f 50 ff ff ff    	jg     80102ee0 <iget+0x30>
80102f90:	e9 68 ff ff ff       	jmp    80102efd <iget+0x4d>
    panic("iget: no inodes");
80102f95:	83 ec 0c             	sub    $0xc,%esp
80102f98:	68 45 99 10 80       	push   $0x80109945
80102f9d:	e8 de d3 ff ff       	call   80100380 <panic>
80102fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <bfree>:
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80102fb3:	89 d0                	mov    %edx,%eax
80102fb5:	c1 e8 0c             	shr    $0xc,%eax
{
80102fb8:	89 e5                	mov    %esp,%ebp
80102fba:	56                   	push   %esi
80102fbb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
80102fbc:	03 05 6c 4e 11 80    	add    0x80114e6c,%eax
{
80102fc2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80102fc4:	83 ec 08             	sub    $0x8,%esp
80102fc7:	50                   	push   %eax
80102fc8:	51                   	push   %ecx
80102fc9:	e8 02 d1 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80102fce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80102fd0:	c1 fb 03             	sar    $0x3,%ebx
80102fd3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80102fd6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80102fd8:	83 e1 07             	and    $0x7,%ecx
80102fdb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80102fe0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80102fe6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80102fe8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80102fed:	85 c1                	test   %eax,%ecx
80102fef:	74 23                	je     80103014 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80102ff1:	f7 d0                	not    %eax
  log_write(bp);
80102ff3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102ff6:	21 c8                	and    %ecx,%eax
80102ff8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80102ffc:	56                   	push   %esi
80102ffd:	e8 de 1a 00 00       	call   80104ae0 <log_write>
  brelse(bp);
80103002:	89 34 24             	mov    %esi,(%esp)
80103005:	e8 e6 d1 ff ff       	call   801001f0 <brelse>
}
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103010:	5b                   	pop    %ebx
80103011:	5e                   	pop    %esi
80103012:	5d                   	pop    %ebp
80103013:	c3                   	ret    
    panic("freeing free block");
80103014:	83 ec 0c             	sub    $0xc,%esp
80103017:	68 55 99 10 80       	push   $0x80109955
8010301c:	e8 5f d3 ff ff       	call   80100380 <panic>
80103021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop

80103030 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	89 c6                	mov    %eax,%esi
80103037:	53                   	push   %ebx
80103038:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010303b:	83 fa 0b             	cmp    $0xb,%edx
8010303e:	0f 86 8c 00 00 00    	jbe    801030d0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80103044:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80103047:	83 fb 7f             	cmp    $0x7f,%ebx
8010304a:	0f 87 a2 00 00 00    	ja     801030f2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80103050:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80103056:	85 c0                	test   %eax,%eax
80103058:	74 5e                	je     801030b8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010305a:	83 ec 08             	sub    $0x8,%esp
8010305d:	50                   	push   %eax
8010305e:	ff 36                	pushl  (%esi)
80103060:	e8 6b d0 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80103065:	83 c4 10             	add    $0x10,%esp
80103068:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010306c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010306e:	8b 3b                	mov    (%ebx),%edi
80103070:	85 ff                	test   %edi,%edi
80103072:	74 1c                	je     80103090 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80103074:	83 ec 0c             	sub    $0xc,%esp
80103077:	52                   	push   %edx
80103078:	e8 73 d1 ff ff       	call   801001f0 <brelse>
8010307d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80103080:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103083:	89 f8                	mov    %edi,%eax
80103085:	5b                   	pop    %ebx
80103086:	5e                   	pop    %esi
80103087:	5f                   	pop    %edi
80103088:	5d                   	pop    %ebp
80103089:	c3                   	ret    
8010308a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80103093:	8b 06                	mov    (%esi),%eax
80103095:	e8 06 fd ff ff       	call   80102da0 <balloc>
      log_write(bp);
8010309a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010309d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801030a0:	89 03                	mov    %eax,(%ebx)
801030a2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801030a4:	52                   	push   %edx
801030a5:	e8 36 1a 00 00       	call   80104ae0 <log_write>
801030aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801030ad:	83 c4 10             	add    $0x10,%esp
801030b0:	eb c2                	jmp    80103074 <bmap+0x44>
801030b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801030b8:	8b 06                	mov    (%esi),%eax
801030ba:	e8 e1 fc ff ff       	call   80102da0 <balloc>
801030bf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801030c5:	eb 93                	jmp    8010305a <bmap+0x2a>
801030c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ce:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801030d0:	8d 5a 14             	lea    0x14(%edx),%ebx
801030d3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801030d7:	85 ff                	test   %edi,%edi
801030d9:	75 a5                	jne    80103080 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801030db:	8b 00                	mov    (%eax),%eax
801030dd:	e8 be fc ff ff       	call   80102da0 <balloc>
801030e2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801030e6:	89 c7                	mov    %eax,%edi
}
801030e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030eb:	5b                   	pop    %ebx
801030ec:	89 f8                	mov    %edi,%eax
801030ee:	5e                   	pop    %esi
801030ef:	5f                   	pop    %edi
801030f0:	5d                   	pop    %ebp
801030f1:	c3                   	ret    
  panic("bmap: out of range");
801030f2:	83 ec 0c             	sub    $0xc,%esp
801030f5:	68 68 99 10 80       	push   $0x80109968
801030fa:	e8 81 d2 ff ff       	call   80100380 <panic>
801030ff:	90                   	nop

80103100 <readsb>:
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	56                   	push   %esi
80103104:	53                   	push   %ebx
80103105:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80103108:	83 ec 08             	sub    $0x8,%esp
8010310b:	6a 01                	push   $0x1
8010310d:	ff 75 08             	pushl  0x8(%ebp)
80103110:	e8 bb cf ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80103115:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80103118:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010311a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010311d:	6a 1c                	push   $0x1c
8010311f:	50                   	push   %eax
80103120:	56                   	push   %esi
80103121:	e8 5a 36 00 00       	call   80106780 <memmove>
  brelse(bp);
80103126:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103129:	83 c4 10             	add    $0x10,%esp
}
8010312c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5d                   	pop    %ebp
  brelse(bp);
80103132:	e9 b9 d0 ff ff       	jmp    801001f0 <brelse>
80103137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010313e:	66 90                	xchg   %ax,%ax

80103140 <iinit>:
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	53                   	push   %ebx
80103144:	bb 40 32 11 80       	mov    $0x80113240,%ebx
80103149:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010314c:	68 7b 99 10 80       	push   $0x8010997b
80103151:	68 00 32 11 80       	push   $0x80113200
80103156:	e8 a5 32 00 00       	call   80106400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010315b:	83 c4 10             	add    $0x10,%esp
8010315e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 82 99 10 80       	push   $0x80109982
80103168:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80103169:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010316f:	e8 5c 31 00 00       	call   801062d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80103174:	83 c4 10             	add    $0x10,%esp
80103177:	81 fb 60 4e 11 80    	cmp    $0x80114e60,%ebx
8010317d:	75 e1                	jne    80103160 <iinit+0x20>
  bp = bread(dev, 1);
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	6a 01                	push   $0x1
80103184:	ff 75 08             	pushl  0x8(%ebp)
80103187:	e8 44 cf ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010318c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010318f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80103191:	8d 40 5c             	lea    0x5c(%eax),%eax
80103194:	6a 1c                	push   $0x1c
80103196:	50                   	push   %eax
80103197:	68 54 4e 11 80       	push   $0x80114e54
8010319c:	e8 df 35 00 00       	call   80106780 <memmove>
  brelse(bp);
801031a1:	89 1c 24             	mov    %ebx,(%esp)
801031a4:	e8 47 d0 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801031a9:	ff 35 6c 4e 11 80    	pushl  0x80114e6c
801031af:	ff 35 68 4e 11 80    	pushl  0x80114e68
801031b5:	ff 35 64 4e 11 80    	pushl  0x80114e64
801031bb:	ff 35 60 4e 11 80    	pushl  0x80114e60
801031c1:	ff 35 5c 4e 11 80    	pushl  0x80114e5c
801031c7:	ff 35 58 4e 11 80    	pushl  0x80114e58
801031cd:	ff 35 54 4e 11 80    	pushl  0x80114e54
801031d3:	68 e8 99 10 80       	push   $0x801099e8
801031d8:	e8 f3 d5 ff ff       	call   801007d0 <cprintf>
}
801031dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031e0:	83 c4 30             	add    $0x30,%esp
801031e3:	c9                   	leave  
801031e4:	c3                   	ret    
801031e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031f0 <ialloc>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 1c             	sub    $0x1c,%esp
801031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801031fc:	83 3d 5c 4e 11 80 01 	cmpl   $0x1,0x80114e5c
{
80103203:	8b 75 08             	mov    0x8(%ebp),%esi
80103206:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80103209:	0f 86 91 00 00 00    	jbe    801032a0 <ialloc+0xb0>
8010320f:	bf 01 00 00 00       	mov    $0x1,%edi
80103214:	eb 21                	jmp    80103237 <ialloc+0x47>
80103216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80103220:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80103223:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80103226:	53                   	push   %ebx
80103227:	e8 c4 cf ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010322c:	83 c4 10             	add    $0x10,%esp
8010322f:	3b 3d 5c 4e 11 80    	cmp    0x80114e5c,%edi
80103235:	73 69                	jae    801032a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80103237:	89 f8                	mov    %edi,%eax
80103239:	83 ec 08             	sub    $0x8,%esp
8010323c:	c1 e8 03             	shr    $0x3,%eax
8010323f:	03 05 68 4e 11 80    	add    0x80114e68,%eax
80103245:	50                   	push   %eax
80103246:	56                   	push   %esi
80103247:	e8 84 ce ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010324c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010324f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80103251:	89 f8                	mov    %edi,%eax
80103253:	83 e0 07             	and    $0x7,%eax
80103256:	c1 e0 06             	shl    $0x6,%eax
80103259:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010325d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80103261:	75 bd                	jne    80103220 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80103263:	83 ec 04             	sub    $0x4,%esp
80103266:	6a 40                	push   $0x40
80103268:	6a 00                	push   $0x0
8010326a:	51                   	push   %ecx
8010326b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010326e:	e8 7d 34 00 00       	call   801066f0 <memset>
      dip->type = type;
80103273:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80103277:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010327a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010327d:	89 1c 24             	mov    %ebx,(%esp)
80103280:	e8 5b 18 00 00       	call   80104ae0 <log_write>
      brelse(bp);
80103285:	89 1c 24             	mov    %ebx,(%esp)
80103288:	e8 63 cf ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010328d:	83 c4 10             	add    $0x10,%esp
}
80103290:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80103293:	89 fa                	mov    %edi,%edx
}
80103295:	5b                   	pop    %ebx
      return iget(dev, inum);
80103296:	89 f0                	mov    %esi,%eax
}
80103298:	5e                   	pop    %esi
80103299:	5f                   	pop    %edi
8010329a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010329b:	e9 10 fc ff ff       	jmp    80102eb0 <iget>
  panic("ialloc: no inodes");
801032a0:	83 ec 0c             	sub    $0xc,%esp
801032a3:	68 88 99 10 80       	push   $0x80109988
801032a8:	e8 d3 d0 ff ff       	call   80100380 <panic>
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

801032b0 <iupdate>:
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	56                   	push   %esi
801032b4:	53                   	push   %ebx
801032b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801032bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032be:	83 ec 08             	sub    $0x8,%esp
801032c1:	c1 e8 03             	shr    $0x3,%eax
801032c4:	03 05 68 4e 11 80    	add    0x80114e68,%eax
801032ca:	50                   	push   %eax
801032cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801032ce:	e8 fd cd ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801032d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801032d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801032da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801032dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801032df:	83 e0 07             	and    $0x7,%eax
801032e2:	c1 e0 06             	shl    $0x6,%eax
801032e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801032e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801032ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801032f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801032f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801032f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801032fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801032ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80103303:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80103307:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010330a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010330d:	6a 34                	push   $0x34
8010330f:	53                   	push   %ebx
80103310:	50                   	push   %eax
80103311:	e8 6a 34 00 00       	call   80106780 <memmove>
  log_write(bp);
80103316:	89 34 24             	mov    %esi,(%esp)
80103319:	e8 c2 17 00 00       	call   80104ae0 <log_write>
  brelse(bp);
8010331e:	89 75 08             	mov    %esi,0x8(%ebp)
80103321:	83 c4 10             	add    $0x10,%esp
}
80103324:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103327:	5b                   	pop    %ebx
80103328:	5e                   	pop    %esi
80103329:	5d                   	pop    %ebp
  brelse(bp);
8010332a:	e9 c1 ce ff ff       	jmp    801001f0 <brelse>
8010332f:	90                   	nop

80103330 <idup>:
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	53                   	push   %ebx
80103334:	83 ec 10             	sub    $0x10,%esp
80103337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010333a:	68 00 32 11 80       	push   $0x80113200
8010333f:	e8 ac 32 00 00       	call   801065f0 <acquire>
  ip->ref++;
80103344:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80103348:	c7 04 24 00 32 11 80 	movl   $0x80113200,(%esp)
8010334f:	e8 3c 32 00 00       	call   80106590 <release>
}
80103354:	89 d8                	mov    %ebx,%eax
80103356:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103359:	c9                   	leave  
8010335a:	c3                   	ret    
8010335b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop

80103360 <ilock>:
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80103368:	85 db                	test   %ebx,%ebx
8010336a:	0f 84 b7 00 00 00    	je     80103427 <ilock+0xc7>
80103370:	8b 53 08             	mov    0x8(%ebx),%edx
80103373:	85 d2                	test   %edx,%edx
80103375:	0f 8e ac 00 00 00    	jle    80103427 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010337b:	83 ec 0c             	sub    $0xc,%esp
8010337e:	8d 43 0c             	lea    0xc(%ebx),%eax
80103381:	50                   	push   %eax
80103382:	e8 89 2f 00 00       	call   80106310 <acquiresleep>
  if(ip->valid == 0){
80103387:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010338a:	83 c4 10             	add    $0x10,%esp
8010338d:	85 c0                	test   %eax,%eax
8010338f:	74 0f                	je     801033a0 <ilock+0x40>
}
80103391:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103394:	5b                   	pop    %ebx
80103395:	5e                   	pop    %esi
80103396:	5d                   	pop    %ebp
80103397:	c3                   	ret    
80103398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801033a0:	8b 43 04             	mov    0x4(%ebx),%eax
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	c1 e8 03             	shr    $0x3,%eax
801033a9:	03 05 68 4e 11 80    	add    0x80114e68,%eax
801033af:	50                   	push   %eax
801033b0:	ff 33                	pushl  (%ebx)
801033b2:	e8 19 cd ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801033b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801033ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801033bc:	8b 43 04             	mov    0x4(%ebx),%eax
801033bf:	83 e0 07             	and    $0x7,%eax
801033c2:	c1 e0 06             	shl    $0x6,%eax
801033c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801033c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801033cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801033cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801033d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801033d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801033db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801033df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801033e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801033e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801033eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801033ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801033f1:	6a 34                	push   $0x34
801033f3:	50                   	push   %eax
801033f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801033f7:	50                   	push   %eax
801033f8:	e8 83 33 00 00       	call   80106780 <memmove>
    brelse(bp);
801033fd:	89 34 24             	mov    %esi,(%esp)
80103400:	e8 eb cd ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010340d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80103414:	0f 85 77 ff ff ff    	jne    80103391 <ilock+0x31>
      panic("ilock: no type");
8010341a:	83 ec 0c             	sub    $0xc,%esp
8010341d:	68 a0 99 10 80       	push   $0x801099a0
80103422:	e8 59 cf ff ff       	call   80100380 <panic>
    panic("ilock");
80103427:	83 ec 0c             	sub    $0xc,%esp
8010342a:	68 9a 99 10 80       	push   $0x8010999a
8010342f:	e8 4c cf ff ff       	call   80100380 <panic>
80103434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010343f:	90                   	nop

80103440 <iunlock>:
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	56                   	push   %esi
80103444:	53                   	push   %ebx
80103445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103448:	85 db                	test   %ebx,%ebx
8010344a:	74 28                	je     80103474 <iunlock+0x34>
8010344c:	83 ec 0c             	sub    $0xc,%esp
8010344f:	8d 73 0c             	lea    0xc(%ebx),%esi
80103452:	56                   	push   %esi
80103453:	e8 58 2f 00 00       	call   801063b0 <holdingsleep>
80103458:	83 c4 10             	add    $0x10,%esp
8010345b:	85 c0                	test   %eax,%eax
8010345d:	74 15                	je     80103474 <iunlock+0x34>
8010345f:	8b 43 08             	mov    0x8(%ebx),%eax
80103462:	85 c0                	test   %eax,%eax
80103464:	7e 0e                	jle    80103474 <iunlock+0x34>
  releasesleep(&ip->lock);
80103466:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103469:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010346c:	5b                   	pop    %ebx
8010346d:	5e                   	pop    %esi
8010346e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010346f:	e9 fc 2e 00 00       	jmp    80106370 <releasesleep>
    panic("iunlock");
80103474:	83 ec 0c             	sub    $0xc,%esp
80103477:	68 af 99 10 80       	push   $0x801099af
8010347c:	e8 ff ce ff ff       	call   80100380 <panic>
80103481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010348f:	90                   	nop

80103490 <iput>:
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 28             	sub    $0x28,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010349c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010349f:	57                   	push   %edi
801034a0:	e8 6b 2e 00 00       	call   80106310 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801034a5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801034a8:	83 c4 10             	add    $0x10,%esp
801034ab:	85 d2                	test   %edx,%edx
801034ad:	74 07                	je     801034b6 <iput+0x26>
801034af:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801034b4:	74 32                	je     801034e8 <iput+0x58>
  releasesleep(&ip->lock);
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	57                   	push   %edi
801034ba:	e8 b1 2e 00 00       	call   80106370 <releasesleep>
  acquire(&icache.lock);
801034bf:	c7 04 24 00 32 11 80 	movl   $0x80113200,(%esp)
801034c6:	e8 25 31 00 00       	call   801065f0 <acquire>
  ip->ref--;
801034cb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801034cf:	83 c4 10             	add    $0x10,%esp
801034d2:	c7 45 08 00 32 11 80 	movl   $0x80113200,0x8(%ebp)
}
801034d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034dc:	5b                   	pop    %ebx
801034dd:	5e                   	pop    %esi
801034de:	5f                   	pop    %edi
801034df:	5d                   	pop    %ebp
  release(&icache.lock);
801034e0:	e9 ab 30 00 00       	jmp    80106590 <release>
801034e5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801034e8:	83 ec 0c             	sub    $0xc,%esp
801034eb:	68 00 32 11 80       	push   $0x80113200
801034f0:	e8 fb 30 00 00       	call   801065f0 <acquire>
    int r = ip->ref;
801034f5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801034f8:	c7 04 24 00 32 11 80 	movl   $0x80113200,(%esp)
801034ff:	e8 8c 30 00 00       	call   80106590 <release>
    if(r == 1){
80103504:	83 c4 10             	add    $0x10,%esp
80103507:	83 fe 01             	cmp    $0x1,%esi
8010350a:	75 aa                	jne    801034b6 <iput+0x26>
8010350c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80103512:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80103515:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103518:	89 df                	mov    %ebx,%edi
8010351a:	89 cb                	mov    %ecx,%ebx
8010351c:	eb 09                	jmp    80103527 <iput+0x97>
8010351e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80103520:	83 c6 04             	add    $0x4,%esi
80103523:	39 de                	cmp    %ebx,%esi
80103525:	74 19                	je     80103540 <iput+0xb0>
    if(ip->addrs[i]){
80103527:	8b 16                	mov    (%esi),%edx
80103529:	85 d2                	test   %edx,%edx
8010352b:	74 f3                	je     80103520 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010352d:	8b 07                	mov    (%edi),%eax
8010352f:	e8 7c fa ff ff       	call   80102fb0 <bfree>
      ip->addrs[i] = 0;
80103534:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010353a:	eb e4                	jmp    80103520 <iput+0x90>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80103540:	89 fb                	mov    %edi,%ebx
80103542:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103545:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	75 2d                	jne    8010357c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010354f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80103552:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80103559:	53                   	push   %ebx
8010355a:	e8 51 fd ff ff       	call   801032b0 <iupdate>
      ip->type = 0;
8010355f:	31 c0                	xor    %eax,%eax
80103561:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80103565:	89 1c 24             	mov    %ebx,(%esp)
80103568:	e8 43 fd ff ff       	call   801032b0 <iupdate>
      ip->valid = 0;
8010356d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	e9 3a ff ff ff       	jmp    801034b6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010357c:	83 ec 08             	sub    $0x8,%esp
8010357f:	50                   	push   %eax
80103580:	ff 33                	pushl  (%ebx)
80103582:	e8 49 cb ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80103587:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80103593:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103596:	8d 70 5c             	lea    0x5c(%eax),%esi
80103599:	89 cf                	mov    %ecx,%edi
8010359b:	eb 0a                	jmp    801035a7 <iput+0x117>
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
801035a0:	83 c6 04             	add    $0x4,%esi
801035a3:	39 fe                	cmp    %edi,%esi
801035a5:	74 0f                	je     801035b6 <iput+0x126>
      if(a[j])
801035a7:	8b 16                	mov    (%esi),%edx
801035a9:	85 d2                	test   %edx,%edx
801035ab:	74 f3                	je     801035a0 <iput+0x110>
        bfree(ip->dev, a[j]);
801035ad:	8b 03                	mov    (%ebx),%eax
801035af:	e8 fc f9 ff ff       	call   80102fb0 <bfree>
801035b4:	eb ea                	jmp    801035a0 <iput+0x110>
    brelse(bp);
801035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035b9:	83 ec 0c             	sub    $0xc,%esp
801035bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801035bf:	50                   	push   %eax
801035c0:	e8 2b cc ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801035c5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801035cb:	8b 03                	mov    (%ebx),%eax
801035cd:	e8 de f9 ff ff       	call   80102fb0 <bfree>
    ip->addrs[NDIRECT] = 0;
801035d2:	83 c4 10             	add    $0x10,%esp
801035d5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801035dc:	00 00 00 
801035df:	e9 6b ff ff ff       	jmp    8010354f <iput+0xbf>
801035e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ef:	90                   	nop

801035f0 <iunlockput>:
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801035f8:	85 db                	test   %ebx,%ebx
801035fa:	74 34                	je     80103630 <iunlockput+0x40>
801035fc:	83 ec 0c             	sub    $0xc,%esp
801035ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80103602:	56                   	push   %esi
80103603:	e8 a8 2d 00 00       	call   801063b0 <holdingsleep>
80103608:	83 c4 10             	add    $0x10,%esp
8010360b:	85 c0                	test   %eax,%eax
8010360d:	74 21                	je     80103630 <iunlockput+0x40>
8010360f:	8b 43 08             	mov    0x8(%ebx),%eax
80103612:	85 c0                	test   %eax,%eax
80103614:	7e 1a                	jle    80103630 <iunlockput+0x40>
  releasesleep(&ip->lock);
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	56                   	push   %esi
8010361a:	e8 51 2d 00 00       	call   80106370 <releasesleep>
  iput(ip);
8010361f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103622:	83 c4 10             	add    $0x10,%esp
}
80103625:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103628:	5b                   	pop    %ebx
80103629:	5e                   	pop    %esi
8010362a:	5d                   	pop    %ebp
  iput(ip);
8010362b:	e9 60 fe ff ff       	jmp    80103490 <iput>
    panic("iunlock");
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 af 99 10 80       	push   $0x801099af
80103638:	e8 43 cd ff ff       	call   80100380 <panic>
8010363d:	8d 76 00             	lea    0x0(%esi),%esi

80103640 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	8b 55 08             	mov    0x8(%ebp),%edx
80103646:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80103649:	8b 0a                	mov    (%edx),%ecx
8010364b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010364e:	8b 4a 04             	mov    0x4(%edx),%ecx
80103651:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80103654:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80103658:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010365b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010365f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80103663:	8b 52 58             	mov    0x58(%edx),%edx
80103666:	89 50 10             	mov    %edx,0x10(%eax)
}
80103669:	5d                   	pop    %ebp
8010366a:	c3                   	ret    
8010366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop

80103670 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	57                   	push   %edi
80103674:	56                   	push   %esi
80103675:	53                   	push   %ebx
80103676:	83 ec 1c             	sub    $0x1c,%esp
80103679:	8b 75 08             	mov    0x8(%ebp),%esi
8010367c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010367f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80103682:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80103687:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010368a:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010368d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80103690:	0f 84 aa 00 00 00    	je     80103740 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80103696:	8b 75 d8             	mov    -0x28(%ebp),%esi
80103699:	8b 56 58             	mov    0x58(%esi),%edx
8010369c:	39 fa                	cmp    %edi,%edx
8010369e:	0f 82 bd 00 00 00    	jb     80103761 <readi+0xf1>
801036a4:	89 f9                	mov    %edi,%ecx
801036a6:	31 db                	xor    %ebx,%ebx
801036a8:	01 c1                	add    %eax,%ecx
801036aa:	0f 92 c3             	setb   %bl
801036ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801036b0:	0f 82 ab 00 00 00    	jb     80103761 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801036b6:	89 d3                	mov    %edx,%ebx
801036b8:	29 fb                	sub    %edi,%ebx
801036ba:	39 ca                	cmp    %ecx,%edx
801036bc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801036bf:	85 c0                	test   %eax,%eax
801036c1:	74 73                	je     80103736 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801036c3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801036d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801036d3:	89 fa                	mov    %edi,%edx
801036d5:	c1 ea 09             	shr    $0x9,%edx
801036d8:	89 d8                	mov    %ebx,%eax
801036da:	e8 51 f9 ff ff       	call   80103030 <bmap>
801036df:	83 ec 08             	sub    $0x8,%esp
801036e2:	50                   	push   %eax
801036e3:	ff 33                	pushl  (%ebx)
801036e5:	e8 e6 c9 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801036ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036ed:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801036f2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801036f4:	89 f8                	mov    %edi,%eax
801036f6:	25 ff 01 00 00       	and    $0x1ff,%eax
801036fb:	29 f3                	sub    %esi,%ebx
801036fd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801036ff:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103703:	39 d9                	cmp    %ebx,%ecx
80103705:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80103708:	83 c4 0c             	add    $0xc,%esp
8010370b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010370c:	01 de                	add    %ebx,%esi
8010370e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80103710:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103713:	50                   	push   %eax
80103714:	ff 75 e0             	pushl  -0x20(%ebp)
80103717:	e8 64 30 00 00       	call   80106780 <memmove>
    brelse(bp);
8010371c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010371f:	89 14 24             	mov    %edx,(%esp)
80103722:	e8 c9 ca ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80103727:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010372a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010372d:	83 c4 10             	add    $0x10,%esp
80103730:	39 de                	cmp    %ebx,%esi
80103732:	72 9c                	jb     801036d0 <readi+0x60>
80103734:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80103736:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103739:	5b                   	pop    %ebx
8010373a:	5e                   	pop    %esi
8010373b:	5f                   	pop    %edi
8010373c:	5d                   	pop    %ebp
8010373d:	c3                   	ret    
8010373e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80103740:	0f bf 56 52          	movswl 0x52(%esi),%edx
80103744:	66 83 fa 09          	cmp    $0x9,%dx
80103748:	77 17                	ja     80103761 <readi+0xf1>
8010374a:	8b 14 d5 a0 31 11 80 	mov    -0x7feece60(,%edx,8),%edx
80103751:	85 d2                	test   %edx,%edx
80103753:	74 0c                	je     80103761 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80103755:	89 45 10             	mov    %eax,0x10(%ebp)
}
80103758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010375b:	5b                   	pop    %ebx
8010375c:	5e                   	pop    %esi
8010375d:	5f                   	pop    %edi
8010375e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010375f:	ff e2                	jmp    *%edx
      return -1;
80103761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103766:	eb ce                	jmp    80103736 <readi+0xc6>
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop

80103770 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 1c             	sub    $0x1c,%esp
80103779:	8b 45 08             	mov    0x8(%ebp),%eax
8010377c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010377f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80103782:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80103787:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010378a:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010378d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80103790:	0f 84 ba 00 00 00    	je     80103850 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80103796:	39 78 58             	cmp    %edi,0x58(%eax)
80103799:	0f 82 ea 00 00 00    	jb     80103889 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010379f:	8b 75 e0             	mov    -0x20(%ebp),%esi
801037a2:	89 f2                	mov    %esi,%edx
801037a4:	01 fa                	add    %edi,%edx
801037a6:	0f 82 dd 00 00 00    	jb     80103889 <writei+0x119>
801037ac:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801037b2:	0f 87 d1 00 00 00    	ja     80103889 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801037b8:	85 f6                	test   %esi,%esi
801037ba:	0f 84 85 00 00 00    	je     80103845 <writei+0xd5>
801037c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801037c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801037d0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801037d3:	89 fa                	mov    %edi,%edx
801037d5:	c1 ea 09             	shr    $0x9,%edx
801037d8:	89 f0                	mov    %esi,%eax
801037da:	e8 51 f8 ff ff       	call   80103030 <bmap>
801037df:	83 ec 08             	sub    $0x8,%esp
801037e2:	50                   	push   %eax
801037e3:	ff 36                	pushl  (%esi)
801037e5:	e8 e6 c8 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801037ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801037ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801037f0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801037f5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801037f7:	89 f8                	mov    %edi,%eax
801037f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801037fe:	29 d3                	sub    %edx,%ebx
80103800:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103802:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103806:	39 d9                	cmp    %ebx,%ecx
80103808:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010380b:	83 c4 0c             	add    $0xc,%esp
8010380e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010380f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80103811:	ff 75 dc             	pushl  -0x24(%ebp)
80103814:	50                   	push   %eax
80103815:	e8 66 2f 00 00       	call   80106780 <memmove>
    log_write(bp);
8010381a:	89 34 24             	mov    %esi,(%esp)
8010381d:	e8 be 12 00 00       	call   80104ae0 <log_write>
    brelse(bp);
80103822:	89 34 24             	mov    %esi,(%esp)
80103825:	e8 c6 c9 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010382a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103836:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103839:	39 d8                	cmp    %ebx,%eax
8010383b:	72 93                	jb     801037d0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010383d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103840:	39 78 58             	cmp    %edi,0x58(%eax)
80103843:	72 33                	jb     80103878 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103845:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103848:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010384b:	5b                   	pop    %ebx
8010384c:	5e                   	pop    %esi
8010384d:	5f                   	pop    %edi
8010384e:	5d                   	pop    %ebp
8010384f:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103850:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103854:	66 83 f8 09          	cmp    $0x9,%ax
80103858:	77 2f                	ja     80103889 <writei+0x119>
8010385a:	8b 04 c5 a4 31 11 80 	mov    -0x7feece5c(,%eax,8),%eax
80103861:	85 c0                	test   %eax,%eax
80103863:	74 24                	je     80103889 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80103865:	89 75 10             	mov    %esi,0x10(%ebp)
}
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386b:	5b                   	pop    %ebx
8010386c:	5e                   	pop    %esi
8010386d:	5f                   	pop    %edi
8010386e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010386f:	ff e0                	jmp    *%eax
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80103878:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010387b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010387e:	50                   	push   %eax
8010387f:	e8 2c fa ff ff       	call   801032b0 <iupdate>
80103884:	83 c4 10             	add    $0x10,%esp
80103887:	eb bc                	jmp    80103845 <writei+0xd5>
      return -1;
80103889:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010388e:	eb b8                	jmp    80103848 <writei+0xd8>

80103890 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80103896:	6a 0e                	push   $0xe
80103898:	ff 75 0c             	pushl  0xc(%ebp)
8010389b:	ff 75 08             	pushl  0x8(%ebp)
8010389e:	e8 4d 2f 00 00       	call   801067f0 <strncmp>
}
801038a3:	c9                   	leave  
801038a4:	c3                   	ret    
801038a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038b0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 1c             	sub    $0x1c,%esp
801038b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801038bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801038c1:	0f 85 85 00 00 00    	jne    8010394c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801038c7:	8b 53 58             	mov    0x58(%ebx),%edx
801038ca:	31 ff                	xor    %edi,%edi
801038cc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801038cf:	85 d2                	test   %edx,%edx
801038d1:	74 3e                	je     80103911 <dirlookup+0x61>
801038d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801038d8:	6a 10                	push   $0x10
801038da:	57                   	push   %edi
801038db:	56                   	push   %esi
801038dc:	53                   	push   %ebx
801038dd:	e8 8e fd ff ff       	call   80103670 <readi>
801038e2:	83 c4 10             	add    $0x10,%esp
801038e5:	83 f8 10             	cmp    $0x10,%eax
801038e8:	75 55                	jne    8010393f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801038ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801038ef:	74 18                	je     80103909 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801038f1:	83 ec 04             	sub    $0x4,%esp
801038f4:	8d 45 da             	lea    -0x26(%ebp),%eax
801038f7:	6a 0e                	push   $0xe
801038f9:	50                   	push   %eax
801038fa:	ff 75 0c             	pushl  0xc(%ebp)
801038fd:	e8 ee 2e 00 00       	call   801067f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103902:	83 c4 10             	add    $0x10,%esp
80103905:	85 c0                	test   %eax,%eax
80103907:	74 17                	je     80103920 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103909:	83 c7 10             	add    $0x10,%edi
8010390c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010390f:	72 c7                	jb     801038d8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103911:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103914:	31 c0                	xor    %eax,%eax
}
80103916:	5b                   	pop    %ebx
80103917:	5e                   	pop    %esi
80103918:	5f                   	pop    %edi
80103919:	5d                   	pop    %ebp
8010391a:	c3                   	ret    
8010391b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop
      if(poff)
80103920:	8b 45 10             	mov    0x10(%ebp),%eax
80103923:	85 c0                	test   %eax,%eax
80103925:	74 05                	je     8010392c <dirlookup+0x7c>
        *poff = off;
80103927:	8b 45 10             	mov    0x10(%ebp),%eax
8010392a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010392c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103930:	8b 03                	mov    (%ebx),%eax
80103932:	e8 79 f5 ff ff       	call   80102eb0 <iget>
}
80103937:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010393a:	5b                   	pop    %ebx
8010393b:	5e                   	pop    %esi
8010393c:	5f                   	pop    %edi
8010393d:	5d                   	pop    %ebp
8010393e:	c3                   	ret    
      panic("dirlookup read");
8010393f:	83 ec 0c             	sub    $0xc,%esp
80103942:	68 c9 99 10 80       	push   $0x801099c9
80103947:	e8 34 ca ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	68 b7 99 10 80       	push   $0x801099b7
80103954:	e8 27 ca ff ff       	call   80100380 <panic>
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	89 c3                	mov    %eax,%ebx
80103968:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010396b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010396e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103971:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103974:	0f 84 9e 01 00 00    	je     80103b18 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010397a:	e8 e1 1b 00 00       	call   80105560 <myproc>
  acquire(&icache.lock);
8010397f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103982:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103985:	68 00 32 11 80       	push   $0x80113200
8010398a:	e8 61 2c 00 00       	call   801065f0 <acquire>
  ip->ref++;
8010398f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80103993:	c7 04 24 00 32 11 80 	movl   $0x80113200,(%esp)
8010399a:	e8 f1 2b 00 00       	call   80106590 <release>
8010399f:	83 c4 10             	add    $0x10,%esp
801039a2:	eb 07                	jmp    801039ab <namex+0x4b>
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801039a8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801039ab:	0f b6 03             	movzbl (%ebx),%eax
801039ae:	3c 2f                	cmp    $0x2f,%al
801039b0:	74 f6                	je     801039a8 <namex+0x48>
  if(*path == 0)
801039b2:	84 c0                	test   %al,%al
801039b4:	0f 84 06 01 00 00    	je     80103ac0 <namex+0x160>
  while(*path != '/' && *path != 0)
801039ba:	0f b6 03             	movzbl (%ebx),%eax
801039bd:	84 c0                	test   %al,%al
801039bf:	0f 84 10 01 00 00    	je     80103ad5 <namex+0x175>
801039c5:	89 df                	mov    %ebx,%edi
801039c7:	3c 2f                	cmp    $0x2f,%al
801039c9:	0f 84 06 01 00 00    	je     80103ad5 <namex+0x175>
801039cf:	90                   	nop
801039d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801039d4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801039d7:	3c 2f                	cmp    $0x2f,%al
801039d9:	74 04                	je     801039df <namex+0x7f>
801039db:	84 c0                	test   %al,%al
801039dd:	75 f1                	jne    801039d0 <namex+0x70>
  len = path - s;
801039df:	89 f8                	mov    %edi,%eax
801039e1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801039e3:	83 f8 0d             	cmp    $0xd,%eax
801039e6:	0f 8e ac 00 00 00    	jle    80103a98 <namex+0x138>
    memmove(name, s, DIRSIZ);
801039ec:	83 ec 04             	sub    $0x4,%esp
801039ef:	6a 0e                	push   $0xe
801039f1:	53                   	push   %ebx
801039f2:	89 fb                	mov    %edi,%ebx
801039f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801039f7:	e8 84 2d 00 00       	call   80106780 <memmove>
801039fc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801039ff:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103a02:	75 0c                	jne    80103a10 <namex+0xb0>
80103a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103a08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80103a0b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80103a0e:	74 f8                	je     80103a08 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	56                   	push   %esi
80103a14:	e8 47 f9 ff ff       	call   80103360 <ilock>
    if(ip->type != T_DIR){
80103a19:	83 c4 10             	add    $0x10,%esp
80103a1c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103a21:	0f 85 b7 00 00 00    	jne    80103ade <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103a27:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103a2a:	85 c0                	test   %eax,%eax
80103a2c:	74 09                	je     80103a37 <namex+0xd7>
80103a2e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103a31:	0f 84 f7 00 00 00    	je     80103b2e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103a37:	83 ec 04             	sub    $0x4,%esp
80103a3a:	6a 00                	push   $0x0
80103a3c:	ff 75 e4             	pushl  -0x1c(%ebp)
80103a3f:	56                   	push   %esi
80103a40:	e8 6b fe ff ff       	call   801038b0 <dirlookup>
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	89 c7                	mov    %eax,%edi
80103a4a:	85 c0                	test   %eax,%eax
80103a4c:	0f 84 8c 00 00 00    	je     80103ade <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103a52:	8d 4e 0c             	lea    0xc(%esi),%ecx
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	51                   	push   %ecx
80103a59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103a5c:	e8 4f 29 00 00       	call   801063b0 <holdingsleep>
80103a61:	83 c4 10             	add    $0x10,%esp
80103a64:	85 c0                	test   %eax,%eax
80103a66:	0f 84 02 01 00 00    	je     80103b6e <namex+0x20e>
80103a6c:	8b 56 08             	mov    0x8(%esi),%edx
80103a6f:	85 d2                	test   %edx,%edx
80103a71:	0f 8e f7 00 00 00    	jle    80103b6e <namex+0x20e>
  releasesleep(&ip->lock);
80103a77:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103a7a:	83 ec 0c             	sub    $0xc,%esp
80103a7d:	51                   	push   %ecx
80103a7e:	e8 ed 28 00 00       	call   80106370 <releasesleep>
  iput(ip);
80103a83:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103a86:	89 fe                	mov    %edi,%esi
  iput(ip);
80103a88:	e8 03 fa ff ff       	call   80103490 <iput>
80103a8d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103a90:	e9 16 ff ff ff       	jmp    801039ab <namex+0x4b>
80103a95:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80103a98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a9b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80103a9e:	83 ec 04             	sub    $0x4,%esp
80103aa1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103aa4:	50                   	push   %eax
80103aa5:	53                   	push   %ebx
    name[len] = 0;
80103aa6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103aa8:	ff 75 e4             	pushl  -0x1c(%ebp)
80103aab:	e8 d0 2c 00 00       	call   80106780 <memmove>
    name[len] = 0;
80103ab0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	c6 01 00             	movb   $0x0,(%ecx)
80103ab9:	e9 41 ff ff ff       	jmp    801039ff <namex+0x9f>
80103abe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80103ac0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ac3:	85 c0                	test   %eax,%eax
80103ac5:	0f 85 93 00 00 00    	jne    80103b5e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80103acb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ace:	89 f0                	mov    %esi,%eax
80103ad0:	5b                   	pop    %ebx
80103ad1:	5e                   	pop    %esi
80103ad2:	5f                   	pop    %edi
80103ad3:	5d                   	pop    %ebp
80103ad4:	c3                   	ret    
  while(*path != '/' && *path != 0)
80103ad5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ad8:	89 df                	mov    %ebx,%edi
80103ada:	31 c0                	xor    %eax,%eax
80103adc:	eb c0                	jmp    80103a9e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103ae4:	53                   	push   %ebx
80103ae5:	e8 c6 28 00 00       	call   801063b0 <holdingsleep>
80103aea:	83 c4 10             	add    $0x10,%esp
80103aed:	85 c0                	test   %eax,%eax
80103aef:	74 7d                	je     80103b6e <namex+0x20e>
80103af1:	8b 4e 08             	mov    0x8(%esi),%ecx
80103af4:	85 c9                	test   %ecx,%ecx
80103af6:	7e 76                	jle    80103b6e <namex+0x20e>
  releasesleep(&ip->lock);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	53                   	push   %ebx
80103afc:	e8 6f 28 00 00       	call   80106370 <releasesleep>
  iput(ip);
80103b01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103b04:	31 f6                	xor    %esi,%esi
  iput(ip);
80103b06:	e8 85 f9 ff ff       	call   80103490 <iput>
      return 0;
80103b0b:	83 c4 10             	add    $0x10,%esp
}
80103b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b11:	89 f0                	mov    %esi,%eax
80103b13:	5b                   	pop    %ebx
80103b14:	5e                   	pop    %esi
80103b15:	5f                   	pop    %edi
80103b16:	5d                   	pop    %ebp
80103b17:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80103b18:	ba 01 00 00 00       	mov    $0x1,%edx
80103b1d:	b8 01 00 00 00       	mov    $0x1,%eax
80103b22:	e8 89 f3 ff ff       	call   80102eb0 <iget>
80103b27:	89 c6                	mov    %eax,%esi
80103b29:	e9 7d fe ff ff       	jmp    801039ab <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103b2e:	83 ec 0c             	sub    $0xc,%esp
80103b31:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103b34:	53                   	push   %ebx
80103b35:	e8 76 28 00 00       	call   801063b0 <holdingsleep>
80103b3a:	83 c4 10             	add    $0x10,%esp
80103b3d:	85 c0                	test   %eax,%eax
80103b3f:	74 2d                	je     80103b6e <namex+0x20e>
80103b41:	8b 7e 08             	mov    0x8(%esi),%edi
80103b44:	85 ff                	test   %edi,%edi
80103b46:	7e 26                	jle    80103b6e <namex+0x20e>
  releasesleep(&ip->lock);
80103b48:	83 ec 0c             	sub    $0xc,%esp
80103b4b:	53                   	push   %ebx
80103b4c:	e8 1f 28 00 00       	call   80106370 <releasesleep>
}
80103b51:	83 c4 10             	add    $0x10,%esp
}
80103b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b57:	89 f0                	mov    %esi,%eax
80103b59:	5b                   	pop    %ebx
80103b5a:	5e                   	pop    %esi
80103b5b:	5f                   	pop    %edi
80103b5c:	5d                   	pop    %ebp
80103b5d:	c3                   	ret    
    iput(ip);
80103b5e:	83 ec 0c             	sub    $0xc,%esp
80103b61:	56                   	push   %esi
      return 0;
80103b62:	31 f6                	xor    %esi,%esi
    iput(ip);
80103b64:	e8 27 f9 ff ff       	call   80103490 <iput>
    return 0;
80103b69:	83 c4 10             	add    $0x10,%esp
80103b6c:	eb a0                	jmp    80103b0e <namex+0x1ae>
    panic("iunlock");
80103b6e:	83 ec 0c             	sub    $0xc,%esp
80103b71:	68 af 99 10 80       	push   $0x801099af
80103b76:	e8 05 c8 ff ff       	call   80100380 <panic>
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <dirlink>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 20             	sub    $0x20,%esp
80103b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80103b8c:	6a 00                	push   $0x0
80103b8e:	ff 75 0c             	pushl  0xc(%ebp)
80103b91:	53                   	push   %ebx
80103b92:	e8 19 fd ff ff       	call   801038b0 <dirlookup>
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	85 c0                	test   %eax,%eax
80103b9c:	75 67                	jne    80103c05 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103b9e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103ba1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103ba4:	85 ff                	test   %edi,%edi
80103ba6:	74 29                	je     80103bd1 <dirlink+0x51>
80103ba8:	31 ff                	xor    %edi,%edi
80103baa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103bad:	eb 09                	jmp    80103bb8 <dirlink+0x38>
80103baf:	90                   	nop
80103bb0:	83 c7 10             	add    $0x10,%edi
80103bb3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103bb6:	73 19                	jae    80103bd1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103bb8:	6a 10                	push   $0x10
80103bba:	57                   	push   %edi
80103bbb:	56                   	push   %esi
80103bbc:	53                   	push   %ebx
80103bbd:	e8 ae fa ff ff       	call   80103670 <readi>
80103bc2:	83 c4 10             	add    $0x10,%esp
80103bc5:	83 f8 10             	cmp    $0x10,%eax
80103bc8:	75 4e                	jne    80103c18 <dirlink+0x98>
    if(de.inum == 0)
80103bca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80103bcf:	75 df                	jne    80103bb0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103bd1:	83 ec 04             	sub    $0x4,%esp
80103bd4:	8d 45 da             	lea    -0x26(%ebp),%eax
80103bd7:	6a 0e                	push   $0xe
80103bd9:	ff 75 0c             	pushl  0xc(%ebp)
80103bdc:	50                   	push   %eax
80103bdd:	e8 5e 2c 00 00       	call   80106840 <strncpy>
  de.inum = inum;
80103be2:	8b 45 10             	mov    0x10(%ebp),%eax
80103be5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103be9:	6a 10                	push   $0x10
80103beb:	57                   	push   %edi
80103bec:	56                   	push   %esi
80103bed:	53                   	push   %ebx
80103bee:	e8 7d fb ff ff       	call   80103770 <writei>
80103bf3:	83 c4 20             	add    $0x20,%esp
80103bf6:	83 f8 10             	cmp    $0x10,%eax
80103bf9:	75 2a                	jne    80103c25 <dirlink+0xa5>
  return 0;
80103bfb:	31 c0                	xor    %eax,%eax
}
80103bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
    iput(ip);
80103c05:	83 ec 0c             	sub    $0xc,%esp
80103c08:	50                   	push   %eax
80103c09:	e8 82 f8 ff ff       	call   80103490 <iput>
    return -1;
80103c0e:	83 c4 10             	add    $0x10,%esp
80103c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c16:	eb e5                	jmp    80103bfd <dirlink+0x7d>
      panic("dirlink read");
80103c18:	83 ec 0c             	sub    $0xc,%esp
80103c1b:	68 d8 99 10 80       	push   $0x801099d8
80103c20:	e8 5b c7 ff ff       	call   80100380 <panic>
    panic("dirlink");
80103c25:	83 ec 0c             	sub    $0xc,%esp
80103c28:	68 d2 a0 10 80       	push   $0x8010a0d2
80103c2d:	e8 4e c7 ff ff       	call   80100380 <panic>
80103c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c40 <namei>:

struct inode*
namei(char *path)
{
80103c40:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103c41:	31 d2                	xor    %edx,%edx
{
80103c43:	89 e5                	mov    %esp,%ebp
80103c45:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103c48:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80103c4e:	e8 0d fd ff ff       	call   80103960 <namex>
}
80103c53:	c9                   	leave  
80103c54:	c3                   	ret    
80103c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c60 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103c60:	55                   	push   %ebp
  return namex(path, 1, name);
80103c61:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103c66:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103c68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103c6e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80103c6f:	e9 ec fc ff ff       	jmp    80103960 <namex>
80103c74:	66 90                	xchg   %ax,%ax
80103c76:	66 90                	xchg   %ax,%ax
80103c78:	66 90                	xchg   %ax,%ax
80103c7a:	66 90                	xchg   %ax,%ax
80103c7c:	66 90                	xchg   %ax,%ax
80103c7e:	66 90                	xchg   %ax,%ax

80103c80 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103c89:	85 c0                	test   %eax,%eax
80103c8b:	0f 84 b4 00 00 00    	je     80103d45 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103c91:	8b 70 08             	mov    0x8(%eax),%esi
80103c94:	89 c3                	mov    %eax,%ebx
80103c96:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80103c9c:	0f 87 96 00 00 00    	ja     80103d38 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ca2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cae:	66 90                	xchg   %ax,%ax
80103cb0:	89 ca                	mov    %ecx,%edx
80103cb2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103cb3:	83 e0 c0             	and    $0xffffffc0,%eax
80103cb6:	3c 40                	cmp    $0x40,%al
80103cb8:	75 f6                	jne    80103cb0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cba:	31 ff                	xor    %edi,%edi
80103cbc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103cc1:	89 f8                	mov    %edi,%eax
80103cc3:	ee                   	out    %al,(%dx)
80103cc4:	b8 01 00 00 00       	mov    $0x1,%eax
80103cc9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80103cce:	ee                   	out    %al,(%dx)
80103ccf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103cd4:	89 f0                	mov    %esi,%eax
80103cd6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103cd7:	89 f0                	mov    %esi,%eax
80103cd9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80103cde:	c1 f8 08             	sar    $0x8,%eax
80103ce1:	ee                   	out    %al,(%dx)
80103ce2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103ce7:	89 f8                	mov    %edi,%eax
80103ce9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80103cea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80103cee:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103cf3:	c1 e0 04             	shl    $0x4,%eax
80103cf6:	83 e0 10             	and    $0x10,%eax
80103cf9:	83 c8 e0             	or     $0xffffffe0,%eax
80103cfc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80103cfd:	f6 03 04             	testb  $0x4,(%ebx)
80103d00:	75 16                	jne    80103d18 <idestart+0x98>
80103d02:	b8 20 00 00 00       	mov    $0x20,%eax
80103d07:	89 ca                	mov    %ecx,%edx
80103d09:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80103d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d0d:	5b                   	pop    %ebx
80103d0e:	5e                   	pop    %esi
80103d0f:	5f                   	pop    %edi
80103d10:	5d                   	pop    %ebp
80103d11:	c3                   	ret    
80103d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d18:	b8 30 00 00 00       	mov    $0x30,%eax
80103d1d:	89 ca                	mov    %ecx,%edx
80103d1f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103d20:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103d25:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103d28:	ba f0 01 00 00       	mov    $0x1f0,%edx
80103d2d:	fc                   	cld    
80103d2e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d33:	5b                   	pop    %ebx
80103d34:	5e                   	pop    %esi
80103d35:	5f                   	pop    %edi
80103d36:	5d                   	pop    %ebp
80103d37:	c3                   	ret    
    panic("incorrect blockno");
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	68 44 9a 10 80       	push   $0x80109a44
80103d40:	e8 3b c6 ff ff       	call   80100380 <panic>
    panic("idestart");
80103d45:	83 ec 0c             	sub    $0xc,%esp
80103d48:	68 3b 9a 10 80       	push   $0x80109a3b
80103d4d:	e8 2e c6 ff ff       	call   80100380 <panic>
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d60 <ideinit>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80103d66:	68 56 9a 10 80       	push   $0x80109a56
80103d6b:	68 a0 4e 11 80       	push   $0x80114ea0
80103d70:	e8 8b 26 00 00       	call   80106400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80103d75:	58                   	pop    %eax
80103d76:	a1 24 50 11 80       	mov    0x80115024,%eax
80103d7b:	5a                   	pop    %edx
80103d7c:	83 e8 01             	sub    $0x1,%eax
80103d7f:	50                   	push   %eax
80103d80:	6a 0e                	push   $0xe
80103d82:	e8 99 02 00 00       	call   80104020 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103d87:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d8a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103d8f:	90                   	nop
80103d90:	89 ca                	mov    %ecx,%edx
80103d92:	ec                   	in     (%dx),%al
80103d93:	83 e0 c0             	and    $0xffffffc0,%eax
80103d96:	3c 40                	cmp    $0x40,%al
80103d98:	75 f6                	jne    80103d90 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80103d9f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103da4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103da5:	89 ca                	mov    %ecx,%edx
80103da7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103da8:	84 c0                	test   %al,%al
80103daa:	75 1e                	jne    80103dca <ideinit+0x6a>
80103dac:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80103db1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80103dc0:	83 e9 01             	sub    $0x1,%ecx
80103dc3:	74 0f                	je     80103dd4 <ideinit+0x74>
80103dc5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103dc6:	84 c0                	test   %al,%al
80103dc8:	74 f6                	je     80103dc0 <ideinit+0x60>
      havedisk1 = 1;
80103dca:	c7 05 80 4e 11 80 01 	movl   $0x1,0x80114e80
80103dd1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dd4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103dd9:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103dde:	ee                   	out    %al,(%dx)
}
80103ddf:	c9                   	leave  
80103de0:	c3                   	ret    
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop

80103df0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103df9:	68 a0 4e 11 80       	push   $0x80114ea0
80103dfe:	e8 ed 27 00 00       	call   801065f0 <acquire>

  if((b = idequeue) == 0){
80103e03:	8b 1d 84 4e 11 80    	mov    0x80114e84,%ebx
80103e09:	83 c4 10             	add    $0x10,%esp
80103e0c:	85 db                	test   %ebx,%ebx
80103e0e:	74 63                	je     80103e73 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103e10:	8b 43 58             	mov    0x58(%ebx),%eax
80103e13:	a3 84 4e 11 80       	mov    %eax,0x80114e84

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103e18:	8b 33                	mov    (%ebx),%esi
80103e1a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103e20:	75 2f                	jne    80103e51 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e22:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2e:	66 90                	xchg   %ax,%ax
80103e30:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103e31:	89 c1                	mov    %eax,%ecx
80103e33:	83 e1 c0             	and    $0xffffffc0,%ecx
80103e36:	80 f9 40             	cmp    $0x40,%cl
80103e39:	75 f5                	jne    80103e30 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80103e3b:	a8 21                	test   $0x21,%al
80103e3d:	75 12                	jne    80103e51 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80103e3f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103e42:	b9 80 00 00 00       	mov    $0x80,%ecx
80103e47:	ba f0 01 00 00       	mov    $0x1f0,%edx
80103e4c:	fc                   	cld    
80103e4d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80103e4f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80103e51:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80103e54:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80103e57:	83 ce 02             	or     $0x2,%esi
80103e5a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80103e5c:	53                   	push   %ebx
80103e5d:	e8 ae 20 00 00       	call   80105f10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103e62:	a1 84 4e 11 80       	mov    0x80114e84,%eax
80103e67:	83 c4 10             	add    $0x10,%esp
80103e6a:	85 c0                	test   %eax,%eax
80103e6c:	74 05                	je     80103e73 <ideintr+0x83>
    idestart(idequeue);
80103e6e:	e8 0d fe ff ff       	call   80103c80 <idestart>
    release(&idelock);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 a0 4e 11 80       	push   $0x80114ea0
80103e7b:	e8 10 27 00 00       	call   80106590 <release>

  release(&idelock);
}
80103e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e83:	5b                   	pop    %ebx
80103e84:	5e                   	pop    %esi
80103e85:	5f                   	pop    %edi
80103e86:	5d                   	pop    %ebp
80103e87:	c3                   	ret    
80103e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop

80103e90 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 10             	sub    $0x10,%esp
80103e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80103e9a:	8d 43 0c             	lea    0xc(%ebx),%eax
80103e9d:	50                   	push   %eax
80103e9e:	e8 0d 25 00 00       	call   801063b0 <holdingsleep>
80103ea3:	83 c4 10             	add    $0x10,%esp
80103ea6:	85 c0                	test   %eax,%eax
80103ea8:	0f 84 c3 00 00 00    	je     80103f71 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80103eae:	8b 03                	mov    (%ebx),%eax
80103eb0:	83 e0 06             	and    $0x6,%eax
80103eb3:	83 f8 02             	cmp    $0x2,%eax
80103eb6:	0f 84 a8 00 00 00    	je     80103f64 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80103ebc:	8b 53 04             	mov    0x4(%ebx),%edx
80103ebf:	85 d2                	test   %edx,%edx
80103ec1:	74 0d                	je     80103ed0 <iderw+0x40>
80103ec3:	a1 80 4e 11 80       	mov    0x80114e80,%eax
80103ec8:	85 c0                	test   %eax,%eax
80103eca:	0f 84 87 00 00 00    	je     80103f57 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 a0 4e 11 80       	push   $0x80114ea0
80103ed8:	e8 13 27 00 00       	call   801065f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103edd:	a1 84 4e 11 80       	mov    0x80114e84,%eax
  b->qnext = 0;
80103ee2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103ee9:	83 c4 10             	add    $0x10,%esp
80103eec:	85 c0                	test   %eax,%eax
80103eee:	74 60                	je     80103f50 <iderw+0xc0>
80103ef0:	89 c2                	mov    %eax,%edx
80103ef2:	8b 40 58             	mov    0x58(%eax),%eax
80103ef5:	85 c0                	test   %eax,%eax
80103ef7:	75 f7                	jne    80103ef0 <iderw+0x60>
80103ef9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80103efc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80103efe:	39 1d 84 4e 11 80    	cmp    %ebx,0x80114e84
80103f04:	74 3a                	je     80103f40 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103f06:	8b 03                	mov    (%ebx),%eax
80103f08:	83 e0 06             	and    $0x6,%eax
80103f0b:	83 f8 02             	cmp    $0x2,%eax
80103f0e:	74 1b                	je     80103f2b <iderw+0x9b>
    sleep(b, &idelock);
80103f10:	83 ec 08             	sub    $0x8,%esp
80103f13:	68 a0 4e 11 80       	push   $0x80114ea0
80103f18:	53                   	push   %ebx
80103f19:	e8 32 1f 00 00       	call   80105e50 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103f1e:	8b 03                	mov    (%ebx),%eax
80103f20:	83 c4 10             	add    $0x10,%esp
80103f23:	83 e0 06             	and    $0x6,%eax
80103f26:	83 f8 02             	cmp    $0x2,%eax
80103f29:	75 e5                	jne    80103f10 <iderw+0x80>
  }


  release(&idelock);
80103f2b:	c7 45 08 a0 4e 11 80 	movl   $0x80114ea0,0x8(%ebp)
}
80103f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f35:	c9                   	leave  
  release(&idelock);
80103f36:	e9 55 26 00 00       	jmp    80106590 <release>
80103f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f3f:	90                   	nop
    idestart(b);
80103f40:	89 d8                	mov    %ebx,%eax
80103f42:	e8 39 fd ff ff       	call   80103c80 <idestart>
80103f47:	eb bd                	jmp    80103f06 <iderw+0x76>
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103f50:	ba 84 4e 11 80       	mov    $0x80114e84,%edx
80103f55:	eb a5                	jmp    80103efc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 85 9a 10 80       	push   $0x80109a85
80103f5f:	e8 1c c4 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 70 9a 10 80       	push   $0x80109a70
80103f6c:	e8 0f c4 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80103f71:	83 ec 0c             	sub    $0xc,%esp
80103f74:	68 5a 9a 10 80       	push   $0x80109a5a
80103f79:	e8 02 c4 ff ff       	call   80100380 <panic>
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103f85:	c7 05 d4 4e 11 80 00 	movl   $0xfec00000,0x80114ed4
80103f8c:	00 c0 fe 
  ioapic->reg = reg;
80103f8f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80103f96:	00 00 00 
  return ioapic->data;
80103f99:	8b 15 d4 4e 11 80    	mov    0x80114ed4,%edx
80103f9f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103fa2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103fa8:	8b 1d d4 4e 11 80    	mov    0x80114ed4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80103fae:	0f b6 15 20 50 11 80 	movzbl 0x80115020,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103fb5:	c1 ee 10             	shr    $0x10,%esi
80103fb8:	89 f0                	mov    %esi,%eax
80103fba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80103fbd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80103fc0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103fc3:	39 c2                	cmp    %eax,%edx
80103fc5:	74 16                	je     80103fdd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103fc7:	83 ec 0c             	sub    $0xc,%esp
80103fca:	68 a4 9a 10 80       	push   $0x80109aa4
80103fcf:	e8 fc c7 ff ff       	call   801007d0 <cprintf>
  ioapic->reg = reg;
80103fd4:	8b 1d d4 4e 11 80    	mov    0x80114ed4,%ebx
80103fda:	83 c4 10             	add    $0x10,%esp
{
80103fdd:	ba 10 00 00 00       	mov    $0x10,%edx
80103fe2:	31 c0                	xor    %eax,%eax
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80103fe8:	89 13                	mov    %edx,(%ebx)
80103fea:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
80103fed:	8b 1d d4 4e 11 80    	mov    0x80114ed4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80103ff3:	83 c0 01             	add    $0x1,%eax
80103ff6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
80103ffc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
80103fff:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80104002:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80104005:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80104007:	8b 1d d4 4e 11 80    	mov    0x80114ed4,%ebx
8010400d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80104014:	39 c6                	cmp    %eax,%esi
80104016:	7d d0                	jge    80103fe8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80104018:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010401b:	5b                   	pop    %ebx
8010401c:	5e                   	pop    %esi
8010401d:	5d                   	pop    %ebp
8010401e:	c3                   	ret    
8010401f:	90                   	nop

80104020 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80104020:	55                   	push   %ebp
  ioapic->reg = reg;
80104021:	8b 0d d4 4e 11 80    	mov    0x80114ed4,%ecx
{
80104027:	89 e5                	mov    %esp,%ebp
80104029:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010402c:	8d 50 20             	lea    0x20(%eax),%edx
8010402f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80104033:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104035:	8b 0d d4 4e 11 80    	mov    0x80114ed4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010403b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010403e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80104041:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80104044:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104046:	a1 d4 4e 11 80       	mov    0x80114ed4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010404b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010404e:	89 50 10             	mov    %edx,0x10(%eax)
}
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
80104053:	66 90                	xchg   %ax,%ax
80104055:	66 90                	xchg   %ax,%ax
80104057:	66 90                	xchg   %ax,%ax
80104059:	66 90                	xchg   %ax,%ax
8010405b:	66 90                	xchg   %ax,%ax
8010405d:	66 90                	xchg   %ax,%ax
8010405f:	90                   	nop

80104060 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 04             	sub    $0x4,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010406a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80104070:	75 76                	jne    801040e8 <kfree+0x88>
80104072:	81 fb 90 90 11 80    	cmp    $0x80119090,%ebx
80104078:	72 6e                	jb     801040e8 <kfree+0x88>
8010407a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80104080:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80104085:	77 61                	ja     801040e8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80104087:	83 ec 04             	sub    $0x4,%esp
8010408a:	68 00 10 00 00       	push   $0x1000
8010408f:	6a 01                	push   $0x1
80104091:	53                   	push   %ebx
80104092:	e8 59 26 00 00       	call   801066f0 <memset>

  if(kmem.use_lock)
80104097:	8b 15 14 4f 11 80    	mov    0x80114f14,%edx
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	85 d2                	test   %edx,%edx
801040a2:	75 1c                	jne    801040c0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801040a4:	a1 18 4f 11 80       	mov    0x80114f18,%eax
801040a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801040ab:	a1 14 4f 11 80       	mov    0x80114f14,%eax
  kmem.freelist = r;
801040b0:	89 1d 18 4f 11 80    	mov    %ebx,0x80114f18
  if(kmem.use_lock)
801040b6:	85 c0                	test   %eax,%eax
801040b8:	75 1e                	jne    801040d8 <kfree+0x78>
    release(&kmem.lock);
}
801040ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040bd:	c9                   	leave  
801040be:	c3                   	ret    
801040bf:	90                   	nop
    acquire(&kmem.lock);
801040c0:	83 ec 0c             	sub    $0xc,%esp
801040c3:	68 e0 4e 11 80       	push   $0x80114ee0
801040c8:	e8 23 25 00 00       	call   801065f0 <acquire>
801040cd:	83 c4 10             	add    $0x10,%esp
801040d0:	eb d2                	jmp    801040a4 <kfree+0x44>
801040d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801040d8:	c7 45 08 e0 4e 11 80 	movl   $0x80114ee0,0x8(%ebp)
}
801040df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e2:	c9                   	leave  
    release(&kmem.lock);
801040e3:	e9 a8 24 00 00       	jmp    80106590 <release>
    panic("kfree");
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 d6 9a 10 80       	push   $0x80109ad6
801040f0:	e8 8b c2 ff ff       	call   80100380 <panic>
801040f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104100 <freerange>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80104105:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104108:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010410b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104111:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104117:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010411d:	39 de                	cmp    %ebx,%esi
8010411f:	72 23                	jb     80104144 <freerange+0x44>
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104131:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80104137:	50                   	push   %eax
80104138:	e8 23 ff ff ff       	call   80104060 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010413d:	83 c4 10             	add    $0x10,%esp
80104140:	39 de                	cmp    %ebx,%esi
80104142:	73 e4                	jae    80104128 <freerange+0x28>
}
80104144:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104147:	5b                   	pop    %ebx
80104148:	5e                   	pop    %esi
80104149:	5d                   	pop    %ebp
8010414a:	c3                   	ret    
8010414b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop

80104150 <kinit2>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80104155:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104158:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010415b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104161:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104167:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010416d:	39 de                	cmp    %ebx,%esi
8010416f:	72 23                	jb     80104194 <kinit2+0x44>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104181:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80104187:	50                   	push   %eax
80104188:	e8 d3 fe ff ff       	call   80104060 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010418d:	83 c4 10             	add    $0x10,%esp
80104190:	39 de                	cmp    %ebx,%esi
80104192:	73 e4                	jae    80104178 <kinit2+0x28>
  kmem.use_lock = 1;
80104194:	c7 05 14 4f 11 80 01 	movl   $0x1,0x80114f14
8010419b:	00 00 00 
}
8010419e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5d                   	pop    %ebp
801041a4:	c3                   	ret    
801041a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041b0 <kinit1>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801041b8:	83 ec 08             	sub    $0x8,%esp
801041bb:	68 dc 9a 10 80       	push   $0x80109adc
801041c0:	68 e0 4e 11 80       	push   $0x80114ee0
801041c5:	e8 36 22 00 00       	call   80106400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041cd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801041d0:	c7 05 14 4f 11 80 00 	movl   $0x0,0x80114f14
801041d7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801041da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801041e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801041ec:	39 de                	cmp    %ebx,%esi
801041ee:	72 1c                	jb     8010420c <kinit1+0x5c>
    kfree(p);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801041f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801041ff:	50                   	push   %eax
80104200:	e8 5b fe ff ff       	call   80104060 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	39 de                	cmp    %ebx,%esi
8010420a:	73 e4                	jae    801041f0 <kinit1+0x40>
}
8010420c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010420f:	5b                   	pop    %ebx
80104210:	5e                   	pop    %esi
80104211:	5d                   	pop    %ebp
80104212:	c3                   	ret    
80104213:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80104227:	a1 14 4f 11 80       	mov    0x80114f14,%eax
8010422c:	85 c0                	test   %eax,%eax
8010422e:	75 20                	jne    80104250 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80104230:	8b 1d 18 4f 11 80    	mov    0x80114f18,%ebx
  if(r)
80104236:	85 db                	test   %ebx,%ebx
80104238:	74 07                	je     80104241 <kalloc+0x21>
    kmem.freelist = r->next;
8010423a:	8b 03                	mov    (%ebx),%eax
8010423c:	a3 18 4f 11 80       	mov    %eax,0x80114f18
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80104241:	89 d8                	mov    %ebx,%eax
80104243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104246:	c9                   	leave  
80104247:	c3                   	ret    
80104248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop
    acquire(&kmem.lock);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	68 e0 4e 11 80       	push   $0x80114ee0
80104258:	e8 93 23 00 00       	call   801065f0 <acquire>
  r = kmem.freelist;
8010425d:	8b 1d 18 4f 11 80    	mov    0x80114f18,%ebx
  if(kmem.use_lock)
80104263:	a1 14 4f 11 80       	mov    0x80114f14,%eax
  if(r)
80104268:	83 c4 10             	add    $0x10,%esp
8010426b:	85 db                	test   %ebx,%ebx
8010426d:	74 08                	je     80104277 <kalloc+0x57>
    kmem.freelist = r->next;
8010426f:	8b 13                	mov    (%ebx),%edx
80104271:	89 15 18 4f 11 80    	mov    %edx,0x80114f18
  if(kmem.use_lock)
80104277:	85 c0                	test   %eax,%eax
80104279:	74 c6                	je     80104241 <kalloc+0x21>
    release(&kmem.lock);
8010427b:	83 ec 0c             	sub    $0xc,%esp
8010427e:	68 e0 4e 11 80       	push   $0x80114ee0
80104283:	e8 08 23 00 00       	call   80106590 <release>
}
80104288:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010428a:	83 c4 10             	add    $0x10,%esp
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104290:	c9                   	leave  
80104291:	c3                   	ret    
80104292:	66 90                	xchg   %ax,%ax
80104294:	66 90                	xchg   %ax,%ax
80104296:	66 90                	xchg   %ax,%ax
80104298:	66 90                	xchg   %ax,%ax
8010429a:	66 90                	xchg   %ax,%ax
8010429c:	66 90                	xchg   %ax,%ax
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801042a0:	ba 64 00 00 00       	mov    $0x64,%edx
801042a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801042a6:	a8 01                	test   $0x1,%al
801042a8:	0f 84 c2 00 00 00    	je     80104370 <kbdgetc+0xd0>
{
801042ae:	55                   	push   %ebp
801042af:	ba 60 00 00 00       	mov    $0x60,%edx
801042b4:	89 e5                	mov    %esp,%ebp
801042b6:	53                   	push   %ebx
801042b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801042b8:	8b 1d 1c 4f 11 80    	mov    0x80114f1c,%ebx
  data = inb(KBDATAP);
801042be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801042c1:	3c e0                	cmp    $0xe0,%al
801042c3:	74 5b                	je     80104320 <kbdgetc+0x80>

    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801042c5:	89 da                	mov    %ebx,%edx
801042c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801042ca:	84 c0                	test   %al,%al
801042cc:	78 62                	js     80104330 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801042ce:	85 d2                	test   %edx,%edx
801042d0:	74 09                	je     801042db <kbdgetc+0x3b>
    //     return KEY_LEFT;
    //   case 0x4D:  
    //     shift &= ~E0ESC;
    //     return KEY_RIGHT;
    // }
    data |= 0x80;
801042d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801042d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801042d8:	0f b6 c8             	movzbl %al,%ecx
    
  }

  shift |= shiftcode[data];
801042db:	0f b6 91 20 9c 10 80 	movzbl -0x7fef63e0(%ecx),%edx
  shift ^= togglecode[data];
801042e2:	0f b6 81 20 9b 10 80 	movzbl -0x7fef64e0(%ecx),%eax
  shift |= shiftcode[data];
801042e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801042eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801042ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801042ef:	89 15 1c 4f 11 80    	mov    %edx,0x80114f1c
  c = charcode[shift & (CTL | SHIFT)][data];
801042f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801042f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801042fb:	8b 04 85 00 9b 10 80 	mov    -0x7fef6500(,%eax,4),%eax
80104302:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80104306:	74 0b                	je     80104313 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80104308:	8d 50 9f             	lea    -0x61(%eax),%edx
8010430b:	83 fa 19             	cmp    $0x19,%edx
8010430e:	77 48                	ja     80104358 <kbdgetc+0xb8>
      c += 'A' - 'a';
80104310:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80104313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104316:	c9                   	leave  
80104317:	c3                   	ret    
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop
    shift |= E0ESC;
80104320:	83 cb 40             	or     $0x40,%ebx
    return 0;
80104323:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80104325:	89 1d 1c 4f 11 80    	mov    %ebx,0x80114f1c
}
8010432b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010432e:	c9                   	leave  
8010432f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80104330:	83 e0 7f             	and    $0x7f,%eax
80104333:	85 d2                	test   %edx,%edx
80104335:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80104338:	0f b6 81 20 9c 10 80 	movzbl -0x7fef63e0(%ecx),%eax
8010433f:	83 c8 40             	or     $0x40,%eax
80104342:	0f b6 c0             	movzbl %al,%eax
80104345:	f7 d0                	not    %eax
80104347:	21 d8                	and    %ebx,%eax
80104349:	a3 1c 4f 11 80       	mov    %eax,0x80114f1c
    return 0;
8010434e:	31 c0                	xor    %eax,%eax
80104350:	eb d9                	jmp    8010432b <kbdgetc+0x8b>
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80104358:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010435b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010435e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104361:	c9                   	leave  
      c += 'a' - 'A';
80104362:	83 f9 1a             	cmp    $0x1a,%ecx
80104365:	0f 42 c2             	cmovb  %edx,%eax
}
80104368:	c3                   	ret    
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104375:	c3                   	ret    
80104376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <kbdintr>:

void
kbdintr(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80104386:	68 a0 42 10 80       	push   $0x801042a0
8010438b:	e8 80 d2 ff ff       	call   80101610 <consoleintr>
}
80104390:	83 c4 10             	add    $0x10,%esp
80104393:	c9                   	leave  
80104394:	c3                   	ret    
80104395:	66 90                	xchg   %ax,%ax
80104397:	66 90                	xchg   %ax,%ax
80104399:	66 90                	xchg   %ax,%ax
8010439b:	66 90                	xchg   %ax,%ax
8010439d:	66 90                	xchg   %ax,%ax
8010439f:	90                   	nop

801043a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801043a0:	a1 20 4f 11 80       	mov    0x80114f20,%eax
801043a5:	85 c0                	test   %eax,%eax
801043a7:	0f 84 c3 00 00 00    	je     80104470 <lapicinit+0xd0>
  lapic[index] = value;
801043ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801043b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801043b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801043c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801043c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801043ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801043d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801043db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801043de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801043e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801043eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801043ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801043f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801043f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801043fb:	8b 50 30             	mov    0x30(%eax),%edx
801043fe:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80104404:	75 72                	jne    80104478 <lapicinit+0xd8>
  lapic[index] = value;
80104406:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010440d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104410:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104413:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010441a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010441d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104420:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80104427:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010442a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010442d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104434:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104437:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010443a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80104441:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104444:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104447:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010444e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80104451:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104458:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010445e:	80 e6 10             	and    $0x10,%dh
80104461:	75 f5                	jne    80104458 <lapicinit+0xb8>
  lapic[index] = value;
80104463:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010446a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010446d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80104470:	c3                   	ret    
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80104478:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010447f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80104482:	8b 50 20             	mov    0x20(%eax),%edx
}
80104485:	e9 7c ff ff ff       	jmp    80104406 <lapicinit+0x66>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80104490:	a1 20 4f 11 80       	mov    0x80114f20,%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 07                	je     801044a0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80104499:	8b 40 20             	mov    0x20(%eax),%eax
8010449c:	c1 e8 18             	shr    $0x18,%eax
8010449f:	c3                   	ret    
    return 0;
801044a0:	31 c0                	xor    %eax,%eax
}
801044a2:	c3                   	ret    
801044a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801044b0:	a1 20 4f 11 80       	mov    0x80114f20,%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	74 0d                	je     801044c6 <lapiceoi+0x16>
  lapic[index] = value;
801044b9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801044c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801044c3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801044c6:	c3                   	ret    
801044c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ce:	66 90                	xchg   %ax,%ax

801044d0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801044d0:	c3                   	ret    
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop

801044e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801044e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801044e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801044e6:	ba 70 00 00 00       	mov    $0x70,%edx
801044eb:	89 e5                	mov    %esp,%ebp
801044ed:	53                   	push   %ebx
801044ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801044f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044f4:	ee                   	out    %al,(%dx)
801044f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801044fa:	ba 71 00 00 00       	mov    $0x71,%edx
801044ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80104500:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80104502:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80104505:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010450b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010450d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80104510:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80104512:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80104515:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80104518:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010451e:	a1 20 4f 11 80       	mov    0x80114f20,%eax
80104523:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104529:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010452c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80104533:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104536:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104539:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80104540:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104543:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104546:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010454c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010454f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104555:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104558:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010455e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104561:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104567:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010456a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010456d:	c9                   	leave  
8010456e:	c3                   	ret    
8010456f:	90                   	nop

80104570 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80104570:	55                   	push   %ebp
80104571:	b8 0b 00 00 00       	mov    $0xb,%eax
80104576:	ba 70 00 00 00       	mov    $0x70,%edx
8010457b:	89 e5                	mov    %esp,%ebp
8010457d:	57                   	push   %edi
8010457e:	56                   	push   %esi
8010457f:	53                   	push   %ebx
80104580:	83 ec 4c             	sub    $0x4c,%esp
80104583:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104584:	ba 71 00 00 00       	mov    $0x71,%edx
80104589:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010458a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010458d:	bf 70 00 00 00       	mov    $0x70,%edi
80104592:	88 45 b3             	mov    %al,-0x4d(%ebp)
80104595:	8d 76 00             	lea    0x0(%esi),%esi
80104598:	31 c0                	xor    %eax,%eax
8010459a:	89 fa                	mov    %edi,%edx
8010459c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010459d:	b9 71 00 00 00       	mov    $0x71,%ecx
801045a2:	89 ca                	mov    %ecx,%edx
801045a4:	ec                   	in     (%dx),%al
801045a5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045a8:	89 fa                	mov    %edi,%edx
801045aa:	b8 02 00 00 00       	mov    $0x2,%eax
801045af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045b0:	89 ca                	mov    %ecx,%edx
801045b2:	ec                   	in     (%dx),%al
801045b3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045b6:	89 fa                	mov    %edi,%edx
801045b8:	b8 04 00 00 00       	mov    $0x4,%eax
801045bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045be:	89 ca                	mov    %ecx,%edx
801045c0:	ec                   	in     (%dx),%al
801045c1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045c4:	89 fa                	mov    %edi,%edx
801045c6:	b8 07 00 00 00       	mov    $0x7,%eax
801045cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045cc:	89 ca                	mov    %ecx,%edx
801045ce:	ec                   	in     (%dx),%al
801045cf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045d2:	89 fa                	mov    %edi,%edx
801045d4:	b8 08 00 00 00       	mov    $0x8,%eax
801045d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045da:	89 ca                	mov    %ecx,%edx
801045dc:	ec                   	in     (%dx),%al
801045dd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045df:	89 fa                	mov    %edi,%edx
801045e1:	b8 09 00 00 00       	mov    $0x9,%eax
801045e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045e7:	89 ca                	mov    %ecx,%edx
801045e9:	ec                   	in     (%dx),%al
801045ea:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045ed:	89 fa                	mov    %edi,%edx
801045ef:	b8 0a 00 00 00       	mov    $0xa,%eax
801045f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045f5:	89 ca                	mov    %ecx,%edx
801045f7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801045f8:	84 c0                	test   %al,%al
801045fa:	78 9c                	js     80104598 <cmostime+0x28>
  return inb(CMOS_RETURN);
801045fc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80104600:	89 f2                	mov    %esi,%edx
80104602:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80104605:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104608:	89 fa                	mov    %edi,%edx
8010460a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010460d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80104611:	89 75 c8             	mov    %esi,-0x38(%ebp)
80104614:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104617:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010461b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010461e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80104622:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80104625:	31 c0                	xor    %eax,%eax
80104627:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104628:	89 ca                	mov    %ecx,%edx
8010462a:	ec                   	in     (%dx),%al
8010462b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010462e:	89 fa                	mov    %edi,%edx
80104630:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104633:	b8 02 00 00 00       	mov    $0x2,%eax
80104638:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104639:	89 ca                	mov    %ecx,%edx
8010463b:	ec                   	in     (%dx),%al
8010463c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010463f:	89 fa                	mov    %edi,%edx
80104641:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104644:	b8 04 00 00 00       	mov    $0x4,%eax
80104649:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010464a:	89 ca                	mov    %ecx,%edx
8010464c:	ec                   	in     (%dx),%al
8010464d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104650:	89 fa                	mov    %edi,%edx
80104652:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104655:	b8 07 00 00 00       	mov    $0x7,%eax
8010465a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010465b:	89 ca                	mov    %ecx,%edx
8010465d:	ec                   	in     (%dx),%al
8010465e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104661:	89 fa                	mov    %edi,%edx
80104663:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104666:	b8 08 00 00 00       	mov    $0x8,%eax
8010466b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010466c:	89 ca                	mov    %ecx,%edx
8010466e:	ec                   	in     (%dx),%al
8010466f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104672:	89 fa                	mov    %edi,%edx
80104674:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104677:	b8 09 00 00 00       	mov    $0x9,%eax
8010467c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010467d:	89 ca                	mov    %ecx,%edx
8010467f:	ec                   	in     (%dx),%al
80104680:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80104683:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80104686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80104689:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010468c:	6a 18                	push   $0x18
8010468e:	50                   	push   %eax
8010468f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80104692:	50                   	push   %eax
80104693:	e8 98 20 00 00       	call   80106730 <memcmp>
80104698:	83 c4 10             	add    $0x10,%esp
8010469b:	85 c0                	test   %eax,%eax
8010469d:	0f 85 f5 fe ff ff    	jne    80104598 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801046a3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046aa:	89 f0                	mov    %esi,%eax
801046ac:	84 c0                	test   %al,%al
801046ae:	75 78                	jne    80104728 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801046b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801046b3:	89 c2                	mov    %eax,%edx
801046b5:	83 e0 0f             	and    $0xf,%eax
801046b8:	c1 ea 04             	shr    $0x4,%edx
801046bb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046be:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801046c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801046c7:	89 c2                	mov    %eax,%edx
801046c9:	83 e0 0f             	and    $0xf,%eax
801046cc:	c1 ea 04             	shr    $0x4,%edx
801046cf:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046d2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801046d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801046db:	89 c2                	mov    %eax,%edx
801046dd:	83 e0 0f             	and    $0xf,%eax
801046e0:	c1 ea 04             	shr    $0x4,%edx
801046e3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046e6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801046ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801046ef:	89 c2                	mov    %eax,%edx
801046f1:	83 e0 0f             	and    $0xf,%eax
801046f4:	c1 ea 04             	shr    $0x4,%edx
801046f7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801046fa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801046fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80104700:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104703:	89 c2                	mov    %eax,%edx
80104705:	83 e0 0f             	and    $0xf,%eax
80104708:	c1 ea 04             	shr    $0x4,%edx
8010470b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010470e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104711:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80104714:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104717:	89 c2                	mov    %eax,%edx
80104719:	83 e0 0f             	and    $0xf,%eax
8010471c:	c1 ea 04             	shr    $0x4,%edx
8010471f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104722:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104725:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80104728:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010472b:	89 03                	mov    %eax,(%ebx)
8010472d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104730:	89 43 04             	mov    %eax,0x4(%ebx)
80104733:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104736:	89 43 08             	mov    %eax,0x8(%ebx)
80104739:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010473c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010473f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104742:	89 43 10             	mov    %eax,0x10(%ebx)
80104745:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104748:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010474b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80104752:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104755:	5b                   	pop    %ebx
80104756:	5e                   	pop    %esi
80104757:	5f                   	pop    %edi
80104758:	5d                   	pop    %ebp
80104759:	c3                   	ret    
8010475a:	66 90                	xchg   %ax,%ax
8010475c:	66 90                	xchg   %ax,%ax
8010475e:	66 90                	xchg   %ax,%ax

80104760 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80104760:	8b 0d 88 4f 11 80    	mov    0x80114f88,%ecx
80104766:	85 c9                	test   %ecx,%ecx
80104768:	0f 8e 8a 00 00 00    	jle    801047f8 <install_trans+0x98>
{
8010476e:	55                   	push   %ebp
8010476f:	89 e5                	mov    %esp,%ebp
80104771:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80104772:	31 ff                	xor    %edi,%edi
{
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	83 ec 0c             	sub    $0xc,%esp
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80104780:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80104785:	83 ec 08             	sub    $0x8,%esp
80104788:	01 f8                	add    %edi,%eax
8010478a:	83 c0 01             	add    $0x1,%eax
8010478d:	50                   	push   %eax
8010478e:	ff 35 84 4f 11 80    	pushl  0x80114f84
80104794:	e8 37 b9 ff ff       	call   801000d0 <bread>
80104799:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010479b:	58                   	pop    %eax
8010479c:	5a                   	pop    %edx
8010479d:	ff 34 bd 8c 4f 11 80 	pushl  -0x7feeb074(,%edi,4)
801047a4:	ff 35 84 4f 11 80    	pushl  0x80114f84
  for (tail = 0; tail < log.lh.n; tail++) {
801047aa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801047ad:	e8 1e b9 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801047b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801047b5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801047b7:	8d 46 5c             	lea    0x5c(%esi),%eax
801047ba:	68 00 02 00 00       	push   $0x200
801047bf:	50                   	push   %eax
801047c0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801047c3:	50                   	push   %eax
801047c4:	e8 b7 1f 00 00       	call   80106780 <memmove>
    bwrite(dbuf);  // write dst to disk
801047c9:	89 1c 24             	mov    %ebx,(%esp)
801047cc:	e8 df b9 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801047d1:	89 34 24             	mov    %esi,(%esp)
801047d4:	e8 17 ba ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801047d9:	89 1c 24             	mov    %ebx,(%esp)
801047dc:	e8 0f ba ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801047e1:	83 c4 10             	add    $0x10,%esp
801047e4:	39 3d 88 4f 11 80    	cmp    %edi,0x80114f88
801047ea:	7f 94                	jg     80104780 <install_trans+0x20>
  }
}
801047ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ef:	5b                   	pop    %ebx
801047f0:	5e                   	pop    %esi
801047f1:	5f                   	pop    %edi
801047f2:	5d                   	pop    %ebp
801047f3:	c3                   	ret    
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f8:	c3                   	ret    
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104807:	ff 35 74 4f 11 80    	pushl  0x80114f74
8010480d:	ff 35 84 4f 11 80    	pushl  0x80114f84
80104813:	e8 b8 b8 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104818:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010481b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010481d:	a1 88 4f 11 80       	mov    0x80114f88,%eax
80104822:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104825:	85 c0                	test   %eax,%eax
80104827:	7e 19                	jle    80104842 <write_head+0x42>
80104829:	31 d2                	xor    %edx,%edx
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80104830:	8b 0c 95 8c 4f 11 80 	mov    -0x7feeb074(,%edx,4),%ecx
80104837:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010483b:	83 c2 01             	add    $0x1,%edx
8010483e:	39 d0                	cmp    %edx,%eax
80104840:	75 ee                	jne    80104830 <write_head+0x30>
  }
  bwrite(buf);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	53                   	push   %ebx
80104846:	e8 65 b9 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010484b:	89 1c 24             	mov    %ebx,(%esp)
8010484e:	e8 9d b9 ff ff       	call   801001f0 <brelse>
}
80104853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104856:	83 c4 10             	add    $0x10,%esp
80104859:	c9                   	leave  
8010485a:	c3                   	ret    
8010485b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop

80104860 <initlog>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 2c             	sub    $0x2c,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010486a:	68 20 9d 10 80       	push   $0x80109d20
8010486f:	68 40 4f 11 80       	push   $0x80114f40
80104874:	e8 87 1b 00 00       	call   80106400 <initlock>
  readsb(dev, &sb);
80104879:	58                   	pop    %eax
8010487a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010487d:	5a                   	pop    %edx
8010487e:	50                   	push   %eax
8010487f:	53                   	push   %ebx
80104880:	e8 7b e8 ff ff       	call   80103100 <readsb>
  log.start = sb.logstart;
80104885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80104888:	59                   	pop    %ecx
  log.dev = dev;
80104889:	89 1d 84 4f 11 80    	mov    %ebx,0x80114f84
  log.size = sb.nlog;
8010488f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104892:	a3 74 4f 11 80       	mov    %eax,0x80114f74
  log.size = sb.nlog;
80104897:	89 15 78 4f 11 80    	mov    %edx,0x80114f78
  struct buf *buf = bread(log.dev, log.start);
8010489d:	5a                   	pop    %edx
8010489e:	50                   	push   %eax
8010489f:	53                   	push   %ebx
801048a0:	e8 2b b8 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801048a5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801048a8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801048ab:	89 1d 88 4f 11 80    	mov    %ebx,0x80114f88
  for (i = 0; i < log.lh.n; i++) {
801048b1:	85 db                	test   %ebx,%ebx
801048b3:	7e 1d                	jle    801048d2 <initlog+0x72>
801048b5:	31 d2                	xor    %edx,%edx
801048b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048be:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801048c0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801048c4:	89 0c 95 8c 4f 11 80 	mov    %ecx,-0x7feeb074(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801048cb:	83 c2 01             	add    $0x1,%edx
801048ce:	39 d3                	cmp    %edx,%ebx
801048d0:	75 ee                	jne    801048c0 <initlog+0x60>
  brelse(buf);
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	50                   	push   %eax
801048d6:	e8 15 b9 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801048db:	e8 80 fe ff ff       	call   80104760 <install_trans>
  log.lh.n = 0;
801048e0:	c7 05 88 4f 11 80 00 	movl   $0x0,0x80114f88
801048e7:	00 00 00 
  write_head(); // clear the log
801048ea:	e8 11 ff ff ff       	call   80104800 <write_head>
}
801048ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f2:	83 c4 10             	add    $0x10,%esp
801048f5:	c9                   	leave  
801048f6:	c3                   	ret    
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax

80104900 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104906:	68 40 4f 11 80       	push   $0x80114f40
8010490b:	e8 e0 1c 00 00       	call   801065f0 <acquire>
80104910:	83 c4 10             	add    $0x10,%esp
80104913:	eb 18                	jmp    8010492d <begin_op+0x2d>
80104915:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104918:	83 ec 08             	sub    $0x8,%esp
8010491b:	68 40 4f 11 80       	push   $0x80114f40
80104920:	68 40 4f 11 80       	push   $0x80114f40
80104925:	e8 26 15 00 00       	call   80105e50 <sleep>
8010492a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010492d:	a1 80 4f 11 80       	mov    0x80114f80,%eax
80104932:	85 c0                	test   %eax,%eax
80104934:	75 e2                	jne    80104918 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104936:	a1 7c 4f 11 80       	mov    0x80114f7c,%eax
8010493b:	8b 15 88 4f 11 80    	mov    0x80114f88,%edx
80104941:	83 c0 01             	add    $0x1,%eax
80104944:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104947:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010494a:	83 fa 1e             	cmp    $0x1e,%edx
8010494d:	7f c9                	jg     80104918 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010494f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104952:	a3 7c 4f 11 80       	mov    %eax,0x80114f7c
      release(&log.lock);
80104957:	68 40 4f 11 80       	push   $0x80114f40
8010495c:	e8 2f 1c 00 00       	call   80106590 <release>
      break;
    }
  }
}
80104961:	83 c4 10             	add    $0x10,%esp
80104964:	c9                   	leave  
80104965:	c3                   	ret    
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	53                   	push   %ebx
80104976:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80104979:	68 40 4f 11 80       	push   $0x80114f40
8010497e:	e8 6d 1c 00 00       	call   801065f0 <acquire>
  log.outstanding -= 1;
80104983:	a1 7c 4f 11 80       	mov    0x80114f7c,%eax
  if(log.committing)
80104988:	8b 35 80 4f 11 80    	mov    0x80114f80,%esi
8010498e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104991:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104994:	89 1d 7c 4f 11 80    	mov    %ebx,0x80114f7c
  if(log.committing)
8010499a:	85 f6                	test   %esi,%esi
8010499c:	0f 85 22 01 00 00    	jne    80104ac4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801049a2:	85 db                	test   %ebx,%ebx
801049a4:	0f 85 f6 00 00 00    	jne    80104aa0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801049aa:	c7 05 80 4f 11 80 01 	movl   $0x1,0x80114f80
801049b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	68 40 4f 11 80       	push   $0x80114f40
801049bc:	e8 cf 1b 00 00       	call   80106590 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801049c1:	8b 0d 88 4f 11 80    	mov    0x80114f88,%ecx
801049c7:	83 c4 10             	add    $0x10,%esp
801049ca:	85 c9                	test   %ecx,%ecx
801049cc:	7f 42                	jg     80104a10 <end_op+0xa0>
    acquire(&log.lock);
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	68 40 4f 11 80       	push   $0x80114f40
801049d6:	e8 15 1c 00 00       	call   801065f0 <acquire>
    log.committing = 0;
801049db:	c7 05 80 4f 11 80 00 	movl   $0x0,0x80114f80
801049e2:	00 00 00 
    wakeup(&log);
801049e5:	c7 04 24 40 4f 11 80 	movl   $0x80114f40,(%esp)
801049ec:	e8 1f 15 00 00       	call   80105f10 <wakeup>
    release(&log.lock);
801049f1:	c7 04 24 40 4f 11 80 	movl   $0x80114f40,(%esp)
801049f8:	e8 93 1b 00 00       	call   80106590 <release>
801049fd:	83 c4 10             	add    $0x10,%esp
}
80104a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a03:	5b                   	pop    %ebx
80104a04:	5e                   	pop    %esi
80104a05:	5f                   	pop    %edi
80104a06:	5d                   	pop    %ebp
80104a07:	c3                   	ret    
80104a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104a10:	a1 74 4f 11 80       	mov    0x80114f74,%eax
80104a15:	83 ec 08             	sub    $0x8,%esp
80104a18:	01 d8                	add    %ebx,%eax
80104a1a:	83 c0 01             	add    $0x1,%eax
80104a1d:	50                   	push   %eax
80104a1e:	ff 35 84 4f 11 80    	pushl  0x80114f84
80104a24:	e8 a7 b6 ff ff       	call   801000d0 <bread>
80104a29:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a2b:	58                   	pop    %eax
80104a2c:	5a                   	pop    %edx
80104a2d:	ff 34 9d 8c 4f 11 80 	pushl  -0x7feeb074(,%ebx,4)
80104a34:	ff 35 84 4f 11 80    	pushl  0x80114f84
  for (tail = 0; tail < log.lh.n; tail++) {
80104a3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a3d:	e8 8e b6 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104a42:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104a45:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104a47:	8d 40 5c             	lea    0x5c(%eax),%eax
80104a4a:	68 00 02 00 00       	push   $0x200
80104a4f:	50                   	push   %eax
80104a50:	8d 46 5c             	lea    0x5c(%esi),%eax
80104a53:	50                   	push   %eax
80104a54:	e8 27 1d 00 00       	call   80106780 <memmove>
    bwrite(to);  // write the log
80104a59:	89 34 24             	mov    %esi,(%esp)
80104a5c:	e8 4f b7 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80104a61:	89 3c 24             	mov    %edi,(%esp)
80104a64:	e8 87 b7 ff ff       	call   801001f0 <brelse>
    brelse(to);
80104a69:	89 34 24             	mov    %esi,(%esp)
80104a6c:	e8 7f b7 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	3b 1d 88 4f 11 80    	cmp    0x80114f88,%ebx
80104a7a:	7c 94                	jl     80104a10 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80104a7c:	e8 7f fd ff ff       	call   80104800 <write_head>
    install_trans(); // Now install writes to home locations
80104a81:	e8 da fc ff ff       	call   80104760 <install_trans>
    log.lh.n = 0;
80104a86:	c7 05 88 4f 11 80 00 	movl   $0x0,0x80114f88
80104a8d:	00 00 00 
    write_head();    // Erase the transaction from the log
80104a90:	e8 6b fd ff ff       	call   80104800 <write_head>
80104a95:	e9 34 ff ff ff       	jmp    801049ce <end_op+0x5e>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	68 40 4f 11 80       	push   $0x80114f40
80104aa8:	e8 63 14 00 00       	call   80105f10 <wakeup>
  release(&log.lock);
80104aad:	c7 04 24 40 4f 11 80 	movl   $0x80114f40,(%esp)
80104ab4:	e8 d7 1a 00 00       	call   80106590 <release>
80104ab9:	83 c4 10             	add    $0x10,%esp
}
80104abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104abf:	5b                   	pop    %ebx
80104ac0:	5e                   	pop    %esi
80104ac1:	5f                   	pop    %edi
80104ac2:	5d                   	pop    %ebp
80104ac3:	c3                   	ret    
    panic("log.committing");
80104ac4:	83 ec 0c             	sub    $0xc,%esp
80104ac7:	68 24 9d 10 80       	push   $0x80109d24
80104acc:	e8 af b8 ff ff       	call   80100380 <panic>
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104adf:	90                   	nop

80104ae0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104ae7:	8b 15 88 4f 11 80    	mov    0x80114f88,%edx
{
80104aed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104af0:	83 fa 1d             	cmp    $0x1d,%edx
80104af3:	7f 7d                	jg     80104b72 <log_write+0x92>
80104af5:	a1 78 4f 11 80       	mov    0x80114f78,%eax
80104afa:	83 e8 01             	sub    $0x1,%eax
80104afd:	39 c2                	cmp    %eax,%edx
80104aff:	7d 71                	jge    80104b72 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104b01:	a1 7c 4f 11 80       	mov    0x80114f7c,%eax
80104b06:	85 c0                	test   %eax,%eax
80104b08:	7e 75                	jle    80104b7f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	68 40 4f 11 80       	push   $0x80114f40
80104b12:	e8 d9 1a 00 00       	call   801065f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104b17:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80104b1a:	83 c4 10             	add    $0x10,%esp
80104b1d:	31 c0                	xor    %eax,%eax
80104b1f:	8b 15 88 4f 11 80    	mov    0x80114f88,%edx
80104b25:	85 d2                	test   %edx,%edx
80104b27:	7f 0e                	jg     80104b37 <log_write+0x57>
80104b29:	eb 15                	jmp    80104b40 <log_write+0x60>
80104b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
80104b30:	83 c0 01             	add    $0x1,%eax
80104b33:	39 c2                	cmp    %eax,%edx
80104b35:	74 29                	je     80104b60 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104b37:	39 0c 85 8c 4f 11 80 	cmp    %ecx,-0x7feeb074(,%eax,4)
80104b3e:	75 f0                	jne    80104b30 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104b40:	89 0c 85 8c 4f 11 80 	mov    %ecx,-0x7feeb074(,%eax,4)
  if (i == log.lh.n)
80104b47:	39 c2                	cmp    %eax,%edx
80104b49:	74 1c                	je     80104b67 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80104b4b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80104b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80104b51:	c7 45 08 40 4f 11 80 	movl   $0x80114f40,0x8(%ebp)
}
80104b58:	c9                   	leave  
  release(&log.lock);
80104b59:	e9 32 1a 00 00       	jmp    80106590 <release>
80104b5e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104b60:	89 0c 95 8c 4f 11 80 	mov    %ecx,-0x7feeb074(,%edx,4)
    log.lh.n++;
80104b67:	83 c2 01             	add    $0x1,%edx
80104b6a:	89 15 88 4f 11 80    	mov    %edx,0x80114f88
80104b70:	eb d9                	jmp    80104b4b <log_write+0x6b>
    panic("too big a transaction");
80104b72:	83 ec 0c             	sub    $0xc,%esp
80104b75:	68 33 9d 10 80       	push   $0x80109d33
80104b7a:	e8 01 b8 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	68 49 9d 10 80       	push   $0x80109d49
80104b87:	e8 f4 b7 ff ff       	call   80100380 <panic>
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104b97:	e8 a4 09 00 00       	call   80105540 <cpuid>
80104b9c:	89 c3                	mov    %eax,%ebx
80104b9e:	e8 9d 09 00 00       	call   80105540 <cpuid>
80104ba3:	83 ec 04             	sub    $0x4,%esp
80104ba6:	53                   	push   %ebx
80104ba7:	50                   	push   %eax
80104ba8:	68 64 9d 10 80       	push   $0x80109d64
80104bad:	e8 1e bc ff ff       	call   801007d0 <cprintf>
  idtinit();       // load idt register
80104bb2:	e8 39 33 00 00       	call   80107ef0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104bb7:	e8 24 09 00 00       	call   801054e0 <mycpu>
80104bbc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104bbe:	b8 01 00 00 00       	mov    $0x1,%eax
80104bc3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80104bca:	e8 21 0e 00 00       	call   801059f0 <scheduler>
80104bcf:	90                   	nop

80104bd0 <mpenter>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104bd6:	e8 45 44 00 00       	call   80109020 <switchkvm>
  seginit();
80104bdb:	e8 b0 43 00 00       	call   80108f90 <seginit>
  lapicinit();
80104be0:	e8 bb f7 ff ff       	call   801043a0 <lapicinit>
  mpmain();
80104be5:	e8 a6 ff ff ff       	call   80104b90 <mpmain>
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <main>:
{
80104bf0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104bf4:	83 e4 f0             	and    $0xfffffff0,%esp
80104bf7:	ff 71 fc             	pushl  -0x4(%ecx)
80104bfa:	55                   	push   %ebp
80104bfb:	89 e5                	mov    %esp,%ebp
80104bfd:	53                   	push   %ebx
80104bfe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80104bff:	83 ec 08             	sub    $0x8,%esp
80104c02:	68 00 00 40 80       	push   $0x80400000
80104c07:	68 90 90 11 80       	push   $0x80119090
80104c0c:	e8 9f f5 ff ff       	call   801041b0 <kinit1>
  kvmalloc();      // kernel page table
80104c11:	e8 ca 48 00 00       	call   801094e0 <kvmalloc>
  mpinit();        // detect other processors
80104c16:	e8 85 01 00 00       	call   80104da0 <mpinit>
  lapicinit();     // interrupt controller
80104c1b:	e8 80 f7 ff ff       	call   801043a0 <lapicinit>
  seginit();       // segment descriptors
80104c20:	e8 6b 43 00 00       	call   80108f90 <seginit>
  picinit();       // disable pic
80104c25:	e8 a6 03 00 00       	call   80104fd0 <picinit>
  ioapicinit();    // another interrupt controller
80104c2a:	e8 51 f3 ff ff       	call   80103f80 <ioapicinit>
  consoleinit();   // console hardware
80104c2f:	e8 ec d9 ff ff       	call   80102620 <consoleinit>
  uartinit();      // serial port
80104c34:	e8 c7 35 00 00       	call   80108200 <uartinit>
  pinit();         // process table
80104c39:	e8 82 08 00 00       	call   801054c0 <pinit>
  tvinit();        // trap vectors
80104c3e:	e8 2d 32 00 00       	call   80107e70 <tvinit>
  binit();         // buffer cache
80104c43:	e8 f8 b3 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104c48:	e8 a3 dd ff ff       	call   801029f0 <fileinit>
  ideinit();       // disk 
80104c4d:	e8 0e f1 ff ff       	call   80103d60 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104c52:	83 c4 0c             	add    $0xc,%esp
80104c55:	68 8a 00 00 00       	push   $0x8a
80104c5a:	68 8c d4 10 80       	push   $0x8010d48c
80104c5f:	68 00 70 00 80       	push   $0x80007000
80104c64:	e8 17 1b 00 00       	call   80106780 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104c69:	83 c4 10             	add    $0x10,%esp
80104c6c:	69 05 24 50 11 80 b4 	imul   $0xb4,0x80115024,%eax
80104c73:	00 00 00 
80104c76:	05 40 50 11 80       	add    $0x80115040,%eax
80104c7b:	3d 40 50 11 80       	cmp    $0x80115040,%eax
80104c80:	76 7e                	jbe    80104d00 <main+0x110>
80104c82:	bb 40 50 11 80       	mov    $0x80115040,%ebx
80104c87:	eb 20                	jmp    80104ca9 <main+0xb9>
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c90:	69 05 24 50 11 80 b4 	imul   $0xb4,0x80115024,%eax
80104c97:	00 00 00 
80104c9a:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80104ca0:	05 40 50 11 80       	add    $0x80115040,%eax
80104ca5:	39 c3                	cmp    %eax,%ebx
80104ca7:	73 57                	jae    80104d00 <main+0x110>
    if(c == mycpu())  // We've started already.
80104ca9:	e8 32 08 00 00       	call   801054e0 <mycpu>
80104cae:	39 c3                	cmp    %eax,%ebx
80104cb0:	74 de                	je     80104c90 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104cb2:	e8 69 f5 ff ff       	call   80104220 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104cb7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80104cba:	c7 05 f8 6f 00 80 d0 	movl   $0x80104bd0,0x80006ff8
80104cc1:	4b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104cc4:	c7 05 f4 6f 00 80 00 	movl   $0x10c000,0x80006ff4
80104ccb:	c0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80104cce:	05 00 10 00 00       	add    $0x1000,%eax
80104cd3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104cd8:	0f b6 03             	movzbl (%ebx),%eax
80104cdb:	68 00 70 00 00       	push   $0x7000
80104ce0:	50                   	push   %eax
80104ce1:	e8 fa f7 ff ff       	call   801044e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	74 f6                	je     80104cf0 <main+0x100>
80104cfa:	eb 94                	jmp    80104c90 <main+0xa0>
80104cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104d00:	83 ec 08             	sub    $0x8,%esp
80104d03:	68 00 00 00 8e       	push   $0x8e000000
80104d08:	68 00 00 40 80       	push   $0x80400000
80104d0d:	e8 3e f4 ff ff       	call   80104150 <kinit2>
  userinit();      // first user process
80104d12:	e8 79 08 00 00       	call   80105590 <userinit>
  mpmain();        // finish this processor's setup
80104d17:	e8 74 fe ff ff       	call   80104b90 <mpmain>
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104d25:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80104d2b:	53                   	push   %ebx
  e = addr+len;
80104d2c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80104d2f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80104d32:	39 de                	cmp    %ebx,%esi
80104d34:	72 10                	jb     80104d46 <mpsearch1+0x26>
80104d36:	eb 50                	jmp    80104d88 <mpsearch1+0x68>
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop
80104d40:	89 fe                	mov    %edi,%esi
80104d42:	39 df                	cmp    %ebx,%edi
80104d44:	73 42                	jae    80104d88 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104d46:	83 ec 04             	sub    $0x4,%esp
80104d49:	8d 7e 10             	lea    0x10(%esi),%edi
80104d4c:	6a 04                	push   $0x4
80104d4e:	68 78 9d 10 80       	push   $0x80109d78
80104d53:	56                   	push   %esi
80104d54:	e8 d7 19 00 00       	call   80106730 <memcmp>
80104d59:	83 c4 10             	add    $0x10,%esp
80104d5c:	85 c0                	test   %eax,%eax
80104d5e:	75 e0                	jne    80104d40 <mpsearch1+0x20>
80104d60:	89 f2                	mov    %esi,%edx
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80104d68:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104d6b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104d6e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104d70:	39 fa                	cmp    %edi,%edx
80104d72:	75 f4                	jne    80104d68 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104d74:	84 c0                	test   %al,%al
80104d76:	75 c8                	jne    80104d40 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80104d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d7b:	89 f0                	mov    %esi,%eax
80104d7d:	5b                   	pop    %ebx
80104d7e:	5e                   	pop    %esi
80104d7f:	5f                   	pop    %edi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret    
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104d8b:	31 f6                	xor    %esi,%esi
}
80104d8d:	5b                   	pop    %ebx
80104d8e:	89 f0                	mov    %esi,%eax
80104d90:	5e                   	pop    %esi
80104d91:	5f                   	pop    %edi
80104d92:	5d                   	pop    %ebp
80104d93:	c3                   	ret    
80104d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop

80104da0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
80104da6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104da9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104db0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104db7:	c1 e0 08             	shl    $0x8,%eax
80104dba:	09 d0                	or     %edx,%eax
80104dbc:	c1 e0 04             	shl    $0x4,%eax
80104dbf:	75 1b                	jne    80104ddc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104dc1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104dc8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80104dcf:	c1 e0 08             	shl    $0x8,%eax
80104dd2:	09 d0                	or     %edx,%eax
80104dd4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104dd7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80104ddc:	ba 00 04 00 00       	mov    $0x400,%edx
80104de1:	e8 3a ff ff ff       	call   80104d20 <mpsearch1>
80104de6:	89 c3                	mov    %eax,%ebx
80104de8:	85 c0                	test   %eax,%eax
80104dea:	0f 84 78 01 00 00    	je     80104f68 <mpinit+0x1c8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104df0:	8b 73 04             	mov    0x4(%ebx),%esi
80104df3:	85 f6                	test   %esi,%esi
80104df5:	0f 84 5d 01 00 00    	je     80104f58 <mpinit+0x1b8>
  if(memcmp(conf, "PCMP", 4) != 0)
80104dfb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80104dfe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80104e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104e07:	6a 04                	push   $0x4
80104e09:	68 7d 9d 10 80       	push   $0x80109d7d
80104e0e:	50                   	push   %eax
80104e0f:	e8 1c 19 00 00       	call   80106730 <memcmp>
80104e14:	83 c4 10             	add    $0x10,%esp
80104e17:	85 c0                	test   %eax,%eax
80104e19:	0f 85 39 01 00 00    	jne    80104f58 <mpinit+0x1b8>
  if(conf->version != 1 && conf->version != 4)
80104e1f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104e26:	3c 01                	cmp    $0x1,%al
80104e28:	74 08                	je     80104e32 <mpinit+0x92>
80104e2a:	3c 04                	cmp    $0x4,%al
80104e2c:	0f 85 26 01 00 00    	jne    80104f58 <mpinit+0x1b8>
  if(sum((uchar*)conf, conf->length) != 0)
80104e32:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80104e39:	66 85 d2             	test   %dx,%dx
80104e3c:	74 22                	je     80104e60 <mpinit+0xc0>
80104e3e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80104e41:	89 f0                	mov    %esi,%eax
  sum = 0;
80104e43:	31 d2                	xor    %edx,%edx
80104e45:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104e48:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80104e4f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80104e52:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80104e54:	39 f8                	cmp    %edi,%eax
80104e56:	75 f0                	jne    80104e48 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80104e58:	84 d2                	test   %dl,%dl
80104e5a:	0f 85 f8 00 00 00    	jne    80104f58 <mpinit+0x1b8>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80104e60:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104e66:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  ismp = 1;
80104e69:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
80104e70:	a3 20 4f 11 80       	mov    %eax,0x80114f20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104e75:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80104e7c:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80104e82:	01 cf                	add    %ecx,%edi
80104e84:	89 f9                	mov    %edi,%ecx
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
80104e90:	39 c8                	cmp    %ecx,%eax
80104e92:	73 19                	jae    80104ead <mpinit+0x10d>
    switch(*p){
80104e94:	0f b6 10             	movzbl (%eax),%edx
80104e97:	80 fa 02             	cmp    $0x2,%dl
80104e9a:	0f 84 a0 00 00 00    	je     80104f40 <mpinit+0x1a0>
80104ea0:	77 7e                	ja     80104f20 <mpinit+0x180>
80104ea2:	84 d2                	test   %dl,%dl
80104ea4:	74 3a                	je     80104ee0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104ea6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104ea9:	39 c8                	cmp    %ecx,%eax
80104eab:	72 e7                	jb     80104e94 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	0f 84 fd 00 00 00    	je     80104fb5 <mpinit+0x215>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104eb8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104ebc:	74 15                	je     80104ed3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104ebe:	b8 70 00 00 00       	mov    $0x70,%eax
80104ec3:	ba 22 00 00 00       	mov    $0x22,%edx
80104ec8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104ec9:	ba 23 00 00 00       	mov    $0x23,%edx
80104ece:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104ecf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104ed2:	ee                   	out    %al,(%dx)
  }
}
80104ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed6:	5b                   	pop    %ebx
80104ed7:	5e                   	pop    %esi
80104ed8:	5f                   	pop    %edi
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    
80104edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop
      if(ncpu < NCPU) {
80104ee0:	8b 35 24 50 11 80    	mov    0x80115024,%esi
80104ee6:	83 fe 07             	cmp    $0x7,%esi
80104ee9:	7f 24                	jg     80104f0f <mpinit+0x16f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80104eeb:	69 fe b4 00 00 00    	imul   $0xb4,%esi,%edi
80104ef1:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80104ef5:	88 97 40 50 11 80    	mov    %dl,-0x7feeafc0(%edi)
        cpus[ncpu].type = (ncpu % 2 == 0) ? ECORE : PCORE; // add for LAB3
80104efb:	89 f2                	mov    %esi,%edx
        ncpu++;
80104efd:	83 c6 01             	add    $0x1,%esi
        cpus[ncpu].type = (ncpu % 2 == 0) ? ECORE : PCORE; // add for LAB3
80104f00:	83 e2 01             	and    $0x1,%edx
        ncpu++;
80104f03:	89 35 24 50 11 80    	mov    %esi,0x80115024
        cpus[ncpu].type = (ncpu % 2 == 0) ? ECORE : PCORE; // add for LAB3
80104f09:	89 97 f0 50 11 80    	mov    %edx,-0x7feeaf10(%edi)
      p += sizeof(struct mpproc);
80104f0f:	83 c0 14             	add    $0x14,%eax
      continue;
80104f12:	e9 79 ff ff ff       	jmp    80104e90 <mpinit+0xf0>
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax
    switch(*p){
80104f20:	83 ea 03             	sub    $0x3,%edx
80104f23:	80 fa 01             	cmp    $0x1,%dl
80104f26:	0f 86 7a ff ff ff    	jbe    80104ea6 <mpinit+0x106>
80104f2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104f33:	e9 58 ff ff ff       	jmp    80104e90 <mpinit+0xf0>
80104f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
      ioapicid = ioapic->apicno;
80104f40:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80104f44:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104f47:	88 15 20 50 11 80    	mov    %dl,0x80115020
      continue;
80104f4d:	e9 3e ff ff ff       	jmp    80104e90 <mpinit+0xf0>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80104f58:	83 ec 0c             	sub    $0xc,%esp
80104f5b:	68 82 9d 10 80       	push   $0x80109d82
80104f60:	e8 1b b4 ff ff       	call   80100380 <panic>
80104f65:	8d 76 00             	lea    0x0(%esi),%esi
{
80104f68:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80104f6d:	eb 0b                	jmp    80104f7a <mpinit+0x1da>
80104f6f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80104f70:	89 f3                	mov    %esi,%ebx
80104f72:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80104f78:	74 de                	je     80104f58 <mpinit+0x1b8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	8d 73 10             	lea    0x10(%ebx),%esi
80104f80:	6a 04                	push   $0x4
80104f82:	68 78 9d 10 80       	push   $0x80109d78
80104f87:	53                   	push   %ebx
80104f88:	e8 a3 17 00 00       	call   80106730 <memcmp>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	75 dc                	jne    80104f70 <mpinit+0x1d0>
80104f94:	89 da                	mov    %ebx,%edx
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104fa0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104fa3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104fa6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104fa8:	39 d6                	cmp    %edx,%esi
80104faa:	75 f4                	jne    80104fa0 <mpinit+0x200>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104fac:	84 c0                	test   %al,%al
80104fae:	75 c0                	jne    80104f70 <mpinit+0x1d0>
80104fb0:	e9 3b fe ff ff       	jmp    80104df0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	68 9c 9d 10 80       	push   $0x80109d9c
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
8010500b:	e8 00 da ff ff       	call   80102a10 <filealloc>
80105010:	89 06                	mov    %eax,(%esi)
80105012:	85 c0                	test   %eax,%eax
80105014:	0f 84 a5 00 00 00    	je     801050bf <pipealloc+0xcf>
8010501a:	e8 f1 d9 ff ff       	call   80102a10 <filealloc>
8010501f:	89 07                	mov    %eax,(%edi)
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 84 00 00 00    	je     801050ad <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80105029:	e8 f2 f1 ff ff       	call   80104220 <kalloc>
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
80105063:	68 bb 9d 10 80       	push   $0x80109dbb
80105068:	50                   	push   %eax
80105069:	e8 92 13 00 00       	call   80106400 <initlock>
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
801050b7:	e8 14 da ff ff       	call   80102ad0 <fileclose>
801050bc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801050bf:	8b 07                	mov    (%edi),%eax
801050c1:	85 c0                	test   %eax,%eax
801050c3:	74 0c                	je     801050d1 <pipealloc+0xe1>
    fileclose(*f1);
801050c5:	83 ec 0c             	sub    $0xc,%esp
801050c8:	50                   	push   %eax
801050c9:	e8 02 da ff ff       	call   80102ad0 <fileclose>
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
801050ef:	e8 fc 14 00 00       	call   801065f0 <acquire>
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
8010510f:	e8 fc 0d 00 00       	call   80105f10 <wakeup>
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
80105134:	e9 57 14 00 00       	jmp    80106590 <release>
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	53                   	push   %ebx
80105144:	e8 47 14 00 00       	call   80106590 <release>
    kfree((char*)p);
80105149:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010514c:	83 c4 10             	add    $0x10,%esp
}
8010514f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
    kfree((char*)p);
80105155:	e9 06 ef ff ff       	jmp    80104060 <kfree>
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80105169:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80105170:	00 00 00 
    wakeup(&p->nwrite);
80105173:	50                   	push   %eax
80105174:	e8 97 0d 00 00       	call   80105f10 <wakeup>
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
80105190:	e8 5b 14 00 00       	call   801065f0 <acquire>
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
801051db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051df:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801051e0:	e8 7b 03 00 00       	call   80105560 <myproc>
801051e5:	8b 48 24             	mov    0x24(%eax),%ecx
801051e8:	85 c9                	test   %ecx,%ecx
801051ea:	75 34                	jne    80105220 <pipewrite+0xa0>
      wakeup(&p->nread);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	56                   	push   %esi
801051f0:	e8 1b 0d 00 00       	call   80105f10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	53                   	push   %ebx
801051f8:	57                   	push   %edi
801051f9:	e8 52 0c 00 00       	call   80105e50 <sleep>
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
80105224:	e8 67 13 00 00       	call   80106590 <release>
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
80105278:	e8 93 0c 00 00       	call   80105f10 <wakeup>
  release(&p->lock);
8010527d:	89 1c 24             	mov    %ebx,(%esp)
80105280:	e8 0b 13 00 00       	call   80106590 <release>
  return n;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	89 f8                	mov    %edi,%eax
8010528a:	eb a5                	jmp    80105231 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010528c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010528f:	eb b2                	jmp    80105243 <pipewrite+0xc3>
80105291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop

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
801052b6:	e8 35 13 00 00       	call   801065f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801052bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801052ca:	74 2f                	je     801052fb <piperead+0x5b>
801052cc:	eb 37                	jmp    80105305 <piperead+0x65>
801052ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801052d0:	e8 8b 02 00 00       	call   80105560 <myproc>
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
801052e5:	e8 66 0b 00 00       	call   80105e50 <sleep>
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
80105346:	e8 c5 0b 00 00       	call   80105f10 <wakeup>
  release(&p->lock);
8010534b:	89 34 24             	mov    %esi,(%esp)
8010534e:	e8 3d 12 00 00       	call   80106590 <release>
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
80105369:	e8 22 12 00 00       	call   80106590 <release>
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
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105384:	bb 14 56 11 80       	mov    $0x80115614,%ebx
{
80105389:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010538c:	68 e0 55 11 80       	push   $0x801155e0
80105391:	e8 5a 12 00 00       	call   801065f0 <acquire>
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	eb 17                	jmp    801053b2 <allocproc+0x32>
8010539b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010539f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053a0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801053a6:	81 fb 14 78 11 80    	cmp    $0x80117814,%ebx
801053ac:	0f 84 8e 00 00 00    	je     80105440 <allocproc+0xc0>
    if (p->state == UNUSED)
801053b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801053b5:	85 c0                	test   %eax,%eax
801053b7:	75 e7                	jne    801053a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801053b9:	a1 04 d0 10 80       	mov    0x8010d004,%eax
  p->priority = 1;

  release(&ptable.lock);
801053be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801053c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 1;
801053c8:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->pid = nextpid++;
801053cf:	89 43 10             	mov    %eax,0x10(%ebx)
801053d2:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801053d5:	68 e0 55 11 80       	push   $0x801155e0
  p->pid = nextpid++;
801053da:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
  release(&ptable.lock);
801053e0:	e8 ab 11 00 00       	call   80106590 <release>

  p->create_time = ticks; // add for FCFS
801053e5:	a1 20 78 11 80       	mov    0x80117820,%eax
801053ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801053f0:	e8 2b ee ff ff       	call   80104220 <kalloc>
801053f5:	83 c4 10             	add    $0x10,%esp
801053f8:	89 43 08             	mov    %eax,0x8(%ebx)
801053fb:	85 c0                	test   %eax,%eax
801053fd:	74 5a                	je     80105459 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801053ff:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80105405:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80105408:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010540d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80105410:	c7 40 14 5f 7e 10 80 	movl   $0x80107e5f,0x14(%eax)
  p->context = (struct context *)sp;
80105417:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010541a:	6a 14                	push   $0x14
8010541c:	6a 00                	push   $0x0
8010541e:	50                   	push   %eax
8010541f:	e8 cc 12 00 00       	call   801066f0 <memset>
  p->context->eip = (uint)forkret;
80105424:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80105427:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010542a:	c7 40 10 70 54 10 80 	movl   $0x80105470,0x10(%eax)
}
80105431:	89 d8                	mov    %ebx,%eax
80105433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105436:	c9                   	leave  
80105437:	c3                   	ret    
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
  release(&ptable.lock);
80105440:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80105443:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80105445:	68 e0 55 11 80       	push   $0x801155e0
8010544a:	e8 41 11 00 00       	call   80106590 <release>
  return 0;
8010544f:	83 c4 10             	add    $0x10,%esp
}
80105452:	89 d8                	mov    %ebx,%eax
80105454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105457:	c9                   	leave  
80105458:	c3                   	ret    
    p->state = UNUSED;
80105459:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80105460:	31 db                	xor    %ebx,%ebx
80105462:	eb ee                	jmp    80105452 <allocproc+0xd2>
80105464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105476:	68 e0 55 11 80       	push   $0x801155e0
8010547b:	e8 10 11 00 00       	call   80106590 <release>

  if (first)
80105480:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	85 c0                	test   %eax,%eax
8010548a:	75 04                	jne    80105490 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010548c:	c9                   	leave  
8010548d:	c3                   	ret    
8010548e:	66 90                	xchg   %ax,%ax
    first = 0;
80105490:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
80105497:	00 00 00 
    iinit(ROOTDEV);
8010549a:	83 ec 0c             	sub    $0xc,%esp
8010549d:	6a 01                	push   $0x1
8010549f:	e8 9c dc ff ff       	call   80103140 <iinit>
    initlog(ROOTDEV);
801054a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054ab:	e8 b0 f3 ff ff       	call   80104860 <initlog>
}
801054b0:	83 c4 10             	add    $0x10,%esp
801054b3:	c9                   	leave  
801054b4:	c3                   	ret    
801054b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <pinit>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801054c6:	68 c0 9d 10 80       	push   $0x80109dc0
801054cb:	68 e0 55 11 80       	push   $0x801155e0
801054d0:	e8 2b 0f 00 00       	call   80106400 <initlock>
}
801054d5:	83 c4 10             	add    $0x10,%esp
801054d8:	c9                   	leave  
801054d9:	c3                   	ret    
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054e0 <mycpu>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801054e5:	9c                   	pushf  
801054e6:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801054e7:	f6 c4 02             	test   $0x2,%ah
801054ea:	75 46                	jne    80105532 <mycpu+0x52>
  apicid = lapicid();
801054ec:	e8 9f ef ff ff       	call   80104490 <lapicid>
  for (i = 0; i < ncpu; ++i)
801054f1:	8b 35 24 50 11 80    	mov    0x80115024,%esi
801054f7:	85 f6                	test   %esi,%esi
801054f9:	7e 2a                	jle    80105525 <mycpu+0x45>
801054fb:	31 d2                	xor    %edx,%edx
801054fd:	eb 08                	jmp    80105507 <mycpu+0x27>
801054ff:	90                   	nop
80105500:	83 c2 01             	add    $0x1,%edx
80105503:	39 f2                	cmp    %esi,%edx
80105505:	74 1e                	je     80105525 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80105507:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
8010550d:	0f b6 99 40 50 11 80 	movzbl -0x7feeafc0(%ecx),%ebx
80105514:	39 c3                	cmp    %eax,%ebx
80105516:	75 e8                	jne    80105500 <mycpu+0x20>
}
80105518:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010551b:	8d 81 40 50 11 80    	lea    -0x7feeafc0(%ecx),%eax
}
80105521:	5b                   	pop    %ebx
80105522:	5e                   	pop    %esi
80105523:	5d                   	pop    %ebp
80105524:	c3                   	ret    
  panic("unknown apicid\n");
80105525:	83 ec 0c             	sub    $0xc,%esp
80105528:	68 c7 9d 10 80       	push   $0x80109dc7
8010552d:	e8 4e ae ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80105532:	83 ec 0c             	sub    $0xc,%esp
80105535:	68 08 9f 10 80       	push   $0x80109f08
8010553a:	e8 41 ae ff ff       	call   80100380 <panic>
8010553f:	90                   	nop

80105540 <cpuid>:
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80105546:	e8 95 ff ff ff       	call   801054e0 <mycpu>
}
8010554b:	c9                   	leave  
  return mycpu() - cpus;
8010554c:	2d 40 50 11 80       	sub    $0x80115040,%eax
80105551:	c1 f8 02             	sar    $0x2,%eax
80105554:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010555a:	c3                   	ret    
8010555b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010555f:	90                   	nop

80105560 <myproc>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80105567:	e8 34 0f 00 00       	call   801064a0 <pushcli>
  c = mycpu();
8010556c:	e8 6f ff ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105571:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105577:	e8 74 0f 00 00       	call   801064f0 <popcli>
}
8010557c:	89 d8                	mov    %ebx,%eax
8010557e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105581:	c9                   	leave  
80105582:	c3                   	ret    
80105583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105590 <userinit>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80105597:	e8 e4 fd ff ff       	call   80105380 <allocproc>
8010559c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010559e:	a3 14 78 11 80       	mov    %eax,0x80117814
  if ((p->pgdir = setupkvm()) == 0)
801055a3:	e8 b8 3e 00 00       	call   80109460 <setupkvm>
801055a8:	89 43 04             	mov    %eax,0x4(%ebx)
801055ab:	85 c0                	test   %eax,%eax
801055ad:	0f 84 c7 00 00 00    	je     8010567a <userinit+0xea>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801055b3:	83 ec 04             	sub    $0x4,%esp
801055b6:	68 2c 00 00 00       	push   $0x2c
801055bb:	68 60 d4 10 80       	push   $0x8010d460
801055c0:	50                   	push   %eax
801055c1:	e8 7a 3b 00 00       	call   80109140 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801055c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801055c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801055cf:	6a 4c                	push   $0x4c
801055d1:	6a 00                	push   $0x0
801055d3:	ff 73 18             	pushl  0x18(%ebx)
801055d6:	e8 15 11 00 00       	call   801066f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801055db:	8b 43 18             	mov    0x18(%ebx),%eax
801055de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801055e3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801055e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801055eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801055ef:	8b 43 18             	mov    0x18(%ebx),%eax
801055f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801055f6:	8b 43 18             	mov    0x18(%ebx),%eax
801055f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801055fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80105601:	8b 43 18             	mov    0x18(%ebx),%eax
80105604:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80105608:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010560c:	8b 43 18             	mov    0x18(%ebx),%eax
8010560f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80105616:	8b 43 18             	mov    0x18(%ebx),%eax
80105619:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80105620:	8b 43 18             	mov    0x18(%ebx),%eax
80105623:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010562a:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->host_cpu = 0; // add for moving between queues
8010562d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80105634:	00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105637:	6a 10                	push   $0x10
80105639:	68 f0 9d 10 80       	push   $0x80109df0
8010563e:	50                   	push   %eax
8010563f:	e8 5c 12 00 00       	call   801068a0 <safestrcpy>
  p->cwd = namei("/");
80105644:	c7 04 24 f9 9d 10 80 	movl   $0x80109df9,(%esp)
8010564b:	e8 f0 e5 ff ff       	call   80103c40 <namei>
80105650:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80105653:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
8010565a:	e8 91 0f 00 00       	call   801065f0 <acquire>
  p->state = RUNNABLE;
8010565f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80105666:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
8010566d:	e8 1e 0f 00 00       	call   80106590 <release>
}
80105672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	c9                   	leave  
80105679:	c3                   	ret    
    panic("userinit: out of memory?");
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	68 d7 9d 10 80       	push   $0x80109dd7
80105682:	e8 f9 ac ff ff       	call   80100380 <panic>
80105687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568e:	66 90                	xchg   %ax,%ax

80105690 <growproc>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
80105695:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105698:	e8 03 0e 00 00       	call   801064a0 <pushcli>
  c = mycpu();
8010569d:	e8 3e fe ff ff       	call   801054e0 <mycpu>
  p = c->proc;
801056a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801056a8:	e8 43 0e 00 00       	call   801064f0 <popcli>
  sz = curproc->sz;
801056ad:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801056af:	85 f6                	test   %esi,%esi
801056b1:	7f 1d                	jg     801056d0 <growproc+0x40>
  else if (n < 0)
801056b3:	75 3b                	jne    801056f0 <growproc+0x60>
  switchuvm(curproc);
801056b5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801056b8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801056ba:	53                   	push   %ebx
801056bb:	e8 70 39 00 00       	call   80109030 <switchuvm>
  return 0;
801056c0:	83 c4 10             	add    $0x10,%esp
801056c3:	31 c0                	xor    %eax,%eax
}
801056c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c8:	5b                   	pop    %ebx
801056c9:	5e                   	pop    %esi
801056ca:	5d                   	pop    %ebp
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801056d0:	83 ec 04             	sub    $0x4,%esp
801056d3:	01 c6                	add    %eax,%esi
801056d5:	56                   	push   %esi
801056d6:	50                   	push   %eax
801056d7:	ff 73 04             	pushl  0x4(%ebx)
801056da:	e8 b1 3b 00 00       	call   80109290 <allocuvm>
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	85 c0                	test   %eax,%eax
801056e4:	75 cf                	jne    801056b5 <growproc+0x25>
      return -1;
801056e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056eb:	eb d8                	jmp    801056c5 <growproc+0x35>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801056f0:	83 ec 04             	sub    $0x4,%esp
801056f3:	01 c6                	add    %eax,%esi
801056f5:	56                   	push   %esi
801056f6:	50                   	push   %eax
801056f7:	ff 73 04             	pushl  0x4(%ebx)
801056fa:	e8 b1 3c 00 00       	call   801093b0 <deallocuvm>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	75 af                	jne    801056b5 <growproc+0x25>
80105706:	eb de                	jmp    801056e6 <growproc+0x56>
80105708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop

80105710 <fork>:
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
80105716:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80105719:	e8 82 0d 00 00       	call   801064a0 <pushcli>
  c = mycpu();
8010571e:	e8 bd fd ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105723:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105729:	e8 c2 0d 00 00       	call   801064f0 <popcli>
  if ((np = allocproc()) == 0)
8010572e:	e8 4d fc ff ff       	call   80105380 <allocproc>
80105733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105736:	85 c0                	test   %eax,%eax
80105738:	0f 84 e6 00 00 00    	je     80105824 <fork+0x114>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010573e:	83 ec 08             	sub    $0x8,%esp
80105741:	ff 33                	pushl  (%ebx)
80105743:	89 c7                	mov    %eax,%edi
80105745:	ff 73 04             	pushl  0x4(%ebx)
80105748:	e8 03 3e 00 00       	call   80109550 <copyuvm>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	89 47 04             	mov    %eax,0x4(%edi)
80105753:	85 c0                	test   %eax,%eax
80105755:	0f 84 aa 00 00 00    	je     80105805 <fork+0xf5>
  np->sz = curproc->sz;
8010575b:	8b 03                	mov    (%ebx),%eax
8010575d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80105760:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80105765:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80105767:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
8010576a:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010576d:	8b 73 18             	mov    0x18(%ebx),%esi
80105770:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80105772:	31 f6                	xor    %esi,%esi
  np->host_cpu = curproc->host_cpu;   // add for moving between queues
80105774:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010577a:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->tf->eax = 0;
80105780:	8b 42 18             	mov    0x18(%edx),%eax
80105783:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
8010578a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[i])
80105790:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105794:	85 c0                	test   %eax,%eax
80105796:	74 13                	je     801057ab <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	50                   	push   %eax
8010579c:	e8 df d2 ff ff       	call   80102a80 <filedup>
801057a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801057ab:	83 c6 01             	add    $0x1,%esi
801057ae:	83 fe 10             	cmp    $0x10,%esi
801057b1:	75 dd                	jne    80105790 <fork+0x80>
  np->cwd = idup(curproc->cwd);
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801057b9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801057bc:	e8 6f db ff ff       	call   80103330 <idup>
801057c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801057c4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801057c7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801057ca:	8d 47 6c             	lea    0x6c(%edi),%eax
801057cd:	6a 10                	push   $0x10
801057cf:	53                   	push   %ebx
801057d0:	50                   	push   %eax
801057d1:	e8 ca 10 00 00       	call   801068a0 <safestrcpy>
  pid = np->pid;
801057d6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801057d9:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
801057e0:	e8 0b 0e 00 00       	call   801065f0 <acquire>
  np->state = RUNNABLE;
801057e5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801057ec:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
801057f3:	e8 98 0d 00 00       	call   80106590 <release>
  return pid;
801057f8:	83 c4 10             	add    $0x10,%esp
}
801057fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057fe:	89 d8                	mov    %ebx,%eax
80105800:	5b                   	pop    %ebx
80105801:	5e                   	pop    %esi
80105802:	5f                   	pop    %edi
80105803:	5d                   	pop    %ebp
80105804:	c3                   	ret    
    kfree(np->kstack);
80105805:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	ff 73 08             	pushl  0x8(%ebx)
8010580e:	e8 4d e8 ff ff       	call   80104060 <kfree>
    np->kstack = 0;
80105813:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010581a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010581d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105824:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105829:	eb d0                	jmp    801057fb <fork+0xeb>
8010582b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop

80105830 <balance_queues>:
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	83 ec 3c             	sub    $0x3c,%esp
  return mycpu() - cpus;
80105839:	e8 a2 fc ff ff       	call   801054e0 <mycpu>
  acquire(&ptable.lock);
8010583e:	83 ec 0c             	sub    $0xc,%esp
80105841:	68 e0 55 11 80       	push   $0x801155e0
  return mycpu() - cpus;
80105846:	2d 40 50 11 80       	sub    $0x80115040,%eax
8010584b:	89 c3                	mov    %eax,%ebx
8010584d:	c1 fb 02             	sar    $0x2,%ebx
  acquire(&ptable.lock);
80105850:	e8 9b 0d 00 00       	call   801065f0 <acquire>
  for(i = 0; i < ncpu; i++) {
80105855:	8b 3d 24 50 11 80    	mov    0x80115024,%edi
  return mycpu() - cpus;
8010585b:	69 db a5 4f fa a4    	imul   $0xa4fa4fa5,%ebx,%ebx
  for(i = 0; i < ncpu; i++) {
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	85 ff                	test   %edi,%edi
80105866:	7e 2a                	jle    80105892 <balance_queues+0x62>
80105868:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010586b:	b9 f0 50 11 80       	mov    $0x801150f0,%ecx
80105870:	8d 34 b8             	lea    (%eax,%edi,4),%esi
80105873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105877:	90                   	nop
    if(cpus[i].type == PCORE)
80105878:	31 d2                	xor    %edx,%edx
8010587a:	83 39 01             	cmpl   $0x1,(%ecx)
8010587d:	0f 95 c2             	setne  %dl
  for(i = 0; i < ncpu; i++) {
80105880:	83 c0 04             	add    $0x4,%eax
80105883:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
    if(cpus[i].type == PCORE)
80105889:	f7 da                	neg    %edx
8010588b:	89 50 fc             	mov    %edx,-0x4(%eax)
  for(i = 0; i < ncpu; i++) {
8010588e:	39 c6                	cmp    %eax,%esi
80105890:	75 e6                	jne    80105878 <balance_queues+0x48>
  int E_count = 0;               
80105892:	31 c0                	xor    %eax,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105894:	ba 14 56 11 80       	mov    $0x80115614,%edx
80105899:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state != RUNNABLE)
801058a0:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801058a4:	75 2a                	jne    801058d0 <balance_queues+0xa0>
    if(p->host_cpu == E_id){
801058a6:	8b 8a 84 00 00 00    	mov    0x84(%edx),%ecx
      E_count++;
801058ac:	31 c0                	xor    %eax,%eax
801058ae:	39 d9                	cmp    %ebx,%ecx
801058b0:	0f 94 c0             	sete   %al
801058b3:	89 c6                	mov    %eax,%esi
801058b5:	01 75 c4             	add    %esi,-0x3c(%ebp)
    if(cpus[p->host_cpu].type == PCORE){ 
801058b8:	69 f1 b4 00 00 00    	imul   $0xb4,%ecx,%esi
801058be:	83 be f0 50 11 80 01 	cmpl   $0x1,-0x7feeaf10(%esi)
801058c5:	75 09                	jne    801058d0 <balance_queues+0xa0>
      runnable_count[p->host_cpu]++;
801058c7:	83 44 8d c8 01       	addl   $0x1,-0x38(%ebp,%ecx,4)
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058d0:	81 c2 88 00 00 00    	add    $0x88,%edx
801058d6:	81 fa 14 78 11 80    	cmp    $0x80117814,%edx
801058dc:	75 c2                	jne    801058a0 <balance_queues+0x70>
  for(i = 0; i < ncpu; i++){
801058de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801058e1:	85 ff                	test   %edi,%edi
801058e3:	0f 8e f3 00 00 00    	jle    801059dc <balance_queues+0x1ac>
801058e9:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  int min_P_count = 0x7fffffff;
801058ec:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
  int min_P_id = -1;           
801058f1:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  for(i = 0; i < ncpu; i++){
801058f6:	31 d2                	xor    %edx,%edx
801058f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
    int cnt = runnable_count[i];
80105900:	8b 44 95 c8          	mov    -0x38(%ebp,%edx,4),%eax
    if(cnt < min_P_count){
80105904:	85 c0                	test   %eax,%eax
80105906:	78 0d                	js     80105915 <balance_queues+0xe5>
80105908:	39 c6                	cmp    %eax,%esi
8010590a:	0f 9f c3             	setg   %bl
      min_P_count = cnt;
8010590d:	84 db                	test   %bl,%bl
8010590f:	0f 45 f0             	cmovne %eax,%esi
80105912:	0f 45 ca             	cmovne %edx,%ecx
  for(i = 0; i < ncpu; i++){
80105915:	83 c2 01             	add    $0x1,%edx
80105918:	39 fa                	cmp    %edi,%edx
8010591a:	75 e4                	jne    80105900 <balance_queues+0xd0>
  if(E_count < min_P_count + 3){ 
8010591c:	8b 5d c0             	mov    -0x40(%ebp),%ebx
8010591f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105922:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80105925:	8d 4e 02             	lea    0x2(%esi),%ecx
  struct proc *first = 0;
80105928:	31 ff                	xor    %edi,%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010592a:	be 14 56 11 80       	mov    $0x80115614,%esi
  if(E_count < min_P_count + 3){ 
8010592f:	39 c1                	cmp    %eax,%ecx
80105931:	7c 2b                	jl     8010595e <balance_queues+0x12e>
80105933:	e9 8f 00 00 00       	jmp    801059c7 <balance_queues+0x197>
80105938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop
      first = p;
80105940:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80105946:	39 86 80 00 00 00    	cmp    %eax,0x80(%esi)
8010594c:	0f 42 fe             	cmovb  %esi,%edi
8010594f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105950:	81 c6 88 00 00 00    	add    $0x88,%esi
80105956:	81 fe 14 78 11 80    	cmp    $0x80117814,%esi
8010595c:	74 4a                	je     801059a8 <balance_queues+0x178>
    if(p->state != RUNNABLE)
8010595e:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80105962:	75 ec                	jne    80105950 <balance_queues+0x120>
    if(p->host_cpu != E_id)
80105964:	39 9e 84 00 00 00    	cmp    %ebx,0x84(%esi)
8010596a:	75 e4                	jne    80105950 <balance_queues+0x120>
    if(p == initproc)        
8010596c:	39 35 14 78 11 80    	cmp    %esi,0x80117814
80105972:	74 dc                	je     80105950 <balance_queues+0x120>
    if(strncmp(p->name, "sh", 2) == 0)
80105974:	83 ec 04             	sub    $0x4,%esp
80105977:	8d 46 6c             	lea    0x6c(%esi),%eax
8010597a:	6a 02                	push   $0x2
8010597c:	68 50 98 10 80       	push   $0x80109850
80105981:	50                   	push   %eax
80105982:	e8 69 0e 00 00       	call   801067f0 <strncmp>
80105987:	83 c4 10             	add    $0x10,%esp
8010598a:	85 c0                	test   %eax,%eax
8010598c:	74 c2                	je     80105950 <balance_queues+0x120>
    if (first == 0 || p->create_time < first->create_time)
8010598e:	85 ff                	test   %edi,%edi
80105990:	75 ae                	jne    80105940 <balance_queues+0x110>
      first = p;
80105992:	89 f7                	mov    %esi,%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105994:	81 c6 88 00 00 00    	add    $0x88,%esi
8010599a:	81 fe 14 78 11 80    	cmp    $0x80117814,%esi
801059a0:	75 bc                	jne    8010595e <balance_queues+0x12e>
801059a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (first) {
801059a8:	85 ff                	test   %edi,%edi
801059aa:	74 1b                	je     801059c7 <balance_queues+0x197>
    cprintf("moving process %d from CPU %d to CPU %d\n", first->pid, E_id, min_P_id); 
801059ac:	8b 75 c4             	mov    -0x3c(%ebp),%esi
801059af:	56                   	push   %esi
801059b0:	53                   	push   %ebx
801059b1:	ff 77 10             	pushl  0x10(%edi)
801059b4:	68 30 9f 10 80       	push   $0x80109f30
801059b9:	e8 12 ae ff ff       	call   801007d0 <cprintf>
    first->host_cpu = min_P_id;
801059be:	89 b7 84 00 00 00    	mov    %esi,0x84(%edi)
801059c4:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	68 e0 55 11 80       	push   $0x801155e0
801059cf:	e8 bc 0b 00 00       	call   80106590 <release>
}
801059d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d7:	5b                   	pop    %ebx
801059d8:	5e                   	pop    %esi
801059d9:	5f                   	pop    %edi
801059da:	5d                   	pop    %ebp
801059db:	c3                   	ret    
  int min_P_id = -1;           
801059dc:	c7 45 c4 ff ff ff ff 	movl   $0xffffffff,-0x3c(%ebp)
  for(i = 0; i < ncpu; i++){
801059e3:	b9 01 00 00 80       	mov    $0x80000001,%ecx
801059e8:	e9 3b ff ff ff       	jmp    80105928 <balance_queues+0xf8>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi

801059f0 <scheduler>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801059f9:	e8 e2 fa ff ff       	call   801054e0 <mycpu>
  c->proc = 0;
801059fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105a05:	00 00 00 
  struct cpu *c = mycpu();
80105a08:	89 c3                	mov    %eax,%ebx
  return mycpu() - cpus;
80105a0a:	e8 d1 fa ff ff       	call   801054e0 <mycpu>
80105a0f:	2d 40 50 11 80       	sub    $0x80115040,%eax
80105a14:	89 c2                	mov    %eax,%edx
80105a16:	8d 43 04             	lea    0x4(%ebx),%eax
80105a19:	c1 fa 02             	sar    $0x2,%edx
80105a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105a1f:	69 f2 a5 4f fa a4    	imul   $0xa4fa4fa5,%edx,%esi
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105a28:	fb                   	sti    
    acquire(&ptable.lock);
80105a29:	83 ec 0c             	sub    $0xc,%esp
      struct proc *best = 0;
80105a2c:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80105a2e:	68 e0 55 11 80       	push   $0x801155e0
80105a33:	e8 b8 0b 00 00       	call   801065f0 <acquire>
80105a38:	83 c4 10             	add    $0x10,%esp
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a3b:	b8 14 56 11 80       	mov    $0x80115614,%eax
80105a40:	eb 2a                	jmp    80105a6c <scheduler+0x7c>
80105a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          best = p;
80105a48:	8b 8f 80 00 00 00    	mov    0x80(%edi),%ecx
80105a4e:	39 88 80 00 00 00    	cmp    %ecx,0x80(%eax)
80105a54:	0f 42 f8             	cmovb  %eax,%edi
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a60:	05 88 00 00 00       	add    $0x88,%eax
80105a65:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105a6a:	74 24                	je     80105a90 <scheduler+0xa0>
        if (p->state != RUNNABLE)
80105a6c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105a70:	75 ee                	jne    80105a60 <scheduler+0x70>
        if (p->host_cpu != cpu_id)       // add: only processes of this CPU's queue
80105a72:	39 b0 84 00 00 00    	cmp    %esi,0x84(%eax)
80105a78:	75 e6                	jne    80105a60 <scheduler+0x70>
        if (best == 0 || p->create_time < best->create_time)
80105a7a:	85 ff                	test   %edi,%edi
80105a7c:	75 ca                	jne    80105a48 <scheduler+0x58>
          best = p;
80105a7e:	89 c7                	mov    %eax,%edi
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a80:	05 88 00 00 00       	add    $0x88,%eax
80105a85:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105a8a:	75 e0                	jne    80105a6c <scheduler+0x7c>
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (best)
80105a90:	85 ff                	test   %edi,%edi
80105a92:	74 35                	je     80105ac9 <scheduler+0xd9>
        switchuvm(best);
80105a94:	83 ec 0c             	sub    $0xc,%esp
        c->proc = best;
80105a97:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(best);
80105a9d:	57                   	push   %edi
80105a9e:	e8 8d 35 00 00       	call   80109030 <switchuvm>
        best->state = RUNNING;
80105aa3:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), best->context);
80105aaa:	58                   	pop    %eax
80105aab:	5a                   	pop    %edx
80105aac:	ff 77 1c             	pushl  0x1c(%edi)
80105aaf:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ab2:	e8 44 0e 00 00       	call   801068fb <swtch>
        switchkvm();
80105ab7:	e8 64 35 00 00       	call   80109020 <switchkvm>
        c->proc = 0;
80105abc:	83 c4 10             	add    $0x10,%esp
80105abf:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80105ac6:	00 00 00 
      release(&ptable.lock);
80105ac9:	83 ec 0c             	sub    $0xc,%esp
80105acc:	68 e0 55 11 80       	push   $0x801155e0
80105ad1:	e8 ba 0a 00 00       	call   80106590 <release>
    sti();
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	e9 4a ff ff ff       	jmp    80105a28 <scheduler+0x38>
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sched>:
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
  pushcli();
80105ae5:	e8 b6 09 00 00       	call   801064a0 <pushcli>
  c = mycpu();
80105aea:	e8 f1 f9 ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105aef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105af5:	e8 f6 09 00 00       	call   801064f0 <popcli>
  if (!holding(&ptable.lock))
80105afa:	83 ec 0c             	sub    $0xc,%esp
80105afd:	68 e0 55 11 80       	push   $0x801155e0
80105b02:	e8 49 0a 00 00       	call   80106550 <holding>
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	74 4f                	je     80105b5d <sched+0x7d>
  if (mycpu()->ncli != 1)
80105b0e:	e8 cd f9 ff ff       	call   801054e0 <mycpu>
80105b13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80105b1a:	75 68                	jne    80105b84 <sched+0xa4>
  if (p->state == RUNNING)
80105b1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105b20:	74 55                	je     80105b77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105b22:	9c                   	pushf  
80105b23:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80105b24:	f6 c4 02             	test   $0x2,%ah
80105b27:	75 41                	jne    80105b6a <sched+0x8a>
  intena = mycpu()->intena;
80105b29:	e8 b2 f9 ff ff       	call   801054e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80105b2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105b31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105b37:	e8 a4 f9 ff ff       	call   801054e0 <mycpu>
80105b3c:	83 ec 08             	sub    $0x8,%esp
80105b3f:	ff 70 04             	pushl  0x4(%eax)
80105b42:	53                   	push   %ebx
80105b43:	e8 b3 0d 00 00       	call   801068fb <swtch>
  mycpu()->intena = intena;
80105b48:	e8 93 f9 ff ff       	call   801054e0 <mycpu>
}
80105b4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105b50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105b56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b59:	5b                   	pop    %ebx
80105b5a:	5e                   	pop    %esi
80105b5b:	5d                   	pop    %ebp
80105b5c:	c3                   	ret    
    panic("sched ptable.lock");
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 fb 9d 10 80       	push   $0x80109dfb
80105b65:	e8 16 a8 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	68 27 9e 10 80       	push   $0x80109e27
80105b72:	e8 09 a8 ff ff       	call   80100380 <panic>
    panic("sched running");
80105b77:	83 ec 0c             	sub    $0xc,%esp
80105b7a:	68 19 9e 10 80       	push   $0x80109e19
80105b7f:	e8 fc a7 ff ff       	call   80100380 <panic>
    panic("sched locks");
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	68 0d 9e 10 80       	push   $0x80109e0d
80105b8c:	e8 ef a7 ff ff       	call   80100380 <panic>
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop

80105ba0 <exit>:
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	57                   	push   %edi
80105ba4:	56                   	push   %esi
80105ba5:	53                   	push   %ebx
80105ba6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105ba9:	e8 b2 f9 ff ff       	call   80105560 <myproc>
  if (curproc == initproc)
80105bae:	39 05 14 78 11 80    	cmp    %eax,0x80117814
80105bb4:	0f 84 07 01 00 00    	je     80105cc1 <exit+0x121>
80105bba:	89 c3                	mov    %eax,%ebx
80105bbc:	8d 70 28             	lea    0x28(%eax),%esi
80105bbf:	8d 78 68             	lea    0x68(%eax),%edi
80105bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80105bc8:	8b 06                	mov    (%esi),%eax
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	74 12                	je     80105be0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80105bce:	83 ec 0c             	sub    $0xc,%esp
80105bd1:	50                   	push   %eax
80105bd2:	e8 f9 ce ff ff       	call   80102ad0 <fileclose>
      curproc->ofile[fd] = 0;
80105bd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80105bdd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80105be0:	83 c6 04             	add    $0x4,%esi
80105be3:	39 f7                	cmp    %esi,%edi
80105be5:	75 e1                	jne    80105bc8 <exit+0x28>
  begin_op();
80105be7:	e8 14 ed ff ff       	call   80104900 <begin_op>
  iput(curproc->cwd);
80105bec:	83 ec 0c             	sub    $0xc,%esp
80105bef:	ff 73 68             	pushl  0x68(%ebx)
80105bf2:	e8 99 d8 ff ff       	call   80103490 <iput>
  end_op();
80105bf7:	e8 74 ed ff ff       	call   80104970 <end_op>
  curproc->cwd = 0;
80105bfc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80105c03:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
80105c0a:	e8 e1 09 00 00       	call   801065f0 <acquire>
  wakeup1(curproc->parent);
80105c0f:	8b 53 14             	mov    0x14(%ebx),%edx
80105c12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105c15:	b8 14 56 11 80       	mov    $0x80115614,%eax
80105c1a:	eb 10                	jmp    80105c2c <exit+0x8c>
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c20:	05 88 00 00 00       	add    $0x88,%eax
80105c25:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105c2a:	74 1e                	je     80105c4a <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
80105c2c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105c30:	75 ee                	jne    80105c20 <exit+0x80>
80105c32:	3b 50 20             	cmp    0x20(%eax),%edx
80105c35:	75 e9                	jne    80105c20 <exit+0x80>
      p->state = RUNNABLE;
80105c37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105c3e:	05 88 00 00 00       	add    $0x88,%eax
80105c43:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105c48:	75 e2                	jne    80105c2c <exit+0x8c>
      p->parent = initproc;
80105c4a:	8b 0d 14 78 11 80    	mov    0x80117814,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105c50:	ba 14 56 11 80       	mov    $0x80115614,%edx
80105c55:	eb 17                	jmp    80105c6e <exit+0xce>
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax
80105c60:	81 c2 88 00 00 00    	add    $0x88,%edx
80105c66:	81 fa 14 78 11 80    	cmp    $0x80117814,%edx
80105c6c:	74 3a                	je     80105ca8 <exit+0x108>
    if (p->parent == curproc)
80105c6e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105c71:	75 ed                	jne    80105c60 <exit+0xc0>
      if (p->state == ZOMBIE)
80105c73:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105c77:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
80105c7a:	75 e4                	jne    80105c60 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105c7c:	b8 14 56 11 80       	mov    $0x80115614,%eax
80105c81:	eb 11                	jmp    80105c94 <exit+0xf4>
80105c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c87:	90                   	nop
80105c88:	05 88 00 00 00       	add    $0x88,%eax
80105c8d:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105c92:	74 cc                	je     80105c60 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80105c94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105c98:	75 ee                	jne    80105c88 <exit+0xe8>
80105c9a:	3b 48 20             	cmp    0x20(%eax),%ecx
80105c9d:	75 e9                	jne    80105c88 <exit+0xe8>
      p->state = RUNNABLE;
80105c9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105ca6:	eb e0                	jmp    80105c88 <exit+0xe8>
  curproc->state = ZOMBIE;
80105ca8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105caf:	e8 2c fe ff ff       	call   80105ae0 <sched>
  panic("zombie exit");
80105cb4:	83 ec 0c             	sub    $0xc,%esp
80105cb7:	68 48 9e 10 80       	push   $0x80109e48
80105cbc:	e8 bf a6 ff ff       	call   80100380 <panic>
    panic("init exiting");
80105cc1:	83 ec 0c             	sub    $0xc,%esp
80105cc4:	68 3b 9e 10 80       	push   $0x80109e3b
80105cc9:	e8 b2 a6 ff ff       	call   80100380 <panic>
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <wait>:
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	56                   	push   %esi
80105cd4:	53                   	push   %ebx
  pushcli();
80105cd5:	e8 c6 07 00 00       	call   801064a0 <pushcli>
  c = mycpu();
80105cda:	e8 01 f8 ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105cdf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105ce5:	e8 06 08 00 00       	call   801064f0 <popcli>
  acquire(&ptable.lock);
80105cea:	83 ec 0c             	sub    $0xc,%esp
80105ced:	68 e0 55 11 80       	push   $0x801155e0
80105cf2:	e8 f9 08 00 00       	call   801065f0 <acquire>
80105cf7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80105cfa:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105cfc:	bb 14 56 11 80       	mov    $0x80115614,%ebx
80105d01:	eb 13                	jmp    80105d16 <wait+0x46>
80105d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d07:	90                   	nop
80105d08:	81 c3 88 00 00 00    	add    $0x88,%ebx
80105d0e:	81 fb 14 78 11 80    	cmp    $0x80117814,%ebx
80105d14:	74 1e                	je     80105d34 <wait+0x64>
      if (p->parent != curproc)
80105d16:	39 73 14             	cmp    %esi,0x14(%ebx)
80105d19:	75 ed                	jne    80105d08 <wait+0x38>
      if (p->state == ZOMBIE)
80105d1b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105d1f:	74 5f                	je     80105d80 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105d21:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80105d27:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105d2c:	81 fb 14 78 11 80    	cmp    $0x80117814,%ebx
80105d32:	75 e2                	jne    80105d16 <wait+0x46>
    if (!havekids || curproc->killed)
80105d34:	85 c0                	test   %eax,%eax
80105d36:	0f 84 9a 00 00 00    	je     80105dd6 <wait+0x106>
80105d3c:	8b 46 24             	mov    0x24(%esi),%eax
80105d3f:	85 c0                	test   %eax,%eax
80105d41:	0f 85 8f 00 00 00    	jne    80105dd6 <wait+0x106>
  pushcli();
80105d47:	e8 54 07 00 00       	call   801064a0 <pushcli>
  c = mycpu();
80105d4c:	e8 8f f7 ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105d51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105d57:	e8 94 07 00 00       	call   801064f0 <popcli>
  if (p == 0)
80105d5c:	85 db                	test   %ebx,%ebx
80105d5e:	0f 84 89 00 00 00    	je     80105ded <wait+0x11d>
  p->chan = chan;
80105d64:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105d67:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105d6e:	e8 6d fd ff ff       	call   80105ae0 <sched>
  p->chan = 0;
80105d73:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105d7a:	e9 7b ff ff ff       	jmp    80105cfa <wait+0x2a>
80105d7f:	90                   	nop
        kfree(p->kstack);
80105d80:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105d83:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105d86:	ff 73 08             	pushl  0x8(%ebx)
80105d89:	e8 d2 e2 ff ff       	call   80104060 <kfree>
        p->kstack = 0;
80105d8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105d95:	5a                   	pop    %edx
80105d96:	ff 73 04             	pushl  0x4(%ebx)
80105d99:	e8 42 36 00 00       	call   801093e0 <freevm>
        p->pid = 0;
80105d9e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105da5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80105dac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105db0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105db7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80105dbe:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
80105dc5:	e8 c6 07 00 00       	call   80106590 <release>
        return pid;
80105dca:	83 c4 10             	add    $0x10,%esp
}
80105dcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dd0:	89 f0                	mov    %esi,%eax
80105dd2:	5b                   	pop    %ebx
80105dd3:	5e                   	pop    %esi
80105dd4:	5d                   	pop    %ebp
80105dd5:	c3                   	ret    
      release(&ptable.lock);
80105dd6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105dd9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80105dde:	68 e0 55 11 80       	push   $0x801155e0
80105de3:	e8 a8 07 00 00       	call   80106590 <release>
      return -1;
80105de8:	83 c4 10             	add    $0x10,%esp
80105deb:	eb e0                	jmp    80105dcd <wait+0xfd>
    panic("sleep");
80105ded:	83 ec 0c             	sub    $0xc,%esp
80105df0:	68 54 9e 10 80       	push   $0x80109e54
80105df5:	e8 86 a5 ff ff       	call   80100380 <panic>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <yield>:
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
80105e04:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80105e07:	68 e0 55 11 80       	push   $0x801155e0
80105e0c:	e8 df 07 00 00       	call   801065f0 <acquire>
  pushcli();
80105e11:	e8 8a 06 00 00       	call   801064a0 <pushcli>
  c = mycpu();
80105e16:	e8 c5 f6 ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105e1b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105e21:	e8 ca 06 00 00       	call   801064f0 <popcli>
  myproc()->state = RUNNABLE;
80105e26:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80105e2d:	e8 ae fc ff ff       	call   80105ae0 <sched>
  release(&ptable.lock);
80105e32:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
80105e39:	e8 52 07 00 00       	call   80106590 <release>
}
80105e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	c9                   	leave  
80105e45:	c3                   	ret    
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi

80105e50 <sleep>:
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	57                   	push   %edi
80105e54:	56                   	push   %esi
80105e55:	53                   	push   %ebx
80105e56:	83 ec 0c             	sub    $0xc,%esp
80105e59:	8b 7d 08             	mov    0x8(%ebp),%edi
80105e5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80105e5f:	e8 3c 06 00 00       	call   801064a0 <pushcli>
  c = mycpu();
80105e64:	e8 77 f6 ff ff       	call   801054e0 <mycpu>
  p = c->proc;
80105e69:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105e6f:	e8 7c 06 00 00       	call   801064f0 <popcli>
  if (p == 0)
80105e74:	85 db                	test   %ebx,%ebx
80105e76:	0f 84 87 00 00 00    	je     80105f03 <sleep+0xb3>
  if (lk == 0)
80105e7c:	85 f6                	test   %esi,%esi
80105e7e:	74 76                	je     80105ef6 <sleep+0xa6>
  if (lk != &ptable.lock)
80105e80:	81 fe e0 55 11 80    	cmp    $0x801155e0,%esi
80105e86:	74 50                	je     80105ed8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	68 e0 55 11 80       	push   $0x801155e0
80105e90:	e8 5b 07 00 00       	call   801065f0 <acquire>
    release(lk);
80105e95:	89 34 24             	mov    %esi,(%esp)
80105e98:	e8 f3 06 00 00       	call   80106590 <release>
  p->chan = chan;
80105e9d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105ea0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105ea7:	e8 34 fc ff ff       	call   80105ae0 <sched>
  p->chan = 0;
80105eac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105eb3:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
80105eba:	e8 d1 06 00 00       	call   80106590 <release>
    acquire(lk);
80105ebf:	89 75 08             	mov    %esi,0x8(%ebp)
80105ec2:	83 c4 10             	add    $0x10,%esp
}
80105ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec8:	5b                   	pop    %ebx
80105ec9:	5e                   	pop    %esi
80105eca:	5f                   	pop    %edi
80105ecb:	5d                   	pop    %ebp
    acquire(lk);
80105ecc:	e9 1f 07 00 00       	jmp    801065f0 <acquire>
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105ed8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105edb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105ee2:	e8 f9 fb ff ff       	call   80105ae0 <sched>
  p->chan = 0;
80105ee7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef1:	5b                   	pop    %ebx
80105ef2:	5e                   	pop    %esi
80105ef3:	5f                   	pop    %edi
80105ef4:	5d                   	pop    %ebp
80105ef5:	c3                   	ret    
    panic("sleep without lk");
80105ef6:	83 ec 0c             	sub    $0xc,%esp
80105ef9:	68 5a 9e 10 80       	push   $0x80109e5a
80105efe:	e8 7d a4 ff ff       	call   80100380 <panic>
    panic("sleep");
80105f03:	83 ec 0c             	sub    $0xc,%esp
80105f06:	68 54 9e 10 80       	push   $0x80109e54
80105f0b:	e8 70 a4 ff ff       	call   80100380 <panic>

80105f10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	53                   	push   %ebx
80105f14:	83 ec 10             	sub    $0x10,%esp
80105f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80105f1a:	68 e0 55 11 80       	push   $0x801155e0
80105f1f:	e8 cc 06 00 00       	call   801065f0 <acquire>
80105f24:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105f27:	b8 14 56 11 80       	mov    $0x80115614,%eax
80105f2c:	eb 0e                	jmp    80105f3c <wakeup+0x2c>
80105f2e:	66 90                	xchg   %ax,%ax
80105f30:	05 88 00 00 00       	add    $0x88,%eax
80105f35:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105f3a:	74 1e                	je     80105f5a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80105f3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105f40:	75 ee                	jne    80105f30 <wakeup+0x20>
80105f42:	3b 58 20             	cmp    0x20(%eax),%ebx
80105f45:	75 e9                	jne    80105f30 <wakeup+0x20>
      p->state = RUNNABLE;
80105f47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105f4e:	05 88 00 00 00       	add    $0x88,%eax
80105f53:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105f58:	75 e2                	jne    80105f3c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80105f5a:	c7 45 08 e0 55 11 80 	movl   $0x801155e0,0x8(%ebp)
}
80105f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f64:	c9                   	leave  
  release(&ptable.lock);
80105f65:	e9 26 06 00 00       	jmp    80106590 <release>
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f70 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	53                   	push   %ebx
80105f74:	83 ec 10             	sub    $0x10,%esp
80105f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80105f7a:	68 e0 55 11 80       	push   $0x801155e0
80105f7f:	e8 6c 06 00 00       	call   801065f0 <acquire>
80105f84:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105f87:	b8 14 56 11 80       	mov    $0x80115614,%eax
80105f8c:	eb 0e                	jmp    80105f9c <kill+0x2c>
80105f8e:	66 90                	xchg   %ax,%ax
80105f90:	05 88 00 00 00       	add    $0x88,%eax
80105f95:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80105f9a:	74 34                	je     80105fd0 <kill+0x60>
  {
    if (p->pid == pid)
80105f9c:	39 58 10             	cmp    %ebx,0x10(%eax)
80105f9f:	75 ef                	jne    80105f90 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80105fa1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105fa5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80105fac:	75 07                	jne    80105fb5 <kill+0x45>
        p->state = RUNNABLE;
80105fae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105fb5:	83 ec 0c             	sub    $0xc,%esp
80105fb8:	68 e0 55 11 80       	push   $0x801155e0
80105fbd:	e8 ce 05 00 00       	call   80106590 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105fc5:	83 c4 10             	add    $0x10,%esp
80105fc8:	31 c0                	xor    %eax,%eax
}
80105fca:	c9                   	leave  
80105fcb:	c3                   	ret    
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 e0 55 11 80       	push   $0x801155e0
80105fd8:	e8 b3 05 00 00       	call   80106590 <release>
}
80105fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105fe0:	83 c4 10             	add    $0x10,%esp
80105fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ff0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105ff8:	53                   	push   %ebx
80105ff9:	bb 80 56 11 80       	mov    $0x80115680,%ebx
80105ffe:	83 ec 3c             	sub    $0x3c,%esp
80106001:	eb 27                	jmp    8010602a <procdump+0x3a>
80106003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106007:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80106008:	83 ec 0c             	sub    $0xc,%esp
8010600b:	68 4b a3 10 80       	push   $0x8010a34b
80106010:	e8 bb a7 ff ff       	call   801007d0 <cprintf>
80106015:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106018:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010601e:	81 fb 80 78 11 80    	cmp    $0x80117880,%ebx
80106024:	0f 84 7e 00 00 00    	je     801060a8 <procdump+0xb8>
    if (p->state == UNUSED)
8010602a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010602d:	85 c0                	test   %eax,%eax
8010602f:	74 e7                	je     80106018 <procdump+0x28>
      state = "???";
80106031:	ba 6b 9e 10 80       	mov    $0x80109e6b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80106036:	83 f8 05             	cmp    $0x5,%eax
80106039:	77 11                	ja     8010604c <procdump+0x5c>
8010603b:	8b 14 85 b4 9f 10 80 	mov    -0x7fef604c(,%eax,4),%edx
      state = "???";
80106042:	b8 6b 9e 10 80       	mov    $0x80109e6b,%eax
80106047:	85 d2                	test   %edx,%edx
80106049:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010604c:	53                   	push   %ebx
8010604d:	52                   	push   %edx
8010604e:	ff 73 a4             	pushl  -0x5c(%ebx)
80106051:	68 6f 9e 10 80       	push   $0x80109e6f
80106056:	e8 75 a7 ff ff       	call   801007d0 <cprintf>
    if (p->state == SLEEPING)
8010605b:	83 c4 10             	add    $0x10,%esp
8010605e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80106062:	75 a4                	jne    80106008 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80106064:	83 ec 08             	sub    $0x8,%esp
80106067:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010606a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010606d:	50                   	push   %eax
8010606e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80106071:	8b 40 0c             	mov    0xc(%eax),%eax
80106074:	83 c0 08             	add    $0x8,%eax
80106077:	50                   	push   %eax
80106078:	e8 a3 03 00 00       	call   80106420 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	8b 17                	mov    (%edi),%edx
80106082:	85 d2                	test   %edx,%edx
80106084:	74 82                	je     80106008 <procdump+0x18>
        cprintf(" %p", pc[i]);
80106086:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80106089:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010608c:	52                   	push   %edx
8010608d:	68 e1 97 10 80       	push   $0x801097e1
80106092:	e8 39 a7 ff ff       	call   801007d0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	39 f7                	cmp    %esi,%edi
8010609c:	75 e2                	jne    80106080 <procdump+0x90>
8010609e:	e9 65 ff ff ff       	jmp    80106008 <procdump+0x18>
801060a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060a7:	90                   	nop
  }
}
801060a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060ab:	5b                   	pop    %ebx
801060ac:	5e                   	pop    %esi
801060ad:	5f                   	pop    %edi
801060ae:	5d                   	pop    %ebp
801060af:	c3                   	ret    

801060b0 <show_process_family>:

int show_process_family(int pid)
{
801060b0:	55                   	push   %ebp
  struct proc *p;
  struct proc *target_p;
  int found = 0;
  int number_of_siblings = 0;
  int number_of_children = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801060b1:	b8 14 56 11 80       	mov    $0x80115614,%eax
{
801060b6:	89 e5                	mov    %esp,%ebp
801060b8:	57                   	push   %edi
801060b9:	56                   	push   %esi
801060ba:	53                   	push   %ebx
801060bb:	83 ec 1c             	sub    $0x1c,%esp
801060be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801060c1:	eb 15                	jmp    801060d8 <show_process_family+0x28>
801060c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060c7:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801060c8:	05 88 00 00 00       	add    $0x88,%eax
801060cd:	3d 14 78 11 80       	cmp    $0x80117814,%eax
801060d2:	0f 84 70 01 00 00    	je     80106248 <show_process_family+0x198>
  {
    if (pid == p->pid && p->pid != 0)
801060d8:	8b 50 10             	mov    0x10(%eax),%edx
801060db:	39 da                	cmp    %ebx,%edx
801060dd:	75 e9                	jne    801060c8 <show_process_family+0x18>
801060df:	85 d2                	test   %edx,%edx
801060e1:	74 e5                	je     801060c8 <show_process_family+0x18>

  if (found == 0)
  {
    return -1;
  }
  int parent_id = target_p->parent->pid;
801060e3:	8b 40 14             	mov    0x14(%eax),%eax
  cprintf("My id: %d,My parent id:%d\n", pid, parent_id);
801060e6:	83 ec 04             	sub    $0x4,%esp
  int parent_id = target_p->parent->pid;
801060e9:	8b 70 10             	mov    0x10(%eax),%esi
  cprintf("My id: %d,My parent id:%d\n", pid, parent_id);
801060ec:	56                   	push   %esi
801060ed:	53                   	push   %ebx
801060ee:	68 78 9e 10 80       	push   $0x80109e78
801060f3:	e8 d8 a6 ff ff       	call   801007d0 <cprintf>
801060f8:	83 c4 10             	add    $0x10,%esp
  int number_of_children = 0;
801060fb:	31 c9                	xor    %ecx,%ecx

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801060fd:	b8 14 56 11 80       	mov    $0x80115614,%eax
80106102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {

    if (pid == p->parent->pid && p->pid != 0)
80106108:	8b 50 14             	mov    0x14(%eax),%edx
8010610b:	3b 5a 10             	cmp    0x10(%edx),%ebx
8010610e:	75 07                	jne    80106117 <show_process_family+0x67>
    {
      number_of_children += 1;
80106110:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80106114:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106117:	05 88 00 00 00       	add    $0x88,%eax
8010611c:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80106121:	75 e5                	jne    80106108 <show_process_family+0x58>
    }
  }

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106123:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  int number_of_siblings = 0;
80106126:	31 ff                	xor    %edi,%edi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106128:	b8 14 56 11 80       	mov    $0x80115614,%eax
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
  {

    if (p->pid != 0)
80106130:	8b 50 10             	mov    0x10(%eax),%edx
80106133:	85 d2                	test   %edx,%edx
80106135:	74 13                	je     8010614a <show_process_family+0x9a>
    {

      if (parent_id == p->parent->pid)
      {

        if (pid != p->pid)
80106137:	8b 48 14             	mov    0x14(%eax),%ecx
8010613a:	39 71 10             	cmp    %esi,0x10(%ecx)
8010613d:	75 0b                	jne    8010614a <show_process_family+0x9a>
8010613f:	39 da                	cmp    %ebx,%edx
80106141:	0f 95 c2             	setne  %dl
        {
          number_of_siblings += 1;
80106144:	80 fa 01             	cmp    $0x1,%dl
80106147:	83 df ff             	sbb    $0xffffffff,%edi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010614a:	05 88 00 00 00       	add    $0x88,%eax
8010614f:	3d 14 78 11 80       	cmp    $0x80117814,%eax
80106154:	75 da                	jne    80106130 <show_process_family+0x80>
        }
      }
    }
  }

  if (number_of_children > 0)
80106156:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106159:	85 c9                	test   %ecx,%ecx
8010615b:	0f 8e 7e 00 00 00    	jle    801061df <show_process_family+0x12f>
  { cprintf("Children of process %d:\n", pid);
80106161:	83 ec 08             	sub    $0x8,%esp
80106164:	53                   	push   %ebx
80106165:	68 93 9e 10 80       	push   $0x80109e93
8010616a:	e8 61 a6 ff ff       	call   801007d0 <cprintf>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010616f:	b8 14 56 11 80       	mov    $0x80115614,%eax
80106174:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  { cprintf("Children of process %d:\n", pid);
80106177:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010617a:	89 de                	mov    %ebx,%esi
8010617c:	89 c3                	mov    %eax,%ebx
8010617e:	eb 0e                	jmp    8010618e <show_process_family+0xde>
80106180:	81 c3 88 00 00 00    	add    $0x88,%ebx
80106186:	81 fb 14 78 11 80    	cmp    $0x80117814,%ebx
8010618c:	74 2e                	je     801061bc <show_process_family+0x10c>
    {

      if (pid == p->parent->pid && p->pid != 0)
8010618e:	8b 43 14             	mov    0x14(%ebx),%eax
80106191:	39 70 10             	cmp    %esi,0x10(%eax)
80106194:	75 ea                	jne    80106180 <show_process_family+0xd0>
80106196:	8b 43 10             	mov    0x10(%ebx),%eax
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 e3                	je     80106180 <show_process_family+0xd0>
      {
        cprintf("Child pid: %d\n", p->pid);
8010619d:	83 ec 08             	sub    $0x8,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801061a0:	81 c3 88 00 00 00    	add    $0x88,%ebx
        cprintf("Child pid: %d\n", p->pid);
801061a6:	50                   	push   %eax
801061a7:	68 ac 9e 10 80       	push   $0x80109eac
801061ac:	e8 1f a6 ff ff       	call   801007d0 <cprintf>
801061b1:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801061b4:	81 fb 14 78 11 80    	cmp    $0x80117814,%ebx
801061ba:	75 d2                	jne    8010618e <show_process_family+0xde>
801061bc:	89 f3                	mov    %esi,%ebx
801061be:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  }
  else
  {
   cprintf("This process does not have  any children!\n");
  }
  if (number_of_siblings > 0)
801061c1:	85 ff                	test   %edi,%edi
801061c3:	7f 2e                	jg     801061f3 <show_process_family+0x143>
      }
    }
  }
  else
  {
    cprintf("This process does not have  any siblings!\n");
801061c5:	83 ec 0c             	sub    $0xc,%esp
801061c8:	68 88 9f 10 80       	push   $0x80109f88
801061cd:	e8 fe a5 ff ff       	call   801007d0 <cprintf>
801061d2:	83 c4 10             	add    $0x10,%esp
  }
 
  return 0;
}
801061d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801061d8:	31 c0                	xor    %eax,%eax
}
801061da:	5b                   	pop    %ebx
801061db:	5e                   	pop    %esi
801061dc:	5f                   	pop    %edi
801061dd:	5d                   	pop    %ebp
801061de:	c3                   	ret    
   cprintf("This process does not have  any children!\n");
801061df:	83 ec 0c             	sub    $0xc,%esp
801061e2:	68 5c 9f 10 80       	push   $0x80109f5c
801061e7:	e8 e4 a5 ff ff       	call   801007d0 <cprintf>
801061ec:	83 c4 10             	add    $0x10,%esp
  if (number_of_siblings > 0)
801061ef:	85 ff                	test   %edi,%edi
801061f1:	7e d2                	jle    801061c5 <show_process_family+0x115>
    cprintf("Siblings of process %d:\n", pid);
801061f3:	83 ec 08             	sub    $0x8,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801061f6:	bf 14 56 11 80       	mov    $0x80115614,%edi
    cprintf("Siblings of process %d:\n", pid);
801061fb:	53                   	push   %ebx
801061fc:	68 bb 9e 10 80       	push   $0x80109ebb
80106201:	e8 ca a5 ff ff       	call   801007d0 <cprintf>
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	eb 13                	jmp    8010621e <show_process_family+0x16e>
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106210:	81 c7 88 00 00 00    	add    $0x88,%edi
80106216:	81 ff 14 78 11 80    	cmp    $0x80117814,%edi
8010621c:	74 b7                	je     801061d5 <show_process_family+0x125>
      if (p->pid != 0)
8010621e:	8b 47 10             	mov    0x10(%edi),%eax
80106221:	85 c0                	test   %eax,%eax
80106223:	74 eb                	je     80106210 <show_process_family+0x160>
        if (parent_id == p->parent->pid)
80106225:	8b 57 14             	mov    0x14(%edi),%edx
          if (pid != p->pid)
80106228:	39 72 10             	cmp    %esi,0x10(%edx)
8010622b:	75 e3                	jne    80106210 <show_process_family+0x160>
8010622d:	39 d8                	cmp    %ebx,%eax
8010622f:	74 df                	je     80106210 <show_process_family+0x160>
            cprintf("Sibling pid: %d\n", p->pid);
80106231:	83 ec 08             	sub    $0x8,%esp
80106234:	50                   	push   %eax
80106235:	68 d4 9e 10 80       	push   $0x80109ed4
8010623a:	e8 91 a5 ff ff       	call   801007d0 <cprintf>
8010623f:	83 c4 10             	add    $0x10,%esp
80106242:	eb cc                	jmp    80106210 <show_process_family+0x160>
80106244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106248:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010624b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106250:	5b                   	pop    %ebx
80106251:	5e                   	pop    %esi
80106252:	5f                   	pop    %edi
80106253:	5d                   	pop    %ebp
80106254:	c3                   	ret    
80106255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106260 <set_priority_helper>:


int
set_priority_helper(int pid, int priority)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	53                   	push   %ebx
80106264:	83 ec 10             	sub    $0x10,%esp
80106267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int found = 0;

  acquire(&ptable.lock);
8010626a:	68 e0 55 11 80       	push   $0x801155e0
8010626f:	e8 7c 03 00 00       	call   801065f0 <acquire>
80106274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80106277:	b8 14 56 11 80       	mov    $0x80115614,%eax
8010627c:	eb 0e                	jmp    8010628c <set_priority_helper+0x2c>
8010627e:	66 90                	xchg   %ax,%ax
80106280:	05 88 00 00 00       	add    $0x88,%eax
80106285:	3d 14 78 11 80       	cmp    $0x80117814,%eax
8010628a:	74 24                	je     801062b0 <set_priority_helper+0x50>
    if(p->pid == pid){
8010628c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010628f:	75 ef                	jne    80106280 <set_priority_helper+0x20>
      p->priority = priority; 
80106291:	8b 55 0c             	mov    0xc(%ebp),%edx
      found = 1;
      break;
    }
  }
  release(&ptable.lock);
80106294:	83 ec 0c             	sub    $0xc,%esp
      p->priority = priority; 
80106297:	89 50 7c             	mov    %edx,0x7c(%eax)
  release(&ptable.lock);
8010629a:	68 e0 55 11 80       	push   $0x801155e0
8010629f:	e8 ec 02 00 00       	call   80106590 <release>

  if(found)
    return 0; 
  else
    return -1; 
}
801062a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
801062a7:	83 c4 10             	add    $0x10,%esp
    return 0; 
801062aa:	31 c0                	xor    %eax,%eax
}
801062ac:	c9                   	leave  
801062ad:	c3                   	ret    
801062ae:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	68 e0 55 11 80       	push   $0x801155e0
801062b8:	e8 d3 02 00 00       	call   80106590 <release>
}
801062bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1; 
801062c0:	83 c4 10             	add    $0x10,%esp
801062c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062c8:	c9                   	leave  
801062c9:	c3                   	ret    
801062ca:	66 90                	xchg   %ax,%ax
801062cc:	66 90                	xchg   %ax,%ax
801062ce:	66 90                	xchg   %ax,%ax

801062d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	53                   	push   %ebx
801062d4:	83 ec 0c             	sub    $0xc,%esp
801062d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801062da:	68 cc 9f 10 80       	push   $0x80109fcc
801062df:	8d 43 04             	lea    0x4(%ebx),%eax
801062e2:	50                   	push   %eax
801062e3:	e8 18 01 00 00       	call   80106400 <initlock>
  lk->name = name;
801062e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801062eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801062f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801062f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801062fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801062fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106301:	c9                   	leave  
80106302:	c3                   	ret    
80106303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106310 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	56                   	push   %esi
80106314:	53                   	push   %ebx
80106315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106318:	8d 73 04             	lea    0x4(%ebx),%esi
8010631b:	83 ec 0c             	sub    $0xc,%esp
8010631e:	56                   	push   %esi
8010631f:	e8 cc 02 00 00       	call   801065f0 <acquire>
  while (lk->locked) {
80106324:	8b 13                	mov    (%ebx),%edx
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	85 d2                	test   %edx,%edx
8010632b:	74 16                	je     80106343 <acquiresleep+0x33>
8010632d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80106330:	83 ec 08             	sub    $0x8,%esp
80106333:	56                   	push   %esi
80106334:	53                   	push   %ebx
80106335:	e8 16 fb ff ff       	call   80105e50 <sleep>
  while (lk->locked) {
8010633a:	8b 03                	mov    (%ebx),%eax
8010633c:	83 c4 10             	add    $0x10,%esp
8010633f:	85 c0                	test   %eax,%eax
80106341:	75 ed                	jne    80106330 <acquiresleep+0x20>
  }
  lk->locked = 1;
80106343:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80106349:	e8 12 f2 ff ff       	call   80105560 <myproc>
8010634e:	8b 40 10             	mov    0x10(%eax),%eax
80106351:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80106354:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106357:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010635a:	5b                   	pop    %ebx
8010635b:	5e                   	pop    %esi
8010635c:	5d                   	pop    %ebp
  release(&lk->lk);
8010635d:	e9 2e 02 00 00       	jmp    80106590 <release>
80106362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106370 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	56                   	push   %esi
80106374:	53                   	push   %ebx
80106375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106378:	8d 73 04             	lea    0x4(%ebx),%esi
8010637b:	83 ec 0c             	sub    $0xc,%esp
8010637e:	56                   	push   %esi
8010637f:	e8 6c 02 00 00       	call   801065f0 <acquire>
  lk->locked = 0;
80106384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010638a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80106391:	89 1c 24             	mov    %ebx,(%esp)
80106394:	e8 77 fb ff ff       	call   80105f10 <wakeup>
  release(&lk->lk);
80106399:	89 75 08             	mov    %esi,0x8(%ebp)
8010639c:	83 c4 10             	add    $0x10,%esp
}
8010639f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063a2:	5b                   	pop    %ebx
801063a3:	5e                   	pop    %esi
801063a4:	5d                   	pop    %ebp
  release(&lk->lk);
801063a5:	e9 e6 01 00 00       	jmp    80106590 <release>
801063aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	31 ff                	xor    %edi,%edi
801063b6:	56                   	push   %esi
801063b7:	53                   	push   %ebx
801063b8:	83 ec 18             	sub    $0x18,%esp
801063bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801063be:	8d 73 04             	lea    0x4(%ebx),%esi
801063c1:	56                   	push   %esi
801063c2:	e8 29 02 00 00       	call   801065f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801063c7:	8b 03                	mov    (%ebx),%eax
801063c9:	83 c4 10             	add    $0x10,%esp
801063cc:	85 c0                	test   %eax,%eax
801063ce:	75 18                	jne    801063e8 <holdingsleep+0x38>
  release(&lk->lk);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	56                   	push   %esi
801063d4:	e8 b7 01 00 00       	call   80106590 <release>
  return r;
}
801063d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063dc:	89 f8                	mov    %edi,%eax
801063de:	5b                   	pop    %ebx
801063df:	5e                   	pop    %esi
801063e0:	5f                   	pop    %edi
801063e1:	5d                   	pop    %ebp
801063e2:	c3                   	ret    
801063e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801063e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801063eb:	e8 70 f1 ff ff       	call   80105560 <myproc>
801063f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801063f3:	0f 94 c0             	sete   %al
801063f6:	0f b6 c0             	movzbl %al,%eax
801063f9:	89 c7                	mov    %eax,%edi
801063fb:	eb d3                	jmp    801063d0 <holdingsleep+0x20>
801063fd:	66 90                	xchg   %ax,%ax
801063ff:	90                   	nop

80106400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80106406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80106409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010640f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80106412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106419:	5d                   	pop    %ebp
8010641a:	c3                   	ret    
8010641b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010641f:	90                   	nop

80106420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
80106424:	8b 45 08             	mov    0x8(%ebp),%eax
80106427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010642a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010642d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80106432:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80106437:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010643c:	76 10                	jbe    8010644e <getcallerpcs+0x2e>
8010643e:	eb 28                	jmp    80106468 <getcallerpcs+0x48>
80106440:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80106446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010644c:	77 1a                	ja     80106468 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010644e:	8b 5a 04             	mov    0x4(%edx),%ebx
80106451:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80106454:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80106457:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80106459:	83 f8 0a             	cmp    $0xa,%eax
8010645c:	75 e2                	jne    80106440 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010645e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106461:	c9                   	leave  
80106462:	c3                   	ret    
80106463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106467:	90                   	nop
80106468:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010646b:	83 c1 28             	add    $0x28,%ecx
8010646e:	89 ca                	mov    %ecx,%edx
80106470:	29 c2                	sub    %eax,%edx
80106472:	83 e2 04             	and    $0x4,%edx
80106475:	74 11                	je     80106488 <getcallerpcs+0x68>
    pcs[i] = 0;
80106477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010647d:	83 c0 04             	add    $0x4,%eax
80106480:	39 c1                	cmp    %eax,%ecx
80106482:	74 da                	je     8010645e <getcallerpcs+0x3e>
80106484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80106488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010648e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106491:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106498:	39 c1                	cmp    %eax,%ecx
8010649a:	75 ec                	jne    80106488 <getcallerpcs+0x68>
8010649c:	eb c0                	jmp    8010645e <getcallerpcs+0x3e>
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	53                   	push   %ebx
801064a4:	83 ec 04             	sub    $0x4,%esp
801064a7:	9c                   	pushf  
801064a8:	5b                   	pop    %ebx
  asm volatile("cli");
801064a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801064aa:	e8 31 f0 ff ff       	call   801054e0 <mycpu>
801064af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801064b5:	85 c0                	test   %eax,%eax
801064b7:	74 17                	je     801064d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801064b9:	e8 22 f0 ff ff       	call   801054e0 <mycpu>
801064be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801064c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c8:	c9                   	leave  
801064c9:	c3                   	ret    
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801064d0:	e8 0b f0 ff ff       	call   801054e0 <mycpu>
801064d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801064db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801064e1:	eb d6                	jmp    801064b9 <pushcli+0x19>
801064e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064f0 <popcli>:

void
popcli(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801064f6:	9c                   	pushf  
801064f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801064f8:	f6 c4 02             	test   $0x2,%ah
801064fb:	75 35                	jne    80106532 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801064fd:	e8 de ef ff ff       	call   801054e0 <mycpu>
80106502:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106509:	78 34                	js     8010653f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010650b:	e8 d0 ef ff ff       	call   801054e0 <mycpu>
80106510:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80106516:	85 d2                	test   %edx,%edx
80106518:	74 06                	je     80106520 <popcli+0x30>
    sti();
}
8010651a:	c9                   	leave  
8010651b:	c3                   	ret    
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106520:	e8 bb ef ff ff       	call   801054e0 <mycpu>
80106525:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010652b:	85 c0                	test   %eax,%eax
8010652d:	74 eb                	je     8010651a <popcli+0x2a>
  asm volatile("sti");
8010652f:	fb                   	sti    
}
80106530:	c9                   	leave  
80106531:	c3                   	ret    
    panic("popcli - interruptible");
80106532:	83 ec 0c             	sub    $0xc,%esp
80106535:	68 d7 9f 10 80       	push   $0x80109fd7
8010653a:	e8 41 9e ff ff       	call   80100380 <panic>
    panic("popcli");
8010653f:	83 ec 0c             	sub    $0xc,%esp
80106542:	68 ee 9f 10 80       	push   $0x80109fee
80106547:	e8 34 9e ff ff       	call   80100380 <panic>
8010654c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106550 <holding>:
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	56                   	push   %esi
80106554:	53                   	push   %ebx
80106555:	8b 75 08             	mov    0x8(%ebp),%esi
80106558:	31 db                	xor    %ebx,%ebx
  pushcli();
8010655a:	e8 41 ff ff ff       	call   801064a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010655f:	8b 06                	mov    (%esi),%eax
80106561:	85 c0                	test   %eax,%eax
80106563:	75 0b                	jne    80106570 <holding+0x20>
  popcli();
80106565:	e8 86 ff ff ff       	call   801064f0 <popcli>
}
8010656a:	89 d8                	mov    %ebx,%eax
8010656c:	5b                   	pop    %ebx
8010656d:	5e                   	pop    %esi
8010656e:	5d                   	pop    %ebp
8010656f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80106570:	8b 5e 08             	mov    0x8(%esi),%ebx
80106573:	e8 68 ef ff ff       	call   801054e0 <mycpu>
80106578:	39 c3                	cmp    %eax,%ebx
8010657a:	0f 94 c3             	sete   %bl
  popcli();
8010657d:	e8 6e ff ff ff       	call   801064f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80106582:	0f b6 db             	movzbl %bl,%ebx
}
80106585:	89 d8                	mov    %ebx,%eax
80106587:	5b                   	pop    %ebx
80106588:	5e                   	pop    %esi
80106589:	5d                   	pop    %ebp
8010658a:	c3                   	ret    
8010658b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010658f:	90                   	nop

80106590 <release>:
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	56                   	push   %esi
80106594:	53                   	push   %ebx
80106595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106598:	e8 03 ff ff ff       	call   801064a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010659d:	8b 03                	mov    (%ebx),%eax
8010659f:	85 c0                	test   %eax,%eax
801065a1:	75 15                	jne    801065b8 <release+0x28>
  popcli();
801065a3:	e8 48 ff ff ff       	call   801064f0 <popcli>
    panic("release");
801065a8:	83 ec 0c             	sub    $0xc,%esp
801065ab:	68 f5 9f 10 80       	push   $0x80109ff5
801065b0:	e8 cb 9d ff ff       	call   80100380 <panic>
801065b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801065b8:	8b 73 08             	mov    0x8(%ebx),%esi
801065bb:	e8 20 ef ff ff       	call   801054e0 <mycpu>
801065c0:	39 c6                	cmp    %eax,%esi
801065c2:	75 df                	jne    801065a3 <release+0x13>
  popcli();
801065c4:	e8 27 ff ff ff       	call   801064f0 <popcli>
  lk->pcs[0] = 0;
801065c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801065d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801065d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801065dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801065e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065e5:	5b                   	pop    %ebx
801065e6:	5e                   	pop    %esi
801065e7:	5d                   	pop    %ebp
  popcli();
801065e8:	e9 03 ff ff ff       	jmp    801064f0 <popcli>
801065ed:	8d 76 00             	lea    0x0(%esi),%esi

801065f0 <acquire>:
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	53                   	push   %ebx
801065f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801065f7:	e8 a4 fe ff ff       	call   801064a0 <pushcli>
  if(holding(lk))
801065fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801065ff:	e8 9c fe ff ff       	call   801064a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106604:	8b 03                	mov    (%ebx),%eax
80106606:	85 c0                	test   %eax,%eax
80106608:	0f 85 b2 00 00 00    	jne    801066c0 <acquire+0xd0>
  popcli();
8010660e:	e8 dd fe ff ff       	call   801064f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80106613:	b9 01 00 00 00       	mov    $0x1,%ecx
80106618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80106620:	8b 55 08             	mov    0x8(%ebp),%edx
80106623:	89 c8                	mov    %ecx,%eax
80106625:	f0 87 02             	lock xchg %eax,(%edx)
80106628:	85 c0                	test   %eax,%eax
8010662a:	75 f4                	jne    80106620 <acquire+0x30>
  __sync_synchronize();
8010662c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80106631:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106634:	e8 a7 ee ff ff       	call   801054e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80106639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010663c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010663e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106641:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80106647:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010664c:	77 32                	ja     80106680 <acquire+0x90>
  ebp = (uint*)v - 2;
8010664e:	89 e8                	mov    %ebp,%eax
80106650:	eb 14                	jmp    80106666 <acquire+0x76>
80106652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106658:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010665e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80106664:	77 1a                	ja     80106680 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80106666:	8b 58 04             	mov    0x4(%eax),%ebx
80106669:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010666d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80106670:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80106672:	83 fa 0a             	cmp    $0xa,%edx
80106675:	75 e1                	jne    80106658 <acquire+0x68>
}
80106677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010667a:	c9                   	leave  
8010667b:	c3                   	ret    
8010667c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106680:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80106684:	83 c1 34             	add    $0x34,%ecx
80106687:	89 ca                	mov    %ecx,%edx
80106689:	29 c2                	sub    %eax,%edx
8010668b:	83 e2 04             	and    $0x4,%edx
8010668e:	74 10                	je     801066a0 <acquire+0xb0>
    pcs[i] = 0;
80106690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106696:	83 c0 04             	add    $0x4,%eax
80106699:	39 c1                	cmp    %eax,%ecx
8010669b:	74 da                	je     80106677 <acquire+0x87>
8010669d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801066a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801066a6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801066a9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801066b0:	39 c1                	cmp    %eax,%ecx
801066b2:	75 ec                	jne    801066a0 <acquire+0xb0>
801066b4:	eb c1                	jmp    80106677 <acquire+0x87>
801066b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066bd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801066c0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801066c3:	e8 18 ee ff ff       	call   801054e0 <mycpu>
801066c8:	39 c3                	cmp    %eax,%ebx
801066ca:	0f 85 3e ff ff ff    	jne    8010660e <acquire+0x1e>
  popcli();
801066d0:	e8 1b fe ff ff       	call   801064f0 <popcli>
    panic("acquire");
801066d5:	83 ec 0c             	sub    $0xc,%esp
801066d8:	68 fd 9f 10 80       	push   $0x80109ffd
801066dd:	e8 9e 9c ff ff       	call   80100380 <panic>
801066e2:	66 90                	xchg   %ax,%ax
801066e4:	66 90                	xchg   %ax,%ax
801066e6:	66 90                	xchg   %ax,%ax
801066e8:	66 90                	xchg   %ax,%ax
801066ea:	66 90                	xchg   %ax,%ax
801066ec:	66 90                	xchg   %ax,%ax
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	8b 55 08             	mov    0x8(%ebp),%edx
801066f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801066fa:	89 d0                	mov    %edx,%eax
801066fc:	09 c8                	or     %ecx,%eax
801066fe:	a8 03                	test   $0x3,%al
80106700:	75 1e                	jne    80106720 <memset+0x30>
    c &= 0xFF;
80106702:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106706:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80106709:	89 d7                	mov    %edx,%edi
8010670b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80106711:	fc                   	cld    
80106712:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80106714:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106717:	89 d0                	mov    %edx,%eax
80106719:	c9                   	leave  
8010671a:	c3                   	ret    
8010671b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop
  asm volatile("cld; rep stosb" :
80106720:	8b 45 0c             	mov    0xc(%ebp),%eax
80106723:	89 d7                	mov    %edx,%edi
80106725:	fc                   	cld    
80106726:	f3 aa                	rep stos %al,%es:(%edi)
80106728:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010672b:	89 d0                	mov    %edx,%eax
8010672d:	c9                   	leave  
8010672e:	c3                   	ret    
8010672f:	90                   	nop

80106730 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	56                   	push   %esi
80106734:	8b 75 10             	mov    0x10(%ebp),%esi
80106737:	8b 45 08             	mov    0x8(%ebp),%eax
8010673a:	53                   	push   %ebx
8010673b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010673e:	85 f6                	test   %esi,%esi
80106740:	74 2e                	je     80106770 <memcmp+0x40>
80106742:	01 c6                	add    %eax,%esi
80106744:	eb 14                	jmp    8010675a <memcmp+0x2a>
80106746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80106750:	83 c0 01             	add    $0x1,%eax
80106753:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80106756:	39 f0                	cmp    %esi,%eax
80106758:	74 16                	je     80106770 <memcmp+0x40>
    if(*s1 != *s2)
8010675a:	0f b6 08             	movzbl (%eax),%ecx
8010675d:	0f b6 1a             	movzbl (%edx),%ebx
80106760:	38 d9                	cmp    %bl,%cl
80106762:	74 ec                	je     80106750 <memcmp+0x20>
      return *s1 - *s2;
80106764:	0f b6 c1             	movzbl %cl,%eax
80106767:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80106769:	5b                   	pop    %ebx
8010676a:	5e                   	pop    %esi
8010676b:	5d                   	pop    %ebp
8010676c:	c3                   	ret    
8010676d:	8d 76 00             	lea    0x0(%esi),%esi
80106770:	5b                   	pop    %ebx
  return 0;
80106771:	31 c0                	xor    %eax,%eax
}
80106773:	5e                   	pop    %esi
80106774:	5d                   	pop    %ebp
80106775:	c3                   	ret    
80106776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677d:	8d 76 00             	lea    0x0(%esi),%esi

80106780 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	8b 55 08             	mov    0x8(%ebp),%edx
80106787:	8b 45 10             	mov    0x10(%ebp),%eax
8010678a:	56                   	push   %esi
8010678b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010678e:	39 d6                	cmp    %edx,%esi
80106790:	73 26                	jae    801067b8 <memmove+0x38>
80106792:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80106795:	39 ca                	cmp    %ecx,%edx
80106797:	73 1f                	jae    801067b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80106799:	85 c0                	test   %eax,%eax
8010679b:	74 0f                	je     801067ac <memmove+0x2c>
8010679d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801067a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801067a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801067a7:	83 e8 01             	sub    $0x1,%eax
801067aa:	73 f4                	jae    801067a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801067ac:	5e                   	pop    %esi
801067ad:	89 d0                	mov    %edx,%eax
801067af:	5f                   	pop    %edi
801067b0:	5d                   	pop    %ebp
801067b1:	c3                   	ret    
801067b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801067b8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801067bb:	89 d7                	mov    %edx,%edi
801067bd:	85 c0                	test   %eax,%eax
801067bf:	74 eb                	je     801067ac <memmove+0x2c>
801067c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801067c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801067c9:	39 ce                	cmp    %ecx,%esi
801067cb:	75 fb                	jne    801067c8 <memmove+0x48>
}
801067cd:	5e                   	pop    %esi
801067ce:	89 d0                	mov    %edx,%eax
801067d0:	5f                   	pop    %edi
801067d1:	5d                   	pop    %ebp
801067d2:	c3                   	ret    
801067d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801067e0:	eb 9e                	jmp    80106780 <memmove>
801067e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	53                   	push   %ebx
801067f4:	8b 55 10             	mov    0x10(%ebp),%edx
801067f7:	8b 45 08             	mov    0x8(%ebp),%eax
801067fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801067fd:	85 d2                	test   %edx,%edx
801067ff:	75 16                	jne    80106817 <strncmp+0x27>
80106801:	eb 2d                	jmp    80106830 <strncmp+0x40>
80106803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106807:	90                   	nop
80106808:	3a 19                	cmp    (%ecx),%bl
8010680a:	75 12                	jne    8010681e <strncmp+0x2e>
    n--, p++, q++;
8010680c:	83 c0 01             	add    $0x1,%eax
8010680f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80106812:	83 ea 01             	sub    $0x1,%edx
80106815:	74 19                	je     80106830 <strncmp+0x40>
80106817:	0f b6 18             	movzbl (%eax),%ebx
8010681a:	84 db                	test   %bl,%bl
8010681c:	75 ea                	jne    80106808 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010681e:	0f b6 00             	movzbl (%eax),%eax
80106821:	0f b6 11             	movzbl (%ecx),%edx
}
80106824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106827:	c9                   	leave  
  return (uchar)*p - (uchar)*q;
80106828:	29 d0                	sub    %edx,%eax
}
8010682a:	c3                   	ret    
8010682b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010682f:	90                   	nop
80106830:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80106833:	31 c0                	xor    %eax,%eax
}
80106835:	c9                   	leave  
80106836:	c3                   	ret    
80106837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010683e:	66 90                	xchg   %ax,%ax

80106840 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	8b 75 08             	mov    0x8(%ebp),%esi
80106848:	53                   	push   %ebx
80106849:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010684c:	89 f0                	mov    %esi,%eax
8010684e:	eb 15                	jmp    80106865 <strncpy+0x25>
80106850:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80106854:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106857:	83 c0 01             	add    $0x1,%eax
8010685a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010685e:	88 48 ff             	mov    %cl,-0x1(%eax)
80106861:	84 c9                	test   %cl,%cl
80106863:	74 13                	je     80106878 <strncpy+0x38>
80106865:	89 d3                	mov    %edx,%ebx
80106867:	83 ea 01             	sub    $0x1,%edx
8010686a:	85 db                	test   %ebx,%ebx
8010686c:	7f e2                	jg     80106850 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010686e:	5b                   	pop    %ebx
8010686f:	89 f0                	mov    %esi,%eax
80106871:	5e                   	pop    %esi
80106872:	5f                   	pop    %edi
80106873:	5d                   	pop    %ebp
80106874:	c3                   	ret    
80106875:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80106878:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010687b:	83 e9 01             	sub    $0x1,%ecx
8010687e:	85 d2                	test   %edx,%edx
80106880:	74 ec                	je     8010686e <strncpy+0x2e>
80106882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80106888:	83 c0 01             	add    $0x1,%eax
8010688b:	89 ca                	mov    %ecx,%edx
8010688d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80106891:	29 c2                	sub    %eax,%edx
80106893:	85 d2                	test   %edx,%edx
80106895:	7f f1                	jg     80106888 <strncpy+0x48>
}
80106897:	5b                   	pop    %ebx
80106898:	89 f0                	mov    %esi,%eax
8010689a:	5e                   	pop    %esi
8010689b:	5f                   	pop    %edi
8010689c:	5d                   	pop    %ebp
8010689d:	c3                   	ret    
8010689e:	66 90                	xchg   %ax,%ax

801068a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	56                   	push   %esi
801068a4:	8b 55 10             	mov    0x10(%ebp),%edx
801068a7:	8b 75 08             	mov    0x8(%ebp),%esi
801068aa:	53                   	push   %ebx
801068ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801068ae:	85 d2                	test   %edx,%edx
801068b0:	7e 25                	jle    801068d7 <safestrcpy+0x37>
801068b2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801068b6:	89 f2                	mov    %esi,%edx
801068b8:	eb 16                	jmp    801068d0 <safestrcpy+0x30>
801068ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801068c0:	0f b6 08             	movzbl (%eax),%ecx
801068c3:	83 c0 01             	add    $0x1,%eax
801068c6:	83 c2 01             	add    $0x1,%edx
801068c9:	88 4a ff             	mov    %cl,-0x1(%edx)
801068cc:	84 c9                	test   %cl,%cl
801068ce:	74 04                	je     801068d4 <safestrcpy+0x34>
801068d0:	39 d8                	cmp    %ebx,%eax
801068d2:	75 ec                	jne    801068c0 <safestrcpy+0x20>
    ;
  *s = 0;
801068d4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801068d7:	89 f0                	mov    %esi,%eax
801068d9:	5b                   	pop    %ebx
801068da:	5e                   	pop    %esi
801068db:	5d                   	pop    %ebp
801068dc:	c3                   	ret    
801068dd:	8d 76 00             	lea    0x0(%esi),%esi

801068e0 <strlen>:

int
strlen(const char *s)
{
801068e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801068e1:	31 c0                	xor    %eax,%eax
{
801068e3:	89 e5                	mov    %esp,%ebp
801068e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801068e8:	80 3a 00             	cmpb   $0x0,(%edx)
801068eb:	74 0c                	je     801068f9 <strlen+0x19>
801068ed:	8d 76 00             	lea    0x0(%esi),%esi
801068f0:	83 c0 01             	add    $0x1,%eax
801068f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801068f7:	75 f7                	jne    801068f0 <strlen+0x10>
    ;
  return n;
}
801068f9:	5d                   	pop    %ebp
801068fa:	c3                   	ret    

801068fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801068fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801068ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80106903:	55                   	push   %ebp
  pushl %ebx
80106904:	53                   	push   %ebx
  pushl %esi
80106905:	56                   	push   %esi
  pushl %edi
80106906:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106907:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106909:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010690b:	5f                   	pop    %edi
  popl %esi
8010690c:	5e                   	pop    %esi
  popl %ebx
8010690d:	5b                   	pop    %ebx
  popl %ebp
8010690e:	5d                   	pop    %ebp
  ret
8010690f:	c3                   	ret    

80106910 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	53                   	push   %ebx
80106914:	83 ec 04             	sub    $0x4,%esp
80106917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010691a:	e8 41 ec ff ff       	call   80105560 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010691f:	8b 00                	mov    (%eax),%eax
80106921:	39 c3                	cmp    %eax,%ebx
80106923:	73 1b                	jae    80106940 <fetchint+0x30>
80106925:	8d 53 04             	lea    0x4(%ebx),%edx
80106928:	39 d0                	cmp    %edx,%eax
8010692a:	72 14                	jb     80106940 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010692c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010692f:	8b 13                	mov    (%ebx),%edx
80106931:	89 10                	mov    %edx,(%eax)
  return 0;
80106933:	31 c0                	xor    %eax,%eax
}
80106935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106938:	c9                   	leave  
80106939:	c3                   	ret    
8010693a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106945:	eb ee                	jmp    80106935 <fetchint+0x25>
80106947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694e:	66 90                	xchg   %ax,%ax

80106950 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	53                   	push   %ebx
80106954:	83 ec 04             	sub    $0x4,%esp
80106957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010695a:	e8 01 ec ff ff       	call   80105560 <myproc>

  if(addr >= curproc->sz)
8010695f:	3b 18                	cmp    (%eax),%ebx
80106961:	73 2d                	jae    80106990 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80106963:	8b 55 0c             	mov    0xc(%ebp),%edx
80106966:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80106968:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010696a:	39 d3                	cmp    %edx,%ebx
8010696c:	73 22                	jae    80106990 <fetchstr+0x40>
8010696e:	89 d8                	mov    %ebx,%eax
80106970:	eb 0d                	jmp    8010697f <fetchstr+0x2f>
80106972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106978:	83 c0 01             	add    $0x1,%eax
8010697b:	39 d0                	cmp    %edx,%eax
8010697d:	73 11                	jae    80106990 <fetchstr+0x40>
    if(*s == 0)
8010697f:	80 38 00             	cmpb   $0x0,(%eax)
80106982:	75 f4                	jne    80106978 <fetchstr+0x28>
      return s - *pp;
80106984:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80106986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106989:	c9                   	leave  
8010698a:	c3                   	ret    
8010698b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010698f:	90                   	nop
80106990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106998:	c9                   	leave  
80106999:	c3                   	ret    
8010699a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	56                   	push   %esi
801069a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801069a5:	e8 b6 eb ff ff       	call   80105560 <myproc>
801069aa:	8b 55 08             	mov    0x8(%ebp),%edx
801069ad:	8b 40 18             	mov    0x18(%eax),%eax
801069b0:	8b 40 44             	mov    0x44(%eax),%eax
801069b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801069b6:	e8 a5 eb ff ff       	call   80105560 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801069bb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801069be:	8b 00                	mov    (%eax),%eax
801069c0:	39 c6                	cmp    %eax,%esi
801069c2:	73 1c                	jae    801069e0 <argint+0x40>
801069c4:	8d 53 08             	lea    0x8(%ebx),%edx
801069c7:	39 d0                	cmp    %edx,%eax
801069c9:	72 15                	jb     801069e0 <argint+0x40>
  *ip = *(int*)(addr);
801069cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ce:	8b 53 04             	mov    0x4(%ebx),%edx
801069d1:	89 10                	mov    %edx,(%eax)
  return 0;
801069d3:	31 c0                	xor    %eax,%eax
}
801069d5:	5b                   	pop    %ebx
801069d6:	5e                   	pop    %esi
801069d7:	5d                   	pop    %ebp
801069d8:	c3                   	ret    
801069d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801069e5:	eb ee                	jmp    801069d5 <argint+0x35>
801069e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ee:	66 90                	xchg   %ax,%ax

801069f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
801069f6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801069f9:	e8 62 eb ff ff       	call   80105560 <myproc>
801069fe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106a00:	e8 5b eb ff ff       	call   80105560 <myproc>
80106a05:	8b 55 08             	mov    0x8(%ebp),%edx
80106a08:	8b 40 18             	mov    0x18(%eax),%eax
80106a0b:	8b 40 44             	mov    0x44(%eax),%eax
80106a0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106a11:	e8 4a eb ff ff       	call   80105560 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106a16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106a19:	8b 00                	mov    (%eax),%eax
80106a1b:	39 c7                	cmp    %eax,%edi
80106a1d:	73 31                	jae    80106a50 <argptr+0x60>
80106a1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106a22:	39 c8                	cmp    %ecx,%eax
80106a24:	72 2a                	jb     80106a50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106a26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106a29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106a2c:	85 d2                	test   %edx,%edx
80106a2e:	78 20                	js     80106a50 <argptr+0x60>
80106a30:	8b 16                	mov    (%esi),%edx
80106a32:	39 d0                	cmp    %edx,%eax
80106a34:	73 1a                	jae    80106a50 <argptr+0x60>
80106a36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106a39:	01 c3                	add    %eax,%ebx
80106a3b:	39 da                	cmp    %ebx,%edx
80106a3d:	72 11                	jb     80106a50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80106a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a42:	89 02                	mov    %eax,(%edx)
  return 0;
80106a44:	31 c0                	xor    %eax,%eax
}
80106a46:	83 c4 0c             	add    $0xc,%esp
80106a49:	5b                   	pop    %ebx
80106a4a:	5e                   	pop    %esi
80106a4b:	5f                   	pop    %edi
80106a4c:	5d                   	pop    %ebp
80106a4d:	c3                   	ret    
80106a4e:	66 90                	xchg   %ax,%ax
    return -1;
80106a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a55:	eb ef                	jmp    80106a46 <argptr+0x56>
80106a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5e:	66 90                	xchg   %ax,%ax

80106a60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	56                   	push   %esi
80106a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106a65:	e8 f6 ea ff ff       	call   80105560 <myproc>
80106a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a6d:	8b 40 18             	mov    0x18(%eax),%eax
80106a70:	8b 40 44             	mov    0x44(%eax),%eax
80106a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106a76:	e8 e5 ea ff ff       	call   80105560 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106a7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106a7e:	8b 00                	mov    (%eax),%eax
80106a80:	39 c6                	cmp    %eax,%esi
80106a82:	73 44                	jae    80106ac8 <argstr+0x68>
80106a84:	8d 53 08             	lea    0x8(%ebx),%edx
80106a87:	39 d0                	cmp    %edx,%eax
80106a89:	72 3d                	jb     80106ac8 <argstr+0x68>
  *ip = *(int*)(addr);
80106a8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80106a8e:	e8 cd ea ff ff       	call   80105560 <myproc>
  if(addr >= curproc->sz)
80106a93:	3b 18                	cmp    (%eax),%ebx
80106a95:	73 31                	jae    80106ac8 <argstr+0x68>
  *pp = (char*)addr;
80106a97:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80106a9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80106a9e:	39 d3                	cmp    %edx,%ebx
80106aa0:	73 26                	jae    80106ac8 <argstr+0x68>
80106aa2:	89 d8                	mov    %ebx,%eax
80106aa4:	eb 11                	jmp    80106ab7 <argstr+0x57>
80106aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
80106ab0:	83 c0 01             	add    $0x1,%eax
80106ab3:	39 d0                	cmp    %edx,%eax
80106ab5:	73 11                	jae    80106ac8 <argstr+0x68>
    if(*s == 0)
80106ab7:	80 38 00             	cmpb   $0x0,(%eax)
80106aba:	75 f4                	jne    80106ab0 <argstr+0x50>
      return s - *pp;
80106abc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80106abe:	5b                   	pop    %ebx
80106abf:	5e                   	pop    %esi
80106ac0:	5d                   	pop    %ebp
80106ac1:	c3                   	ret    
80106ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ac8:	5b                   	pop    %ebx
    return -1;
80106ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ace:	5e                   	pop    %esi
80106acf:	5d                   	pop    %ebp
80106ad0:	c3                   	ret    
80106ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106adf:	90                   	nop

80106ae0 <syscall>:
[SYS_set_priority_syscall] sys_set_priority_syscall,
};

void
syscall(void)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	53                   	push   %ebx
80106ae4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106ae7:	e8 74 ea ff ff       	call   80105560 <myproc>
80106aec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80106aee:	8b 40 18             	mov    0x18(%eax),%eax
80106af1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106af4:	8d 50 ff             	lea    -0x1(%eax),%edx
80106af7:	83 fa 19             	cmp    $0x19,%edx
80106afa:	77 24                	ja     80106b20 <syscall+0x40>
80106afc:	8b 14 85 40 a0 10 80 	mov    -0x7fef5fc0(,%eax,4),%edx
80106b03:	85 d2                	test   %edx,%edx
80106b05:	74 19                	je     80106b20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80106b07:	ff d2                	call   *%edx
80106b09:	89 c2                	mov    %eax,%edx
80106b0b:	8b 43 18             	mov    0x18(%ebx),%eax
80106b0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80106b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b14:	c9                   	leave  
80106b15:	c3                   	ret    
80106b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80106b20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106b21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106b24:	50                   	push   %eax
80106b25:	ff 73 10             	pushl  0x10(%ebx)
80106b28:	68 05 a0 10 80       	push   $0x8010a005
80106b2d:	e8 9e 9c ff ff       	call   801007d0 <cprintf>
    curproc->tf->eax = -1;
80106b32:	8b 43 18             	mov    0x18(%ebx),%eax
80106b35:	83 c4 10             	add    $0x10,%esp
80106b38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80106b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b42:	c9                   	leave  
80106b43:	c3                   	ret    
80106b44:	66 90                	xchg   %ax,%ax
80106b46:	66 90                	xchg   %ax,%ax
80106b48:	66 90                	xchg   %ax,%ax
80106b4a:	66 90                	xchg   %ax,%ax
80106b4c:	66 90                	xchg   %ax,%ax
80106b4e:	66 90                	xchg   %ax,%ax

80106b50 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80106b55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106b58:	53                   	push   %ebx
80106b59:	83 ec 34             	sub    $0x34,%esp
80106b5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80106b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106b62:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106b65:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
80106b68:	57                   	push   %edi
80106b69:	50                   	push   %eax
80106b6a:	e8 f1 d0 ff ff       	call   80103c60 <nameiparent>
80106b6f:	83 c4 10             	add    $0x10,%esp
80106b72:	85 c0                	test   %eax,%eax
80106b74:	74 5e                	je     80106bd4 <create+0x84>
    return 0;
  ilock(dp);
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	89 c3                	mov    %eax,%ebx
80106b7b:	50                   	push   %eax
80106b7c:	e8 df c7 ff ff       	call   80103360 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80106b81:	83 c4 0c             	add    $0xc,%esp
80106b84:	6a 00                	push   $0x0
80106b86:	57                   	push   %edi
80106b87:	53                   	push   %ebx
80106b88:	e8 23 cd ff ff       	call   801038b0 <dirlookup>
80106b8d:	83 c4 10             	add    $0x10,%esp
80106b90:	89 c6                	mov    %eax,%esi
80106b92:	85 c0                	test   %eax,%eax
80106b94:	74 4a                	je     80106be0 <create+0x90>
  {
    iunlockput(dp);
80106b96:	83 ec 0c             	sub    $0xc,%esp
80106b99:	53                   	push   %ebx
80106b9a:	e8 51 ca ff ff       	call   801035f0 <iunlockput>
    ilock(ip);
80106b9f:	89 34 24             	mov    %esi,(%esp)
80106ba2:	e8 b9 c7 ff ff       	call   80103360 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
80106ba7:	83 c4 10             	add    $0x10,%esp
80106baa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106baf:	75 17                	jne    80106bc8 <create+0x78>
80106bb1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80106bb6:	75 10                	jne    80106bc8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80106bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bbb:	89 f0                	mov    %esi,%eax
80106bbd:	5b                   	pop    %ebx
80106bbe:	5e                   	pop    %esi
80106bbf:	5f                   	pop    %edi
80106bc0:	5d                   	pop    %ebp
80106bc1:	c3                   	ret    
80106bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106bc8:	83 ec 0c             	sub    $0xc,%esp
80106bcb:	56                   	push   %esi
80106bcc:	e8 1f ca ff ff       	call   801035f0 <iunlockput>
    return 0;
80106bd1:	83 c4 10             	add    $0x10,%esp
}
80106bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bd7:	31 f6                	xor    %esi,%esi
}
80106bd9:	5b                   	pop    %ebx
80106bda:	89 f0                	mov    %esi,%eax
80106bdc:	5e                   	pop    %esi
80106bdd:	5f                   	pop    %edi
80106bde:	5d                   	pop    %ebp
80106bdf:	c3                   	ret    
  if ((ip = ialloc(dp->dev, type)) == 0)
80106be0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106be4:	83 ec 08             	sub    $0x8,%esp
80106be7:	50                   	push   %eax
80106be8:	ff 33                	pushl  (%ebx)
80106bea:	e8 01 c6 ff ff       	call   801031f0 <ialloc>
80106bef:	83 c4 10             	add    $0x10,%esp
80106bf2:	89 c6                	mov    %eax,%esi
80106bf4:	85 c0                	test   %eax,%eax
80106bf6:	0f 84 bc 00 00 00    	je     80106cb8 <create+0x168>
  ilock(ip);
80106bfc:	83 ec 0c             	sub    $0xc,%esp
80106bff:	50                   	push   %eax
80106c00:	e8 5b c7 ff ff       	call   80103360 <ilock>
  ip->major = major;
80106c05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106c09:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80106c0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106c11:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106c15:	b8 01 00 00 00       	mov    $0x1,%eax
80106c1a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80106c1e:	89 34 24             	mov    %esi,(%esp)
80106c21:	e8 8a c6 ff ff       	call   801032b0 <iupdate>
  if (type == T_DIR)
80106c26:	83 c4 10             	add    $0x10,%esp
80106c29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106c2e:	74 30                	je     80106c60 <create+0x110>
  if (dirlink(dp, name, ip->inum) < 0)
80106c30:	83 ec 04             	sub    $0x4,%esp
80106c33:	ff 76 04             	pushl  0x4(%esi)
80106c36:	57                   	push   %edi
80106c37:	53                   	push   %ebx
80106c38:	e8 43 cf ff ff       	call   80103b80 <dirlink>
80106c3d:	83 c4 10             	add    $0x10,%esp
80106c40:	85 c0                	test   %eax,%eax
80106c42:	78 67                	js     80106cab <create+0x15b>
  iunlockput(dp);
80106c44:	83 ec 0c             	sub    $0xc,%esp
80106c47:	53                   	push   %ebx
80106c48:	e8 a3 c9 ff ff       	call   801035f0 <iunlockput>
  return ip;
80106c4d:	83 c4 10             	add    $0x10,%esp
}
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c53:	89 f0                	mov    %esi,%eax
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106c60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80106c63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106c68:	53                   	push   %ebx
80106c69:	e8 42 c6 ff ff       	call   801032b0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106c6e:	83 c4 0c             	add    $0xc,%esp
80106c71:	ff 76 04             	pushl  0x4(%esi)
80106c74:	68 c8 a0 10 80       	push   $0x8010a0c8
80106c79:	56                   	push   %esi
80106c7a:	e8 01 cf ff ff       	call   80103b80 <dirlink>
80106c7f:	83 c4 10             	add    $0x10,%esp
80106c82:	85 c0                	test   %eax,%eax
80106c84:	78 18                	js     80106c9e <create+0x14e>
80106c86:	83 ec 04             	sub    $0x4,%esp
80106c89:	ff 73 04             	pushl  0x4(%ebx)
80106c8c:	68 c7 a0 10 80       	push   $0x8010a0c7
80106c91:	56                   	push   %esi
80106c92:	e8 e9 ce ff ff       	call   80103b80 <dirlink>
80106c97:	83 c4 10             	add    $0x10,%esp
80106c9a:	85 c0                	test   %eax,%eax
80106c9c:	79 92                	jns    80106c30 <create+0xe0>
      panic("create dots");
80106c9e:	83 ec 0c             	sub    $0xc,%esp
80106ca1:	68 bb a0 10 80       	push   $0x8010a0bb
80106ca6:	e8 d5 96 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80106cab:	83 ec 0c             	sub    $0xc,%esp
80106cae:	68 ca a0 10 80       	push   $0x8010a0ca
80106cb3:	e8 c8 96 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80106cb8:	83 ec 0c             	sub    $0xc,%esp
80106cbb:	68 ac a0 10 80       	push   $0x8010a0ac
80106cc0:	e8 bb 96 ff ff       	call   80100380 <panic>
80106cc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cd0 <sys_dup>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	56                   	push   %esi
80106cd4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106cd8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106cdb:	50                   	push   %eax
80106cdc:	6a 00                	push   $0x0
80106cde:	e8 bd fc ff ff       	call   801069a0 <argint>
80106ce3:	83 c4 10             	add    $0x10,%esp
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	78 36                	js     80106d20 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106cea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106cee:	77 30                	ja     80106d20 <sys_dup+0x50>
80106cf0:	e8 6b e8 ff ff       	call   80105560 <myproc>
80106cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cf8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106cfc:	85 f6                	test   %esi,%esi
80106cfe:	74 20                	je     80106d20 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106d00:	e8 5b e8 ff ff       	call   80105560 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106d05:	31 db                	xor    %ebx,%ebx
80106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80106d10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106d14:	85 d2                	test   %edx,%edx
80106d16:	74 18                	je     80106d30 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
80106d18:	83 c3 01             	add    $0x1,%ebx
80106d1b:	83 fb 10             	cmp    $0x10,%ebx
80106d1e:	75 f0                	jne    80106d10 <sys_dup+0x40>
}
80106d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106d28:	89 d8                	mov    %ebx,%eax
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5d                   	pop    %ebp
80106d2d:	c3                   	ret    
80106d2e:	66 90                	xchg   %ax,%ax
  filedup(f);
80106d30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106d33:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106d37:	56                   	push   %esi
80106d38:	e8 43 bd ff ff       	call   80102a80 <filedup>
  return fd;
80106d3d:	83 c4 10             	add    $0x10,%esp
}
80106d40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d43:	89 d8                	mov    %ebx,%eax
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5d                   	pop    %ebp
80106d48:	c3                   	ret    
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d50 <sys_read>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	56                   	push   %esi
80106d54:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106d55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106d58:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106d5b:	53                   	push   %ebx
80106d5c:	6a 00                	push   $0x0
80106d5e:	e8 3d fc ff ff       	call   801069a0 <argint>
80106d63:	83 c4 10             	add    $0x10,%esp
80106d66:	85 c0                	test   %eax,%eax
80106d68:	78 5e                	js     80106dc8 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106d6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106d6e:	77 58                	ja     80106dc8 <sys_read+0x78>
80106d70:	e8 eb e7 ff ff       	call   80105560 <myproc>
80106d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106d7c:	85 f6                	test   %esi,%esi
80106d7e:	74 48                	je     80106dc8 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106d80:	83 ec 08             	sub    $0x8,%esp
80106d83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d86:	50                   	push   %eax
80106d87:	6a 02                	push   $0x2
80106d89:	e8 12 fc ff ff       	call   801069a0 <argint>
80106d8e:	83 c4 10             	add    $0x10,%esp
80106d91:	85 c0                	test   %eax,%eax
80106d93:	78 33                	js     80106dc8 <sys_read+0x78>
80106d95:	83 ec 04             	sub    $0x4,%esp
80106d98:	ff 75 f0             	pushl  -0x10(%ebp)
80106d9b:	53                   	push   %ebx
80106d9c:	6a 01                	push   $0x1
80106d9e:	e8 4d fc ff ff       	call   801069f0 <argptr>
80106da3:	83 c4 10             	add    $0x10,%esp
80106da6:	85 c0                	test   %eax,%eax
80106da8:	78 1e                	js     80106dc8 <sys_read+0x78>
  return fileread(f, p, n);
80106daa:	83 ec 04             	sub    $0x4,%esp
80106dad:	ff 75 f0             	pushl  -0x10(%ebp)
80106db0:	ff 75 f4             	pushl  -0xc(%ebp)
80106db3:	56                   	push   %esi
80106db4:	e8 47 be ff ff       	call   80102c00 <fileread>
80106db9:	83 c4 10             	add    $0x10,%esp
}
80106dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106dbf:	5b                   	pop    %ebx
80106dc0:	5e                   	pop    %esi
80106dc1:	5d                   	pop    %ebp
80106dc2:	c3                   	ret    
80106dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106dc7:	90                   	nop
    return -1;
80106dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dcd:	eb ed                	jmp    80106dbc <sys_read+0x6c>
80106dcf:	90                   	nop

80106dd0 <sys_write>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	56                   	push   %esi
80106dd4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106dd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106dd8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106ddb:	53                   	push   %ebx
80106ddc:	6a 00                	push   $0x0
80106dde:	e8 bd fb ff ff       	call   801069a0 <argint>
80106de3:	83 c4 10             	add    $0x10,%esp
80106de6:	85 c0                	test   %eax,%eax
80106de8:	78 5e                	js     80106e48 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106dea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106dee:	77 58                	ja     80106e48 <sys_write+0x78>
80106df0:	e8 6b e7 ff ff       	call   80105560 <myproc>
80106df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106df8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106dfc:	85 f6                	test   %esi,%esi
80106dfe:	74 48                	je     80106e48 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106e00:	83 ec 08             	sub    $0x8,%esp
80106e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e06:	50                   	push   %eax
80106e07:	6a 02                	push   $0x2
80106e09:	e8 92 fb ff ff       	call   801069a0 <argint>
80106e0e:	83 c4 10             	add    $0x10,%esp
80106e11:	85 c0                	test   %eax,%eax
80106e13:	78 33                	js     80106e48 <sys_write+0x78>
80106e15:	83 ec 04             	sub    $0x4,%esp
80106e18:	ff 75 f0             	pushl  -0x10(%ebp)
80106e1b:	53                   	push   %ebx
80106e1c:	6a 01                	push   $0x1
80106e1e:	e8 cd fb ff ff       	call   801069f0 <argptr>
80106e23:	83 c4 10             	add    $0x10,%esp
80106e26:	85 c0                	test   %eax,%eax
80106e28:	78 1e                	js     80106e48 <sys_write+0x78>
  return filewrite(f, p, n);
80106e2a:	83 ec 04             	sub    $0x4,%esp
80106e2d:	ff 75 f0             	pushl  -0x10(%ebp)
80106e30:	ff 75 f4             	pushl  -0xc(%ebp)
80106e33:	56                   	push   %esi
80106e34:	e8 57 be ff ff       	call   80102c90 <filewrite>
80106e39:	83 c4 10             	add    $0x10,%esp
}
80106e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e3f:	5b                   	pop    %ebx
80106e40:	5e                   	pop    %esi
80106e41:	5d                   	pop    %ebp
80106e42:	c3                   	ret    
80106e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e47:	90                   	nop
    return -1;
80106e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e4d:	eb ed                	jmp    80106e3c <sys_write+0x6c>
80106e4f:	90                   	nop

80106e50 <sys_close>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	56                   	push   %esi
80106e54:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106e58:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106e5b:	50                   	push   %eax
80106e5c:	6a 00                	push   $0x0
80106e5e:	e8 3d fb ff ff       	call   801069a0 <argint>
80106e63:	83 c4 10             	add    $0x10,%esp
80106e66:	85 c0                	test   %eax,%eax
80106e68:	78 3e                	js     80106ea8 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106e6e:	77 38                	ja     80106ea8 <sys_close+0x58>
80106e70:	e8 eb e6 ff ff       	call   80105560 <myproc>
80106e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e78:	8d 5a 08             	lea    0x8(%edx),%ebx
80106e7b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106e7f:	85 f6                	test   %esi,%esi
80106e81:	74 25                	je     80106ea8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106e83:	e8 d8 e6 ff ff       	call   80105560 <myproc>
  fileclose(f);
80106e88:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106e8b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106e92:	00 
  fileclose(f);
80106e93:	56                   	push   %esi
80106e94:	e8 37 bc ff ff       	call   80102ad0 <fileclose>
  return 0;
80106e99:	83 c4 10             	add    $0x10,%esp
80106e9c:	31 c0                	xor    %eax,%eax
}
80106e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ea1:	5b                   	pop    %ebx
80106ea2:	5e                   	pop    %esi
80106ea3:	5d                   	pop    %ebp
80106ea4:	c3                   	ret    
80106ea5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ead:	eb ef                	jmp    80106e9e <sys_close+0x4e>
80106eaf:	90                   	nop

80106eb0 <sys_fstat>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	56                   	push   %esi
80106eb4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80106eb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106eb8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80106ebb:	53                   	push   %ebx
80106ebc:	6a 00                	push   $0x0
80106ebe:	e8 dd fa ff ff       	call   801069a0 <argint>
80106ec3:	83 c4 10             	add    $0x10,%esp
80106ec6:	85 c0                	test   %eax,%eax
80106ec8:	78 46                	js     80106f10 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80106eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106ece:	77 40                	ja     80106f10 <sys_fstat+0x60>
80106ed0:	e8 8b e6 ff ff       	call   80105560 <myproc>
80106ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106edc:	85 f6                	test   %esi,%esi
80106ede:	74 30                	je     80106f10 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80106ee0:	83 ec 04             	sub    $0x4,%esp
80106ee3:	6a 14                	push   $0x14
80106ee5:	53                   	push   %ebx
80106ee6:	6a 01                	push   $0x1
80106ee8:	e8 03 fb ff ff       	call   801069f0 <argptr>
80106eed:	83 c4 10             	add    $0x10,%esp
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	78 1c                	js     80106f10 <sys_fstat+0x60>
  return filestat(f, st);
80106ef4:	83 ec 08             	sub    $0x8,%esp
80106ef7:	ff 75 f4             	pushl  -0xc(%ebp)
80106efa:	56                   	push   %esi
80106efb:	e8 b0 bc ff ff       	call   80102bb0 <filestat>
80106f00:	83 c4 10             	add    $0x10,%esp
}
80106f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f06:	5b                   	pop    %ebx
80106f07:	5e                   	pop    %esi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f15:	eb ec                	jmp    80106f03 <sys_fstat+0x53>
80106f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1e:	66 90                	xchg   %ax,%ax

80106f20 <sys_link>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106f25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106f28:	53                   	push   %ebx
80106f29:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106f2c:	50                   	push   %eax
80106f2d:	6a 00                	push   $0x0
80106f2f:	e8 2c fb ff ff       	call   80106a60 <argstr>
80106f34:	83 c4 10             	add    $0x10,%esp
80106f37:	85 c0                	test   %eax,%eax
80106f39:	0f 88 fb 00 00 00    	js     8010703a <sys_link+0x11a>
80106f3f:	83 ec 08             	sub    $0x8,%esp
80106f42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106f45:	50                   	push   %eax
80106f46:	6a 01                	push   $0x1
80106f48:	e8 13 fb ff ff       	call   80106a60 <argstr>
80106f4d:	83 c4 10             	add    $0x10,%esp
80106f50:	85 c0                	test   %eax,%eax
80106f52:	0f 88 e2 00 00 00    	js     8010703a <sys_link+0x11a>
  begin_op();
80106f58:	e8 a3 d9 ff ff       	call   80104900 <begin_op>
  if ((ip = namei(old)) == 0)
80106f5d:	83 ec 0c             	sub    $0xc,%esp
80106f60:	ff 75 d4             	pushl  -0x2c(%ebp)
80106f63:	e8 d8 cc ff ff       	call   80103c40 <namei>
80106f68:	83 c4 10             	add    $0x10,%esp
80106f6b:	89 c3                	mov    %eax,%ebx
80106f6d:	85 c0                	test   %eax,%eax
80106f6f:	0f 84 df 00 00 00    	je     80107054 <sys_link+0x134>
  ilock(ip);
80106f75:	83 ec 0c             	sub    $0xc,%esp
80106f78:	50                   	push   %eax
80106f79:	e8 e2 c3 ff ff       	call   80103360 <ilock>
  if (ip->type == T_DIR)
80106f7e:	83 c4 10             	add    $0x10,%esp
80106f81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106f86:	0f 84 b5 00 00 00    	je     80107041 <sys_link+0x121>
  iupdate(ip);
80106f8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106f8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80106f94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106f97:	53                   	push   %ebx
80106f98:	e8 13 c3 ff ff       	call   801032b0 <iupdate>
  iunlock(ip);
80106f9d:	89 1c 24             	mov    %ebx,(%esp)
80106fa0:	e8 9b c4 ff ff       	call   80103440 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80106fa5:	58                   	pop    %eax
80106fa6:	5a                   	pop    %edx
80106fa7:	57                   	push   %edi
80106fa8:	ff 75 d0             	pushl  -0x30(%ebp)
80106fab:	e8 b0 cc ff ff       	call   80103c60 <nameiparent>
80106fb0:	83 c4 10             	add    $0x10,%esp
80106fb3:	89 c6                	mov    %eax,%esi
80106fb5:	85 c0                	test   %eax,%eax
80106fb7:	74 5b                	je     80107014 <sys_link+0xf4>
  ilock(dp);
80106fb9:	83 ec 0c             	sub    $0xc,%esp
80106fbc:	50                   	push   %eax
80106fbd:	e8 9e c3 ff ff       	call   80103360 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80106fc2:	8b 03                	mov    (%ebx),%eax
80106fc4:	83 c4 10             	add    $0x10,%esp
80106fc7:	39 06                	cmp    %eax,(%esi)
80106fc9:	75 3d                	jne    80107008 <sys_link+0xe8>
80106fcb:	83 ec 04             	sub    $0x4,%esp
80106fce:	ff 73 04             	pushl  0x4(%ebx)
80106fd1:	57                   	push   %edi
80106fd2:	56                   	push   %esi
80106fd3:	e8 a8 cb ff ff       	call   80103b80 <dirlink>
80106fd8:	83 c4 10             	add    $0x10,%esp
80106fdb:	85 c0                	test   %eax,%eax
80106fdd:	78 29                	js     80107008 <sys_link+0xe8>
  iunlockput(dp);
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	56                   	push   %esi
80106fe3:	e8 08 c6 ff ff       	call   801035f0 <iunlockput>
  iput(ip);
80106fe8:	89 1c 24             	mov    %ebx,(%esp)
80106feb:	e8 a0 c4 ff ff       	call   80103490 <iput>
  end_op();
80106ff0:	e8 7b d9 ff ff       	call   80104970 <end_op>
  return 0;
80106ff5:	83 c4 10             	add    $0x10,%esp
80106ff8:	31 c0                	xor    %eax,%eax
}
80106ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffd:	5b                   	pop    %ebx
80106ffe:	5e                   	pop    %esi
80106fff:	5f                   	pop    %edi
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80107008:	83 ec 0c             	sub    $0xc,%esp
8010700b:	56                   	push   %esi
8010700c:	e8 df c5 ff ff       	call   801035f0 <iunlockput>
    goto bad;
80107011:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80107014:	83 ec 0c             	sub    $0xc,%esp
80107017:	53                   	push   %ebx
80107018:	e8 43 c3 ff ff       	call   80103360 <ilock>
  ip->nlink--;
8010701d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80107022:	89 1c 24             	mov    %ebx,(%esp)
80107025:	e8 86 c2 ff ff       	call   801032b0 <iupdate>
  iunlockput(ip);
8010702a:	89 1c 24             	mov    %ebx,(%esp)
8010702d:	e8 be c5 ff ff       	call   801035f0 <iunlockput>
  end_op();
80107032:	e8 39 d9 ff ff       	call   80104970 <end_op>
  return -1;
80107037:	83 c4 10             	add    $0x10,%esp
    return -1;
8010703a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010703f:	eb b9                	jmp    80106ffa <sys_link+0xda>
    iunlockput(ip);
80107041:	83 ec 0c             	sub    $0xc,%esp
80107044:	53                   	push   %ebx
80107045:	e8 a6 c5 ff ff       	call   801035f0 <iunlockput>
    end_op();
8010704a:	e8 21 d9 ff ff       	call   80104970 <end_op>
    return -1;
8010704f:	83 c4 10             	add    $0x10,%esp
80107052:	eb e6                	jmp    8010703a <sys_link+0x11a>
    end_op();
80107054:	e8 17 d9 ff ff       	call   80104970 <end_op>
    return -1;
80107059:	eb df                	jmp    8010703a <sys_link+0x11a>
8010705b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop

80107060 <sys_unlink>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80107065:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80107068:	53                   	push   %ebx
80107069:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
8010706c:	50                   	push   %eax
8010706d:	6a 00                	push   $0x0
8010706f:	e8 ec f9 ff ff       	call   80106a60 <argstr>
80107074:	83 c4 10             	add    $0x10,%esp
80107077:	85 c0                	test   %eax,%eax
80107079:	0f 88 54 01 00 00    	js     801071d3 <sys_unlink+0x173>
  begin_op();
8010707f:	e8 7c d8 ff ff       	call   80104900 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80107084:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80107087:	83 ec 08             	sub    $0x8,%esp
8010708a:	53                   	push   %ebx
8010708b:	ff 75 c0             	pushl  -0x40(%ebp)
8010708e:	e8 cd cb ff ff       	call   80103c60 <nameiparent>
80107093:	83 c4 10             	add    $0x10,%esp
80107096:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107099:	85 c0                	test   %eax,%eax
8010709b:	0f 84 58 01 00 00    	je     801071f9 <sys_unlink+0x199>
  ilock(dp);
801070a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801070a4:	83 ec 0c             	sub    $0xc,%esp
801070a7:	57                   	push   %edi
801070a8:	e8 b3 c2 ff ff       	call   80103360 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801070ad:	58                   	pop    %eax
801070ae:	5a                   	pop    %edx
801070af:	68 c8 a0 10 80       	push   $0x8010a0c8
801070b4:	53                   	push   %ebx
801070b5:	e8 d6 c7 ff ff       	call   80103890 <namecmp>
801070ba:	83 c4 10             	add    $0x10,%esp
801070bd:	85 c0                	test   %eax,%eax
801070bf:	0f 84 fb 00 00 00    	je     801071c0 <sys_unlink+0x160>
801070c5:	83 ec 08             	sub    $0x8,%esp
801070c8:	68 c7 a0 10 80       	push   $0x8010a0c7
801070cd:	53                   	push   %ebx
801070ce:	e8 bd c7 ff ff       	call   80103890 <namecmp>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	85 c0                	test   %eax,%eax
801070d8:	0f 84 e2 00 00 00    	je     801071c0 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
801070de:	83 ec 04             	sub    $0x4,%esp
801070e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801070e4:	50                   	push   %eax
801070e5:	53                   	push   %ebx
801070e6:	57                   	push   %edi
801070e7:	e8 c4 c7 ff ff       	call   801038b0 <dirlookup>
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	89 c3                	mov    %eax,%ebx
801070f1:	85 c0                	test   %eax,%eax
801070f3:	0f 84 c7 00 00 00    	je     801071c0 <sys_unlink+0x160>
  ilock(ip);
801070f9:	83 ec 0c             	sub    $0xc,%esp
801070fc:	50                   	push   %eax
801070fd:	e8 5e c2 ff ff       	call   80103360 <ilock>
  if (ip->nlink < 1)
80107102:	83 c4 10             	add    $0x10,%esp
80107105:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010710a:	0f 8e 0a 01 00 00    	jle    8010721a <sys_unlink+0x1ba>
  if (ip->type == T_DIR && !isdirempty(ip))
80107110:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80107115:	8d 7d d8             	lea    -0x28(%ebp),%edi
80107118:	74 66                	je     80107180 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010711a:	83 ec 04             	sub    $0x4,%esp
8010711d:	6a 10                	push   $0x10
8010711f:	6a 00                	push   $0x0
80107121:	57                   	push   %edi
80107122:	e8 c9 f5 ff ff       	call   801066f0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80107127:	6a 10                	push   $0x10
80107129:	ff 75 c4             	pushl  -0x3c(%ebp)
8010712c:	57                   	push   %edi
8010712d:	ff 75 b4             	pushl  -0x4c(%ebp)
80107130:	e8 3b c6 ff ff       	call   80103770 <writei>
80107135:	83 c4 20             	add    $0x20,%esp
80107138:	83 f8 10             	cmp    $0x10,%eax
8010713b:	0f 85 cc 00 00 00    	jne    8010720d <sys_unlink+0x1ad>
  if (ip->type == T_DIR)
80107141:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80107146:	0f 84 94 00 00 00    	je     801071e0 <sys_unlink+0x180>
  iunlockput(dp);
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	ff 75 b4             	pushl  -0x4c(%ebp)
80107152:	e8 99 c4 ff ff       	call   801035f0 <iunlockput>
  ip->nlink--;
80107157:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010715c:	89 1c 24             	mov    %ebx,(%esp)
8010715f:	e8 4c c1 ff ff       	call   801032b0 <iupdate>
  iunlockput(ip);
80107164:	89 1c 24             	mov    %ebx,(%esp)
80107167:	e8 84 c4 ff ff       	call   801035f0 <iunlockput>
  end_op();
8010716c:	e8 ff d7 ff ff       	call   80104970 <end_op>
  return 0;
80107171:	83 c4 10             	add    $0x10,%esp
80107174:	31 c0                	xor    %eax,%eax
}
80107176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107179:	5b                   	pop    %ebx
8010717a:	5e                   	pop    %esi
8010717b:	5f                   	pop    %edi
8010717c:	5d                   	pop    %ebp
8010717d:	c3                   	ret    
8010717e:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80107180:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80107184:	76 94                	jbe    8010711a <sys_unlink+0xba>
80107186:	be 20 00 00 00       	mov    $0x20,%esi
8010718b:	eb 0b                	jmp    80107198 <sys_unlink+0x138>
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
80107190:	83 c6 10             	add    $0x10,%esi
80107193:	3b 73 58             	cmp    0x58(%ebx),%esi
80107196:	73 82                	jae    8010711a <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80107198:	6a 10                	push   $0x10
8010719a:	56                   	push   %esi
8010719b:	57                   	push   %edi
8010719c:	53                   	push   %ebx
8010719d:	e8 ce c4 ff ff       	call   80103670 <readi>
801071a2:	83 c4 10             	add    $0x10,%esp
801071a5:	83 f8 10             	cmp    $0x10,%eax
801071a8:	75 56                	jne    80107200 <sys_unlink+0x1a0>
    if (de.inum != 0)
801071aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801071af:	74 df                	je     80107190 <sys_unlink+0x130>
    iunlockput(ip);
801071b1:	83 ec 0c             	sub    $0xc,%esp
801071b4:	53                   	push   %ebx
801071b5:	e8 36 c4 ff ff       	call   801035f0 <iunlockput>
    goto bad;
801071ba:	83 c4 10             	add    $0x10,%esp
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801071c0:	83 ec 0c             	sub    $0xc,%esp
801071c3:	ff 75 b4             	pushl  -0x4c(%ebp)
801071c6:	e8 25 c4 ff ff       	call   801035f0 <iunlockput>
  end_op();
801071cb:	e8 a0 d7 ff ff       	call   80104970 <end_op>
  return -1;
801071d0:	83 c4 10             	add    $0x10,%esp
    return -1;
801071d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071d8:	eb 9c                	jmp    80107176 <sys_unlink+0x116>
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801071e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801071e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801071e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801071eb:	50                   	push   %eax
801071ec:	e8 bf c0 ff ff       	call   801032b0 <iupdate>
801071f1:	83 c4 10             	add    $0x10,%esp
801071f4:	e9 53 ff ff ff       	jmp    8010714c <sys_unlink+0xec>
    end_op();
801071f9:	e8 72 d7 ff ff       	call   80104970 <end_op>
    return -1;
801071fe:	eb d3                	jmp    801071d3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	68 ec a0 10 80       	push   $0x8010a0ec
80107208:	e8 73 91 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010720d:	83 ec 0c             	sub    $0xc,%esp
80107210:	68 fe a0 10 80       	push   $0x8010a0fe
80107215:	e8 66 91 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 da a0 10 80       	push   $0x8010a0da
80107222:	e8 59 91 ff ff       	call   80100380 <panic>
80107227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722e:	66 90                	xchg   %ax,%ax

80107230 <sys_open>:

int sys_open(void)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107235:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80107238:	53                   	push   %ebx
80107239:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010723c:	50                   	push   %eax
8010723d:	6a 00                	push   $0x0
8010723f:	e8 1c f8 ff ff       	call   80106a60 <argstr>
80107244:	83 c4 10             	add    $0x10,%esp
80107247:	85 c0                	test   %eax,%eax
80107249:	0f 88 8e 00 00 00    	js     801072dd <sys_open+0xad>
8010724f:	83 ec 08             	sub    $0x8,%esp
80107252:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107255:	50                   	push   %eax
80107256:	6a 01                	push   $0x1
80107258:	e8 43 f7 ff ff       	call   801069a0 <argint>
8010725d:	83 c4 10             	add    $0x10,%esp
80107260:	85 c0                	test   %eax,%eax
80107262:	78 79                	js     801072dd <sys_open+0xad>
    return -1;

  begin_op();
80107264:	e8 97 d6 ff ff       	call   80104900 <begin_op>

  if (omode & O_CREATE)
80107269:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010726d:	75 79                	jne    801072e8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
8010726f:	83 ec 0c             	sub    $0xc,%esp
80107272:	ff 75 e0             	pushl  -0x20(%ebp)
80107275:	e8 c6 c9 ff ff       	call   80103c40 <namei>
8010727a:	83 c4 10             	add    $0x10,%esp
8010727d:	89 c6                	mov    %eax,%esi
8010727f:	85 c0                	test   %eax,%eax
80107281:	0f 84 7e 00 00 00    	je     80107305 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80107287:	83 ec 0c             	sub    $0xc,%esp
8010728a:	50                   	push   %eax
8010728b:	e8 d0 c0 ff ff       	call   80103360 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80107298:	0f 84 ba 00 00 00    	je     80107358 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
8010729e:	e8 6d b7 ff ff       	call   80102a10 <filealloc>
801072a3:	89 c7                	mov    %eax,%edi
801072a5:	85 c0                	test   %eax,%eax
801072a7:	74 23                	je     801072cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801072a9:	e8 b2 e2 ff ff       	call   80105560 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801072ae:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
801072b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801072b4:	85 d2                	test   %edx,%edx
801072b6:	74 58                	je     80107310 <sys_open+0xe0>
  for (fd = 0; fd < NOFILE; fd++)
801072b8:	83 c3 01             	add    $0x1,%ebx
801072bb:	83 fb 10             	cmp    $0x10,%ebx
801072be:	75 f0                	jne    801072b0 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
801072c0:	83 ec 0c             	sub    $0xc,%esp
801072c3:	57                   	push   %edi
801072c4:	e8 07 b8 ff ff       	call   80102ad0 <fileclose>
801072c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	56                   	push   %esi
801072d0:	e8 1b c3 ff ff       	call   801035f0 <iunlockput>
    end_op();
801072d5:	e8 96 d6 ff ff       	call   80104970 <end_op>
    return -1;
801072da:	83 c4 10             	add    $0x10,%esp
    return -1;
801072dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801072e2:	eb 65                	jmp    80107349 <sys_open+0x119>
801072e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801072e8:	83 ec 0c             	sub    $0xc,%esp
801072eb:	31 c9                	xor    %ecx,%ecx
801072ed:	ba 02 00 00 00       	mov    $0x2,%edx
801072f2:	6a 00                	push   $0x0
801072f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072f7:	e8 54 f8 ff ff       	call   80106b50 <create>
    if (ip == 0)
801072fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801072ff:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80107301:	85 c0                	test   %eax,%eax
80107303:	75 99                	jne    8010729e <sys_open+0x6e>
      end_op();
80107305:	e8 66 d6 ff ff       	call   80104970 <end_op>
      return -1;
8010730a:	eb d1                	jmp    801072dd <sys_open+0xad>
8010730c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80107310:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80107313:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80107317:	56                   	push   %esi
80107318:	e8 23 c1 ff ff       	call   80103440 <iunlock>
  end_op();
8010731d:	e8 4e d6 ff ff       	call   80104970 <end_op>

  f->type = FD_INODE;
80107322:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80107328:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010732b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010732e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80107331:	89 d0                	mov    %edx,%eax
  f->off = 0;
80107333:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010733a:	f7 d0                	not    %eax
8010733c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010733f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80107342:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107345:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80107349:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734c:	89 d8                	mov    %ebx,%eax
8010734e:	5b                   	pop    %ebx
8010734f:	5e                   	pop    %esi
80107350:	5f                   	pop    %edi
80107351:	5d                   	pop    %ebp
80107352:	c3                   	ret    
80107353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107357:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80107358:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010735b:	85 c9                	test   %ecx,%ecx
8010735d:	0f 84 3b ff ff ff    	je     8010729e <sys_open+0x6e>
80107363:	e9 64 ff ff ff       	jmp    801072cc <sys_open+0x9c>
80107368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop

80107370 <sys_mkdir>:

int sys_mkdir(void)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107376:	e8 85 d5 ff ff       	call   80104900 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
8010737b:	83 ec 08             	sub    $0x8,%esp
8010737e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107381:	50                   	push   %eax
80107382:	6a 00                	push   $0x0
80107384:	e8 d7 f6 ff ff       	call   80106a60 <argstr>
80107389:	83 c4 10             	add    $0x10,%esp
8010738c:	85 c0                	test   %eax,%eax
8010738e:	78 30                	js     801073c0 <sys_mkdir+0x50>
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107396:	31 c9                	xor    %ecx,%ecx
80107398:	ba 01 00 00 00       	mov    $0x1,%edx
8010739d:	6a 00                	push   $0x0
8010739f:	e8 ac f7 ff ff       	call   80106b50 <create>
801073a4:	83 c4 10             	add    $0x10,%esp
801073a7:	85 c0                	test   %eax,%eax
801073a9:	74 15                	je     801073c0 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
801073ab:	83 ec 0c             	sub    $0xc,%esp
801073ae:	50                   	push   %eax
801073af:	e8 3c c2 ff ff       	call   801035f0 <iunlockput>
  end_op();
801073b4:	e8 b7 d5 ff ff       	call   80104970 <end_op>
  return 0;
801073b9:	83 c4 10             	add    $0x10,%esp
801073bc:	31 c0                	xor    %eax,%eax
}
801073be:	c9                   	leave  
801073bf:	c3                   	ret    
    end_op();
801073c0:	e8 ab d5 ff ff       	call   80104970 <end_op>
    return -1;
801073c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073ca:	c9                   	leave  
801073cb:	c3                   	ret    
801073cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073d0 <sys_mknod>:

int sys_mknod(void)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801073d6:	e8 25 d5 ff ff       	call   80104900 <begin_op>
  if ((argstr(0, &path)) < 0 ||
801073db:	83 ec 08             	sub    $0x8,%esp
801073de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801073e1:	50                   	push   %eax
801073e2:	6a 00                	push   $0x0
801073e4:	e8 77 f6 ff ff       	call   80106a60 <argstr>
801073e9:	83 c4 10             	add    $0x10,%esp
801073ec:	85 c0                	test   %eax,%eax
801073ee:	78 60                	js     80107450 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
801073f0:	83 ec 08             	sub    $0x8,%esp
801073f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073f6:	50                   	push   %eax
801073f7:	6a 01                	push   $0x1
801073f9:	e8 a2 f5 ff ff       	call   801069a0 <argint>
  if ((argstr(0, &path)) < 0 ||
801073fe:	83 c4 10             	add    $0x10,%esp
80107401:	85 c0                	test   %eax,%eax
80107403:	78 4b                	js     80107450 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80107405:	83 ec 08             	sub    $0x8,%esp
80107408:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010740b:	50                   	push   %eax
8010740c:	6a 02                	push   $0x2
8010740e:	e8 8d f5 ff ff       	call   801069a0 <argint>
      argint(1, &major) < 0 ||
80107413:	83 c4 10             	add    $0x10,%esp
80107416:	85 c0                	test   %eax,%eax
80107418:	78 36                	js     80107450 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
8010741a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010741e:	83 ec 0c             	sub    $0xc,%esp
80107421:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107425:	ba 03 00 00 00       	mov    $0x3,%edx
8010742a:	50                   	push   %eax
8010742b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010742e:	e8 1d f7 ff ff       	call   80106b50 <create>
      argint(2, &minor) < 0 ||
80107433:	83 c4 10             	add    $0x10,%esp
80107436:	85 c0                	test   %eax,%eax
80107438:	74 16                	je     80107450 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
8010743a:	83 ec 0c             	sub    $0xc,%esp
8010743d:	50                   	push   %eax
8010743e:	e8 ad c1 ff ff       	call   801035f0 <iunlockput>
  end_op();
80107443:	e8 28 d5 ff ff       	call   80104970 <end_op>
  return 0;
80107448:	83 c4 10             	add    $0x10,%esp
8010744b:	31 c0                	xor    %eax,%eax
}
8010744d:	c9                   	leave  
8010744e:	c3                   	ret    
8010744f:	90                   	nop
    end_op();
80107450:	e8 1b d5 ff ff       	call   80104970 <end_op>
    return -1;
80107455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010745a:	c9                   	leave  
8010745b:	c3                   	ret    
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107460 <sys_chdir>:

int sys_chdir(void)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	56                   	push   %esi
80107464:	53                   	push   %ebx
80107465:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80107468:	e8 f3 e0 ff ff       	call   80105560 <myproc>
8010746d:	89 c6                	mov    %eax,%esi

  begin_op();
8010746f:	e8 8c d4 ff ff       	call   80104900 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80107474:	83 ec 08             	sub    $0x8,%esp
80107477:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010747a:	50                   	push   %eax
8010747b:	6a 00                	push   $0x0
8010747d:	e8 de f5 ff ff       	call   80106a60 <argstr>
80107482:	83 c4 10             	add    $0x10,%esp
80107485:	85 c0                	test   %eax,%eax
80107487:	78 77                	js     80107500 <sys_chdir+0xa0>
80107489:	83 ec 0c             	sub    $0xc,%esp
8010748c:	ff 75 f4             	pushl  -0xc(%ebp)
8010748f:	e8 ac c7 ff ff       	call   80103c40 <namei>
80107494:	83 c4 10             	add    $0x10,%esp
80107497:	89 c3                	mov    %eax,%ebx
80107499:	85 c0                	test   %eax,%eax
8010749b:	74 63                	je     80107500 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
8010749d:	83 ec 0c             	sub    $0xc,%esp
801074a0:	50                   	push   %eax
801074a1:	e8 ba be ff ff       	call   80103360 <ilock>
  if (ip->type != T_DIR)
801074a6:	83 c4 10             	add    $0x10,%esp
801074a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801074ae:	75 30                	jne    801074e0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	53                   	push   %ebx
801074b4:	e8 87 bf ff ff       	call   80103440 <iunlock>
  iput(curproc->cwd);
801074b9:	58                   	pop    %eax
801074ba:	ff 76 68             	pushl  0x68(%esi)
801074bd:	e8 ce bf ff ff       	call   80103490 <iput>
  end_op();
801074c2:	e8 a9 d4 ff ff       	call   80104970 <end_op>
  curproc->cwd = ip;
801074c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801074ca:	83 c4 10             	add    $0x10,%esp
801074cd:	31 c0                	xor    %eax,%eax
}
801074cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074d2:	5b                   	pop    %ebx
801074d3:	5e                   	pop    %esi
801074d4:	5d                   	pop    %ebp
801074d5:	c3                   	ret    
801074d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801074e0:	83 ec 0c             	sub    $0xc,%esp
801074e3:	53                   	push   %ebx
801074e4:	e8 07 c1 ff ff       	call   801035f0 <iunlockput>
    end_op();
801074e9:	e8 82 d4 ff ff       	call   80104970 <end_op>
    return -1;
801074ee:	83 c4 10             	add    $0x10,%esp
    return -1;
801074f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074f6:	eb d7                	jmp    801074cf <sys_chdir+0x6f>
801074f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ff:	90                   	nop
    end_op();
80107500:	e8 6b d4 ff ff       	call   80104970 <end_op>
    return -1;
80107505:	eb ea                	jmp    801074f1 <sys_chdir+0x91>
80107507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750e:	66 90                	xchg   %ax,%ax

80107510 <sys_exec>:

int sys_exec(void)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80107515:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010751b:	53                   	push   %ebx
8010751c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80107522:	50                   	push   %eax
80107523:	6a 00                	push   $0x0
80107525:	e8 36 f5 ff ff       	call   80106a60 <argstr>
8010752a:	83 c4 10             	add    $0x10,%esp
8010752d:	85 c0                	test   %eax,%eax
8010752f:	0f 88 87 00 00 00    	js     801075bc <sys_exec+0xac>
80107535:	83 ec 08             	sub    $0x8,%esp
80107538:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010753e:	50                   	push   %eax
8010753f:	6a 01                	push   $0x1
80107541:	e8 5a f4 ff ff       	call   801069a0 <argint>
80107546:	83 c4 10             	add    $0x10,%esp
80107549:	85 c0                	test   %eax,%eax
8010754b:	78 6f                	js     801075bc <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010754d:	83 ec 04             	sub    $0x4,%esp
80107550:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80107556:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80107558:	68 80 00 00 00       	push   $0x80
8010755d:	6a 00                	push   $0x0
8010755f:	56                   	push   %esi
80107560:	e8 8b f1 ff ff       	call   801066f0 <memset>
80107565:	83 c4 10             	add    $0x10,%esp
80107568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756f:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80107570:	83 ec 08             	sub    $0x8,%esp
80107573:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107579:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80107580:	50                   	push   %eax
80107581:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80107587:	01 f8                	add    %edi,%eax
80107589:	50                   	push   %eax
8010758a:	e8 81 f3 ff ff       	call   80106910 <fetchint>
8010758f:	83 c4 10             	add    $0x10,%esp
80107592:	85 c0                	test   %eax,%eax
80107594:	78 26                	js     801075bc <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80107596:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010759c:	85 c0                	test   %eax,%eax
8010759e:	74 30                	je     801075d0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
801075a0:	83 ec 08             	sub    $0x8,%esp
801075a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801075a6:	52                   	push   %edx
801075a7:	50                   	push   %eax
801075a8:	e8 a3 f3 ff ff       	call   80106950 <fetchstr>
801075ad:	83 c4 10             	add    $0x10,%esp
801075b0:	85 c0                	test   %eax,%eax
801075b2:	78 08                	js     801075bc <sys_exec+0xac>
  for (i = 0;; i++)
801075b4:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
801075b7:	83 fb 20             	cmp    $0x20,%ebx
801075ba:	75 b4                	jne    80107570 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801075bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801075bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075c4:	5b                   	pop    %ebx
801075c5:	5e                   	pop    %esi
801075c6:	5f                   	pop    %edi
801075c7:	5d                   	pop    %ebp
801075c8:	c3                   	ret    
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801075d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801075d7:	00 00 00 00 
  return exec(path, argv);
801075db:	83 ec 08             	sub    $0x8,%esp
801075de:	56                   	push   %esi
801075df:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801075e5:	e8 86 b0 ff ff       	call   80102670 <exec>
801075ea:	83 c4 10             	add    $0x10,%esp
}
801075ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f0:	5b                   	pop    %ebx
801075f1:	5e                   	pop    %esi
801075f2:	5f                   	pop    %edi
801075f3:	5d                   	pop    %ebp
801075f4:	c3                   	ret    
801075f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107600 <sys_pipe>:

int sys_pipe(void)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80107605:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80107608:	53                   	push   %ebx
80107609:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
8010760c:	6a 08                	push   $0x8
8010760e:	50                   	push   %eax
8010760f:	6a 00                	push   $0x0
80107611:	e8 da f3 ff ff       	call   801069f0 <argptr>
80107616:	83 c4 10             	add    $0x10,%esp
80107619:	85 c0                	test   %eax,%eax
8010761b:	0f 88 8b 00 00 00    	js     801076ac <sys_pipe+0xac>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80107621:	83 ec 08             	sub    $0x8,%esp
80107624:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107627:	50                   	push   %eax
80107628:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010762b:	50                   	push   %eax
8010762c:	e8 bf d9 ff ff       	call   80104ff0 <pipealloc>
80107631:	83 c4 10             	add    $0x10,%esp
80107634:	85 c0                	test   %eax,%eax
80107636:	78 74                	js     801076ac <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80107638:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
8010763b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010763d:	e8 1e df ff ff       	call   80105560 <myproc>
    if (curproc->ofile[fd] == 0)
80107642:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107646:	85 f6                	test   %esi,%esi
80107648:	74 16                	je     80107660 <sys_pipe+0x60>
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (fd = 0; fd < NOFILE; fd++)
80107650:	83 c3 01             	add    $0x1,%ebx
80107653:	83 fb 10             	cmp    $0x10,%ebx
80107656:	74 3d                	je     80107695 <sys_pipe+0x95>
    if (curproc->ofile[fd] == 0)
80107658:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010765c:	85 f6                	test   %esi,%esi
8010765e:	75 f0                	jne    80107650 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80107660:	8d 73 08             	lea    0x8(%ebx),%esi
80107663:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80107667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010766a:	e8 f1 de ff ff       	call   80105560 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010766f:	31 d2                	xor    %edx,%edx
80107671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80107678:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010767c:	85 c9                	test   %ecx,%ecx
8010767e:	74 38                	je     801076b8 <sys_pipe+0xb8>
  for (fd = 0; fd < NOFILE; fd++)
80107680:	83 c2 01             	add    $0x1,%edx
80107683:	83 fa 10             	cmp    $0x10,%edx
80107686:	75 f0                	jne    80107678 <sys_pipe+0x78>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80107688:	e8 d3 de ff ff       	call   80105560 <myproc>
8010768d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107694:	00 
    fileclose(rf);
80107695:	83 ec 0c             	sub    $0xc,%esp
80107698:	ff 75 e0             	pushl  -0x20(%ebp)
8010769b:	e8 30 b4 ff ff       	call   80102ad0 <fileclose>
    fileclose(wf);
801076a0:	58                   	pop    %eax
801076a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801076a4:	e8 27 b4 ff ff       	call   80102ad0 <fileclose>
    return -1;
801076a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801076ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076b1:	eb 16                	jmp    801076c9 <sys_pipe+0xc9>
801076b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076b7:	90                   	nop
      curproc->ofile[fd] = f;
801076b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801076bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801076bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801076c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801076c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801076c7:	31 c0                	xor    %eax,%eax
}
801076c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076cc:	5b                   	pop    %ebx
801076cd:	5e                   	pop    %esi
801076ce:	5f                   	pop    %edi
801076cf:	5d                   	pop    %ebp
801076d0:	c3                   	ret    
801076d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop

801076e0 <sys_make_duplicate>:

///////////////rashid


int sys_make_duplicate(void)
{
801076e0:	55                   	push   %ebp
    char *src_name;
    char suffix[] = "_copy";
801076e1:	b8 79 00 00 00       	mov    $0x79,%eax
{
801076e6:	89 e5                	mov    %esp,%ebp
801076e8:	57                   	push   %edi
801076e9:	56                   	push   %esi
801076ea:	53                   	push   %ebx
801076eb:	81 ec b4 02 00 00    	sub    $0x2b4,%esp
    char suffix[] = "_copy";
801076f1:	66 89 85 66 fd ff ff 	mov    %ax,-0x29a(%ebp)
    struct inode *ip_src;
    struct inode *ip_dest;
    char new_name[128];
    int n;
    char buf[512];
    if (argstr(0, &src_name) < 0)
801076f8:	8d 85 5c fd ff ff    	lea    -0x2a4(%ebp),%eax
    char suffix[] = "_copy";
801076fe:	c7 85 62 fd ff ff 5f 	movl   $0x706f635f,-0x29e(%ebp)
80107705:	63 6f 70 
    if (argstr(0, &src_name) < 0)
80107708:	50                   	push   %eax
80107709:	6a 00                	push   $0x0
8010770b:	e8 50 f3 ff ff       	call   80106a60 <argstr>
80107710:	83 c4 10             	add    $0x10,%esp
80107713:	85 c0                	test   %eax,%eax
80107715:	0f 88 4a 01 00 00    	js     80107865 <sys_make_duplicate+0x185>
        return -1;

    int i = 0, j = 0;
    while (src_name[i] != '\0')
8010771b:	8b 8d 5c fd ff ff    	mov    -0x2a4(%ebp),%ecx
    int i = 0, j = 0;
80107721:	31 c0                	xor    %eax,%eax
80107723:	8d 9d 68 fd ff ff    	lea    -0x298(%ebp),%ebx
    while (src_name[i] != '\0')
80107729:	0f b6 11             	movzbl (%ecx),%edx
8010772c:	84 d2                	test   %dl,%dl
8010772e:	74 0e                	je     8010773e <sys_make_duplicate+0x5e>
    {     
        new_name[i] = src_name[i];
80107730:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        i++;
80107733:	83 c0 01             	add    $0x1,%eax
    while (src_name[i] != '\0')
80107736:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
8010773a:	84 d2                	test   %dl,%dl
8010773c:	75 f2                	jne    80107730 <sys_make_duplicate+0x50>
    }
    while (suffix[j] != '\0')
8010773e:	8d 8d 62 fd ff ff    	lea    -0x29e(%ebp),%ecx
80107744:	ba 5f 00 00 00       	mov    $0x5f,%edx
80107749:	29 c1                	sub    %eax,%ecx
8010774b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010774f:	90                   	nop
    {
        new_name[i] = suffix[j];
80107750:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        i++;j++;
80107753:	83 c0 01             	add    $0x1,%eax
    while (suffix[j] != '\0')
80107756:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
8010775a:	84 d2                	test   %dl,%dl
8010775c:	75 f2                	jne    80107750 <sys_make_duplicate+0x70>
    }
    new_name[i] = '\0';
8010775e:	c6 84 05 68 fd ff ff 	movb   $0x0,-0x298(%ebp,%eax,1)
80107765:	00 
    begin_op();
80107766:	e8 95 d1 ff ff       	call   80104900 <begin_op>
    ip_src = namei(src_name);
8010776b:	83 ec 0c             	sub    $0xc,%esp
8010776e:	ff b5 5c fd ff ff    	pushl  -0x2a4(%ebp)
80107774:	e8 c7 c4 ff ff       	call   80103c40 <namei>
    if (!ip_src)
80107779:	83 c4 10             	add    $0x10,%esp
    ip_src = namei(src_name);
8010777c:	89 c6                	mov    %eax,%esi
    if (!ip_src)
8010777e:	85 c0                	test   %eax,%eax
80107780:	0f 84 da 00 00 00    	je     80107860 <sys_make_duplicate+0x180>
    {
        end_op();
        return -1; 
    }
    ilock(ip_src);
80107786:	83 ec 0c             	sub    $0xc,%esp
80107789:	50                   	push   %eax
8010778a:	e8 d1 bb ff ff       	call   80103360 <ilock>

    ip_dest = create(new_name, T_FILE, 0, 0);
8010778f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107796:	31 c9                	xor    %ecx,%ecx
80107798:	89 d8                	mov    %ebx,%eax
8010779a:	ba 02 00 00 00       	mov    $0x2,%edx
8010779f:	e8 ac f3 ff ff       	call   80106b50 <create>
   
    if (!ip_dest)
801077a4:	83 c4 10             	add    $0x10,%esp
    ip_dest = create(new_name, T_FILE, 0, 0);
801077a7:	89 85 50 fd ff ff    	mov    %eax,-0x2b0(%ebp)
    if (!ip_dest)
801077ad:	85 c0                	test   %eax,%eax
801077af:	0f 84 bd 00 00 00    	je     80107872 <sys_make_duplicate+0x192>
        return 1; 
    }
   

    j = 0;
    while (j < ip_src->size)
801077b5:	8b 46 58             	mov    0x58(%esi),%eax
    j = 0;
801077b8:	31 db                	xor    %ebx,%ebx
    while (j < ip_src->size)
801077ba:	31 c9                	xor    %ecx,%ecx
801077bc:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
801077c2:	85 c0                	test   %eax,%eax
801077c4:	75 32                	jne    801077f8 <sys_make_duplicate+0x118>
801077c6:	eb 53                	jmp    8010781b <sys_make_duplicate+0x13b>
801077c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077cf:	90                   	nop
    { 
        n = readi(ip_src, buf,j, sizeof(buf));
        if (n <= 0){
            break;
        }
        writei(ip_dest, buf,j, n);
801077d0:	50                   	push   %eax
801077d1:	89 85 54 fd ff ff    	mov    %eax,-0x2ac(%ebp)
801077d7:	51                   	push   %ecx
801077d8:	57                   	push   %edi
801077d9:	ff b5 50 fd ff ff    	pushl  -0x2b0(%ebp)
801077df:	e8 8c bf ff ff       	call   80103770 <writei>
        j+= n;
801077e4:	8b 95 54 fd ff ff    	mov    -0x2ac(%ebp),%edx
    while (j < ip_src->size)
801077ea:	8b 46 58             	mov    0x58(%esi),%eax
801077ed:	83 c4 10             	add    $0x10,%esp
        j+= n;
801077f0:	01 d3                	add    %edx,%ebx
    while (j < ip_src->size)
801077f2:	89 d9                	mov    %ebx,%ecx
801077f4:	39 c3                	cmp    %eax,%ebx
801077f6:	73 23                	jae    8010781b <sys_make_duplicate+0x13b>
        n = readi(ip_src, buf,j, sizeof(buf));
801077f8:	68 00 02 00 00       	push   $0x200
801077fd:	51                   	push   %ecx
801077fe:	89 8d 54 fd ff ff    	mov    %ecx,-0x2ac(%ebp)
80107804:	57                   	push   %edi
80107805:	56                   	push   %esi
80107806:	e8 65 be ff ff       	call   80103670 <readi>
        if (n <= 0){
8010780b:	83 c4 10             	add    $0x10,%esp
8010780e:	8b 8d 54 fd ff ff    	mov    -0x2ac(%ebp),%ecx
80107814:	85 c0                	test   %eax,%eax
80107816:	7f b8                	jg     801077d0 <sys_make_duplicate+0xf0>
    }
    ip_dest->size = ip_src->size;
80107818:	8b 46 58             	mov    0x58(%esi),%eax
8010781b:	8b bd 50 fd ff ff    	mov    -0x2b0(%ebp),%edi
    iupdate(ip_dest);
80107821:	83 ec 0c             	sub    $0xc,%esp
    ip_dest->size = ip_src->size;
80107824:	89 47 58             	mov    %eax,0x58(%edi)
    iupdate(ip_dest);
80107827:	57                   	push   %edi
80107828:	e8 83 ba ff ff       	call   801032b0 <iupdate>
    iunlock(ip_src);
8010782d:	89 34 24             	mov    %esi,(%esp)
80107830:	e8 0b bc ff ff       	call   80103440 <iunlock>
    iunlock(ip_dest);
80107835:	89 3c 24             	mov    %edi,(%esp)
80107838:	e8 03 bc ff ff       	call   80103440 <iunlock>
    iput(ip_src);
8010783d:	89 34 24             	mov    %esi,(%esp)
80107840:	e8 4b bc ff ff       	call   80103490 <iput>
    iput(ip_dest);
80107845:	89 3c 24             	mov    %edi,(%esp)
80107848:	e8 43 bc ff ff       	call   80103490 <iput>

    end_op();
8010784d:	e8 1e d1 ff ff       	call   80104970 <end_op>

    return 0; 
80107852:	83 c4 10             	add    $0x10,%esp
80107855:	31 c0                	xor    %eax,%eax
}
80107857:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785a:	5b                   	pop    %ebx
8010785b:	5e                   	pop    %esi
8010785c:	5f                   	pop    %edi
8010785d:	5d                   	pop    %ebp
8010785e:	c3                   	ret    
8010785f:	90                   	nop
        end_op();
80107860:	e8 0b d1 ff ff       	call   80104970 <end_op>
}
80107865:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80107868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010786d:	5b                   	pop    %ebx
8010786e:	5e                   	pop    %esi
8010786f:	5f                   	pop    %edi
80107870:	5d                   	pop    %ebp
80107871:	c3                   	ret    
        iunlock(ip_src);
80107872:	83 ec 0c             	sub    $0xc,%esp
80107875:	56                   	push   %esi
80107876:	e8 c5 bb ff ff       	call   80103440 <iunlock>
        iput(ip_src);
8010787b:	89 34 24             	mov    %esi,(%esp)
8010787e:	e8 0d bc ff ff       	call   80103490 <iput>
        end_op();
80107883:	e8 e8 d0 ff ff       	call   80104970 <end_op>
        return 1; 
80107888:	83 c4 10             	add    $0x10,%esp
8010788b:	b8 01 00 00 00       	mov    $0x1,%eax
80107890:	eb c5                	jmp    80107857 <sys_make_duplicate+0x177>
80107892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078a0 <find_substr>:

//////////// sharifi

int find_substr(const char *str, int str_len, const char *substr, int substr_len)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	57                   	push   %edi
  if(substr_len <= 0 || str_len < substr_len) 
801078a4:	8b 45 14             	mov    0x14(%ebp),%eax
{
801078a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801078aa:	56                   	push   %esi
801078ab:	53                   	push   %ebx
801078ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(substr_len <= 0 || str_len < substr_len) 
801078af:	85 c0                	test   %eax,%eax
801078b1:	7e 3a                	jle    801078ed <find_substr+0x4d>
801078b3:	39 7d 14             	cmp    %edi,0x14(%ebp)
801078b6:	7f 35                	jg     801078ed <find_substr+0x4d>
801078b8:	8b 55 08             	mov    0x8(%ebp),%edx
    return -1;

  for(int i = 0; i + substr_len <= str_len; i++){
801078bb:	31 f6                	xor    %esi,%esi
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
    int j = 0;
801078c0:	31 c0                	xor    %eax,%eax
801078c2:	eb 0c                	jmp    801078d0 <find_substr+0x30>
801078c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(j < substr_len && str[i + j] == substr[j]) 
      j++;
801078c8:	83 c0 01             	add    $0x1,%eax
    while(j < substr_len && str[i + j] == substr[j]) 
801078cb:	39 45 14             	cmp    %eax,0x14(%ebp)
801078ce:	7e 09                	jle    801078d9 <find_substr+0x39>
801078d0:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801078d4:	38 0c 02             	cmp    %cl,(%edx,%eax,1)
801078d7:	74 ef                	je     801078c8 <find_substr+0x28>
    if(j == substr_len) 
801078d9:	3b 45 14             	cmp    0x14(%ebp),%eax
801078dc:	74 19                	je     801078f7 <find_substr+0x57>
  for(int i = 0; i + substr_len <= str_len; i++){
801078de:	8b 45 14             	mov    0x14(%ebp),%eax
801078e1:	83 c6 01             	add    $0x1,%esi
801078e4:	83 c2 01             	add    $0x1,%edx
801078e7:	01 f0                	add    %esi,%eax
801078e9:	39 c7                	cmp    %eax,%edi
801078eb:	7d d3                	jge    801078c0 <find_substr+0x20>
      return 1;
  }

  return -1;
}
801078ed:	5b                   	pop    %ebx
    return -1;
801078ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078f3:	5e                   	pop    %esi
801078f4:	5f                   	pop    %edi
801078f5:	5d                   	pop    %ebp
801078f6:	c3                   	ret    
801078f7:	5b                   	pop    %ebx
      return 1;
801078f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801078fd:	5e                   	pop    %esi
801078fe:	5f                   	pop    %edi
801078ff:	5d                   	pop    %ebp
80107900:	c3                   	ret    
80107901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790f:	90                   	nop

80107910 <sys_grep_syscall>:

int sys_grep_syscall(void)
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
  char *keyword = 0;
  char *filename = 0;  
  char *user_buffer = 0;             
  int buffer_size = 0;

  if(argstr(0, &keyword)  < 0) 
80107915:	8d 45 d8             	lea    -0x28(%ebp),%eax
{
80107918:	53                   	push   %ebx
80107919:	83 ec 64             	sub    $0x64,%esp
  char *keyword = 0;
8010791c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  char *filename = 0;  
80107923:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  char *user_buffer = 0;             
8010792a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  int buffer_size = 0;
80107931:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if(argstr(0, &keyword)  < 0) 
80107938:	50                   	push   %eax
80107939:	6a 00                	push   $0x0
8010793b:	e8 20 f1 ff ff       	call   80106a60 <argstr>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	0f 88 51 02 00 00    	js     80107b9c <sys_grep_syscall+0x28c>
    return -1;

  if(argstr(1, &filename) < 0) 
8010794b:	83 ec 08             	sub    $0x8,%esp
8010794e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80107951:	50                   	push   %eax
80107952:	6a 01                	push   $0x1
80107954:	e8 07 f1 ff ff       	call   80106a60 <argstr>
80107959:	83 c4 10             	add    $0x10,%esp
8010795c:	85 c0                	test   %eax,%eax
8010795e:	0f 88 38 02 00 00    	js     80107b9c <sys_grep_syscall+0x28c>
    return -1;

  if(argptr(2, &user_buffer, 0) < 0) 
80107964:	83 ec 04             	sub    $0x4,%esp
80107967:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010796a:	6a 00                	push   $0x0
8010796c:	50                   	push   %eax
8010796d:	6a 02                	push   $0x2
8010796f:	e8 7c f0 ff ff       	call   801069f0 <argptr>
80107974:	83 c4 10             	add    $0x10,%esp
80107977:	85 c0                	test   %eax,%eax
80107979:	0f 88 1d 02 00 00    	js     80107b9c <sys_grep_syscall+0x28c>
    return -1;  

  if(argint(3, &buffer_size) < 0) 
8010797f:	83 ec 08             	sub    $0x8,%esp
80107982:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107985:	50                   	push   %eax
80107986:	6a 03                	push   $0x3
80107988:	e8 13 f0 ff ff       	call   801069a0 <argint>
8010798d:	83 c4 10             	add    $0x10,%esp
80107990:	85 c0                	test   %eax,%eax
80107992:	0f 88 04 02 00 00    	js     80107b9c <sys_grep_syscall+0x28c>
    return -1;

  int klen = 0;
  while(keyword[klen] != 0){
80107998:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010799b:	80 38 00             	cmpb   $0x0,(%eax)
8010799e:	0f 84 f8 01 00 00    	je     80107b9c <sys_grep_syscall+0x28c>
  int klen = 0;
801079a4:	31 d2                	xor    %edx,%edx
    klen++;
801079a6:	89 d7                	mov    %edx,%edi
801079a8:	83 c2 01             	add    $0x1,%edx
  while(keyword[klen] != 0){
801079ab:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
801079af:	75 f5                	jne    801079a6 <sys_grep_syscall+0x96>
    return -1;

  int return_value = -1;
  struct inode *ip = 0;

  begin_op();
801079b1:	89 55 c0             	mov    %edx,-0x40(%ebp)
801079b4:	e8 47 cf ff ff       	call   80104900 <begin_op>
  ip = namei(filename);
801079b9:	83 ec 0c             	sub    $0xc,%esp
801079bc:	ff 75 dc             	pushl  -0x24(%ebp)
801079bf:	e8 7c c2 ff ff       	call   80103c40 <namei>
  if(ip == 0){
801079c4:	83 c4 10             	add    $0x10,%esp
  ip = namei(filename);
801079c7:	89 45 b0             	mov    %eax,-0x50(%ebp)
  if(ip == 0){
801079ca:	85 c0                	test   %eax,%eax
801079cc:	0f 84 d4 01 00 00    	je     80107ba6 <sys_grep_syscall+0x296>
    end_op();
    return -1;
  }

  ilock(ip);
801079d2:	83 ec 0c             	sub    $0xc,%esp
801079d5:	ff 75 b0             	pushl  -0x50(%ebp)
801079d8:	e8 83 b9 ff ff       	call   80103360 <ilock>

  int chunk = BSIZE;                
  char *kernel_buf  = (char*)kalloc();     
801079dd:	e8 3e c8 ff ff       	call   80104220 <kalloc>
801079e2:	89 c3                	mov    %eax,%ebx
  char *kernel_line = (char*)kalloc();    
801079e4:	e8 37 c8 ff ff       	call   80104220 <kalloc>
  if(kernel_buf == 0 || kernel_line == 0){
801079e9:	83 c4 10             	add    $0x10,%esp
  char *kernel_line = (char*)kalloc();    
801079ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(kernel_buf == 0 || kernel_line == 0){
801079ef:	85 db                	test   %ebx,%ebx
801079f1:	0f 84 7f 01 00 00    	je     80107b76 <sys_grep_syscall+0x266>
801079f7:	85 c0                	test   %eax,%eax
801079f9:	0f 84 67 01 00 00    	je     80107b66 <sys_grep_syscall+0x256>
    iunlockput(ip);
    end_op();
    return -1;
  }

  int line_len = 0;   
801079ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  int curr_pos = 0;        
80107a06:	31 f6                	xor    %esi,%esi
  int read_len;

  while((read_len = readi(ip, kernel_buf, curr_pos, chunk)) > 0){
80107a08:	68 00 02 00 00       	push   $0x200
80107a0d:	56                   	push   %esi
80107a0e:	53                   	push   %ebx
80107a0f:	ff 75 b0             	pushl  -0x50(%ebp)
80107a12:	e8 59 bc ff ff       	call   80103670 <readi>
80107a17:	83 c4 10             	add    $0x10,%esp
80107a1a:	89 c1                	mov    %eax,%ecx
80107a1c:	85 c0                	test   %eax,%eax
80107a1e:	0f 8e fb 00 00 00    	jle    80107b1f <sys_grep_syscall+0x20f>
80107a24:	89 75 a8             	mov    %esi,-0x58(%ebp)
80107a27:	89 da                	mov    %ebx,%edx
80107a29:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
80107a2c:	89 5d ac             	mov    %ebx,-0x54(%ebp)
80107a2f:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
80107a32:	eb 1a                	jmp    80107a4e <sys_grep_syscall+0x13e>
80107a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int i = 0;
    while(i < read_len){
      char c = kernel_buf[i++];

      if(c != '\n'){
        kernel_line[line_len++] = c;
80107a38:	8b 75 c4             	mov    -0x3c(%ebp),%esi
80107a3b:	8b 5d bc             	mov    -0x44(%ebp),%ebx
    while(i < read_len){
80107a3e:	83 c2 01             	add    $0x1,%edx
        kernel_line[line_len++] = c;
80107a41:	88 0c 33             	mov    %cl,(%ebx,%esi,1)
80107a44:	83 c6 01             	add    $0x1,%esi
80107a47:	89 75 c4             	mov    %esi,-0x3c(%ebp)
    while(i < read_len){
80107a4a:	39 c2                	cmp    %eax,%edx
80107a4c:	74 65                	je     80107ab3 <sys_grep_syscall+0x1a3>
      char c = kernel_buf[i++];
80107a4e:	0f b6 0a             	movzbl (%edx),%ecx
      if(c != '\n'){
80107a51:	80 f9 0a             	cmp    $0xa,%cl
80107a54:	75 e2                	jne    80107a38 <sys_grep_syscall+0x128>
        continue;
      }

      if(find_substr(kernel_line, line_len, keyword, klen) == 1){
80107a56:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  if(substr_len <= 0 || str_len < substr_len) 
80107a59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
80107a5c:	39 4d c0             	cmp    %ecx,-0x40(%ebp)
80107a5f:	7f 44                	jg     80107aa5 <sys_grep_syscall+0x195>
80107a61:	89 55 b8             	mov    %edx,-0x48(%ebp)
80107a64:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  for(int i = 0; i + substr_len <= str_len; i++){
80107a67:	31 f6                	xor    %esi,%esi
80107a69:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int j = 0;
80107a70:	31 c0                	xor    %eax,%eax
80107a72:	eb 0d                	jmp    80107a81 <sys_grep_syscall+0x171>
80107a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      j++;
80107a78:	8d 50 01             	lea    0x1(%eax),%edx
    while(j < substr_len && str[i + j] == substr[j]) 
80107a7b:	39 f8                	cmp    %edi,%eax
80107a7d:	89 d0                	mov    %edx,%eax
80107a7f:	74 09                	je     80107a8a <sys_grep_syscall+0x17a>
80107a81:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80107a85:	38 14 01             	cmp    %dl,(%ecx,%eax,1)
80107a88:	74 ee                	je     80107a78 <sys_grep_syscall+0x168>
    if(j == substr_len) 
80107a8a:	8b 55 c0             	mov    -0x40(%ebp),%edx
80107a8d:	39 d0                	cmp    %edx,%eax
80107a8f:	74 32                	je     80107ac3 <sys_grep_syscall+0x1b3>
  for(int i = 0; i + substr_len <= str_len; i++){
80107a91:	83 c6 01             	add    $0x1,%esi
80107a94:	83 c1 01             	add    $0x1,%ecx
80107a97:	8d 04 16             	lea    (%esi,%edx,1),%eax
80107a9a:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
80107a9d:	7d d1                	jge    80107a70 <sys_grep_syscall+0x160>
          return_value = copy_len;
        }
        goto done;
      }

      line_len = 0;
80107a9f:	8b 55 b8             	mov    -0x48(%ebp),%edx
80107aa2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    while(i < read_len){
80107aa5:	83 c2 01             	add    $0x1,%edx
      line_len = 0;
80107aa8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    while(i < read_len){
80107aaf:	39 c2                	cmp    %eax,%edx
80107ab1:	75 9b                	jne    80107a4e <sys_grep_syscall+0x13e>
    }
    curr_pos += read_len;
80107ab3:	8b 75 a8             	mov    -0x58(%ebp),%esi
80107ab6:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
80107ab9:	8b 5d ac             	mov    -0x54(%ebp),%ebx
80107abc:	01 ce                	add    %ecx,%esi
80107abe:	e9 45 ff ff ff       	jmp    80107a08 <sys_grep_syscall+0xf8>
        if(copy_len > buffer_size) 
80107ac3:	8b 5d ac             	mov    -0x54(%ebp),%ebx
80107ac6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80107ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
        if(copyout(myproc()->pgdir, (uint)user_buffer, kernel_line, copy_len) < 0){
80107acc:	8b 7d e0             	mov    -0x20(%ebp),%edi
        if(copy_len > buffer_size) 
80107acf:	39 f0                	cmp    %esi,%eax
80107ad1:	0f 4e f0             	cmovle %eax,%esi
        if(copyout(myproc()->pgdir, (uint)user_buffer, kernel_line, copy_len) < 0){
80107ad4:	e8 87 da ff ff       	call   80105560 <myproc>
80107ad9:	56                   	push   %esi
80107ada:	ff 75 bc             	pushl  -0x44(%ebp)
80107add:	57                   	push   %edi
80107ade:	ff 70 04             	pushl  0x4(%eax)
80107ae1:	e8 ea 1b 00 00       	call   801096d0 <copyout>
80107ae6:	83 c4 10             	add    $0x10,%esp
80107ae9:	85 c0                	test   %eax,%eax
80107aeb:	78 50                	js     80107b3d <sys_grep_syscall+0x22d>
        copy_len = buffer_size;

      if (copyout(myproc()->pgdir, (uint)user_buffer, kernel_line, copy_len) < 0) {
        return_value = -1;
      } else {
        if (copy_len < buffer_size) {
80107aed:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80107af0:	7f 52                	jg     80107b44 <sys_grep_syscall+0x234>
  }

  return_value = -1;

  done:
    kfree(kernel_buf);
80107af2:	83 ec 0c             	sub    $0xc,%esp
80107af5:	53                   	push   %ebx
80107af6:	e8 65 c5 ff ff       	call   80104060 <kfree>
    kfree(kernel_line);
80107afb:	58                   	pop    %eax
80107afc:	ff 75 bc             	pushl  -0x44(%ebp)
80107aff:	e8 5c c5 ff ff       	call   80104060 <kfree>
    iunlockput(ip);
80107b04:	5a                   	pop    %edx
80107b05:	ff 75 b0             	pushl  -0x50(%ebp)
80107b08:	e8 e3 ba ff ff       	call   801035f0 <iunlockput>
    end_op();
80107b0d:	e8 5e ce ff ff       	call   80104970 <end_op>
    return return_value;
80107b12:	83 c4 10             	add    $0x10,%esp
80107b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b18:	89 f0                	mov    %esi,%eax
80107b1a:	5b                   	pop    %ebx
80107b1b:	5e                   	pop    %esi
80107b1c:	5f                   	pop    %edi
80107b1d:	5d                   	pop    %ebp
80107b1e:	c3                   	ret    
  if (line_len > 0) {
80107b1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80107b22:	85 c0                	test   %eax,%eax
80107b24:	7e 17                	jle    80107b3d <sys_grep_syscall+0x22d>
    if (find_substr(kernel_line, line_len, keyword, klen) == 1) {
80107b26:	ff 75 c0             	pushl  -0x40(%ebp)
80107b29:	ff 75 d8             	pushl  -0x28(%ebp)
80107b2c:	50                   	push   %eax
80107b2d:	ff 75 bc             	pushl  -0x44(%ebp)
80107b30:	e8 6b fd ff ff       	call   801078a0 <find_substr>
80107b35:	83 c4 10             	add    $0x10,%esp
80107b38:	83 f8 01             	cmp    $0x1,%eax
80107b3b:	74 89                	je     80107ac6 <sys_grep_syscall+0x1b6>
          return_value = -1;
80107b3d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80107b42:	eb ae                	jmp    80107af2 <sys_grep_syscall+0x1e2>
          copyout(myproc()->pgdir, (uint)user_buffer + copy_len, &nul, 1);
80107b44:	8b 7d e0             	mov    -0x20(%ebp),%edi
          char nul = 0;
80107b47:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
          copyout(myproc()->pgdir, (uint)user_buffer + copy_len, &nul, 1);
80107b4b:	e8 10 da ff ff       	call   80105560 <myproc>
80107b50:	8d 55 d7             	lea    -0x29(%ebp),%edx
80107b53:	6a 01                	push   $0x1
80107b55:	01 f7                	add    %esi,%edi
80107b57:	52                   	push   %edx
80107b58:	57                   	push   %edi
80107b59:	ff 70 04             	pushl  0x4(%eax)
80107b5c:	e8 6f 1b 00 00       	call   801096d0 <copyout>
80107b61:	83 c4 10             	add    $0x10,%esp
80107b64:	eb 8c                	jmp    80107af2 <sys_grep_syscall+0x1e2>
    if(kernel_buf)  
80107b66:	85 db                	test   %ebx,%ebx
80107b68:	74 0c                	je     80107b76 <sys_grep_syscall+0x266>
      kfree(kernel_buf);
80107b6a:	83 ec 0c             	sub    $0xc,%esp
80107b6d:	53                   	push   %ebx
80107b6e:	e8 ed c4 ff ff       	call   80104060 <kfree>
80107b73:	83 c4 10             	add    $0x10,%esp
    if(kernel_line) 
80107b76:	8b 45 bc             	mov    -0x44(%ebp),%eax
80107b79:	85 c0                	test   %eax,%eax
80107b7b:	74 0c                	je     80107b89 <sys_grep_syscall+0x279>
      kfree(kernel_line);
80107b7d:	83 ec 0c             	sub    $0xc,%esp
80107b80:	50                   	push   %eax
80107b81:	e8 da c4 ff ff       	call   80104060 <kfree>
80107b86:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107b89:	83 ec 0c             	sub    $0xc,%esp
80107b8c:	ff 75 b0             	pushl  -0x50(%ebp)
80107b8f:	e8 5c ba ff ff       	call   801035f0 <iunlockput>
    end_op();
80107b94:	e8 d7 cd ff ff       	call   80104970 <end_op>
    return -1;
80107b99:	83 c4 10             	add    $0x10,%esp
    return -1;
80107b9c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80107ba1:	e9 6f ff ff ff       	jmp    80107b15 <sys_grep_syscall+0x205>
    end_op();
80107ba6:	e8 c5 cd ff ff       	call   80104970 <end_op>
    return -1;
80107bab:	eb ef                	jmp    80107b9c <sys_grep_syscall+0x28c>
80107bad:	66 90                	xchg   %ax,%ax
80107baf:	90                   	nop

80107bb0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80107bb0:	e9 5b db ff ff       	jmp    80105710 <fork>
80107bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107bc0 <sys_exit>:
}

int
sys_exit(void)
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	83 ec 08             	sub    $0x8,%esp
  exit();
80107bc6:	e8 d5 df ff ff       	call   80105ba0 <exit>
  return 0;  // not reached
}
80107bcb:	31 c0                	xor    %eax,%eax
80107bcd:	c9                   	leave  
80107bce:	c3                   	ret    
80107bcf:	90                   	nop

80107bd0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80107bd0:	e9 fb e0 ff ff       	jmp    80105cd0 <wait>
80107bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107be0 <sys_kill>:
}

int
sys_kill(void)
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107be9:	50                   	push   %eax
80107bea:	6a 00                	push   $0x0
80107bec:	e8 af ed ff ff       	call   801069a0 <argint>
80107bf1:	83 c4 10             	add    $0x10,%esp
80107bf4:	85 c0                	test   %eax,%eax
80107bf6:	78 18                	js     80107c10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80107bf8:	83 ec 0c             	sub    $0xc,%esp
80107bfb:	ff 75 f4             	pushl  -0xc(%ebp)
80107bfe:	e8 6d e3 ff ff       	call   80105f70 <kill>
80107c03:	83 c4 10             	add    $0x10,%esp
}
80107c06:	c9                   	leave  
80107c07:	c3                   	ret    
80107c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c0f:	90                   	nop
80107c10:	c9                   	leave  
    return -1;
80107c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c16:	c3                   	ret    
80107c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1e:	66 90                	xchg   %ax,%ax

80107c20 <sys_getpid>:

int
sys_getpid(void)
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107c26:	e8 35 d9 ff ff       	call   80105560 <myproc>
80107c2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80107c2e:	c9                   	leave  
80107c2f:	c3                   	ret    

80107c30 <sys_sbrk>:

int
sys_sbrk(void)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107c34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107c37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80107c3a:	50                   	push   %eax
80107c3b:	6a 00                	push   $0x0
80107c3d:	e8 5e ed ff ff       	call   801069a0 <argint>
80107c42:	83 c4 10             	add    $0x10,%esp
80107c45:	85 c0                	test   %eax,%eax
80107c47:	78 27                	js     80107c70 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107c49:	e8 12 d9 ff ff       	call   80105560 <myproc>
  if(growproc(n) < 0)
80107c4e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107c51:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80107c53:	ff 75 f4             	pushl  -0xc(%ebp)
80107c56:	e8 35 da ff ff       	call   80105690 <growproc>
80107c5b:	83 c4 10             	add    $0x10,%esp
80107c5e:	85 c0                	test   %eax,%eax
80107c60:	78 0e                	js     80107c70 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107c62:	89 d8                	mov    %ebx,%eax
80107c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107c67:	c9                   	leave  
80107c68:	c3                   	ret    
80107c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107c70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107c75:	eb eb                	jmp    80107c62 <sys_sbrk+0x32>
80107c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c7e:	66 90                	xchg   %ax,%ax

80107c80 <sys_sleep>:

int
sys_sleep(void)
{
80107c80:	55                   	push   %ebp
80107c81:	89 e5                	mov    %esp,%ebp
80107c83:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80107c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107c87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80107c8a:	50                   	push   %eax
80107c8b:	6a 00                	push   $0x0
80107c8d:	e8 0e ed ff ff       	call   801069a0 <argint>
80107c92:	83 c4 10             	add    $0x10,%esp
80107c95:	85 c0                	test   %eax,%eax
80107c97:	78 64                	js     80107cfd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80107c99:	83 ec 0c             	sub    $0xc,%esp
80107c9c:	68 40 78 11 80       	push   $0x80117840
80107ca1:	e8 4a e9 ff ff       	call   801065f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107ca9:	8b 1d 20 78 11 80    	mov    0x80117820,%ebx
  while(ticks - ticks0 < n){
80107caf:	83 c4 10             	add    $0x10,%esp
80107cb2:	85 d2                	test   %edx,%edx
80107cb4:	75 2b                	jne    80107ce1 <sys_sleep+0x61>
80107cb6:	eb 58                	jmp    80107d10 <sys_sleep+0x90>
80107cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cbf:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107cc0:	83 ec 08             	sub    $0x8,%esp
80107cc3:	68 40 78 11 80       	push   $0x80117840
80107cc8:	68 20 78 11 80       	push   $0x80117820
80107ccd:	e8 7e e1 ff ff       	call   80105e50 <sleep>
  while(ticks - ticks0 < n){
80107cd2:	a1 20 78 11 80       	mov    0x80117820,%eax
80107cd7:	83 c4 10             	add    $0x10,%esp
80107cda:	29 d8                	sub    %ebx,%eax
80107cdc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80107cdf:	73 2f                	jae    80107d10 <sys_sleep+0x90>
    if(myproc()->killed){
80107ce1:	e8 7a d8 ff ff       	call   80105560 <myproc>
80107ce6:	8b 40 24             	mov    0x24(%eax),%eax
80107ce9:	85 c0                	test   %eax,%eax
80107ceb:	74 d3                	je     80107cc0 <sys_sleep+0x40>
      release(&tickslock);
80107ced:	83 ec 0c             	sub    $0xc,%esp
80107cf0:	68 40 78 11 80       	push   $0x80117840
80107cf5:	e8 96 e8 ff ff       	call   80106590 <release>
      return -1;
80107cfa:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80107cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80107d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d05:	c9                   	leave  
80107d06:	c3                   	ret    
80107d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d0e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80107d10:	83 ec 0c             	sub    $0xc,%esp
80107d13:	68 40 78 11 80       	push   $0x80117840
80107d18:	e8 73 e8 ff ff       	call   80106590 <release>
}
80107d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80107d20:	83 c4 10             	add    $0x10,%esp
80107d23:	31 c0                	xor    %eax,%eax
}
80107d25:	c9                   	leave  
80107d26:	c3                   	ret    
80107d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2e:	66 90                	xchg   %ax,%ax

80107d30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	53                   	push   %ebx
80107d34:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107d37:	68 40 78 11 80       	push   $0x80117840
80107d3c:	e8 af e8 ff ff       	call   801065f0 <acquire>
  xticks = ticks;
80107d41:	8b 1d 20 78 11 80    	mov    0x80117820,%ebx
  release(&tickslock);
80107d47:	c7 04 24 40 78 11 80 	movl   $0x80117840,(%esp)
80107d4e:	e8 3d e8 ff ff       	call   80106590 <release>
  return xticks;
}
80107d53:	89 d8                	mov    %ebx,%eax
80107d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d58:	c9                   	leave  
80107d59:	c3                   	ret    
80107d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d60 <sys_simple_arithmetic_syscall>:

int sys_simple_arithmetic_syscall(void)
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	53                   	push   %ebx
80107d64:	83 ec 04             	sub    $0x4,%esp
  int a, b, result;
  struct proc *curproc = myproc();
80107d67:	e8 f4 d7 ff ff       	call   80105560 <myproc>
  a = curproc->tf->ebx;
  b = curproc->tf->ecx;

  result = (a - b) * (a + b);

  cprintf("Calc:  (%d - %d) * (%d + %d) = %d\n", a, b, a, b, result);
80107d6c:	83 ec 08             	sub    $0x8,%esp
  a = curproc->tf->ebx;
80107d6f:	8b 50 18             	mov    0x18(%eax),%edx
80107d72:	8b 42 10             	mov    0x10(%edx),%eax
  b = curproc->tf->ecx;
80107d75:	8b 52 18             	mov    0x18(%edx),%edx
  result = (a - b) * (a + b);
80107d78:	89 c3                	mov    %eax,%ebx
80107d7a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80107d7d:	29 d3                	sub    %edx,%ebx
80107d7f:	0f af d9             	imul   %ecx,%ebx
  cprintf("Calc:  (%d - %d) * (%d + %d) = %d\n", a, b, a, b, result);
80107d82:	53                   	push   %ebx
80107d83:	52                   	push   %edx
80107d84:	50                   	push   %eax
80107d85:	52                   	push   %edx
80107d86:	50                   	push   %eax
80107d87:	68 10 a1 10 80       	push   $0x8010a110
80107d8c:	e8 3f 8a ff ff       	call   801007d0 <cprintf>

  return result;
}
80107d91:	89 d8                	mov    %ebx,%eax
80107d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d96:	c9                   	leave  
80107d97:	c3                   	ret    
80107d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d9f:	90                   	nop

80107da0 <sys_show_process_family>:

int sys_show_process_family(void)
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	83 ec 20             	sub    $0x20,%esp

int pid;
if(argint(0,&pid) < 0 ){
80107da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107da9:	50                   	push   %eax
80107daa:	6a 00                	push   $0x0
80107dac:	e8 ef eb ff ff       	call   801069a0 <argint>
80107db1:	83 c4 10             	add    $0x10,%esp
80107db4:	85 c0                	test   %eax,%eax
80107db6:	78 18                	js     80107dd0 <sys_show_process_family+0x30>


  return -2;
}

return  show_process_family( pid);
80107db8:	83 ec 0c             	sub    $0xc,%esp
80107dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80107dbe:	e8 ed e2 ff ff       	call   801060b0 <show_process_family>
80107dc3:	83 c4 10             	add    $0x10,%esp
}
80107dc6:	c9                   	leave  
80107dc7:	c3                   	ret    
80107dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dcf:	90                   	nop
80107dd0:	c9                   	leave  
  return -2;
80107dd1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80107dd6:	c3                   	ret    
80107dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dde:	66 90                	xchg   %ax,%ax

80107de0 <sys_set_priority_syscall>:

extern int set_priority_helper(int pid, int priority);

int sys_set_priority_syscall(void)
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int priority;

  if(argint(0, &pid) < 0)
80107de6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107de9:	50                   	push   %eax
80107dea:	6a 00                	push   $0x0
80107dec:	e8 af eb ff ff       	call   801069a0 <argint>
80107df1:	83 c4 10             	add    $0x10,%esp
80107df4:	85 c0                	test   %eax,%eax
80107df6:	78 48                	js     80107e40 <sys_set_priority_syscall+0x60>
    return -1;
  if(argint(1, &priority) < 0)
80107df8:	83 ec 08             	sub    $0x8,%esp
80107dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107dfe:	50                   	push   %eax
80107dff:	6a 01                	push   $0x1
80107e01:	e8 9a eb ff ff       	call   801069a0 <argint>
80107e06:	83 c4 10             	add    $0x10,%esp
80107e09:	85 c0                	test   %eax,%eax
80107e0b:	78 33                	js     80107e40 <sys_set_priority_syscall+0x60>
    return -1;

  if(priority < 0 || priority > 2) {
80107e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e10:	83 f8 02             	cmp    $0x2,%eax
80107e13:	77 1b                	ja     80107e30 <sys_set_priority_syscall+0x50>
    cprintf("Error: Priority must be between 0 (High) and 2 (Low).\n");
    return -1;
  }
    
  return set_priority_helper(pid, priority);
80107e15:	83 ec 08             	sub    $0x8,%esp
80107e18:	50                   	push   %eax
80107e19:	ff 75 f0             	pushl  -0x10(%ebp)
80107e1c:	e8 3f e4 ff ff       	call   80106260 <set_priority_helper>
80107e21:	83 c4 10             	add    $0x10,%esp
}
80107e24:	c9                   	leave  
80107e25:	c3                   	ret    
80107e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e2d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("Error: Priority must be between 0 (High) and 2 (Low).\n");
80107e30:	83 ec 0c             	sub    $0xc,%esp
80107e33:	68 34 a1 10 80       	push   $0x8010a134
80107e38:	e8 93 89 ff ff       	call   801007d0 <cprintf>
    return -1;
80107e3d:	83 c4 10             	add    $0x10,%esp
}
80107e40:	c9                   	leave  
    return -1;
80107e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e46:	c3                   	ret    

80107e47 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107e47:	1e                   	push   %ds
  pushl %es
80107e48:	06                   	push   %es
  pushl %fs
80107e49:	0f a0                	push   %fs
  pushl %gs
80107e4b:	0f a8                	push   %gs
  pushal
80107e4d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107e4e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107e52:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107e54:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107e56:	54                   	push   %esp
  call trap
80107e57:	e8 c4 00 00 00       	call   80107f20 <trap>
  addl $4, %esp
80107e5c:	83 c4 04             	add    $0x4,%esp

80107e5f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107e5f:	61                   	popa   
  popl %gs
80107e60:	0f a9                	pop    %gs
  popl %fs
80107e62:	0f a1                	pop    %fs
  popl %es
80107e64:	07                   	pop    %es
  popl %ds
80107e65:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107e66:	83 c4 08             	add    $0x8,%esp
  iret
80107e69:	cf                   	iret   
80107e6a:	66 90                	xchg   %ax,%ax
80107e6c:	66 90                	xchg   %ax,%ax
80107e6e:	66 90                	xchg   %ax,%ax

80107e70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107e70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107e71:	31 c0                	xor    %eax,%eax
{
80107e73:	89 e5                	mov    %esp,%ebp
80107e75:	83 ec 08             	sub    $0x8,%esp
80107e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e7f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107e80:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80107e87:	c7 04 c5 82 78 11 80 	movl   $0x8e000008,-0x7fee877e(,%eax,8)
80107e8e:	08 00 00 8e 
80107e92:	66 89 14 c5 80 78 11 	mov    %dx,-0x7fee8780(,%eax,8)
80107e99:	80 
80107e9a:	c1 ea 10             	shr    $0x10,%edx
80107e9d:	66 89 14 c5 86 78 11 	mov    %dx,-0x7fee877a(,%eax,8)
80107ea4:	80 
  for(i = 0; i < 256; i++)
80107ea5:	83 c0 01             	add    $0x1,%eax
80107ea8:	3d 00 01 00 00       	cmp    $0x100,%eax
80107ead:	75 d1                	jne    80107e80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80107eaf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107eb2:	a1 08 d1 10 80       	mov    0x8010d108,%eax
80107eb7:	c7 05 82 7a 11 80 08 	movl   $0xef000008,0x80117a82
80107ebe:	00 00 ef 
  initlock(&tickslock, "time");
80107ec1:	68 6b a1 10 80       	push   $0x8010a16b
80107ec6:	68 40 78 11 80       	push   $0x80117840
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107ecb:	66 a3 80 7a 11 80    	mov    %ax,0x80117a80
80107ed1:	c1 e8 10             	shr    $0x10,%eax
80107ed4:	66 a3 86 7a 11 80    	mov    %ax,0x80117a86
  initlock(&tickslock, "time");
80107eda:	e8 21 e5 ff ff       	call   80106400 <initlock>
}
80107edf:	83 c4 10             	add    $0x10,%esp
80107ee2:	c9                   	leave  
80107ee3:	c3                   	ret    
80107ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eef:	90                   	nop

80107ef0 <idtinit>:

void
idtinit(void)
{
80107ef0:	55                   	push   %ebp
  pd[0] = size-1;
80107ef1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107ef6:	89 e5                	mov    %esp,%ebp
80107ef8:	83 ec 10             	sub    $0x10,%esp
80107efb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107eff:	b8 80 78 11 80       	mov    $0x80117880,%eax
80107f04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f08:	c1 e8 10             	shr    $0x10,%eax
80107f0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80107f0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107f15:	c9                   	leave  
80107f16:	c3                   	ret    
80107f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f1e:	66 90                	xchg   %ax,%ax

80107f20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107f20:	55                   	push   %ebp
80107f21:	89 e5                	mov    %esp,%ebp
80107f23:	57                   	push   %edi
80107f24:	56                   	push   %esi
80107f25:	53                   	push   %ebx
80107f26:	83 ec 1c             	sub    $0x1c,%esp
80107f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80107f2c:	8b 43 30             	mov    0x30(%ebx),%eax
80107f2f:	83 f8 40             	cmp    $0x40,%eax
80107f32:	0f 84 58 01 00 00    	je     80108090 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80107f38:	83 e8 20             	sub    $0x20,%eax
80107f3b:	83 f8 1f             	cmp    $0x1f,%eax
80107f3e:	0f 87 7c 00 00 00    	ja     80107fc0 <trap+0xa0>
80107f44:	ff 24 85 14 a2 10 80 	jmp    *-0x7fef5dec(,%eax,4)
80107f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f4f:	90                   	nop
    }

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107f50:	e8 9b be ff ff       	call   80103df0 <ideintr>
    lapiceoi();
80107f55:	e8 56 c5 ff ff       	call   801044b0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107f5a:	e8 01 d6 ff ff       	call   80105560 <myproc>
80107f5f:	85 c0                	test   %eax,%eax
80107f61:	74 1a                	je     80107f7d <trap+0x5d>
80107f63:	e8 f8 d5 ff ff       	call   80105560 <myproc>
80107f68:	8b 50 24             	mov    0x24(%eax),%edx
80107f6b:	85 d2                	test   %edx,%edx
80107f6d:	74 0e                	je     80107f7d <trap+0x5d>
80107f6f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107f73:	f7 d0                	not    %eax
80107f75:	a8 03                	test   $0x3,%al
80107f77:	0f 84 d3 01 00 00    	je     80108150 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107f7d:	e8 de d5 ff ff       	call   80105560 <myproc>
80107f82:	85 c0                	test   %eax,%eax
80107f84:	74 0f                	je     80107f95 <trap+0x75>
80107f86:	e8 d5 d5 ff ff       	call   80105560 <myproc>
80107f8b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107f8f:	0f 84 ab 00 00 00    	je     80108040 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107f95:	e8 c6 d5 ff ff       	call   80105560 <myproc>
80107f9a:	85 c0                	test   %eax,%eax
80107f9c:	74 1a                	je     80107fb8 <trap+0x98>
80107f9e:	e8 bd d5 ff ff       	call   80105560 <myproc>
80107fa3:	8b 40 24             	mov    0x24(%eax),%eax
80107fa6:	85 c0                	test   %eax,%eax
80107fa8:	74 0e                	je     80107fb8 <trap+0x98>
80107faa:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107fae:	f7 d0                	not    %eax
80107fb0:	a8 03                	test   $0x3,%al
80107fb2:	0f 84 05 01 00 00    	je     801080bd <trap+0x19d>
    exit();
}
80107fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fbb:	5b                   	pop    %ebx
80107fbc:	5e                   	pop    %esi
80107fbd:	5f                   	pop    %edi
80107fbe:	5d                   	pop    %ebp
80107fbf:	c3                   	ret    
    if(myproc() == 0 || (tf->cs&3) == 0){
80107fc0:	e8 9b d5 ff ff       	call   80105560 <myproc>
80107fc5:	8b 7b 38             	mov    0x38(%ebx),%edi
80107fc8:	85 c0                	test   %eax,%eax
80107fca:	0f 84 d2 01 00 00    	je     801081a2 <trap+0x282>
80107fd0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107fd4:	0f 84 c8 01 00 00    	je     801081a2 <trap+0x282>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107fda:	0f 20 d1             	mov    %cr2,%ecx
80107fdd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107fe0:	e8 5b d5 ff ff       	call   80105540 <cpuid>
80107fe5:	8b 73 30             	mov    0x30(%ebx),%esi
80107fe8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107feb:	8b 43 34             	mov    0x34(%ebx),%eax
80107fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107ff1:	e8 6a d5 ff ff       	call   80105560 <myproc>
80107ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ff9:	e8 62 d5 ff ff       	call   80105560 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107ffe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80108001:	51                   	push   %ecx
80108002:	57                   	push   %edi
80108003:	8b 55 dc             	mov    -0x24(%ebp),%edx
80108006:	52                   	push   %edx
80108007:	ff 75 e4             	pushl  -0x1c(%ebp)
8010800a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010800b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010800e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108011:	56                   	push   %esi
80108012:	ff 70 10             	pushl  0x10(%eax)
80108015:	68 d0 a1 10 80       	push   $0x8010a1d0
8010801a:	e8 b1 87 ff ff       	call   801007d0 <cprintf>
    myproc()->killed = 1;
8010801f:	83 c4 20             	add    $0x20,%esp
80108022:	e8 39 d5 ff ff       	call   80105560 <myproc>
80108027:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010802e:	e8 2d d5 ff ff       	call   80105560 <myproc>
80108033:	85 c0                	test   %eax,%eax
80108035:	0f 85 28 ff ff ff    	jne    80107f63 <trap+0x43>
8010803b:	e9 3d ff ff ff       	jmp    80107f7d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80108040:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80108044:	0f 85 4b ff ff ff    	jne    80107f95 <trap+0x75>
    yield();
8010804a:	e8 b1 dd ff ff       	call   80105e00 <yield>
8010804f:	e9 41 ff ff ff       	jmp    80107f95 <trap+0x75>
80108054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108058:	8b 7b 38             	mov    0x38(%ebx),%edi
8010805b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010805f:	e8 dc d4 ff ff       	call   80105540 <cpuid>
80108064:	57                   	push   %edi
80108065:	56                   	push   %esi
80108066:	50                   	push   %eax
80108067:	68 78 a1 10 80       	push   $0x8010a178
8010806c:	e8 5f 87 ff ff       	call   801007d0 <cprintf>
    lapiceoi();
80108071:	e8 3a c4 ff ff       	call   801044b0 <lapiceoi>
    break;
80108076:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108079:	e8 e2 d4 ff ff       	call   80105560 <myproc>
8010807e:	85 c0                	test   %eax,%eax
80108080:	0f 85 dd fe ff ff    	jne    80107f63 <trap+0x43>
80108086:	e9 f2 fe ff ff       	jmp    80107f7d <trap+0x5d>
8010808b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010808f:	90                   	nop
    if(myproc()->killed)
80108090:	e8 cb d4 ff ff       	call   80105560 <myproc>
80108095:	8b 70 24             	mov    0x24(%eax),%esi
80108098:	85 f6                	test   %esi,%esi
8010809a:	0f 85 f8 00 00 00    	jne    80108198 <trap+0x278>
    myproc()->tf = tf;
801080a0:	e8 bb d4 ff ff       	call   80105560 <myproc>
801080a5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801080a8:	e8 33 ea ff ff       	call   80106ae0 <syscall>
    if(myproc()->killed)
801080ad:	e8 ae d4 ff ff       	call   80105560 <myproc>
801080b2:	8b 48 24             	mov    0x24(%eax),%ecx
801080b5:	85 c9                	test   %ecx,%ecx
801080b7:	0f 84 fb fe ff ff    	je     80107fb8 <trap+0x98>
}
801080bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080c0:	5b                   	pop    %ebx
801080c1:	5e                   	pop    %esi
801080c2:	5f                   	pop    %edi
801080c3:	5d                   	pop    %ebp
      exit();
801080c4:	e9 d7 da ff ff       	jmp    80105ba0 <exit>
801080c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801080d0:	e8 7b 02 00 00       	call   80108350 <uartintr>
    lapiceoi();
801080d5:	e8 d6 c3 ff ff       	call   801044b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801080da:	e8 81 d4 ff ff       	call   80105560 <myproc>
801080df:	85 c0                	test   %eax,%eax
801080e1:	0f 85 7c fe ff ff    	jne    80107f63 <trap+0x43>
801080e7:	e9 91 fe ff ff       	jmp    80107f7d <trap+0x5d>
801080ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801080f0:	e8 8b c2 ff ff       	call   80104380 <kbdintr>
    lapiceoi();
801080f5:	e8 b6 c3 ff ff       	call   801044b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801080fa:	e8 61 d4 ff ff       	call   80105560 <myproc>
801080ff:	85 c0                	test   %eax,%eax
80108101:	0f 85 5c fe ff ff    	jne    80107f63 <trap+0x43>
80108107:	e9 71 fe ff ff       	jmp    80107f7d <trap+0x5d>
8010810c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80108110:	e8 2b d4 ff ff       	call   80105540 <cpuid>
80108115:	85 c0                	test   %eax,%eax
80108117:	74 47                	je     80108160 <trap+0x240>
    if (mycpu()->type == ECORE && ticks % 5 == 0) {    // add for moving between queues
80108119:	e8 c2 d3 ff ff       	call   801054e0 <mycpu>
8010811e:	8b 0d 20 78 11 80    	mov    0x80117820,%ecx
80108124:	89 c6                	mov    %eax,%esi
80108126:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
8010812b:	f7 e1                	mul    %ecx
8010812d:	89 d0                	mov    %edx,%eax
8010812f:	83 e2 fc             	and    $0xfffffffc,%edx
80108132:	c1 e8 02             	shr    $0x2,%eax
80108135:	01 c2                	add    %eax,%edx
80108137:	29 d1                	sub    %edx,%ecx
80108139:	0b 8e b0 00 00 00    	or     0xb0(%esi),%ecx
8010813f:	0f 85 10 fe ff ff    	jne    80107f55 <trap+0x35>
      balance_queues();
80108145:	e8 e6 d6 ff ff       	call   80105830 <balance_queues>
    lapiceoi();
8010814a:	e9 06 fe ff ff       	jmp    80107f55 <trap+0x35>
8010814f:	90                   	nop
    exit();
80108150:	e8 4b da ff ff       	call   80105ba0 <exit>
80108155:	e9 23 fe ff ff       	jmp    80107f7d <trap+0x5d>
8010815a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80108160:	83 ec 0c             	sub    $0xc,%esp
80108163:	68 40 78 11 80       	push   $0x80117840
80108168:	e8 83 e4 ff ff       	call   801065f0 <acquire>
      ticks++;
8010816d:	83 05 20 78 11 80 01 	addl   $0x1,0x80117820
      wakeup(&ticks);
80108174:	c7 04 24 20 78 11 80 	movl   $0x80117820,(%esp)
8010817b:	e8 90 dd ff ff       	call   80105f10 <wakeup>
      release(&tickslock);
80108180:	c7 04 24 40 78 11 80 	movl   $0x80117840,(%esp)
80108187:	e8 04 e4 ff ff       	call   80106590 <release>
8010818c:	83 c4 10             	add    $0x10,%esp
8010818f:	eb 88                	jmp    80108119 <trap+0x1f9>
80108191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exit();
80108198:	e8 03 da ff ff       	call   80105ba0 <exit>
8010819d:	e9 fe fe ff ff       	jmp    801080a0 <trap+0x180>
801081a2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801081a5:	e8 96 d3 ff ff       	call   80105540 <cpuid>
801081aa:	83 ec 0c             	sub    $0xc,%esp
801081ad:	56                   	push   %esi
801081ae:	57                   	push   %edi
801081af:	50                   	push   %eax
801081b0:	ff 73 30             	pushl  0x30(%ebx)
801081b3:	68 9c a1 10 80       	push   $0x8010a19c
801081b8:	e8 13 86 ff ff       	call   801007d0 <cprintf>
      panic("trap");
801081bd:	83 c4 14             	add    $0x14,%esp
801081c0:	68 70 a1 10 80       	push   $0x8010a170
801081c5:	e8 b6 81 ff ff       	call   80100380 <panic>
801081ca:	66 90                	xchg   %ax,%ax
801081cc:	66 90                	xchg   %ax,%ax
801081ce:	66 90                	xchg   %ax,%ax

801081d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801081d0:	a1 80 80 11 80       	mov    0x80118080,%eax
801081d5:	85 c0                	test   %eax,%eax
801081d7:	74 17                	je     801081f0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801081d9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801081de:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801081df:	a8 01                	test   $0x1,%al
801081e1:	74 0d                	je     801081f0 <uartgetc+0x20>
801081e3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801081e8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801081e9:	0f b6 c0             	movzbl %al,%eax
801081ec:	c3                   	ret    
801081ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801081f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081f5:	c3                   	ret    
801081f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081fd:	8d 76 00             	lea    0x0(%esi),%esi

80108200 <uartinit>:
{
80108200:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108201:	31 c9                	xor    %ecx,%ecx
80108203:	89 c8                	mov    %ecx,%eax
80108205:	89 e5                	mov    %esp,%ebp
80108207:	57                   	push   %edi
80108208:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010820d:	56                   	push   %esi
8010820e:	89 fa                	mov    %edi,%edx
80108210:	53                   	push   %ebx
80108211:	83 ec 1c             	sub    $0x1c,%esp
80108214:	ee                   	out    %al,(%dx)
80108215:	be fb 03 00 00       	mov    $0x3fb,%esi
8010821a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010821f:	89 f2                	mov    %esi,%edx
80108221:	ee                   	out    %al,(%dx)
80108222:	b8 0c 00 00 00       	mov    $0xc,%eax
80108227:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010822c:	ee                   	out    %al,(%dx)
8010822d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80108232:	89 c8                	mov    %ecx,%eax
80108234:	89 da                	mov    %ebx,%edx
80108236:	ee                   	out    %al,(%dx)
80108237:	b8 03 00 00 00       	mov    $0x3,%eax
8010823c:	89 f2                	mov    %esi,%edx
8010823e:	ee                   	out    %al,(%dx)
8010823f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80108244:	89 c8                	mov    %ecx,%eax
80108246:	ee                   	out    %al,(%dx)
80108247:	b8 01 00 00 00       	mov    $0x1,%eax
8010824c:	89 da                	mov    %ebx,%edx
8010824e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010824f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80108254:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80108255:	3c ff                	cmp    $0xff,%al
80108257:	0f 84 7c 00 00 00    	je     801082d9 <uartinit+0xd9>
  uart = 1;
8010825d:	c7 05 80 80 11 80 01 	movl   $0x1,0x80118080
80108264:	00 00 00 
80108267:	89 fa                	mov    %edi,%edx
80108269:	ec                   	in     (%dx),%al
8010826a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010826f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80108270:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80108273:	bf 94 a2 10 80       	mov    $0x8010a294,%edi
80108278:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010827d:	6a 00                	push   $0x0
8010827f:	6a 04                	push   $0x4
80108281:	e8 9a bd ff ff       	call   80104020 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80108286:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010828a:	83 c4 10             	add    $0x10,%esp
8010828d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80108290:	a1 80 80 11 80       	mov    0x80118080,%eax
80108295:	85 c0                	test   %eax,%eax
80108297:	74 32                	je     801082cb <uartinit+0xcb>
80108299:	89 f2                	mov    %esi,%edx
8010829b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010829c:	a8 20                	test   $0x20,%al
8010829e:	75 21                	jne    801082c1 <uartinit+0xc1>
801082a0:	bb 80 00 00 00       	mov    $0x80,%ebx
801082a5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801082a8:	83 ec 0c             	sub    $0xc,%esp
801082ab:	6a 0a                	push   $0xa
801082ad:	e8 1e c2 ff ff       	call   801044d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801082b2:	83 c4 10             	add    $0x10,%esp
801082b5:	83 eb 01             	sub    $0x1,%ebx
801082b8:	74 07                	je     801082c1 <uartinit+0xc1>
801082ba:	89 f2                	mov    %esi,%edx
801082bc:	ec                   	in     (%dx),%al
801082bd:	a8 20                	test   $0x20,%al
801082bf:	74 e7                	je     801082a8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801082c1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801082c6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801082ca:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801082cb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801082cf:	83 c7 01             	add    $0x1,%edi
801082d2:	88 45 e7             	mov    %al,-0x19(%ebp)
801082d5:	84 c0                	test   %al,%al
801082d7:	75 b7                	jne    80108290 <uartinit+0x90>
}
801082d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082dc:	5b                   	pop    %ebx
801082dd:	5e                   	pop    %esi
801082de:	5f                   	pop    %edi
801082df:	5d                   	pop    %ebp
801082e0:	c3                   	ret    
801082e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082ef:	90                   	nop

801082f0 <uartputc>:
  if(!uart)
801082f0:	a1 80 80 11 80       	mov    0x80118080,%eax
801082f5:	85 c0                	test   %eax,%eax
801082f7:	74 4f                	je     80108348 <uartputc+0x58>
{
801082f9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801082fa:	ba fd 03 00 00       	mov    $0x3fd,%edx
801082ff:	89 e5                	mov    %esp,%ebp
80108301:	56                   	push   %esi
80108302:	53                   	push   %ebx
80108303:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108304:	a8 20                	test   $0x20,%al
80108306:	75 29                	jne    80108331 <uartputc+0x41>
80108308:	bb 80 00 00 00       	mov    $0x80,%ebx
8010830d:	be fd 03 00 00       	mov    $0x3fd,%esi
80108312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80108318:	83 ec 0c             	sub    $0xc,%esp
8010831b:	6a 0a                	push   $0xa
8010831d:	e8 ae c1 ff ff       	call   801044d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108322:	83 c4 10             	add    $0x10,%esp
80108325:	83 eb 01             	sub    $0x1,%ebx
80108328:	74 07                	je     80108331 <uartputc+0x41>
8010832a:	89 f2                	mov    %esi,%edx
8010832c:	ec                   	in     (%dx),%al
8010832d:	a8 20                	test   $0x20,%al
8010832f:	74 e7                	je     80108318 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108331:	8b 45 08             	mov    0x8(%ebp),%eax
80108334:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108339:	ee                   	out    %al,(%dx)
}
8010833a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010833d:	5b                   	pop    %ebx
8010833e:	5e                   	pop    %esi
8010833f:	5d                   	pop    %ebp
80108340:	c3                   	ret    
80108341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108348:	c3                   	ret    
80108349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108350 <uartintr>:

void
uartintr(void)
{
80108350:	55                   	push   %ebp
80108351:	89 e5                	mov    %esp,%ebp
80108353:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80108356:	68 d0 81 10 80       	push   $0x801081d0
8010835b:	e8 b0 92 ff ff       	call   80101610 <consoleintr>
}
80108360:	83 c4 10             	add    $0x10,%esp
80108363:	c9                   	leave  
80108364:	c3                   	ret    

80108365 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108365:	6a 00                	push   $0x0
  pushl $0
80108367:	6a 00                	push   $0x0
  jmp alltraps
80108369:	e9 d9 fa ff ff       	jmp    80107e47 <alltraps>

8010836e <vector1>:
.globl vector1
vector1:
  pushl $0
8010836e:	6a 00                	push   $0x0
  pushl $1
80108370:	6a 01                	push   $0x1
  jmp alltraps
80108372:	e9 d0 fa ff ff       	jmp    80107e47 <alltraps>

80108377 <vector2>:
.globl vector2
vector2:
  pushl $0
80108377:	6a 00                	push   $0x0
  pushl $2
80108379:	6a 02                	push   $0x2
  jmp alltraps
8010837b:	e9 c7 fa ff ff       	jmp    80107e47 <alltraps>

80108380 <vector3>:
.globl vector3
vector3:
  pushl $0
80108380:	6a 00                	push   $0x0
  pushl $3
80108382:	6a 03                	push   $0x3
  jmp alltraps
80108384:	e9 be fa ff ff       	jmp    80107e47 <alltraps>

80108389 <vector4>:
.globl vector4
vector4:
  pushl $0
80108389:	6a 00                	push   $0x0
  pushl $4
8010838b:	6a 04                	push   $0x4
  jmp alltraps
8010838d:	e9 b5 fa ff ff       	jmp    80107e47 <alltraps>

80108392 <vector5>:
.globl vector5
vector5:
  pushl $0
80108392:	6a 00                	push   $0x0
  pushl $5
80108394:	6a 05                	push   $0x5
  jmp alltraps
80108396:	e9 ac fa ff ff       	jmp    80107e47 <alltraps>

8010839b <vector6>:
.globl vector6
vector6:
  pushl $0
8010839b:	6a 00                	push   $0x0
  pushl $6
8010839d:	6a 06                	push   $0x6
  jmp alltraps
8010839f:	e9 a3 fa ff ff       	jmp    80107e47 <alltraps>

801083a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801083a4:	6a 00                	push   $0x0
  pushl $7
801083a6:	6a 07                	push   $0x7
  jmp alltraps
801083a8:	e9 9a fa ff ff       	jmp    80107e47 <alltraps>

801083ad <vector8>:
.globl vector8
vector8:
  pushl $8
801083ad:	6a 08                	push   $0x8
  jmp alltraps
801083af:	e9 93 fa ff ff       	jmp    80107e47 <alltraps>

801083b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801083b4:	6a 00                	push   $0x0
  pushl $9
801083b6:	6a 09                	push   $0x9
  jmp alltraps
801083b8:	e9 8a fa ff ff       	jmp    80107e47 <alltraps>

801083bd <vector10>:
.globl vector10
vector10:
  pushl $10
801083bd:	6a 0a                	push   $0xa
  jmp alltraps
801083bf:	e9 83 fa ff ff       	jmp    80107e47 <alltraps>

801083c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801083c4:	6a 0b                	push   $0xb
  jmp alltraps
801083c6:	e9 7c fa ff ff       	jmp    80107e47 <alltraps>

801083cb <vector12>:
.globl vector12
vector12:
  pushl $12
801083cb:	6a 0c                	push   $0xc
  jmp alltraps
801083cd:	e9 75 fa ff ff       	jmp    80107e47 <alltraps>

801083d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801083d2:	6a 0d                	push   $0xd
  jmp alltraps
801083d4:	e9 6e fa ff ff       	jmp    80107e47 <alltraps>

801083d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801083d9:	6a 0e                	push   $0xe
  jmp alltraps
801083db:	e9 67 fa ff ff       	jmp    80107e47 <alltraps>

801083e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801083e0:	6a 00                	push   $0x0
  pushl $15
801083e2:	6a 0f                	push   $0xf
  jmp alltraps
801083e4:	e9 5e fa ff ff       	jmp    80107e47 <alltraps>

801083e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801083e9:	6a 00                	push   $0x0
  pushl $16
801083eb:	6a 10                	push   $0x10
  jmp alltraps
801083ed:	e9 55 fa ff ff       	jmp    80107e47 <alltraps>

801083f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801083f2:	6a 11                	push   $0x11
  jmp alltraps
801083f4:	e9 4e fa ff ff       	jmp    80107e47 <alltraps>

801083f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801083f9:	6a 00                	push   $0x0
  pushl $18
801083fb:	6a 12                	push   $0x12
  jmp alltraps
801083fd:	e9 45 fa ff ff       	jmp    80107e47 <alltraps>

80108402 <vector19>:
.globl vector19
vector19:
  pushl $0
80108402:	6a 00                	push   $0x0
  pushl $19
80108404:	6a 13                	push   $0x13
  jmp alltraps
80108406:	e9 3c fa ff ff       	jmp    80107e47 <alltraps>

8010840b <vector20>:
.globl vector20
vector20:
  pushl $0
8010840b:	6a 00                	push   $0x0
  pushl $20
8010840d:	6a 14                	push   $0x14
  jmp alltraps
8010840f:	e9 33 fa ff ff       	jmp    80107e47 <alltraps>

80108414 <vector21>:
.globl vector21
vector21:
  pushl $0
80108414:	6a 00                	push   $0x0
  pushl $21
80108416:	6a 15                	push   $0x15
  jmp alltraps
80108418:	e9 2a fa ff ff       	jmp    80107e47 <alltraps>

8010841d <vector22>:
.globl vector22
vector22:
  pushl $0
8010841d:	6a 00                	push   $0x0
  pushl $22
8010841f:	6a 16                	push   $0x16
  jmp alltraps
80108421:	e9 21 fa ff ff       	jmp    80107e47 <alltraps>

80108426 <vector23>:
.globl vector23
vector23:
  pushl $0
80108426:	6a 00                	push   $0x0
  pushl $23
80108428:	6a 17                	push   $0x17
  jmp alltraps
8010842a:	e9 18 fa ff ff       	jmp    80107e47 <alltraps>

8010842f <vector24>:
.globl vector24
vector24:
  pushl $0
8010842f:	6a 00                	push   $0x0
  pushl $24
80108431:	6a 18                	push   $0x18
  jmp alltraps
80108433:	e9 0f fa ff ff       	jmp    80107e47 <alltraps>

80108438 <vector25>:
.globl vector25
vector25:
  pushl $0
80108438:	6a 00                	push   $0x0
  pushl $25
8010843a:	6a 19                	push   $0x19
  jmp alltraps
8010843c:	e9 06 fa ff ff       	jmp    80107e47 <alltraps>

80108441 <vector26>:
.globl vector26
vector26:
  pushl $0
80108441:	6a 00                	push   $0x0
  pushl $26
80108443:	6a 1a                	push   $0x1a
  jmp alltraps
80108445:	e9 fd f9 ff ff       	jmp    80107e47 <alltraps>

8010844a <vector27>:
.globl vector27
vector27:
  pushl $0
8010844a:	6a 00                	push   $0x0
  pushl $27
8010844c:	6a 1b                	push   $0x1b
  jmp alltraps
8010844e:	e9 f4 f9 ff ff       	jmp    80107e47 <alltraps>

80108453 <vector28>:
.globl vector28
vector28:
  pushl $0
80108453:	6a 00                	push   $0x0
  pushl $28
80108455:	6a 1c                	push   $0x1c
  jmp alltraps
80108457:	e9 eb f9 ff ff       	jmp    80107e47 <alltraps>

8010845c <vector29>:
.globl vector29
vector29:
  pushl $0
8010845c:	6a 00                	push   $0x0
  pushl $29
8010845e:	6a 1d                	push   $0x1d
  jmp alltraps
80108460:	e9 e2 f9 ff ff       	jmp    80107e47 <alltraps>

80108465 <vector30>:
.globl vector30
vector30:
  pushl $0
80108465:	6a 00                	push   $0x0
  pushl $30
80108467:	6a 1e                	push   $0x1e
  jmp alltraps
80108469:	e9 d9 f9 ff ff       	jmp    80107e47 <alltraps>

8010846e <vector31>:
.globl vector31
vector31:
  pushl $0
8010846e:	6a 00                	push   $0x0
  pushl $31
80108470:	6a 1f                	push   $0x1f
  jmp alltraps
80108472:	e9 d0 f9 ff ff       	jmp    80107e47 <alltraps>

80108477 <vector32>:
.globl vector32
vector32:
  pushl $0
80108477:	6a 00                	push   $0x0
  pushl $32
80108479:	6a 20                	push   $0x20
  jmp alltraps
8010847b:	e9 c7 f9 ff ff       	jmp    80107e47 <alltraps>

80108480 <vector33>:
.globl vector33
vector33:
  pushl $0
80108480:	6a 00                	push   $0x0
  pushl $33
80108482:	6a 21                	push   $0x21
  jmp alltraps
80108484:	e9 be f9 ff ff       	jmp    80107e47 <alltraps>

80108489 <vector34>:
.globl vector34
vector34:
  pushl $0
80108489:	6a 00                	push   $0x0
  pushl $34
8010848b:	6a 22                	push   $0x22
  jmp alltraps
8010848d:	e9 b5 f9 ff ff       	jmp    80107e47 <alltraps>

80108492 <vector35>:
.globl vector35
vector35:
  pushl $0
80108492:	6a 00                	push   $0x0
  pushl $35
80108494:	6a 23                	push   $0x23
  jmp alltraps
80108496:	e9 ac f9 ff ff       	jmp    80107e47 <alltraps>

8010849b <vector36>:
.globl vector36
vector36:
  pushl $0
8010849b:	6a 00                	push   $0x0
  pushl $36
8010849d:	6a 24                	push   $0x24
  jmp alltraps
8010849f:	e9 a3 f9 ff ff       	jmp    80107e47 <alltraps>

801084a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801084a4:	6a 00                	push   $0x0
  pushl $37
801084a6:	6a 25                	push   $0x25
  jmp alltraps
801084a8:	e9 9a f9 ff ff       	jmp    80107e47 <alltraps>

801084ad <vector38>:
.globl vector38
vector38:
  pushl $0
801084ad:	6a 00                	push   $0x0
  pushl $38
801084af:	6a 26                	push   $0x26
  jmp alltraps
801084b1:	e9 91 f9 ff ff       	jmp    80107e47 <alltraps>

801084b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801084b6:	6a 00                	push   $0x0
  pushl $39
801084b8:	6a 27                	push   $0x27
  jmp alltraps
801084ba:	e9 88 f9 ff ff       	jmp    80107e47 <alltraps>

801084bf <vector40>:
.globl vector40
vector40:
  pushl $0
801084bf:	6a 00                	push   $0x0
  pushl $40
801084c1:	6a 28                	push   $0x28
  jmp alltraps
801084c3:	e9 7f f9 ff ff       	jmp    80107e47 <alltraps>

801084c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801084c8:	6a 00                	push   $0x0
  pushl $41
801084ca:	6a 29                	push   $0x29
  jmp alltraps
801084cc:	e9 76 f9 ff ff       	jmp    80107e47 <alltraps>

801084d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801084d1:	6a 00                	push   $0x0
  pushl $42
801084d3:	6a 2a                	push   $0x2a
  jmp alltraps
801084d5:	e9 6d f9 ff ff       	jmp    80107e47 <alltraps>

801084da <vector43>:
.globl vector43
vector43:
  pushl $0
801084da:	6a 00                	push   $0x0
  pushl $43
801084dc:	6a 2b                	push   $0x2b
  jmp alltraps
801084de:	e9 64 f9 ff ff       	jmp    80107e47 <alltraps>

801084e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801084e3:	6a 00                	push   $0x0
  pushl $44
801084e5:	6a 2c                	push   $0x2c
  jmp alltraps
801084e7:	e9 5b f9 ff ff       	jmp    80107e47 <alltraps>

801084ec <vector45>:
.globl vector45
vector45:
  pushl $0
801084ec:	6a 00                	push   $0x0
  pushl $45
801084ee:	6a 2d                	push   $0x2d
  jmp alltraps
801084f0:	e9 52 f9 ff ff       	jmp    80107e47 <alltraps>

801084f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801084f5:	6a 00                	push   $0x0
  pushl $46
801084f7:	6a 2e                	push   $0x2e
  jmp alltraps
801084f9:	e9 49 f9 ff ff       	jmp    80107e47 <alltraps>

801084fe <vector47>:
.globl vector47
vector47:
  pushl $0
801084fe:	6a 00                	push   $0x0
  pushl $47
80108500:	6a 2f                	push   $0x2f
  jmp alltraps
80108502:	e9 40 f9 ff ff       	jmp    80107e47 <alltraps>

80108507 <vector48>:
.globl vector48
vector48:
  pushl $0
80108507:	6a 00                	push   $0x0
  pushl $48
80108509:	6a 30                	push   $0x30
  jmp alltraps
8010850b:	e9 37 f9 ff ff       	jmp    80107e47 <alltraps>

80108510 <vector49>:
.globl vector49
vector49:
  pushl $0
80108510:	6a 00                	push   $0x0
  pushl $49
80108512:	6a 31                	push   $0x31
  jmp alltraps
80108514:	e9 2e f9 ff ff       	jmp    80107e47 <alltraps>

80108519 <vector50>:
.globl vector50
vector50:
  pushl $0
80108519:	6a 00                	push   $0x0
  pushl $50
8010851b:	6a 32                	push   $0x32
  jmp alltraps
8010851d:	e9 25 f9 ff ff       	jmp    80107e47 <alltraps>

80108522 <vector51>:
.globl vector51
vector51:
  pushl $0
80108522:	6a 00                	push   $0x0
  pushl $51
80108524:	6a 33                	push   $0x33
  jmp alltraps
80108526:	e9 1c f9 ff ff       	jmp    80107e47 <alltraps>

8010852b <vector52>:
.globl vector52
vector52:
  pushl $0
8010852b:	6a 00                	push   $0x0
  pushl $52
8010852d:	6a 34                	push   $0x34
  jmp alltraps
8010852f:	e9 13 f9 ff ff       	jmp    80107e47 <alltraps>

80108534 <vector53>:
.globl vector53
vector53:
  pushl $0
80108534:	6a 00                	push   $0x0
  pushl $53
80108536:	6a 35                	push   $0x35
  jmp alltraps
80108538:	e9 0a f9 ff ff       	jmp    80107e47 <alltraps>

8010853d <vector54>:
.globl vector54
vector54:
  pushl $0
8010853d:	6a 00                	push   $0x0
  pushl $54
8010853f:	6a 36                	push   $0x36
  jmp alltraps
80108541:	e9 01 f9 ff ff       	jmp    80107e47 <alltraps>

80108546 <vector55>:
.globl vector55
vector55:
  pushl $0
80108546:	6a 00                	push   $0x0
  pushl $55
80108548:	6a 37                	push   $0x37
  jmp alltraps
8010854a:	e9 f8 f8 ff ff       	jmp    80107e47 <alltraps>

8010854f <vector56>:
.globl vector56
vector56:
  pushl $0
8010854f:	6a 00                	push   $0x0
  pushl $56
80108551:	6a 38                	push   $0x38
  jmp alltraps
80108553:	e9 ef f8 ff ff       	jmp    80107e47 <alltraps>

80108558 <vector57>:
.globl vector57
vector57:
  pushl $0
80108558:	6a 00                	push   $0x0
  pushl $57
8010855a:	6a 39                	push   $0x39
  jmp alltraps
8010855c:	e9 e6 f8 ff ff       	jmp    80107e47 <alltraps>

80108561 <vector58>:
.globl vector58
vector58:
  pushl $0
80108561:	6a 00                	push   $0x0
  pushl $58
80108563:	6a 3a                	push   $0x3a
  jmp alltraps
80108565:	e9 dd f8 ff ff       	jmp    80107e47 <alltraps>

8010856a <vector59>:
.globl vector59
vector59:
  pushl $0
8010856a:	6a 00                	push   $0x0
  pushl $59
8010856c:	6a 3b                	push   $0x3b
  jmp alltraps
8010856e:	e9 d4 f8 ff ff       	jmp    80107e47 <alltraps>

80108573 <vector60>:
.globl vector60
vector60:
  pushl $0
80108573:	6a 00                	push   $0x0
  pushl $60
80108575:	6a 3c                	push   $0x3c
  jmp alltraps
80108577:	e9 cb f8 ff ff       	jmp    80107e47 <alltraps>

8010857c <vector61>:
.globl vector61
vector61:
  pushl $0
8010857c:	6a 00                	push   $0x0
  pushl $61
8010857e:	6a 3d                	push   $0x3d
  jmp alltraps
80108580:	e9 c2 f8 ff ff       	jmp    80107e47 <alltraps>

80108585 <vector62>:
.globl vector62
vector62:
  pushl $0
80108585:	6a 00                	push   $0x0
  pushl $62
80108587:	6a 3e                	push   $0x3e
  jmp alltraps
80108589:	e9 b9 f8 ff ff       	jmp    80107e47 <alltraps>

8010858e <vector63>:
.globl vector63
vector63:
  pushl $0
8010858e:	6a 00                	push   $0x0
  pushl $63
80108590:	6a 3f                	push   $0x3f
  jmp alltraps
80108592:	e9 b0 f8 ff ff       	jmp    80107e47 <alltraps>

80108597 <vector64>:
.globl vector64
vector64:
  pushl $0
80108597:	6a 00                	push   $0x0
  pushl $64
80108599:	6a 40                	push   $0x40
  jmp alltraps
8010859b:	e9 a7 f8 ff ff       	jmp    80107e47 <alltraps>

801085a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801085a0:	6a 00                	push   $0x0
  pushl $65
801085a2:	6a 41                	push   $0x41
  jmp alltraps
801085a4:	e9 9e f8 ff ff       	jmp    80107e47 <alltraps>

801085a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801085a9:	6a 00                	push   $0x0
  pushl $66
801085ab:	6a 42                	push   $0x42
  jmp alltraps
801085ad:	e9 95 f8 ff ff       	jmp    80107e47 <alltraps>

801085b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801085b2:	6a 00                	push   $0x0
  pushl $67
801085b4:	6a 43                	push   $0x43
  jmp alltraps
801085b6:	e9 8c f8 ff ff       	jmp    80107e47 <alltraps>

801085bb <vector68>:
.globl vector68
vector68:
  pushl $0
801085bb:	6a 00                	push   $0x0
  pushl $68
801085bd:	6a 44                	push   $0x44
  jmp alltraps
801085bf:	e9 83 f8 ff ff       	jmp    80107e47 <alltraps>

801085c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801085c4:	6a 00                	push   $0x0
  pushl $69
801085c6:	6a 45                	push   $0x45
  jmp alltraps
801085c8:	e9 7a f8 ff ff       	jmp    80107e47 <alltraps>

801085cd <vector70>:
.globl vector70
vector70:
  pushl $0
801085cd:	6a 00                	push   $0x0
  pushl $70
801085cf:	6a 46                	push   $0x46
  jmp alltraps
801085d1:	e9 71 f8 ff ff       	jmp    80107e47 <alltraps>

801085d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801085d6:	6a 00                	push   $0x0
  pushl $71
801085d8:	6a 47                	push   $0x47
  jmp alltraps
801085da:	e9 68 f8 ff ff       	jmp    80107e47 <alltraps>

801085df <vector72>:
.globl vector72
vector72:
  pushl $0
801085df:	6a 00                	push   $0x0
  pushl $72
801085e1:	6a 48                	push   $0x48
  jmp alltraps
801085e3:	e9 5f f8 ff ff       	jmp    80107e47 <alltraps>

801085e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801085e8:	6a 00                	push   $0x0
  pushl $73
801085ea:	6a 49                	push   $0x49
  jmp alltraps
801085ec:	e9 56 f8 ff ff       	jmp    80107e47 <alltraps>

801085f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801085f1:	6a 00                	push   $0x0
  pushl $74
801085f3:	6a 4a                	push   $0x4a
  jmp alltraps
801085f5:	e9 4d f8 ff ff       	jmp    80107e47 <alltraps>

801085fa <vector75>:
.globl vector75
vector75:
  pushl $0
801085fa:	6a 00                	push   $0x0
  pushl $75
801085fc:	6a 4b                	push   $0x4b
  jmp alltraps
801085fe:	e9 44 f8 ff ff       	jmp    80107e47 <alltraps>

80108603 <vector76>:
.globl vector76
vector76:
  pushl $0
80108603:	6a 00                	push   $0x0
  pushl $76
80108605:	6a 4c                	push   $0x4c
  jmp alltraps
80108607:	e9 3b f8 ff ff       	jmp    80107e47 <alltraps>

8010860c <vector77>:
.globl vector77
vector77:
  pushl $0
8010860c:	6a 00                	push   $0x0
  pushl $77
8010860e:	6a 4d                	push   $0x4d
  jmp alltraps
80108610:	e9 32 f8 ff ff       	jmp    80107e47 <alltraps>

80108615 <vector78>:
.globl vector78
vector78:
  pushl $0
80108615:	6a 00                	push   $0x0
  pushl $78
80108617:	6a 4e                	push   $0x4e
  jmp alltraps
80108619:	e9 29 f8 ff ff       	jmp    80107e47 <alltraps>

8010861e <vector79>:
.globl vector79
vector79:
  pushl $0
8010861e:	6a 00                	push   $0x0
  pushl $79
80108620:	6a 4f                	push   $0x4f
  jmp alltraps
80108622:	e9 20 f8 ff ff       	jmp    80107e47 <alltraps>

80108627 <vector80>:
.globl vector80
vector80:
  pushl $0
80108627:	6a 00                	push   $0x0
  pushl $80
80108629:	6a 50                	push   $0x50
  jmp alltraps
8010862b:	e9 17 f8 ff ff       	jmp    80107e47 <alltraps>

80108630 <vector81>:
.globl vector81
vector81:
  pushl $0
80108630:	6a 00                	push   $0x0
  pushl $81
80108632:	6a 51                	push   $0x51
  jmp alltraps
80108634:	e9 0e f8 ff ff       	jmp    80107e47 <alltraps>

80108639 <vector82>:
.globl vector82
vector82:
  pushl $0
80108639:	6a 00                	push   $0x0
  pushl $82
8010863b:	6a 52                	push   $0x52
  jmp alltraps
8010863d:	e9 05 f8 ff ff       	jmp    80107e47 <alltraps>

80108642 <vector83>:
.globl vector83
vector83:
  pushl $0
80108642:	6a 00                	push   $0x0
  pushl $83
80108644:	6a 53                	push   $0x53
  jmp alltraps
80108646:	e9 fc f7 ff ff       	jmp    80107e47 <alltraps>

8010864b <vector84>:
.globl vector84
vector84:
  pushl $0
8010864b:	6a 00                	push   $0x0
  pushl $84
8010864d:	6a 54                	push   $0x54
  jmp alltraps
8010864f:	e9 f3 f7 ff ff       	jmp    80107e47 <alltraps>

80108654 <vector85>:
.globl vector85
vector85:
  pushl $0
80108654:	6a 00                	push   $0x0
  pushl $85
80108656:	6a 55                	push   $0x55
  jmp alltraps
80108658:	e9 ea f7 ff ff       	jmp    80107e47 <alltraps>

8010865d <vector86>:
.globl vector86
vector86:
  pushl $0
8010865d:	6a 00                	push   $0x0
  pushl $86
8010865f:	6a 56                	push   $0x56
  jmp alltraps
80108661:	e9 e1 f7 ff ff       	jmp    80107e47 <alltraps>

80108666 <vector87>:
.globl vector87
vector87:
  pushl $0
80108666:	6a 00                	push   $0x0
  pushl $87
80108668:	6a 57                	push   $0x57
  jmp alltraps
8010866a:	e9 d8 f7 ff ff       	jmp    80107e47 <alltraps>

8010866f <vector88>:
.globl vector88
vector88:
  pushl $0
8010866f:	6a 00                	push   $0x0
  pushl $88
80108671:	6a 58                	push   $0x58
  jmp alltraps
80108673:	e9 cf f7 ff ff       	jmp    80107e47 <alltraps>

80108678 <vector89>:
.globl vector89
vector89:
  pushl $0
80108678:	6a 00                	push   $0x0
  pushl $89
8010867a:	6a 59                	push   $0x59
  jmp alltraps
8010867c:	e9 c6 f7 ff ff       	jmp    80107e47 <alltraps>

80108681 <vector90>:
.globl vector90
vector90:
  pushl $0
80108681:	6a 00                	push   $0x0
  pushl $90
80108683:	6a 5a                	push   $0x5a
  jmp alltraps
80108685:	e9 bd f7 ff ff       	jmp    80107e47 <alltraps>

8010868a <vector91>:
.globl vector91
vector91:
  pushl $0
8010868a:	6a 00                	push   $0x0
  pushl $91
8010868c:	6a 5b                	push   $0x5b
  jmp alltraps
8010868e:	e9 b4 f7 ff ff       	jmp    80107e47 <alltraps>

80108693 <vector92>:
.globl vector92
vector92:
  pushl $0
80108693:	6a 00                	push   $0x0
  pushl $92
80108695:	6a 5c                	push   $0x5c
  jmp alltraps
80108697:	e9 ab f7 ff ff       	jmp    80107e47 <alltraps>

8010869c <vector93>:
.globl vector93
vector93:
  pushl $0
8010869c:	6a 00                	push   $0x0
  pushl $93
8010869e:	6a 5d                	push   $0x5d
  jmp alltraps
801086a0:	e9 a2 f7 ff ff       	jmp    80107e47 <alltraps>

801086a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801086a5:	6a 00                	push   $0x0
  pushl $94
801086a7:	6a 5e                	push   $0x5e
  jmp alltraps
801086a9:	e9 99 f7 ff ff       	jmp    80107e47 <alltraps>

801086ae <vector95>:
.globl vector95
vector95:
  pushl $0
801086ae:	6a 00                	push   $0x0
  pushl $95
801086b0:	6a 5f                	push   $0x5f
  jmp alltraps
801086b2:	e9 90 f7 ff ff       	jmp    80107e47 <alltraps>

801086b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801086b7:	6a 00                	push   $0x0
  pushl $96
801086b9:	6a 60                	push   $0x60
  jmp alltraps
801086bb:	e9 87 f7 ff ff       	jmp    80107e47 <alltraps>

801086c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801086c0:	6a 00                	push   $0x0
  pushl $97
801086c2:	6a 61                	push   $0x61
  jmp alltraps
801086c4:	e9 7e f7 ff ff       	jmp    80107e47 <alltraps>

801086c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801086c9:	6a 00                	push   $0x0
  pushl $98
801086cb:	6a 62                	push   $0x62
  jmp alltraps
801086cd:	e9 75 f7 ff ff       	jmp    80107e47 <alltraps>

801086d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801086d2:	6a 00                	push   $0x0
  pushl $99
801086d4:	6a 63                	push   $0x63
  jmp alltraps
801086d6:	e9 6c f7 ff ff       	jmp    80107e47 <alltraps>

801086db <vector100>:
.globl vector100
vector100:
  pushl $0
801086db:	6a 00                	push   $0x0
  pushl $100
801086dd:	6a 64                	push   $0x64
  jmp alltraps
801086df:	e9 63 f7 ff ff       	jmp    80107e47 <alltraps>

801086e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801086e4:	6a 00                	push   $0x0
  pushl $101
801086e6:	6a 65                	push   $0x65
  jmp alltraps
801086e8:	e9 5a f7 ff ff       	jmp    80107e47 <alltraps>

801086ed <vector102>:
.globl vector102
vector102:
  pushl $0
801086ed:	6a 00                	push   $0x0
  pushl $102
801086ef:	6a 66                	push   $0x66
  jmp alltraps
801086f1:	e9 51 f7 ff ff       	jmp    80107e47 <alltraps>

801086f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801086f6:	6a 00                	push   $0x0
  pushl $103
801086f8:	6a 67                	push   $0x67
  jmp alltraps
801086fa:	e9 48 f7 ff ff       	jmp    80107e47 <alltraps>

801086ff <vector104>:
.globl vector104
vector104:
  pushl $0
801086ff:	6a 00                	push   $0x0
  pushl $104
80108701:	6a 68                	push   $0x68
  jmp alltraps
80108703:	e9 3f f7 ff ff       	jmp    80107e47 <alltraps>

80108708 <vector105>:
.globl vector105
vector105:
  pushl $0
80108708:	6a 00                	push   $0x0
  pushl $105
8010870a:	6a 69                	push   $0x69
  jmp alltraps
8010870c:	e9 36 f7 ff ff       	jmp    80107e47 <alltraps>

80108711 <vector106>:
.globl vector106
vector106:
  pushl $0
80108711:	6a 00                	push   $0x0
  pushl $106
80108713:	6a 6a                	push   $0x6a
  jmp alltraps
80108715:	e9 2d f7 ff ff       	jmp    80107e47 <alltraps>

8010871a <vector107>:
.globl vector107
vector107:
  pushl $0
8010871a:	6a 00                	push   $0x0
  pushl $107
8010871c:	6a 6b                	push   $0x6b
  jmp alltraps
8010871e:	e9 24 f7 ff ff       	jmp    80107e47 <alltraps>

80108723 <vector108>:
.globl vector108
vector108:
  pushl $0
80108723:	6a 00                	push   $0x0
  pushl $108
80108725:	6a 6c                	push   $0x6c
  jmp alltraps
80108727:	e9 1b f7 ff ff       	jmp    80107e47 <alltraps>

8010872c <vector109>:
.globl vector109
vector109:
  pushl $0
8010872c:	6a 00                	push   $0x0
  pushl $109
8010872e:	6a 6d                	push   $0x6d
  jmp alltraps
80108730:	e9 12 f7 ff ff       	jmp    80107e47 <alltraps>

80108735 <vector110>:
.globl vector110
vector110:
  pushl $0
80108735:	6a 00                	push   $0x0
  pushl $110
80108737:	6a 6e                	push   $0x6e
  jmp alltraps
80108739:	e9 09 f7 ff ff       	jmp    80107e47 <alltraps>

8010873e <vector111>:
.globl vector111
vector111:
  pushl $0
8010873e:	6a 00                	push   $0x0
  pushl $111
80108740:	6a 6f                	push   $0x6f
  jmp alltraps
80108742:	e9 00 f7 ff ff       	jmp    80107e47 <alltraps>

80108747 <vector112>:
.globl vector112
vector112:
  pushl $0
80108747:	6a 00                	push   $0x0
  pushl $112
80108749:	6a 70                	push   $0x70
  jmp alltraps
8010874b:	e9 f7 f6 ff ff       	jmp    80107e47 <alltraps>

80108750 <vector113>:
.globl vector113
vector113:
  pushl $0
80108750:	6a 00                	push   $0x0
  pushl $113
80108752:	6a 71                	push   $0x71
  jmp alltraps
80108754:	e9 ee f6 ff ff       	jmp    80107e47 <alltraps>

80108759 <vector114>:
.globl vector114
vector114:
  pushl $0
80108759:	6a 00                	push   $0x0
  pushl $114
8010875b:	6a 72                	push   $0x72
  jmp alltraps
8010875d:	e9 e5 f6 ff ff       	jmp    80107e47 <alltraps>

80108762 <vector115>:
.globl vector115
vector115:
  pushl $0
80108762:	6a 00                	push   $0x0
  pushl $115
80108764:	6a 73                	push   $0x73
  jmp alltraps
80108766:	e9 dc f6 ff ff       	jmp    80107e47 <alltraps>

8010876b <vector116>:
.globl vector116
vector116:
  pushl $0
8010876b:	6a 00                	push   $0x0
  pushl $116
8010876d:	6a 74                	push   $0x74
  jmp alltraps
8010876f:	e9 d3 f6 ff ff       	jmp    80107e47 <alltraps>

80108774 <vector117>:
.globl vector117
vector117:
  pushl $0
80108774:	6a 00                	push   $0x0
  pushl $117
80108776:	6a 75                	push   $0x75
  jmp alltraps
80108778:	e9 ca f6 ff ff       	jmp    80107e47 <alltraps>

8010877d <vector118>:
.globl vector118
vector118:
  pushl $0
8010877d:	6a 00                	push   $0x0
  pushl $118
8010877f:	6a 76                	push   $0x76
  jmp alltraps
80108781:	e9 c1 f6 ff ff       	jmp    80107e47 <alltraps>

80108786 <vector119>:
.globl vector119
vector119:
  pushl $0
80108786:	6a 00                	push   $0x0
  pushl $119
80108788:	6a 77                	push   $0x77
  jmp alltraps
8010878a:	e9 b8 f6 ff ff       	jmp    80107e47 <alltraps>

8010878f <vector120>:
.globl vector120
vector120:
  pushl $0
8010878f:	6a 00                	push   $0x0
  pushl $120
80108791:	6a 78                	push   $0x78
  jmp alltraps
80108793:	e9 af f6 ff ff       	jmp    80107e47 <alltraps>

80108798 <vector121>:
.globl vector121
vector121:
  pushl $0
80108798:	6a 00                	push   $0x0
  pushl $121
8010879a:	6a 79                	push   $0x79
  jmp alltraps
8010879c:	e9 a6 f6 ff ff       	jmp    80107e47 <alltraps>

801087a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801087a1:	6a 00                	push   $0x0
  pushl $122
801087a3:	6a 7a                	push   $0x7a
  jmp alltraps
801087a5:	e9 9d f6 ff ff       	jmp    80107e47 <alltraps>

801087aa <vector123>:
.globl vector123
vector123:
  pushl $0
801087aa:	6a 00                	push   $0x0
  pushl $123
801087ac:	6a 7b                	push   $0x7b
  jmp alltraps
801087ae:	e9 94 f6 ff ff       	jmp    80107e47 <alltraps>

801087b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801087b3:	6a 00                	push   $0x0
  pushl $124
801087b5:	6a 7c                	push   $0x7c
  jmp alltraps
801087b7:	e9 8b f6 ff ff       	jmp    80107e47 <alltraps>

801087bc <vector125>:
.globl vector125
vector125:
  pushl $0
801087bc:	6a 00                	push   $0x0
  pushl $125
801087be:	6a 7d                	push   $0x7d
  jmp alltraps
801087c0:	e9 82 f6 ff ff       	jmp    80107e47 <alltraps>

801087c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801087c5:	6a 00                	push   $0x0
  pushl $126
801087c7:	6a 7e                	push   $0x7e
  jmp alltraps
801087c9:	e9 79 f6 ff ff       	jmp    80107e47 <alltraps>

801087ce <vector127>:
.globl vector127
vector127:
  pushl $0
801087ce:	6a 00                	push   $0x0
  pushl $127
801087d0:	6a 7f                	push   $0x7f
  jmp alltraps
801087d2:	e9 70 f6 ff ff       	jmp    80107e47 <alltraps>

801087d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801087d7:	6a 00                	push   $0x0
  pushl $128
801087d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801087de:	e9 64 f6 ff ff       	jmp    80107e47 <alltraps>

801087e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801087e3:	6a 00                	push   $0x0
  pushl $129
801087e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801087ea:	e9 58 f6 ff ff       	jmp    80107e47 <alltraps>

801087ef <vector130>:
.globl vector130
vector130:
  pushl $0
801087ef:	6a 00                	push   $0x0
  pushl $130
801087f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801087f6:	e9 4c f6 ff ff       	jmp    80107e47 <alltraps>

801087fb <vector131>:
.globl vector131
vector131:
  pushl $0
801087fb:	6a 00                	push   $0x0
  pushl $131
801087fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108802:	e9 40 f6 ff ff       	jmp    80107e47 <alltraps>

80108807 <vector132>:
.globl vector132
vector132:
  pushl $0
80108807:	6a 00                	push   $0x0
  pushl $132
80108809:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010880e:	e9 34 f6 ff ff       	jmp    80107e47 <alltraps>

80108813 <vector133>:
.globl vector133
vector133:
  pushl $0
80108813:	6a 00                	push   $0x0
  pushl $133
80108815:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010881a:	e9 28 f6 ff ff       	jmp    80107e47 <alltraps>

8010881f <vector134>:
.globl vector134
vector134:
  pushl $0
8010881f:	6a 00                	push   $0x0
  pushl $134
80108821:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108826:	e9 1c f6 ff ff       	jmp    80107e47 <alltraps>

8010882b <vector135>:
.globl vector135
vector135:
  pushl $0
8010882b:	6a 00                	push   $0x0
  pushl $135
8010882d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108832:	e9 10 f6 ff ff       	jmp    80107e47 <alltraps>

80108837 <vector136>:
.globl vector136
vector136:
  pushl $0
80108837:	6a 00                	push   $0x0
  pushl $136
80108839:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010883e:	e9 04 f6 ff ff       	jmp    80107e47 <alltraps>

80108843 <vector137>:
.globl vector137
vector137:
  pushl $0
80108843:	6a 00                	push   $0x0
  pushl $137
80108845:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010884a:	e9 f8 f5 ff ff       	jmp    80107e47 <alltraps>

8010884f <vector138>:
.globl vector138
vector138:
  pushl $0
8010884f:	6a 00                	push   $0x0
  pushl $138
80108851:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108856:	e9 ec f5 ff ff       	jmp    80107e47 <alltraps>

8010885b <vector139>:
.globl vector139
vector139:
  pushl $0
8010885b:	6a 00                	push   $0x0
  pushl $139
8010885d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108862:	e9 e0 f5 ff ff       	jmp    80107e47 <alltraps>

80108867 <vector140>:
.globl vector140
vector140:
  pushl $0
80108867:	6a 00                	push   $0x0
  pushl $140
80108869:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010886e:	e9 d4 f5 ff ff       	jmp    80107e47 <alltraps>

80108873 <vector141>:
.globl vector141
vector141:
  pushl $0
80108873:	6a 00                	push   $0x0
  pushl $141
80108875:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010887a:	e9 c8 f5 ff ff       	jmp    80107e47 <alltraps>

8010887f <vector142>:
.globl vector142
vector142:
  pushl $0
8010887f:	6a 00                	push   $0x0
  pushl $142
80108881:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108886:	e9 bc f5 ff ff       	jmp    80107e47 <alltraps>

8010888b <vector143>:
.globl vector143
vector143:
  pushl $0
8010888b:	6a 00                	push   $0x0
  pushl $143
8010888d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108892:	e9 b0 f5 ff ff       	jmp    80107e47 <alltraps>

80108897 <vector144>:
.globl vector144
vector144:
  pushl $0
80108897:	6a 00                	push   $0x0
  pushl $144
80108899:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010889e:	e9 a4 f5 ff ff       	jmp    80107e47 <alltraps>

801088a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801088a3:	6a 00                	push   $0x0
  pushl $145
801088a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801088aa:	e9 98 f5 ff ff       	jmp    80107e47 <alltraps>

801088af <vector146>:
.globl vector146
vector146:
  pushl $0
801088af:	6a 00                	push   $0x0
  pushl $146
801088b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801088b6:	e9 8c f5 ff ff       	jmp    80107e47 <alltraps>

801088bb <vector147>:
.globl vector147
vector147:
  pushl $0
801088bb:	6a 00                	push   $0x0
  pushl $147
801088bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801088c2:	e9 80 f5 ff ff       	jmp    80107e47 <alltraps>

801088c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801088c7:	6a 00                	push   $0x0
  pushl $148
801088c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801088ce:	e9 74 f5 ff ff       	jmp    80107e47 <alltraps>

801088d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801088d3:	6a 00                	push   $0x0
  pushl $149
801088d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801088da:	e9 68 f5 ff ff       	jmp    80107e47 <alltraps>

801088df <vector150>:
.globl vector150
vector150:
  pushl $0
801088df:	6a 00                	push   $0x0
  pushl $150
801088e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801088e6:	e9 5c f5 ff ff       	jmp    80107e47 <alltraps>

801088eb <vector151>:
.globl vector151
vector151:
  pushl $0
801088eb:	6a 00                	push   $0x0
  pushl $151
801088ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801088f2:	e9 50 f5 ff ff       	jmp    80107e47 <alltraps>

801088f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801088f7:	6a 00                	push   $0x0
  pushl $152
801088f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801088fe:	e9 44 f5 ff ff       	jmp    80107e47 <alltraps>

80108903 <vector153>:
.globl vector153
vector153:
  pushl $0
80108903:	6a 00                	push   $0x0
  pushl $153
80108905:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010890a:	e9 38 f5 ff ff       	jmp    80107e47 <alltraps>

8010890f <vector154>:
.globl vector154
vector154:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $154
80108911:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108916:	e9 2c f5 ff ff       	jmp    80107e47 <alltraps>

8010891b <vector155>:
.globl vector155
vector155:
  pushl $0
8010891b:	6a 00                	push   $0x0
  pushl $155
8010891d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108922:	e9 20 f5 ff ff       	jmp    80107e47 <alltraps>

80108927 <vector156>:
.globl vector156
vector156:
  pushl $0
80108927:	6a 00                	push   $0x0
  pushl $156
80108929:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010892e:	e9 14 f5 ff ff       	jmp    80107e47 <alltraps>

80108933 <vector157>:
.globl vector157
vector157:
  pushl $0
80108933:	6a 00                	push   $0x0
  pushl $157
80108935:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010893a:	e9 08 f5 ff ff       	jmp    80107e47 <alltraps>

8010893f <vector158>:
.globl vector158
vector158:
  pushl $0
8010893f:	6a 00                	push   $0x0
  pushl $158
80108941:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108946:	e9 fc f4 ff ff       	jmp    80107e47 <alltraps>

8010894b <vector159>:
.globl vector159
vector159:
  pushl $0
8010894b:	6a 00                	push   $0x0
  pushl $159
8010894d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108952:	e9 f0 f4 ff ff       	jmp    80107e47 <alltraps>

80108957 <vector160>:
.globl vector160
vector160:
  pushl $0
80108957:	6a 00                	push   $0x0
  pushl $160
80108959:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010895e:	e9 e4 f4 ff ff       	jmp    80107e47 <alltraps>

80108963 <vector161>:
.globl vector161
vector161:
  pushl $0
80108963:	6a 00                	push   $0x0
  pushl $161
80108965:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010896a:	e9 d8 f4 ff ff       	jmp    80107e47 <alltraps>

8010896f <vector162>:
.globl vector162
vector162:
  pushl $0
8010896f:	6a 00                	push   $0x0
  pushl $162
80108971:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108976:	e9 cc f4 ff ff       	jmp    80107e47 <alltraps>

8010897b <vector163>:
.globl vector163
vector163:
  pushl $0
8010897b:	6a 00                	push   $0x0
  pushl $163
8010897d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108982:	e9 c0 f4 ff ff       	jmp    80107e47 <alltraps>

80108987 <vector164>:
.globl vector164
vector164:
  pushl $0
80108987:	6a 00                	push   $0x0
  pushl $164
80108989:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010898e:	e9 b4 f4 ff ff       	jmp    80107e47 <alltraps>

80108993 <vector165>:
.globl vector165
vector165:
  pushl $0
80108993:	6a 00                	push   $0x0
  pushl $165
80108995:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010899a:	e9 a8 f4 ff ff       	jmp    80107e47 <alltraps>

8010899f <vector166>:
.globl vector166
vector166:
  pushl $0
8010899f:	6a 00                	push   $0x0
  pushl $166
801089a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801089a6:	e9 9c f4 ff ff       	jmp    80107e47 <alltraps>

801089ab <vector167>:
.globl vector167
vector167:
  pushl $0
801089ab:	6a 00                	push   $0x0
  pushl $167
801089ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801089b2:	e9 90 f4 ff ff       	jmp    80107e47 <alltraps>

801089b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801089b7:	6a 00                	push   $0x0
  pushl $168
801089b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801089be:	e9 84 f4 ff ff       	jmp    80107e47 <alltraps>

801089c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801089c3:	6a 00                	push   $0x0
  pushl $169
801089c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801089ca:	e9 78 f4 ff ff       	jmp    80107e47 <alltraps>

801089cf <vector170>:
.globl vector170
vector170:
  pushl $0
801089cf:	6a 00                	push   $0x0
  pushl $170
801089d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801089d6:	e9 6c f4 ff ff       	jmp    80107e47 <alltraps>

801089db <vector171>:
.globl vector171
vector171:
  pushl $0
801089db:	6a 00                	push   $0x0
  pushl $171
801089dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801089e2:	e9 60 f4 ff ff       	jmp    80107e47 <alltraps>

801089e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801089e7:	6a 00                	push   $0x0
  pushl $172
801089e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801089ee:	e9 54 f4 ff ff       	jmp    80107e47 <alltraps>

801089f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801089f3:	6a 00                	push   $0x0
  pushl $173
801089f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801089fa:	e9 48 f4 ff ff       	jmp    80107e47 <alltraps>

801089ff <vector174>:
.globl vector174
vector174:
  pushl $0
801089ff:	6a 00                	push   $0x0
  pushl $174
80108a01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108a06:	e9 3c f4 ff ff       	jmp    80107e47 <alltraps>

80108a0b <vector175>:
.globl vector175
vector175:
  pushl $0
80108a0b:	6a 00                	push   $0x0
  pushl $175
80108a0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108a12:	e9 30 f4 ff ff       	jmp    80107e47 <alltraps>

80108a17 <vector176>:
.globl vector176
vector176:
  pushl $0
80108a17:	6a 00                	push   $0x0
  pushl $176
80108a19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108a1e:	e9 24 f4 ff ff       	jmp    80107e47 <alltraps>

80108a23 <vector177>:
.globl vector177
vector177:
  pushl $0
80108a23:	6a 00                	push   $0x0
  pushl $177
80108a25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108a2a:	e9 18 f4 ff ff       	jmp    80107e47 <alltraps>

80108a2f <vector178>:
.globl vector178
vector178:
  pushl $0
80108a2f:	6a 00                	push   $0x0
  pushl $178
80108a31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108a36:	e9 0c f4 ff ff       	jmp    80107e47 <alltraps>

80108a3b <vector179>:
.globl vector179
vector179:
  pushl $0
80108a3b:	6a 00                	push   $0x0
  pushl $179
80108a3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108a42:	e9 00 f4 ff ff       	jmp    80107e47 <alltraps>

80108a47 <vector180>:
.globl vector180
vector180:
  pushl $0
80108a47:	6a 00                	push   $0x0
  pushl $180
80108a49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108a4e:	e9 f4 f3 ff ff       	jmp    80107e47 <alltraps>

80108a53 <vector181>:
.globl vector181
vector181:
  pushl $0
80108a53:	6a 00                	push   $0x0
  pushl $181
80108a55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108a5a:	e9 e8 f3 ff ff       	jmp    80107e47 <alltraps>

80108a5f <vector182>:
.globl vector182
vector182:
  pushl $0
80108a5f:	6a 00                	push   $0x0
  pushl $182
80108a61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108a66:	e9 dc f3 ff ff       	jmp    80107e47 <alltraps>

80108a6b <vector183>:
.globl vector183
vector183:
  pushl $0
80108a6b:	6a 00                	push   $0x0
  pushl $183
80108a6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108a72:	e9 d0 f3 ff ff       	jmp    80107e47 <alltraps>

80108a77 <vector184>:
.globl vector184
vector184:
  pushl $0
80108a77:	6a 00                	push   $0x0
  pushl $184
80108a79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108a7e:	e9 c4 f3 ff ff       	jmp    80107e47 <alltraps>

80108a83 <vector185>:
.globl vector185
vector185:
  pushl $0
80108a83:	6a 00                	push   $0x0
  pushl $185
80108a85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108a8a:	e9 b8 f3 ff ff       	jmp    80107e47 <alltraps>

80108a8f <vector186>:
.globl vector186
vector186:
  pushl $0
80108a8f:	6a 00                	push   $0x0
  pushl $186
80108a91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108a96:	e9 ac f3 ff ff       	jmp    80107e47 <alltraps>

80108a9b <vector187>:
.globl vector187
vector187:
  pushl $0
80108a9b:	6a 00                	push   $0x0
  pushl $187
80108a9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108aa2:	e9 a0 f3 ff ff       	jmp    80107e47 <alltraps>

80108aa7 <vector188>:
.globl vector188
vector188:
  pushl $0
80108aa7:	6a 00                	push   $0x0
  pushl $188
80108aa9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108aae:	e9 94 f3 ff ff       	jmp    80107e47 <alltraps>

80108ab3 <vector189>:
.globl vector189
vector189:
  pushl $0
80108ab3:	6a 00                	push   $0x0
  pushl $189
80108ab5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108aba:	e9 88 f3 ff ff       	jmp    80107e47 <alltraps>

80108abf <vector190>:
.globl vector190
vector190:
  pushl $0
80108abf:	6a 00                	push   $0x0
  pushl $190
80108ac1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108ac6:	e9 7c f3 ff ff       	jmp    80107e47 <alltraps>

80108acb <vector191>:
.globl vector191
vector191:
  pushl $0
80108acb:	6a 00                	push   $0x0
  pushl $191
80108acd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108ad2:	e9 70 f3 ff ff       	jmp    80107e47 <alltraps>

80108ad7 <vector192>:
.globl vector192
vector192:
  pushl $0
80108ad7:	6a 00                	push   $0x0
  pushl $192
80108ad9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108ade:	e9 64 f3 ff ff       	jmp    80107e47 <alltraps>

80108ae3 <vector193>:
.globl vector193
vector193:
  pushl $0
80108ae3:	6a 00                	push   $0x0
  pushl $193
80108ae5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108aea:	e9 58 f3 ff ff       	jmp    80107e47 <alltraps>

80108aef <vector194>:
.globl vector194
vector194:
  pushl $0
80108aef:	6a 00                	push   $0x0
  pushl $194
80108af1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108af6:	e9 4c f3 ff ff       	jmp    80107e47 <alltraps>

80108afb <vector195>:
.globl vector195
vector195:
  pushl $0
80108afb:	6a 00                	push   $0x0
  pushl $195
80108afd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108b02:	e9 40 f3 ff ff       	jmp    80107e47 <alltraps>

80108b07 <vector196>:
.globl vector196
vector196:
  pushl $0
80108b07:	6a 00                	push   $0x0
  pushl $196
80108b09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108b0e:	e9 34 f3 ff ff       	jmp    80107e47 <alltraps>

80108b13 <vector197>:
.globl vector197
vector197:
  pushl $0
80108b13:	6a 00                	push   $0x0
  pushl $197
80108b15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108b1a:	e9 28 f3 ff ff       	jmp    80107e47 <alltraps>

80108b1f <vector198>:
.globl vector198
vector198:
  pushl $0
80108b1f:	6a 00                	push   $0x0
  pushl $198
80108b21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108b26:	e9 1c f3 ff ff       	jmp    80107e47 <alltraps>

80108b2b <vector199>:
.globl vector199
vector199:
  pushl $0
80108b2b:	6a 00                	push   $0x0
  pushl $199
80108b2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108b32:	e9 10 f3 ff ff       	jmp    80107e47 <alltraps>

80108b37 <vector200>:
.globl vector200
vector200:
  pushl $0
80108b37:	6a 00                	push   $0x0
  pushl $200
80108b39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108b3e:	e9 04 f3 ff ff       	jmp    80107e47 <alltraps>

80108b43 <vector201>:
.globl vector201
vector201:
  pushl $0
80108b43:	6a 00                	push   $0x0
  pushl $201
80108b45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108b4a:	e9 f8 f2 ff ff       	jmp    80107e47 <alltraps>

80108b4f <vector202>:
.globl vector202
vector202:
  pushl $0
80108b4f:	6a 00                	push   $0x0
  pushl $202
80108b51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108b56:	e9 ec f2 ff ff       	jmp    80107e47 <alltraps>

80108b5b <vector203>:
.globl vector203
vector203:
  pushl $0
80108b5b:	6a 00                	push   $0x0
  pushl $203
80108b5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108b62:	e9 e0 f2 ff ff       	jmp    80107e47 <alltraps>

80108b67 <vector204>:
.globl vector204
vector204:
  pushl $0
80108b67:	6a 00                	push   $0x0
  pushl $204
80108b69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108b6e:	e9 d4 f2 ff ff       	jmp    80107e47 <alltraps>

80108b73 <vector205>:
.globl vector205
vector205:
  pushl $0
80108b73:	6a 00                	push   $0x0
  pushl $205
80108b75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108b7a:	e9 c8 f2 ff ff       	jmp    80107e47 <alltraps>

80108b7f <vector206>:
.globl vector206
vector206:
  pushl $0
80108b7f:	6a 00                	push   $0x0
  pushl $206
80108b81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108b86:	e9 bc f2 ff ff       	jmp    80107e47 <alltraps>

80108b8b <vector207>:
.globl vector207
vector207:
  pushl $0
80108b8b:	6a 00                	push   $0x0
  pushl $207
80108b8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108b92:	e9 b0 f2 ff ff       	jmp    80107e47 <alltraps>

80108b97 <vector208>:
.globl vector208
vector208:
  pushl $0
80108b97:	6a 00                	push   $0x0
  pushl $208
80108b99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108b9e:	e9 a4 f2 ff ff       	jmp    80107e47 <alltraps>

80108ba3 <vector209>:
.globl vector209
vector209:
  pushl $0
80108ba3:	6a 00                	push   $0x0
  pushl $209
80108ba5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108baa:	e9 98 f2 ff ff       	jmp    80107e47 <alltraps>

80108baf <vector210>:
.globl vector210
vector210:
  pushl $0
80108baf:	6a 00                	push   $0x0
  pushl $210
80108bb1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108bb6:	e9 8c f2 ff ff       	jmp    80107e47 <alltraps>

80108bbb <vector211>:
.globl vector211
vector211:
  pushl $0
80108bbb:	6a 00                	push   $0x0
  pushl $211
80108bbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108bc2:	e9 80 f2 ff ff       	jmp    80107e47 <alltraps>

80108bc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80108bc7:	6a 00                	push   $0x0
  pushl $212
80108bc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108bce:	e9 74 f2 ff ff       	jmp    80107e47 <alltraps>

80108bd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80108bd3:	6a 00                	push   $0x0
  pushl $213
80108bd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108bda:	e9 68 f2 ff ff       	jmp    80107e47 <alltraps>

80108bdf <vector214>:
.globl vector214
vector214:
  pushl $0
80108bdf:	6a 00                	push   $0x0
  pushl $214
80108be1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108be6:	e9 5c f2 ff ff       	jmp    80107e47 <alltraps>

80108beb <vector215>:
.globl vector215
vector215:
  pushl $0
80108beb:	6a 00                	push   $0x0
  pushl $215
80108bed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108bf2:	e9 50 f2 ff ff       	jmp    80107e47 <alltraps>

80108bf7 <vector216>:
.globl vector216
vector216:
  pushl $0
80108bf7:	6a 00                	push   $0x0
  pushl $216
80108bf9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108bfe:	e9 44 f2 ff ff       	jmp    80107e47 <alltraps>

80108c03 <vector217>:
.globl vector217
vector217:
  pushl $0
80108c03:	6a 00                	push   $0x0
  pushl $217
80108c05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108c0a:	e9 38 f2 ff ff       	jmp    80107e47 <alltraps>

80108c0f <vector218>:
.globl vector218
vector218:
  pushl $0
80108c0f:	6a 00                	push   $0x0
  pushl $218
80108c11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108c16:	e9 2c f2 ff ff       	jmp    80107e47 <alltraps>

80108c1b <vector219>:
.globl vector219
vector219:
  pushl $0
80108c1b:	6a 00                	push   $0x0
  pushl $219
80108c1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108c22:	e9 20 f2 ff ff       	jmp    80107e47 <alltraps>

80108c27 <vector220>:
.globl vector220
vector220:
  pushl $0
80108c27:	6a 00                	push   $0x0
  pushl $220
80108c29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108c2e:	e9 14 f2 ff ff       	jmp    80107e47 <alltraps>

80108c33 <vector221>:
.globl vector221
vector221:
  pushl $0
80108c33:	6a 00                	push   $0x0
  pushl $221
80108c35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108c3a:	e9 08 f2 ff ff       	jmp    80107e47 <alltraps>

80108c3f <vector222>:
.globl vector222
vector222:
  pushl $0
80108c3f:	6a 00                	push   $0x0
  pushl $222
80108c41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108c46:	e9 fc f1 ff ff       	jmp    80107e47 <alltraps>

80108c4b <vector223>:
.globl vector223
vector223:
  pushl $0
80108c4b:	6a 00                	push   $0x0
  pushl $223
80108c4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108c52:	e9 f0 f1 ff ff       	jmp    80107e47 <alltraps>

80108c57 <vector224>:
.globl vector224
vector224:
  pushl $0
80108c57:	6a 00                	push   $0x0
  pushl $224
80108c59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108c5e:	e9 e4 f1 ff ff       	jmp    80107e47 <alltraps>

80108c63 <vector225>:
.globl vector225
vector225:
  pushl $0
80108c63:	6a 00                	push   $0x0
  pushl $225
80108c65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108c6a:	e9 d8 f1 ff ff       	jmp    80107e47 <alltraps>

80108c6f <vector226>:
.globl vector226
vector226:
  pushl $0
80108c6f:	6a 00                	push   $0x0
  pushl $226
80108c71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108c76:	e9 cc f1 ff ff       	jmp    80107e47 <alltraps>

80108c7b <vector227>:
.globl vector227
vector227:
  pushl $0
80108c7b:	6a 00                	push   $0x0
  pushl $227
80108c7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108c82:	e9 c0 f1 ff ff       	jmp    80107e47 <alltraps>

80108c87 <vector228>:
.globl vector228
vector228:
  pushl $0
80108c87:	6a 00                	push   $0x0
  pushl $228
80108c89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108c8e:	e9 b4 f1 ff ff       	jmp    80107e47 <alltraps>

80108c93 <vector229>:
.globl vector229
vector229:
  pushl $0
80108c93:	6a 00                	push   $0x0
  pushl $229
80108c95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108c9a:	e9 a8 f1 ff ff       	jmp    80107e47 <alltraps>

80108c9f <vector230>:
.globl vector230
vector230:
  pushl $0
80108c9f:	6a 00                	push   $0x0
  pushl $230
80108ca1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108ca6:	e9 9c f1 ff ff       	jmp    80107e47 <alltraps>

80108cab <vector231>:
.globl vector231
vector231:
  pushl $0
80108cab:	6a 00                	push   $0x0
  pushl $231
80108cad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108cb2:	e9 90 f1 ff ff       	jmp    80107e47 <alltraps>

80108cb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80108cb7:	6a 00                	push   $0x0
  pushl $232
80108cb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108cbe:	e9 84 f1 ff ff       	jmp    80107e47 <alltraps>

80108cc3 <vector233>:
.globl vector233
vector233:
  pushl $0
80108cc3:	6a 00                	push   $0x0
  pushl $233
80108cc5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108cca:	e9 78 f1 ff ff       	jmp    80107e47 <alltraps>

80108ccf <vector234>:
.globl vector234
vector234:
  pushl $0
80108ccf:	6a 00                	push   $0x0
  pushl $234
80108cd1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108cd6:	e9 6c f1 ff ff       	jmp    80107e47 <alltraps>

80108cdb <vector235>:
.globl vector235
vector235:
  pushl $0
80108cdb:	6a 00                	push   $0x0
  pushl $235
80108cdd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108ce2:	e9 60 f1 ff ff       	jmp    80107e47 <alltraps>

80108ce7 <vector236>:
.globl vector236
vector236:
  pushl $0
80108ce7:	6a 00                	push   $0x0
  pushl $236
80108ce9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108cee:	e9 54 f1 ff ff       	jmp    80107e47 <alltraps>

80108cf3 <vector237>:
.globl vector237
vector237:
  pushl $0
80108cf3:	6a 00                	push   $0x0
  pushl $237
80108cf5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108cfa:	e9 48 f1 ff ff       	jmp    80107e47 <alltraps>

80108cff <vector238>:
.globl vector238
vector238:
  pushl $0
80108cff:	6a 00                	push   $0x0
  pushl $238
80108d01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108d06:	e9 3c f1 ff ff       	jmp    80107e47 <alltraps>

80108d0b <vector239>:
.globl vector239
vector239:
  pushl $0
80108d0b:	6a 00                	push   $0x0
  pushl $239
80108d0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108d12:	e9 30 f1 ff ff       	jmp    80107e47 <alltraps>

80108d17 <vector240>:
.globl vector240
vector240:
  pushl $0
80108d17:	6a 00                	push   $0x0
  pushl $240
80108d19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108d1e:	e9 24 f1 ff ff       	jmp    80107e47 <alltraps>

80108d23 <vector241>:
.globl vector241
vector241:
  pushl $0
80108d23:	6a 00                	push   $0x0
  pushl $241
80108d25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108d2a:	e9 18 f1 ff ff       	jmp    80107e47 <alltraps>

80108d2f <vector242>:
.globl vector242
vector242:
  pushl $0
80108d2f:	6a 00                	push   $0x0
  pushl $242
80108d31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108d36:	e9 0c f1 ff ff       	jmp    80107e47 <alltraps>

80108d3b <vector243>:
.globl vector243
vector243:
  pushl $0
80108d3b:	6a 00                	push   $0x0
  pushl $243
80108d3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108d42:	e9 00 f1 ff ff       	jmp    80107e47 <alltraps>

80108d47 <vector244>:
.globl vector244
vector244:
  pushl $0
80108d47:	6a 00                	push   $0x0
  pushl $244
80108d49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108d4e:	e9 f4 f0 ff ff       	jmp    80107e47 <alltraps>

80108d53 <vector245>:
.globl vector245
vector245:
  pushl $0
80108d53:	6a 00                	push   $0x0
  pushl $245
80108d55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108d5a:	e9 e8 f0 ff ff       	jmp    80107e47 <alltraps>

80108d5f <vector246>:
.globl vector246
vector246:
  pushl $0
80108d5f:	6a 00                	push   $0x0
  pushl $246
80108d61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108d66:	e9 dc f0 ff ff       	jmp    80107e47 <alltraps>

80108d6b <vector247>:
.globl vector247
vector247:
  pushl $0
80108d6b:	6a 00                	push   $0x0
  pushl $247
80108d6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108d72:	e9 d0 f0 ff ff       	jmp    80107e47 <alltraps>

80108d77 <vector248>:
.globl vector248
vector248:
  pushl $0
80108d77:	6a 00                	push   $0x0
  pushl $248
80108d79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108d7e:	e9 c4 f0 ff ff       	jmp    80107e47 <alltraps>

80108d83 <vector249>:
.globl vector249
vector249:
  pushl $0
80108d83:	6a 00                	push   $0x0
  pushl $249
80108d85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108d8a:	e9 b8 f0 ff ff       	jmp    80107e47 <alltraps>

80108d8f <vector250>:
.globl vector250
vector250:
  pushl $0
80108d8f:	6a 00                	push   $0x0
  pushl $250
80108d91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108d96:	e9 ac f0 ff ff       	jmp    80107e47 <alltraps>

80108d9b <vector251>:
.globl vector251
vector251:
  pushl $0
80108d9b:	6a 00                	push   $0x0
  pushl $251
80108d9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108da2:	e9 a0 f0 ff ff       	jmp    80107e47 <alltraps>

80108da7 <vector252>:
.globl vector252
vector252:
  pushl $0
80108da7:	6a 00                	push   $0x0
  pushl $252
80108da9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108dae:	e9 94 f0 ff ff       	jmp    80107e47 <alltraps>

80108db3 <vector253>:
.globl vector253
vector253:
  pushl $0
80108db3:	6a 00                	push   $0x0
  pushl $253
80108db5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108dba:	e9 88 f0 ff ff       	jmp    80107e47 <alltraps>

80108dbf <vector254>:
.globl vector254
vector254:
  pushl $0
80108dbf:	6a 00                	push   $0x0
  pushl $254
80108dc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108dc6:	e9 7c f0 ff ff       	jmp    80107e47 <alltraps>

80108dcb <vector255>:
.globl vector255
vector255:
  pushl $0
80108dcb:	6a 00                	push   $0x0
  pushl $255
80108dcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108dd2:	e9 70 f0 ff ff       	jmp    80107e47 <alltraps>
80108dd7:	66 90                	xchg   %ax,%ax
80108dd9:	66 90                	xchg   %ax,%ax
80108ddb:	66 90                	xchg   %ax,%ax
80108ddd:	66 90                	xchg   %ax,%ax
80108ddf:	90                   	nop

80108de0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108de0:	55                   	push   %ebp
80108de1:	89 e5                	mov    %esp,%ebp
80108de3:	57                   	push   %edi
80108de4:	56                   	push   %esi
80108de5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108de6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80108dec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108df2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80108df5:	39 d3                	cmp    %edx,%ebx
80108df7:	73 56                	jae    80108e4f <deallocuvm.part.0+0x6f>
80108df9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80108dfc:	89 c6                	mov    %eax,%esi
80108dfe:	89 d7                	mov    %edx,%edi
80108e00:	eb 12                	jmp    80108e14 <deallocuvm.part.0+0x34>
80108e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108e08:	83 c2 01             	add    $0x1,%edx
80108e0b:	89 d3                	mov    %edx,%ebx
80108e0d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108e10:	39 fb                	cmp    %edi,%ebx
80108e12:	73 38                	jae    80108e4c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80108e14:	89 da                	mov    %ebx,%edx
80108e16:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108e19:	8b 04 96             	mov    (%esi,%edx,4),%eax
80108e1c:	a8 01                	test   $0x1,%al
80108e1e:	74 e8                	je     80108e08 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80108e20:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108e27:	c1 e9 0a             	shr    $0xa,%ecx
80108e2a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80108e30:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80108e37:	85 c0                	test   %eax,%eax
80108e39:	74 cd                	je     80108e08 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80108e3b:	8b 10                	mov    (%eax),%edx
80108e3d:	f6 c2 01             	test   $0x1,%dl
80108e40:	75 1e                	jne    80108e60 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80108e42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108e48:	39 fb                	cmp    %edi,%ebx
80108e4a:	72 c8                	jb     80108e14 <deallocuvm.part.0+0x34>
80108e4c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e52:	89 c8                	mov    %ecx,%eax
80108e54:	5b                   	pop    %ebx
80108e55:	5e                   	pop    %esi
80108e56:	5f                   	pop    %edi
80108e57:	5d                   	pop    %ebp
80108e58:	c3                   	ret    
80108e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80108e60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108e66:	74 26                	je     80108e8e <deallocuvm.part.0+0xae>
      kfree(v);
80108e68:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80108e6b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108e74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108e7a:	52                   	push   %edx
80108e7b:	e8 e0 b1 ff ff       	call   80104060 <kfree>
      *pte = 0;
80108e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80108e83:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108e8c:	eb 82                	jmp    80108e10 <deallocuvm.part.0+0x30>
        panic("kfree");
80108e8e:	83 ec 0c             	sub    $0xc,%esp
80108e91:	68 d6 9a 10 80       	push   $0x80109ad6
80108e96:	e8 e5 74 ff ff       	call   80100380 <panic>
80108e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108e9f:	90                   	nop

80108ea0 <mappages>:
{
80108ea0:	55                   	push   %ebp
80108ea1:	89 e5                	mov    %esp,%ebp
80108ea3:	57                   	push   %edi
80108ea4:	56                   	push   %esi
80108ea5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108ea6:	89 d3                	mov    %edx,%ebx
80108ea8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80108eae:	83 ec 1c             	sub    $0x1c,%esp
80108eb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108eb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ebd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ec3:	29 d8                	sub    %ebx,%eax
80108ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108ec8:	eb 3f                	jmp    80108f09 <mappages+0x69>
80108eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108ed0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108ed7:	c1 ea 0a             	shr    $0xa,%edx
80108eda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108ee0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108ee7:	85 c0                	test   %eax,%eax
80108ee9:	74 75                	je     80108f60 <mappages+0xc0>
    if(*pte & PTE_P)
80108eeb:	f6 00 01             	testb  $0x1,(%eax)
80108eee:	0f 85 86 00 00 00    	jne    80108f7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108ef4:	0b 75 0c             	or     0xc(%ebp),%esi
80108ef7:	83 ce 01             	or     $0x1,%esi
80108efa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80108efc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108eff:	39 c3                	cmp    %eax,%ebx
80108f01:	74 6d                	je     80108f70 <mappages+0xd0>
    a += PGSIZE;
80108f03:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80108f0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108f0f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108f12:	89 d8                	mov    %ebx,%eax
80108f14:	c1 e8 16             	shr    $0x16,%eax
80108f17:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108f1a:	8b 07                	mov    (%edi),%eax
80108f1c:	a8 01                	test   $0x1,%al
80108f1e:	75 b0                	jne    80108ed0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108f20:	e8 fb b2 ff ff       	call   80104220 <kalloc>
80108f25:	85 c0                	test   %eax,%eax
80108f27:	74 37                	je     80108f60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108f29:	83 ec 04             	sub    $0x4,%esp
80108f2c:	68 00 10 00 00       	push   $0x1000
80108f31:	6a 00                	push   $0x0
80108f33:	50                   	push   %eax
80108f34:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108f37:	e8 b4 d7 ff ff       	call   801066f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108f3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80108f3f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108f42:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108f48:	83 c8 07             	or     $0x7,%eax
80108f4b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80108f4d:	89 d8                	mov    %ebx,%eax
80108f4f:	c1 e8 0a             	shr    $0xa,%eax
80108f52:	25 fc 0f 00 00       	and    $0xffc,%eax
80108f57:	01 d0                	add    %edx,%eax
80108f59:	eb 90                	jmp    80108eeb <mappages+0x4b>
80108f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108f5f:	90                   	nop
}
80108f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108f68:	5b                   	pop    %ebx
80108f69:	5e                   	pop    %esi
80108f6a:	5f                   	pop    %edi
80108f6b:	5d                   	pop    %ebp
80108f6c:	c3                   	ret    
80108f6d:	8d 76 00             	lea    0x0(%esi),%esi
80108f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108f73:	31 c0                	xor    %eax,%eax
}
80108f75:	5b                   	pop    %ebx
80108f76:	5e                   	pop    %esi
80108f77:	5f                   	pop    %edi
80108f78:	5d                   	pop    %ebp
80108f79:	c3                   	ret    
      panic("remap");
80108f7a:	83 ec 0c             	sub    $0xc,%esp
80108f7d:	68 9c a2 10 80       	push   $0x8010a29c
80108f82:	e8 f9 73 ff ff       	call   80100380 <panic>
80108f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f8e:	66 90                	xchg   %ax,%ax

80108f90 <seginit>:
{
80108f90:	55                   	push   %ebp
80108f91:	89 e5                	mov    %esp,%ebp
80108f93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108f96:	e8 a5 c5 ff ff       	call   80105540 <cpuid>
  pd[0] = size-1;
80108f9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108fa0:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108fa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80108faa:	c7 80 b8 50 11 80 ff 	movl   $0xffff,-0x7feeaf48(%eax)
80108fb1:	ff 00 00 
80108fb4:	c7 80 bc 50 11 80 00 	movl   $0xcf9a00,-0x7feeaf44(%eax)
80108fbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108fbe:	c7 80 c0 50 11 80 ff 	movl   $0xffff,-0x7feeaf40(%eax)
80108fc5:	ff 00 00 
80108fc8:	c7 80 c4 50 11 80 00 	movl   $0xcf9200,-0x7feeaf3c(%eax)
80108fcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108fd2:	c7 80 c8 50 11 80 ff 	movl   $0xffff,-0x7feeaf38(%eax)
80108fd9:	ff 00 00 
80108fdc:	c7 80 cc 50 11 80 00 	movl   $0xcffa00,-0x7feeaf34(%eax)
80108fe3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108fe6:	c7 80 d0 50 11 80 ff 	movl   $0xffff,-0x7feeaf30(%eax)
80108fed:	ff 00 00 
80108ff0:	c7 80 d4 50 11 80 00 	movl   $0xcff200,-0x7feeaf2c(%eax)
80108ff7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80108ffa:	05 b0 50 11 80       	add    $0x801150b0,%eax
  pd[1] = (uint)p;
80108fff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80109003:	c1 e8 10             	shr    $0x10,%eax
80109006:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010900a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010900d:	0f 01 10             	lgdtl  (%eax)
}
80109010:	c9                   	leave  
80109011:	c3                   	ret    
80109012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109020 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80109020:	a1 84 80 11 80       	mov    0x80118084,%eax
80109025:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010902a:	0f 22 d8             	mov    %eax,%cr3
}
8010902d:	c3                   	ret    
8010902e:	66 90                	xchg   %ax,%ax

80109030 <switchuvm>:
{
80109030:	55                   	push   %ebp
80109031:	89 e5                	mov    %esp,%ebp
80109033:	57                   	push   %edi
80109034:	56                   	push   %esi
80109035:	53                   	push   %ebx
80109036:	83 ec 1c             	sub    $0x1c,%esp
80109039:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010903c:	85 f6                	test   %esi,%esi
8010903e:	0f 84 cb 00 00 00    	je     8010910f <switchuvm+0xdf>
  if(p->kstack == 0)
80109044:	8b 46 08             	mov    0x8(%esi),%eax
80109047:	85 c0                	test   %eax,%eax
80109049:	0f 84 da 00 00 00    	je     80109129 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010904f:	8b 46 04             	mov    0x4(%esi),%eax
80109052:	85 c0                	test   %eax,%eax
80109054:	0f 84 c2 00 00 00    	je     8010911c <switchuvm+0xec>
  pushcli();
8010905a:	e8 41 d4 ff ff       	call   801064a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010905f:	e8 7c c4 ff ff       	call   801054e0 <mycpu>
80109064:	89 c3                	mov    %eax,%ebx
80109066:	e8 75 c4 ff ff       	call   801054e0 <mycpu>
8010906b:	89 c7                	mov    %eax,%edi
8010906d:	e8 6e c4 ff ff       	call   801054e0 <mycpu>
80109072:	83 c7 08             	add    $0x8,%edi
80109075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109078:	e8 63 c4 ff ff       	call   801054e0 <mycpu>
8010907d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80109080:	ba 67 00 00 00       	mov    $0x67,%edx
80109085:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010908c:	83 c0 08             	add    $0x8,%eax
8010908f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80109096:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010909b:	83 c1 08             	add    $0x8,%ecx
8010909e:	c1 e8 18             	shr    $0x18,%eax
801090a1:	c1 e9 10             	shr    $0x10,%ecx
801090a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801090aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801090b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801090b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801090bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801090c1:	e8 1a c4 ff ff       	call   801054e0 <mycpu>
801090c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801090cd:	e8 0e c4 ff ff       	call   801054e0 <mycpu>
801090d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801090d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801090d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801090df:	e8 fc c3 ff ff       	call   801054e0 <mycpu>
801090e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801090e7:	e8 f4 c3 ff ff       	call   801054e0 <mycpu>
801090ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801090f0:	b8 28 00 00 00       	mov    $0x28,%eax
801090f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801090f8:	8b 46 04             	mov    0x4(%esi),%eax
801090fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109100:	0f 22 d8             	mov    %eax,%cr3
}
80109103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109106:	5b                   	pop    %ebx
80109107:	5e                   	pop    %esi
80109108:	5f                   	pop    %edi
80109109:	5d                   	pop    %ebp
  popcli();
8010910a:	e9 e1 d3 ff ff       	jmp    801064f0 <popcli>
    panic("switchuvm: no process");
8010910f:	83 ec 0c             	sub    $0xc,%esp
80109112:	68 a2 a2 10 80       	push   $0x8010a2a2
80109117:	e8 64 72 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010911c:	83 ec 0c             	sub    $0xc,%esp
8010911f:	68 cd a2 10 80       	push   $0x8010a2cd
80109124:	e8 57 72 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80109129:	83 ec 0c             	sub    $0xc,%esp
8010912c:	68 b8 a2 10 80       	push   $0x8010a2b8
80109131:	e8 4a 72 ff ff       	call   80100380 <panic>
80109136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010913d:	8d 76 00             	lea    0x0(%esi),%esi

80109140 <inituvm>:
{
80109140:	55                   	push   %ebp
80109141:	89 e5                	mov    %esp,%ebp
80109143:	57                   	push   %edi
80109144:	56                   	push   %esi
80109145:	53                   	push   %ebx
80109146:	83 ec 1c             	sub    $0x1c,%esp
80109149:	8b 45 08             	mov    0x8(%ebp),%eax
8010914c:	8b 75 10             	mov    0x10(%ebp),%esi
8010914f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80109152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80109155:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010915b:	77 49                	ja     801091a6 <inituvm+0x66>
  mem = kalloc();
8010915d:	e8 be b0 ff ff       	call   80104220 <kalloc>
  memset(mem, 0, PGSIZE);
80109162:	83 ec 04             	sub    $0x4,%esp
80109165:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010916a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010916c:	6a 00                	push   $0x0
8010916e:	50                   	push   %eax
8010916f:	e8 7c d5 ff ff       	call   801066f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80109174:	58                   	pop    %eax
80109175:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010917b:	5a                   	pop    %edx
8010917c:	6a 06                	push   $0x6
8010917e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109183:	31 d2                	xor    %edx,%edx
80109185:	50                   	push   %eax
80109186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109189:	e8 12 fd ff ff       	call   80108ea0 <mappages>
  memmove(mem, init, sz);
8010918e:	89 75 10             	mov    %esi,0x10(%ebp)
80109191:	83 c4 10             	add    $0x10,%esp
80109194:	89 7d 0c             	mov    %edi,0xc(%ebp)
80109197:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010919a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010919d:	5b                   	pop    %ebx
8010919e:	5e                   	pop    %esi
8010919f:	5f                   	pop    %edi
801091a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801091a1:	e9 da d5 ff ff       	jmp    80106780 <memmove>
    panic("inituvm: more than a page");
801091a6:	83 ec 0c             	sub    $0xc,%esp
801091a9:	68 e1 a2 10 80       	push   $0x8010a2e1
801091ae:	e8 cd 71 ff ff       	call   80100380 <panic>
801091b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801091ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801091c0 <loaduvm>:
{
801091c0:	55                   	push   %ebp
801091c1:	89 e5                	mov    %esp,%ebp
801091c3:	57                   	push   %edi
801091c4:	56                   	push   %esi
801091c5:	53                   	push   %ebx
801091c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801091c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
801091cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
801091cf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801091d5:	0f 85 a2 00 00 00    	jne    8010927d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
801091db:	85 ff                	test   %edi,%edi
801091dd:	74 7d                	je     8010925c <loaduvm+0x9c>
801091df:	90                   	nop
  pde = &pgdir[PDX(va)];
801091e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801091e3:	8b 55 08             	mov    0x8(%ebp),%edx
801091e6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801091e8:	89 c1                	mov    %eax,%ecx
801091ea:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801091ed:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801091f0:	f6 c1 01             	test   $0x1,%cl
801091f3:	75 13                	jne    80109208 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801091f5:	83 ec 0c             	sub    $0xc,%esp
801091f8:	68 fb a2 10 80       	push   $0x8010a2fb
801091fd:	e8 7e 71 ff ff       	call   80100380 <panic>
80109202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80109208:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010920b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80109211:	25 fc 0f 00 00       	and    $0xffc,%eax
80109216:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010921d:	85 c9                	test   %ecx,%ecx
8010921f:	74 d4                	je     801091f5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80109221:	89 fb                	mov    %edi,%ebx
80109223:	b8 00 10 00 00       	mov    $0x1000,%eax
80109228:	29 f3                	sub    %esi,%ebx
8010922a:	39 c3                	cmp    %eax,%ebx
8010922c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010922f:	53                   	push   %ebx
80109230:	8b 45 14             	mov    0x14(%ebp),%eax
80109233:	01 f0                	add    %esi,%eax
80109235:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80109236:	8b 01                	mov    (%ecx),%eax
80109238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010923d:	05 00 00 00 80       	add    $0x80000000,%eax
80109242:	50                   	push   %eax
80109243:	ff 75 10             	pushl  0x10(%ebp)
80109246:	e8 25 a4 ff ff       	call   80103670 <readi>
8010924b:	83 c4 10             	add    $0x10,%esp
8010924e:	39 d8                	cmp    %ebx,%eax
80109250:	75 1e                	jne    80109270 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80109252:	81 c6 00 10 00 00    	add    $0x1000,%esi
80109258:	39 fe                	cmp    %edi,%esi
8010925a:	72 84                	jb     801091e0 <loaduvm+0x20>
}
8010925c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010925f:	31 c0                	xor    %eax,%eax
}
80109261:	5b                   	pop    %ebx
80109262:	5e                   	pop    %esi
80109263:	5f                   	pop    %edi
80109264:	5d                   	pop    %ebp
80109265:	c3                   	ret    
80109266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010926d:	8d 76 00             	lea    0x0(%esi),%esi
80109270:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80109273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109278:	5b                   	pop    %ebx
80109279:	5e                   	pop    %esi
8010927a:	5f                   	pop    %edi
8010927b:	5d                   	pop    %ebp
8010927c:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
8010927d:	83 ec 0c             	sub    $0xc,%esp
80109280:	68 9c a3 10 80       	push   $0x8010a39c
80109285:	e8 f6 70 ff ff       	call   80100380 <panic>
8010928a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109290 <allocuvm>:
{
80109290:	55                   	push   %ebp
80109291:	89 e5                	mov    %esp,%ebp
80109293:	57                   	push   %edi
80109294:	56                   	push   %esi
80109295:	53                   	push   %ebx
80109296:	83 ec 1c             	sub    $0x1c,%esp
80109299:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010929c:	85 f6                	test   %esi,%esi
8010929e:	0f 88 98 00 00 00    	js     8010933c <allocuvm+0xac>
801092a4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801092a6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801092a9:	0f 82 a1 00 00 00    	jb     80109350 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801092af:	8b 45 0c             	mov    0xc(%ebp),%eax
801092b2:	05 ff 0f 00 00       	add    $0xfff,%eax
801092b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801092bc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
801092be:	39 f0                	cmp    %esi,%eax
801092c0:	0f 83 8d 00 00 00    	jae    80109353 <allocuvm+0xc3>
801092c6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801092c9:	eb 44                	jmp    8010930f <allocuvm+0x7f>
801092cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801092cf:	90                   	nop
    memset(mem, 0, PGSIZE);
801092d0:	83 ec 04             	sub    $0x4,%esp
801092d3:	68 00 10 00 00       	push   $0x1000
801092d8:	6a 00                	push   $0x0
801092da:	50                   	push   %eax
801092db:	e8 10 d4 ff ff       	call   801066f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801092e0:	58                   	pop    %eax
801092e1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801092e7:	5a                   	pop    %edx
801092e8:	6a 06                	push   $0x6
801092ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
801092ef:	89 fa                	mov    %edi,%edx
801092f1:	50                   	push   %eax
801092f2:	8b 45 08             	mov    0x8(%ebp),%eax
801092f5:	e8 a6 fb ff ff       	call   80108ea0 <mappages>
801092fa:	83 c4 10             	add    $0x10,%esp
801092fd:	85 c0                	test   %eax,%eax
801092ff:	78 5f                	js     80109360 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80109301:	81 c7 00 10 00 00    	add    $0x1000,%edi
80109307:	39 f7                	cmp    %esi,%edi
80109309:	0f 83 89 00 00 00    	jae    80109398 <allocuvm+0x108>
    mem = kalloc();
8010930f:	e8 0c af ff ff       	call   80104220 <kalloc>
80109314:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80109316:	85 c0                	test   %eax,%eax
80109318:	75 b6                	jne    801092d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010931a:	83 ec 0c             	sub    $0xc,%esp
8010931d:	68 19 a3 10 80       	push   $0x8010a319
80109322:	e8 a9 74 ff ff       	call   801007d0 <cprintf>
  if(newsz >= oldsz)
80109327:	83 c4 10             	add    $0x10,%esp
8010932a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010932d:	74 0d                	je     8010933c <allocuvm+0xac>
8010932f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109332:	8b 45 08             	mov    0x8(%ebp),%eax
80109335:	89 f2                	mov    %esi,%edx
80109337:	e8 a4 fa ff ff       	call   80108de0 <deallocuvm.part.0>
    return 0;
8010933c:	31 d2                	xor    %edx,%edx
}
8010933e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109341:	89 d0                	mov    %edx,%eax
80109343:	5b                   	pop    %ebx
80109344:	5e                   	pop    %esi
80109345:	5f                   	pop    %edi
80109346:	5d                   	pop    %ebp
80109347:	c3                   	ret    
80109348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010934f:	90                   	nop
    return oldsz;
80109350:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80109353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109356:	89 d0                	mov    %edx,%eax
80109358:	5b                   	pop    %ebx
80109359:	5e                   	pop    %esi
8010935a:	5f                   	pop    %edi
8010935b:	5d                   	pop    %ebp
8010935c:	c3                   	ret    
8010935d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80109360:	83 ec 0c             	sub    $0xc,%esp
80109363:	68 31 a3 10 80       	push   $0x8010a331
80109368:	e8 63 74 ff ff       	call   801007d0 <cprintf>
  if(newsz >= oldsz)
8010936d:	83 c4 10             	add    $0x10,%esp
80109370:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109373:	74 0d                	je     80109382 <allocuvm+0xf2>
80109375:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109378:	8b 45 08             	mov    0x8(%ebp),%eax
8010937b:	89 f2                	mov    %esi,%edx
8010937d:	e8 5e fa ff ff       	call   80108de0 <deallocuvm.part.0>
      kfree(mem);
80109382:	83 ec 0c             	sub    $0xc,%esp
80109385:	53                   	push   %ebx
80109386:	e8 d5 ac ff ff       	call   80104060 <kfree>
      return 0;
8010938b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010938e:	31 d2                	xor    %edx,%edx
80109390:	eb ac                	jmp    8010933e <allocuvm+0xae>
80109392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80109398:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010939b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010939e:	5b                   	pop    %ebx
8010939f:	5e                   	pop    %esi
801093a0:	89 d0                	mov    %edx,%eax
801093a2:	5f                   	pop    %edi
801093a3:	5d                   	pop    %ebp
801093a4:	c3                   	ret    
801093a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801093ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801093b0 <deallocuvm>:
{
801093b0:	55                   	push   %ebp
801093b1:	89 e5                	mov    %esp,%ebp
801093b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801093b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801093b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801093bc:	39 d1                	cmp    %edx,%ecx
801093be:	73 10                	jae    801093d0 <deallocuvm+0x20>
}
801093c0:	5d                   	pop    %ebp
801093c1:	e9 1a fa ff ff       	jmp    80108de0 <deallocuvm.part.0>
801093c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801093cd:	8d 76 00             	lea    0x0(%esi),%esi
801093d0:	89 d0                	mov    %edx,%eax
801093d2:	5d                   	pop    %ebp
801093d3:	c3                   	ret    
801093d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801093db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801093df:	90                   	nop

801093e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801093e0:	55                   	push   %ebp
801093e1:	89 e5                	mov    %esp,%ebp
801093e3:	57                   	push   %edi
801093e4:	56                   	push   %esi
801093e5:	53                   	push   %ebx
801093e6:	83 ec 0c             	sub    $0xc,%esp
801093e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801093ec:	85 f6                	test   %esi,%esi
801093ee:	74 59                	je     80109449 <freevm+0x69>
  if(newsz >= oldsz)
801093f0:	31 c9                	xor    %ecx,%ecx
801093f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801093f7:	89 f0                	mov    %esi,%eax
801093f9:	89 f3                	mov    %esi,%ebx
801093fb:	e8 e0 f9 ff ff       	call   80108de0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109400:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80109406:	eb 0f                	jmp    80109417 <freevm+0x37>
80109408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010940f:	90                   	nop
80109410:	83 c3 04             	add    $0x4,%ebx
80109413:	39 fb                	cmp    %edi,%ebx
80109415:	74 23                	je     8010943a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80109417:	8b 03                	mov    (%ebx),%eax
80109419:	a8 01                	test   $0x1,%al
8010941b:	74 f3                	je     80109410 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010941d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80109422:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109425:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80109428:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010942d:	50                   	push   %eax
8010942e:	e8 2d ac ff ff       	call   80104060 <kfree>
80109433:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109436:	39 fb                	cmp    %edi,%ebx
80109438:	75 dd                	jne    80109417 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010943a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010943d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109440:	5b                   	pop    %ebx
80109441:	5e                   	pop    %esi
80109442:	5f                   	pop    %edi
80109443:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80109444:	e9 17 ac ff ff       	jmp    80104060 <kfree>
    panic("freevm: no pgdir");
80109449:	83 ec 0c             	sub    $0xc,%esp
8010944c:	68 4d a3 10 80       	push   $0x8010a34d
80109451:	e8 2a 6f ff ff       	call   80100380 <panic>
80109456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010945d:	8d 76 00             	lea    0x0(%esi),%esi

80109460 <setupkvm>:
{
80109460:	55                   	push   %ebp
80109461:	89 e5                	mov    %esp,%ebp
80109463:	56                   	push   %esi
80109464:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80109465:	e8 b6 ad ff ff       	call   80104220 <kalloc>
8010946a:	85 c0                	test   %eax,%eax
8010946c:	74 5e                	je     801094cc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010946e:	83 ec 04             	sub    $0x4,%esp
80109471:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109473:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
80109478:	68 00 10 00 00       	push   $0x1000
8010947d:	6a 00                	push   $0x0
8010947f:	50                   	push   %eax
80109480:	e8 6b d2 ff ff       	call   801066f0 <memset>
80109485:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80109488:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010948b:	83 ec 08             	sub    $0x8,%esp
8010948e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80109491:	8b 13                	mov    (%ebx),%edx
80109493:	ff 73 0c             	pushl  0xc(%ebx)
80109496:	50                   	push   %eax
80109497:	29 c1                	sub    %eax,%ecx
80109499:	89 f0                	mov    %esi,%eax
8010949b:	e8 00 fa ff ff       	call   80108ea0 <mappages>
801094a0:	83 c4 10             	add    $0x10,%esp
801094a3:	85 c0                	test   %eax,%eax
801094a5:	78 19                	js     801094c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801094a7:	83 c3 10             	add    $0x10,%ebx
801094aa:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
801094b0:	75 d6                	jne    80109488 <setupkvm+0x28>
}
801094b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801094b5:	89 f0                	mov    %esi,%eax
801094b7:	5b                   	pop    %ebx
801094b8:	5e                   	pop    %esi
801094b9:	5d                   	pop    %ebp
801094ba:	c3                   	ret    
801094bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801094bf:	90                   	nop
      freevm(pgdir);
801094c0:	83 ec 0c             	sub    $0xc,%esp
801094c3:	56                   	push   %esi
801094c4:	e8 17 ff ff ff       	call   801093e0 <freevm>
      return 0;
801094c9:	83 c4 10             	add    $0x10,%esp
}
801094cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801094cf:	31 f6                	xor    %esi,%esi
}
801094d1:	89 f0                	mov    %esi,%eax
801094d3:	5b                   	pop    %ebx
801094d4:	5e                   	pop    %esi
801094d5:	5d                   	pop    %ebp
801094d6:	c3                   	ret    
801094d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801094de:	66 90                	xchg   %ax,%ax

801094e0 <kvmalloc>:
{
801094e0:	55                   	push   %ebp
801094e1:	89 e5                	mov    %esp,%ebp
801094e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801094e6:	e8 75 ff ff ff       	call   80109460 <setupkvm>
801094eb:	a3 84 80 11 80       	mov    %eax,0x80118084
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801094f0:	05 00 00 00 80       	add    $0x80000000,%eax
801094f5:	0f 22 d8             	mov    %eax,%cr3
}
801094f8:	c9                   	leave  
801094f9:	c3                   	ret    
801094fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109500 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109500:	55                   	push   %ebp
80109501:	89 e5                	mov    %esp,%ebp
80109503:	83 ec 08             	sub    $0x8,%esp
80109506:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109509:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010950c:	89 c1                	mov    %eax,%ecx
8010950e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80109511:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80109514:	f6 c2 01             	test   $0x1,%dl
80109517:	75 17                	jne    80109530 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80109519:	83 ec 0c             	sub    $0xc,%esp
8010951c:	68 5e a3 10 80       	push   $0x8010a35e
80109521:	e8 5a 6e ff ff       	call   80100380 <panic>
80109526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010952d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80109530:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109533:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80109539:	25 fc 0f 00 00       	and    $0xffc,%eax
8010953e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80109545:	85 c0                	test   %eax,%eax
80109547:	74 d0                	je     80109519 <clearpteu+0x19>
  *pte &= ~PTE_U;
80109549:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010954c:	c9                   	leave  
8010954d:	c3                   	ret    
8010954e:	66 90                	xchg   %ax,%ax

80109550 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109550:	55                   	push   %ebp
80109551:	89 e5                	mov    %esp,%ebp
80109553:	57                   	push   %edi
80109554:	56                   	push   %esi
80109555:	53                   	push   %ebx
80109556:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109559:	e8 02 ff ff ff       	call   80109460 <setupkvm>
8010955e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109561:	85 c0                	test   %eax,%eax
80109563:	0f 84 e9 00 00 00    	je     80109652 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109569:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010956c:	85 c9                	test   %ecx,%ecx
8010956e:	0f 84 b2 00 00 00    	je     80109626 <copyuvm+0xd6>
80109574:	31 f6                	xor    %esi,%esi
80109576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010957d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80109580:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80109583:	89 f0                	mov    %esi,%eax
80109585:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80109588:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010958b:	a8 01                	test   $0x1,%al
8010958d:	75 11                	jne    801095a0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010958f:	83 ec 0c             	sub    $0xc,%esp
80109592:	68 68 a3 10 80       	push   $0x8010a368
80109597:	e8 e4 6d ff ff       	call   80100380 <panic>
8010959c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801095a0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801095a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801095a7:	c1 ea 0a             	shr    $0xa,%edx
801095aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801095b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801095b7:	85 c0                	test   %eax,%eax
801095b9:	74 d4                	je     8010958f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801095bb:	8b 00                	mov    (%eax),%eax
801095bd:	a8 01                	test   $0x1,%al
801095bf:	0f 84 9f 00 00 00    	je     80109664 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801095c5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801095c7:	25 ff 0f 00 00       	and    $0xfff,%eax
801095cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801095cf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801095d5:	e8 46 ac ff ff       	call   80104220 <kalloc>
801095da:	89 c3                	mov    %eax,%ebx
801095dc:	85 c0                	test   %eax,%eax
801095de:	74 64                	je     80109644 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801095e0:	83 ec 04             	sub    $0x4,%esp
801095e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801095e9:	68 00 10 00 00       	push   $0x1000
801095ee:	57                   	push   %edi
801095ef:	50                   	push   %eax
801095f0:	e8 8b d1 ff ff       	call   80106780 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801095f5:	58                   	pop    %eax
801095f6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801095fc:	5a                   	pop    %edx
801095fd:	ff 75 e4             	pushl  -0x1c(%ebp)
80109600:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109605:	89 f2                	mov    %esi,%edx
80109607:	50                   	push   %eax
80109608:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010960b:	e8 90 f8 ff ff       	call   80108ea0 <mappages>
80109610:	83 c4 10             	add    $0x10,%esp
80109613:	85 c0                	test   %eax,%eax
80109615:	78 21                	js     80109638 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80109617:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010961d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109620:	0f 82 5a ff ff ff    	jb     80109580 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80109626:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109629:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010962c:	5b                   	pop    %ebx
8010962d:	5e                   	pop    %esi
8010962e:	5f                   	pop    %edi
8010962f:	5d                   	pop    %ebp
80109630:	c3                   	ret    
80109631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80109638:	83 ec 0c             	sub    $0xc,%esp
8010963b:	53                   	push   %ebx
8010963c:	e8 1f aa ff ff       	call   80104060 <kfree>
      goto bad;
80109641:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80109644:	83 ec 0c             	sub    $0xc,%esp
80109647:	ff 75 e0             	pushl  -0x20(%ebp)
8010964a:	e8 91 fd ff ff       	call   801093e0 <freevm>
  return 0;
8010964f:	83 c4 10             	add    $0x10,%esp
    return 0;
80109652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80109659:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010965c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010965f:	5b                   	pop    %ebx
80109660:	5e                   	pop    %esi
80109661:	5f                   	pop    %edi
80109662:	5d                   	pop    %ebp
80109663:	c3                   	ret    
      panic("copyuvm: page not present");
80109664:	83 ec 0c             	sub    $0xc,%esp
80109667:	68 82 a3 10 80       	push   $0x8010a382
8010966c:	e8 0f 6d ff ff       	call   80100380 <panic>
80109671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010967f:	90                   	nop

80109680 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109680:	55                   	push   %ebp
80109681:	89 e5                	mov    %esp,%ebp
80109683:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109686:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80109689:	89 c1                	mov    %eax,%ecx
8010968b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010968e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80109691:	f6 c2 01             	test   $0x1,%dl
80109694:	0f 84 f8 00 00 00    	je     80109792 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010969a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010969d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801096a3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801096a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801096a9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801096b0:	89 d0                	mov    %edx,%eax
801096b2:	f7 d2                	not    %edx
801096b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096b9:	05 00 00 00 80       	add    $0x80000000,%eax
801096be:	83 e2 05             	and    $0x5,%edx
801096c1:	ba 00 00 00 00       	mov    $0x0,%edx
801096c6:	0f 45 c2             	cmovne %edx,%eax
}
801096c9:	c3                   	ret    
801096ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801096d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801096d0:	55                   	push   %ebp
801096d1:	89 e5                	mov    %esp,%ebp
801096d3:	57                   	push   %edi
801096d4:	56                   	push   %esi
801096d5:	53                   	push   %ebx
801096d6:	83 ec 0c             	sub    $0xc,%esp
801096d9:	8b 75 14             	mov    0x14(%ebp),%esi
801096dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801096df:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801096e2:	85 f6                	test   %esi,%esi
801096e4:	75 51                	jne    80109737 <copyout+0x67>
801096e6:	e9 9d 00 00 00       	jmp    80109788 <copyout+0xb8>
801096eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801096ef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801096f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801096f6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801096fc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80109702:	74 74                	je     80109778 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80109704:	89 fb                	mov    %edi,%ebx
80109706:	29 c3                	sub    %eax,%ebx
80109708:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010970e:	39 f3                	cmp    %esi,%ebx
80109710:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80109713:	29 f8                	sub    %edi,%eax
80109715:	83 ec 04             	sub    $0x4,%esp
80109718:	01 c1                	add    %eax,%ecx
8010971a:	53                   	push   %ebx
8010971b:	52                   	push   %edx
8010971c:	89 55 10             	mov    %edx,0x10(%ebp)
8010971f:	51                   	push   %ecx
80109720:	e8 5b d0 ff ff       	call   80106780 <memmove>
    len -= n;
    buf += n;
80109725:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80109728:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010972e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80109731:	01 da                	add    %ebx,%edx
  while(len > 0){
80109733:	29 de                	sub    %ebx,%esi
80109735:	74 51                	je     80109788 <copyout+0xb8>
  if(*pde & PTE_P){
80109737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010973a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010973c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010973e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80109741:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80109747:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010974a:	f6 c1 01             	test   $0x1,%cl
8010974d:	0f 84 46 00 00 00    	je     80109799 <copyout.cold>
  return &pgtab[PTX(va)];
80109753:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109755:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010975b:	c1 eb 0c             	shr    $0xc,%ebx
8010975e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80109764:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010976b:	89 d9                	mov    %ebx,%ecx
8010976d:	f7 d1                	not    %ecx
8010976f:	83 e1 05             	and    $0x5,%ecx
80109772:	0f 84 78 ff ff ff    	je     801096f0 <copyout+0x20>
  }
  return 0;
}
80109778:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010977b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109780:	5b                   	pop    %ebx
80109781:	5e                   	pop    %esi
80109782:	5f                   	pop    %edi
80109783:	5d                   	pop    %ebp
80109784:	c3                   	ret    
80109785:	8d 76 00             	lea    0x0(%esi),%esi
80109788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010978b:	31 c0                	xor    %eax,%eax
}
8010978d:	5b                   	pop    %ebx
8010978e:	5e                   	pop    %esi
8010978f:	5f                   	pop    %edi
80109790:	5d                   	pop    %ebp
80109791:	c3                   	ret    

80109792 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80109792:	a1 00 00 00 00       	mov    0x0,%eax
80109797:	0f 0b                	ud2    

80109799 <copyout.cold>:
80109799:	a1 00 00 00 00       	mov    0x0,%eax
8010979e:	0f 0b                	ud2    
