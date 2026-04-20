{ ... }:

{
  xdg.configFile."pcmanfm/default/pcmanfm.conf".text = ''
    [config]
    bm_open_method=0

    [volume]
    mount_on_startup=1
    mount_removable=1
    autorun=1

    [ui]
    always_show_tabs=0
    max_tab_chars=32
    win_width=960
    win_height=1054
    splitter_pos=150
    media_in_new_tab=0
    desktop_folder_new_win=0
    change_tab_on_drop=1
    close_on_unmount=1
    focus_previous=0
    side_pane_mode=places
    view_mode=icon
    show_hidden=0
    sort=name;ascending;
    toolbar=newtab;navigation;home;
    show_statusbar=1
    pathbar_mode_buttons=0
  '';

  xdg.configFile."libfm/libfm.conf".text = ''
    [config]
    single_click=0
    use_trash=1
    confirm_del=1
    confirm_trash=1
    advanced_mode=0
    si_unit=0
    force_startup_notify=1
    backup_as_hidden=1
    no_usb_trash=1
    no_child_non_expandable=0
    show_full_names=1
    only_user_templates=0
    template_run_app=0
    template_type_once=0
    auto_selection_delay=600
    drop_default_action=auto
    defer_content_test=0
    quick_exec=0
    archiver=file-roller
    thumbnail_local=1
    thumbnail_max=4096
    smart_desktop_autodrop=1

    [ui]
    big_icon_size=64
    small_icon_size=16
    pane_icon_size=16
    thumbnail_size=192
    show_thumbnail=1
    shadow_hidden=0
  '';

}
