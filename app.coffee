shuffle = (a) ->
	j = undefined
	x = undefined
	i = undefined
	i = a.length
	while i
		j = Math.floor(Math.random() * i)
		x = a[i - 1]
		a[i - 1] = a[j]
		a[j] = x
		i--
	return a


flow = new FlowComponent
flow.footer = footer_1
# 1.  channel flow
flow.showNext(home)
# 2. explore flow

# GLOBAL. now playing flow
footer_1.on Events.Tap, (event) ->
	goToNowPlaying()
NP_btn_close.on Events.Tap, (event) ->
	flow.showPrevious()
	footer_1.visible = true
NP_btn_add_to_list.on Events.Tap, (event) ->
	flow.showOverlayBottom(naver_playlist)	
list_brand.on Events.Tap, (event) ->
	flow.showNext(Brand_detail)

BD_btn_back.on Events.Tap, (event) ->
	flow.showPrevious()

btn_favor.on Events.Tap, (event) ->
	flow.showOverlayBottom(favor)
	favor_tiles.animate(favor_tiles.states.ready)
	for tile in favor_tiles.children
		tile.animate(tile.states.ready)

goToNowPlaying = () ->
	flow.showOverlayBottom(now_playing)

# PAGE COMPONENT
pages = []
pageComp = new PageComponent
	parent: home
	width: Screen.width
	height: Screen.height - header_1.height - footer_1.height
	scrollVertical:  false
	x: Align.center
	y: header_1.height
for i in [0...2]
	page = new Layer
		parent: pageComp.content
		backgroundColor: 'transparent'
		size: pageComp.size
		x: pageComp.width*i
		name: i
	pages.push(page)
	
indicator = new Layer
	parent: home
	width: 80
	height: 5
	x: 10
	y: Align.top
	backgroundColor: "#fff"
	
tabs = [tab_channel_1, tab_explore_1]
tab_channel_1.on Events.Tap, ->
	pageComp.snapToPage(pages[0])
tab_explore_1.on Events.Tap, ->
	pageComp.snapToPage(pages[1])
pageComp.on Events.Move, ->
	indicator.x = Utils.modulate(pageComp.scrollX, [pageComp.width*0, pageComp.width*1], [10, 90], true) 
	tab.opacity = 0.56 for tab in tabs
	current = pageComp.horizontalPageIndex(pageComp.currentPage)
	tabs[current].opacity = 1
# PAGE COMPONENT END

# SCROLL COMPONENT START	
scrollwrapper = [scroll_channel, scroll_explore]
contents = [content_channel, content_explore]
scrolls = []

for i in [0...2]
	scrollwrapper[i].parent = pages[i]
	scroll = new ScrollComponent
		size: scrollwrapper[i].size
		parent: scrollwrapper[i]
		scrollHorizontal: false
	scrolls.push(scroll)
	contents[i].parent = scroll.content	
	scrolls[i].on Events.ScrollStart, (event, layer) ->
		pageComp.scrollHorizontal = false
	scrolls[i].on Events.ScrollEnd, (event, layer) ->
		pageComp.scrollHorizontal = true
# SCROLL COMPONENT END

# NOW PLAYING START
STARBUCKS_ADDED = false
channel_labels = ['운동', '명상', '슬픈 발라드', '몽환적', '채널1']
SELECTED_CHANNEL = 3
NP_channel_label = new TextLayer
	text: channel_labels[SELECTED_CHANNEL]
	parent: NP_header
	x: Align.center
	y: Align.center
	fontSize: 16
	fontFamily: 'Noto Sans'
	color: '#fff'
	fontWeight:'bold'
footer_love.on Events.Tap, (event, layer) ->
	footer_state_love.opacity = 1
	event.stopPropagation()
NP_header.states.default =
	height: 50
	options:
		time: 0.2
		curve: Bezier.easeInOut
NP_header_bg_color.states.default =
	opacity:0
	options:
		time: 0.2
		curve: Bezier.easeInOut
NP_btn_close.states.default = 
	opacity: 1
	options:
		time: 0.2
		curve: Bezier.easeInOut
NP_channel_list.states.default = 
	y: -50
	opacity: 0
	options:
		time: 0.2
		curve: Bezier.easeInOut
NP_channel_label.states.default = 
	y: 15
	x: Align.center
	options:
		time: 0.2
		curve: Bezier.easeInOut
NP_play_status.states = 
	playing:
		width: 319
		options:
			time: 120
NP_play_cover_back.states =
	default:
		opacity: 0
		options: 
			time: 0.5
	active:
		opacity: 1
		options: 
			time: 0.5
NP_backdrop.states =
	default:
		opacity: 0
		options: 
			time: 0.5
				
msg_ok_1.states =
	default:
		scale:0
		opacity: 0
		options:
			delay: 1
			time: 0.5
	active:
		scale:1
		opacity: 1
		options:
			delay: 0.5
			time: 0.5
			curve: Spring
msg_ok_1_animation = new Animation msg_ok_1,
	msg_ok_1.states.active
msg_ok_1_animation.on Events.AnimationEnd, (event) ->
	msg_ok_1.animate(msg_ok_1.states.default)	
viewMsgText = (i)->
	for text, index in msg_text.children
		if i == +text.name.split('_')[1]
			text.opacity = 1
		else
			text.opacity = 0

NP_play_status.animate(NP_play_status.states.playing)
isPanning = false
NP_play_cover.on Events.PanStart, (event, layer) ->
	isPanning = true
NP_play_cover.on Events.Pan, (event, layer) ->
	NP_header.height = Utils.modulate(Math.log(event.offset.y+1)*5, [0, 150], [50, 600], true)
	NP_btn_close.opacity = Utils.modulate(Math.log((event.offset.y)+1)*5, [0, 10], [1,0], true)
	NP_channel_list.opacity = Utils.modulate(Math.log((event.offset.y)+1)*5, [0, 25], [0,1], true)
	NP_backdrop.opacity = Utils.modulate(Math.log((event.offset.y)+1)*5, [0, 25], [0,1], true)
	NP_header_bg_color.opacity = Utils.modulate(Math.log((event.offset.y)+1)*5, [0, 25], [0,1], true)
	NP_channel_list.y = Utils.modulate(Math.log(event.offset.y+1)*5, [0, 100], [-50, 180], true)
	NP_channel_list.x = Utils.modulate(event.offset.x, [-150, 150], [-500, 500], true)
	NP_channel_label.y = Utils.modulate(Math.log(event.offset.y+1)*5, [0, 100], [20, 360], true) 
	for channel, i in NP_channel_list.children
		channel.scale = 0.8
		offset = NP_channel_list.x + Screen.width/2
		if offset >= (i-1)*105 - 52.5 && offset < (i)*105 -52.5
			channel.scale = 1
			SELECTED_CHANNEL = i
			NP_channel_label.text = channel_labels[SELECTED_CHANNEL]
			NP_channel_label.x = Align.center
		
NP_play_cover.on Events.PanEnd, (event, layer) ->
	for channel, i in NP_channel_list.children
		offset = NP_channel_list.x + Screen.width/2
		if offset >= (i-1)*105 - 52.5 && offset < (i)*105 -52.5
			if i == 2 #balad
				NP_balad.opacity = 1
				balad_cover.opacity = 1
				getPlaylist()
	
	
bool_NP_play_cover_back = false
NP_play_cover.on Events.Tap, (event, layer) ->
	if !isPanning
		if bool_NP_play_cover_back
			NP_play_cover_back.animate(NP_play_cover_back.states.default)
		else
			NP_play_cover_back.animate(NP_play_cover_back.states.active)
		bool_NP_play_cover_back = !bool_NP_play_cover_back
	else
		isPanning = false

now_playing.on Events.PanEnd, (event, layer) ->
	NP_btn_close.animate(NP_btn_close.states.default)
	NP_header.animate(NP_header.states.default)
	NP_header_bg_color.animate(NP_header_bg_color.states.default)
	NP_channel_list.animate(NP_channel_list.states.default)
	NP_channel_label.animate(NP_channel_label.states.default)
	NP_backdrop.animate(NP_backdrop.states.default)

	
NP_channel_list.parent = NP_header
NP_channel_list.opacity = 0
NP_channel_list.center()

	
play_lists = ["There For You / Martin Garrix",
	"Don't Kill My Vibe (Gryffin Remix) / Sigrid",
	"Hunter / Galantis",
	"Hot Summer / f(x)",
	"내꺼하자 / INFINITE",
	"View / SHINee",
	"Fantastic Baby / BIGBANG",
	"This Is What You Came For (feat. Rihanna) / Calvin Harris",
	"Jackpot (The Him Remix) / Jocelyn Alice",
	"Together / CID",
	"Faded / Alan Walker",
	"Inside Out / The Chainsmokers",
	"Say You Do (feat. Imani & DJ Fresh) / Sigala",
	"Candyman / Zedd & Aloe Blacc",
	"2U (feat. Justin Bieber) / David Guetta",
	"Improvise (feat. Tom Aspaul)",
	"Stay / Zedd",
	"Fool / Roisto",
	"First Time / Kygo & Ellie Goulding",
	"개소리 B******T / G-DRAGON"
]
songs = []
NP_play_list_scroll = new ScrollComponent
	parent: NP_play_list_container
	width: Screen.width
	height: NP_play_list_container.height
	scrollHorizontal: false

nextCovers = []
nextCoverLayer = new Layer
	parent: NP_play_cover
	x: 337
	y: 18
	width: 282*2 + 7
	height: 282
	backgroundColor: 'transparent'
nextCoverLayer.states =
	active :
		x : 48
		options: 
			time: 1
for i in [0..2]
	cover = new Layer
		parent: nextCoverLayer
		width: 282
		height:282
		x: 289*i
		y: 0
	nextCovers.push(cover)

getPlaylist = () ->
	arr = [0...20]
	for song in songs
		song.destroy()
	arr = shuffle(arr)
	# 		play_lists = play_lists.reverse()
	for val, index in arr
		layer = new Layer
			parent: NP_play_list_scroll.content
			width: Screen.width
			height: 70
			y: index * 70
			backgroundColor: 'transparent'
		
		album = new Layer
			parent: layer
			image: 'images/albums/'+val+'.jpg'
			width: 43
			height: 43
			x: 20
			y: Align.center
		title = new TextLayer
			parent: layer
			text : play_lists[val].split(' / ')[0]
			fontSize: 16
			fontFamily: 'Noto Sans'
			y: 10
			x: 85
		artist = new TextLayer
			parent: layer
			text : play_lists[val].split(' / ')[1]
			fontSize: 13
			fontFamily: 'Noto Sans'
			y: 36
			x: 85
		songs.push(layer)
	for i in [0...2]
		nextCovers[i].image = 'images/albums/'+arr[i]+'.jpg'
		
getPlaylist(0)	
NP_play_list.states = 
	default:
		y: 525
		options:
			time: 0.3
			curve: Bezier.easeInOut
	open:
		y: Align.bottom
		options:
			time: 0.3
			curve: Bezier.easeInOut

bool_list_opened = false
	
NP_play_list_scroll.on Events.Move, (event, layer)->
	if NP_play_list_scroll.scrollY > 0 && bool_list_opened == false
		bool_list_opened = true
		NP_play_list.animate(NP_play_list.states.open)
	if NP_play_list_scroll.scrollY <= 0 && bool_list_opened == true
		bool_list_opened = false
		NP_play_list.animate(NP_play_list.states.default)
	NP_list_fold.opacity = +(bool_list_opened)
	NP_list_open.opacity = +(!bool_list_opened)

NP_prompt_add_channel.states =
	default:
		y: 667
		options:
			time: 0.5
	active:
		y: Align.bottom
		options:
			time: 0.5

addChannel3 = () ->	
	playing_effect_wrapper_1.opacity = 0
	channel_labels = ['운동', '명상', '슬픈 발라드', '몽환적', '채널1', '스타벅스', '채널3']
	SELECTED_CHANNEL = 6
	NP_channel_label.text = channel_labels[SELECTED_CHANNEL]
	for channel, index in content_channel.children
		channel.opacity = 1
		channel.y = 109 + 157 * index


NP_btn_add_channel.on Events.Tap, (event) ->
	NP_prompt_add_channel.animate(NP_prompt_add_channel.states.active)
	NP_backdrop.opacity = 1
NP_prompt_confirm.on Events.Tap, (event) ->
	NP_prompt_add_channel.animate(NP_prompt_add_channel.states.default)
	NP_backdrop.opacity = 0
	NP_channel_label.text = '채널3'
	getPlaylist(1)
	viewMsgText(1)
	msg_ok_1_animation.start()
	addChannel3()
	

dislike.on Events.Tap, ->
	nextCoverLayer.animate(nextCoverLayer.states.active)
	for song in songs
		song.y = song.y-70
	
# NOW PLAYING END

# CHANEEL START

filter_row_channel.states =
	active_filter:
		y: -45
		options:
			time: 0.1
	default:
		y: -90
		options:
			time: 0.1
scroll_channel.states =
	active_filter:
		y: 45
		options:
			time: 0.1
	default:
		y: 0
		options:
			time: 0.1
addStarbucks = () ->	
	if STARBUCKS_ADDED
		playing_effect_wrapper.opacity = 0
		channel_labels = ['운동', '명상', '슬픈 발라드', '몽환적', '채널1', '스타벅스']
		starbucks_song.opacity = 1
		SELECTED_CHANNEL = 5
		NP_channel_label.text = channel_labels[SELECTED_CHANNEL]
		NP_subway.opacity = 1
		jazz_cover.opacity = 1
		for channel, index in content_channel.children
			if index > 0
				channel.opacity = 1
				channel.y = 109 + 157 * (index-1)

scrolls[0].on Events.Move, (event, layer) ->
	header_channel.scale = Utils.modulate(scrolls[0].scrollY, [0, 200], [1, 0.8], false)
	header_channel.opacity = Utils.modulate(scrolls[0].scrollY, [0, 200], [1, 0], true)
	header_channel.y = Utils.modulate(scrolls[0].scrollY, [0, 200], [0, -50], false)
	
scrolls[0].on Events.Scroll, (event, layer) ->
	if event.offsetDirection == "down"
		filter_row_channel.animate(filter_row_channel.states.active_filter)
		scroll_channel.animate(scroll_channel.states.active_filter)
# 		header_channel.animate(header_channel.states.active_filter)
	else
		filter_row_channel.animate(filter_row_channel.states.default)
# 		header_channel.animate(header_channel.states.default)
		scroll_channel.animate(scroll_channel.states.default)
# CHANNEL END

# PLAYING EFFECT START
effect_lenght = [15, 45, 75]
# for effect_bar, index in playing_effect.children
# PLAYING EFFECT END

# EXPLORE EFFECT START
scrolls[1].y = 96
explore_bg.y = 0

msg_ok.parent = scrolls[1]
msg_ok.scale = 0
msg_ok.y = Align.center(-73)
msg_ok.x = Align.center
msg_ok.states =
	default:
		scale:0
		opacity: 0
		options:
			delay: 1
			time: 0.5
	active:
		scale:1
		opacity: 1
		options:
			delay: 0.5
			time: 0.5
			curve: Spring
msg_ok_animation = new Animation msg_ok,
	msg_ok.states.active
msg_ok_animation.on Events.AnimationEnd, (event) ->
	msg_ok.animate(msg_ok.states.default)	


scrolls[1].on Events.Move, (event, layer) ->
	header_explore.scale = Utils.modulate(scrolls[1].scrollY, [0, 200], [1, 0.8], false)
	header_explore.opacity = Utils.modulate(scrolls[1].scrollY, [0, 200], [1, 0], true)
	header_explore.y = Utils.modulate(scrolls[1].scrollY, [0, 200], [96, 0], false)

explore_lists = [list_genre, list_brand]
for list, index in explore_lists
	scroll = new ScrollComponent
		parent: list
		width: Screen.width
		height: 124
		scrollVertical: false
		
	scroll.content.backgroundColor = "transparent"
	list.children[0].parent = scroll.content
	scroll.on Events.ScrollStart, (event, layer) ->
		pageComp.scrollHorizontal = false
	scroll.on Events.ScrollEnd, (event, layer) ->
		pageComp.scrollHorizontal = true
genre_0.states = 
	default:
		scale:0.3
		opacity: 0
	active:
		scale: 1
		opacity: 1
		options:
			delay: 1
			time: 1
			curve: Spring
for genre, index in list_genre_content.children
	if index != 3
		genre.states =
			move:
				x: genre.x + 124
				options:
					delay: 1
					time: 1
					curve: Spring
addElectronicToGenre = ()->
	for genre, index in list_genre_content.children
		if index != 3
			genre.animate(genre.states.move)
	genre_0.stateSwitch('default')
	genre_0.animate(genre_0.states.active)

# EXPLORE EFFECT END

# FAVOR START

favor_try_count = 0
tiles_label = ['2U','4 walls', '너 아님 안돼', '스물셋', '정준영', '콜드플레이', '혁오', '인디음악', '힙합', 'Free Somebody', 'Rock', 'Shape of you', '규현', 'J-pop', '싱어송라이터', 'There for you']
	
favor_tiles.scale = 2
favor_tiles.opacity = 0.5
favor_tiles.states.ready = 
	scale:1
	opacity: 1
	options: 
		time: 1
		curve: Bezier.easeInOut
		
clearTile = () ->		
	for tile in favor_tiles.children
		tile.destroy()
readyTile = () ->
	favor_try_count++
	randoms = shuffle([0...16])
	for i in [0...16]
		tile = new Layer
			parent: favor_tiles
			image: 'images/favor_tiles_clear/'+randoms[i]+'.png'
			x: (i%4) * Screen.width/4
			y: Math.floor(i/4) * Screen.width/4
			width: Screen.width/4
			height: Screen.width/4
			scale: Math.random(1,5)
		tile_fade = new Layer
			parent: tile
			width: Screen.width/4
			height: Screen.width/4
			backgroundColor: '#000'
			opacity: 0.8
		label = new TextLayer
			parent: tile
			text: tiles_label[randoms[i]],
			fontSize: 14
			color: '#fff'
			x: Align.center
			y: Align.center
		tile.states =
			ready: 
				scale:1
				options: 
					time: Math.random(0.5, 1)
					curve: Bezier.easeInOut
			active:
				scale: 0.8
				options:
					time: 0.6
					curve: Spring
		tile.on Events.Tap, (event, layer)->
			layer.animate(layer.states.active)
			layer.children[0].opacity = 0
			layer.children[1].opacity = 0
readyTile()

next_favor.on Events.Tap, (event, layer) ->
	if favor_try_count > 1
		next_label.opacity = 0
		finishi_label.opacity = 1
	if favor_try_count == 3
		favor_try_count = 0
		flow.showPrevious()
		addElectronicToGenre()
	clearTile()
	readyTile()
	for tile in favor_tiles.children
		tile.animate(tile.states.ready)
		
# FAVOR END

# BRAND START
brand_scroll = new ScrollComponent
	parent: Brand_detail
	width: Screen.width
	height: Screen.height - 50
	y: Align.bottom
	backgroundColor: 'transparent'
	scrollHorizontal: false
starbucks_list.parent = brand_scroll.content
starbucks_list.y = 168
starbucks_fixed_header.parent = brand_scroll
starbucks_fixed_header.y = Align.top
brand_scroll.on Events.Move, (event, layer) ->
	starbucks_cover.scale = Utils.modulate(brand_scroll.scrollY, [0, 200], [1, 0.8], false)
	starbucks_cover.opacity = Utils.modulate(brand_scroll.scrollY, [0, 200], [1, 0], true)
	starbucks_cover.y = Utils.modulate(brand_scroll.scrollY, [0, 200], [50, 0], false)
	if brand_scroll.scrollY >168
		starbucks_fixed_header.opacity = 1
	else
		starbucks_fixed_header.opacity = 0
		
addStarbucksTrack = () ->
	STARBUCKS_ADDED = true
	addStarbucks()
	flow.showPrevious()
	msg_ok_animation.start()
	

starbucks_header.on Events.Tap, (event, layer) ->
	addStarbucksTrack()
starbucks_fixed_header.on Events.Tap, (event, layer) ->
	addStarbucksTrack()

# BRAND END

# NAVER START
btn_playlist_check.on Events.Tap, ->
	btn_playlist_check.opacity = 1
	btn_playlist_ok.opacity = 1
btn_playlist_ok.on Events.Tap, ->
	flow.showPrevious()
	footer_1.visible = false
	viewMsgText(0)
	msg_ok_1_animation.start()	
# NAVER END